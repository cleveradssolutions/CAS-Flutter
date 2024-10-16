//
//  CASBridge.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation

public class CASBridge: CASLoadDelegate {
    private let manager: CASMediationManager
    private let interstitialAdListener: AdCallbackWrapper
    private let rewardedListener: AdCallbackWrapper
    private let appReturnListener: CASAppReturnDelegate
    private let builder: CASBridgeBuilder

    var mediationManager: CASMediationManager { manager }

    var banners = [Int: CASView]()

    init(
        builder: CASBridgeBuilder,
        casID: String,
        mediationManagerMethodHandler: MediationManagerMethodHandler
    ) {
        self.builder = builder

        interstitialAdListener = AdCallbackWrapper(flutterCallback: mediationManagerMethodHandler.flutterInterstitialListener, withComplete: false)
        rewardedListener = AdCallbackWrapper(flutterCallback: mediationManagerMethodHandler.flutterRewardedListener, withComplete: true)
        appReturnListener = mediationManagerMethodHandler.flutterAppReturnListener

        manager = builder.managerBuilder
            .withCompletionHandler({ initialConfig in
                let error = initialConfig.error != nil ? initialConfig.error! : ""
                let countryCode = initialConfig.countryCode != nil ? initialConfig.countryCode! : ""

                builder.initCallback.onCASInitialized(
                    error: error,
                    countryCode: countryCode,
                    isConsentRequired: initialConfig.isConsentRequired,
                    isTestMode: initialConfig.manager.isDemoAdMode)
            })
            .create(withCasId: casID)
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
        manager.presentInterstitial(fromRootViewController: builder.rootViewController, callback: interstitialAdListener)
    }

    func showRewarded() {
        manager.presentRewardedAd(fromRootViewController: builder.rootViewController, callback: rewardedListener)
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
        if adType == CASType.interstitial {
            interstitialAdListener.onAdLoaded()
        } else if adType == CASType.rewarded {
            rewardedListener.onAdLoaded()
        }
    }

    public func onAdFailedToLoad(_ adType: CASType, withError error: String?) {
        if adType == CASType.interstitial {
            interstitialAdListener.onAdFailedToLoad(withError: error)
        } else if adType == CASType.rewarded {
            rewardedListener.onAdFailedToLoad(withError: error)
        }
    }

    public func showGlobalBannerAd(sizeId: Int) {
        if banners[sizeId] != nil {
            banners[sizeId]?.showBanner()
            return
        }

        var casSize = CASSize.banner
        switch sizeId {
        case 2:
            casSize = CASSize.getAdaptiveBanner(inContainer: builder.rootViewController.view)
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

        if let call = builder.flutterCaller {
            flutterCallback.setFlutterCaller(caller: call)
        }

        let view = CASView(bannerView: globalBannerView, view: builder.rootViewController, callback: flutterCallback)

        banners[sizeId] = view

        globalBannerView.rootViewController = builder.rootViewController

        builder.rootViewController.view.addSubview(globalBannerView)
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

    func showBanner(sizeId: Int) {
        if let banner = banners[sizeId] {
            banner.showBanner()
        } else {
            showGlobalBannerAd(sizeId: sizeId)
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
