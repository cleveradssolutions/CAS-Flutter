//
//  CASBridge.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation

public class CASBridge: CASLoadDelegate {
    let manager: CASMediationManager

    private let interstitialAdListener: AdCallbackWrapper
    private let rewardedListener: AdCallbackWrapper
    private let appReturnListener: CASAppReturnDelegate

    var banners = [Int: CASView]()

    init(
        _ manager: CASMediationManager,
        _ mediationManagerMethodHandler: MediationManagerMethodHandler
    ) {
        self.manager = manager
        interstitialAdListener = AdCallbackWrapper(flutterCallback: mediationManagerMethodHandler.flutterInterstitialListener, withComplete: false)
        rewardedListener = AdCallbackWrapper(flutterCallback: mediationManagerMethodHandler.flutterRewardedListener, withComplete: true)
        appReturnListener = mediationManagerMethodHandler.flutterAppReturnListener
        manager.adLoadDelegate = self
    }

    func getManager() -> CASMediationManager {
        return manager
    }

    func enableReturnAds() {
        manager.enableAppReturnAds(with: appReturnListener)
    }

    func disableReturnAds() {
        manager.disableAppReturnAds()
    }

    func skipNextReturnAds() {
        manager.skipNextAppReturnAds()
    }

    func loadInterstitial() {
        manager.loadInterstitial()
    }

    func loadRewarded() {
        manager.loadRewardedAd()
    }

    func showInterstitial() {
        if let viewController = Util.findRootViewController() {
            manager.presentInterstitial(fromRootViewController: viewController, callback: interstitialAdListener)
        } else {
            interstitialAdListener.didShowAdFailed(error: "rootViewController is nil")
        }
    }

    func showRewarded() {
        if let viewController = Util.findRootViewController() {
            manager.presentRewardedAd(fromRootViewController: viewController, callback: rewardedListener)
        } else {
            rewardedListener.didShowAdFailed(error: "rootViewController is nil")
        }
    }

    func isInterstitialReady() -> Bool {
        return manager.isInterstitialReady
    }

    func isRewardedAdReady() -> Bool {
        return manager.isRewardedAdReady
    }

    func isEnabled(type: Int) -> Bool {
        let adType = CASType(rawValue: type)
        return adType != nil ? manager.isEnabled(type: adType!) : false
    }

    func setEnabled(type: Int, enable: Bool) {
        let adType = CASType(rawValue: type)
        if adType != nil {
            manager.setEnabled(enable, type: adType!)
        }
    }

    func setLastPageContent(json: String) {
        let content = CASLastPageAdContent.create(from: json)
        if content != nil {
            manager.lastPageAdContent = content
        }
    }

    public func onAdLoaded(_ adType: CASType) {
        DispatchQueue.main.async { [weak self] in
            if adType == CASType.interstitial {
                self?.interstitialAdListener.onAdLoaded()
            } else if adType == CASType.rewarded {
                self?.rewardedListener.onAdLoaded()
            }
        }
    }

    public func onAdFailedToLoad(_ adType: CASType, withError error: String?) {
        DispatchQueue.main.async { [weak self] in
            if adType == CASType.interstitial {
                self?.interstitialAdListener.onAdFailedToLoad(withError: error)
            } else if adType == CASType.rewarded {
                self?.rewardedListener.onAdFailedToLoad(withError: error)
            }
        }
    }

    func showGlobalBannerAd(
        mediationManagerMethodHandler: MediationManagerMethodHandler,
        sizeId: Int
    ) {
        if banners[sizeId] != nil {
            banners[sizeId]?.showBanner()
            return
        }
        guard let viewController = Util.findRootViewController() else {
            print("showGlobalBannerAd: rootViewController is nil")
            return
        }

        var casSize = CASSize.banner
        switch sizeId {
        case 2:
            casSize = CASSize.getAdaptiveBanner(inContainer: viewController.view)
            break
        case 3:
            casSize = CASSize.getSmartBanner()
            break
        case 4:
            casSize = CASSize.leaderboard
            break
        case 5:
            casSize = CASSize.mediumRectangle
            break
        default:
            casSize = CASSize.banner
            break
        }

        let globalBannerView = CASBannerView(adSize: casSize, manager: manager)
        let flutterCallback = FlutterBannerCallback(sizeId: sizeId)
        flutterCallback.setFlutterCaller(caller: mediationManagerMethodHandler.invokeMethod)
        let view = CASView(bannerView: globalBannerView, view: viewController, callback: flutterCallback)

        banners[sizeId] = view

        globalBannerView.rootViewController = viewController

        viewController.view.addSubview(globalBannerView)
    }

    func loadNextBanner(sizeId: Int) {
        banners[sizeId]?.loadNextBanner()
    }

    func isBannerViewAdReady(sizeId: Int) -> Bool {
        if let banner = banners[sizeId] {
            return banner.isBannerViewAdReady()
        } else {
            return false
        }
    }

    func showBanner(
        mediationManagerMethodHandler: MediationManagerMethodHandler,
        sizeId: Int
    ) {
        if let banner = banners[sizeId] {
            banner.showBanner()
        } else {
            showGlobalBannerAd(mediationManagerMethodHandler: mediationManagerMethodHandler, sizeId: sizeId)
        }
    }

    func hideBanner(sizeId: Int) {
        banners[sizeId]?.hideBanner()
    }

    func setBannerAdRefreshRate(refresh: Int, sizeId: Int) {
        banners[sizeId]?.setBannerAdRefreshRate(refresh: refresh)
    }

    func disableBannerRefresh(sizeId: Int) {
        banners[sizeId]?.disableBannerRefresh()
    }

    func setBannerPosition(sizeId: Int, positionId: Int, x: Int, y: Int) {
        banners[sizeId]?.setBannerPosition(positionId: positionId, xOffest: x, yOffset: y)
    }

    func disposeBanner(sizeId: Int) {
        banners[sizeId]?.disposeBanner()
        banners[sizeId] = nil
    }
}
