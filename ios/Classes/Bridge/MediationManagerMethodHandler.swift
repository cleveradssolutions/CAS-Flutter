//
//  MediationManagerMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "cleveradssolutions/mediation_manager"

class MediationManagerMethodHandler: MethodHandler, CASLoadDelegate {
    private(set) var manager: CASMediationManager?

    private let interstitialListener = FlutterInterstitialCallback()
    private let rewardedListener = FlutterRewardedCallback()
    private let appReturnListener = FlutterAppReturnCallback()

    init(with registrar: FlutterPluginRegistrar) {
        super.init(with: registrar, on: channelName)
        interstitialListener.setMethodHandler(handler: self)
        rewardedListener.setMethodHandler(handler: self)
        appReturnListener.setMethodHandler(handler: self)
    }

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
//        case "setLastPageContent": setLastPageContent(call, result)
        case "loadAd": loadAd(call, result)
        case "isReadyAd": isReadyAd(call, result)
        case "showAd": showAd(call, result)
        case "enableAppReturn": enableAppReturn(call, result)
        case "skipNextAppReturnAds": skipNextAppReturnAds(call, result)
        case "setEnabled": setEnabled(call, result)
        case "isEnabled": isEnabled(call, result)

        case "showBanner": showBanner(call, result)
        case "hideBanner": hideBanner(call, result)
        case "setBannerPosition": setBannerPosition(call, result)
        default: super.onMethodCall(call, result)
        }
    }

    public func onAdLoaded(_ adType: CASType) {
        DispatchQueue.main.async { [weak self] in
            if adType == CASType.interstitial {
                self?.interstitialListener.onAdLoaded()
            } else if adType == CASType.rewarded {
                self?.rewardedListener.onAdLoaded()
            }
        }
    }

    public func onAdFailedToLoad(_ adType: CASType, withError error: String?) {
        DispatchQueue.main.async { [weak self] in
            if adType == CASType.interstitial {
                self?.interstitialListener.onAdFailedToLoad(withError: error)
            } else if adType == CASType.rewarded {
                self?.rewardedListener.onAdFailedToLoad(withError: error)
            }
        }
    }

    public func setManager(_ manager: CASMediationManager) {
        self.manager = manager
        manager.adLoadDelegate = self
    }

//    private func setLastPageContent(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        guard let manager = getManagerAndCheckNil(call, result) else { return }
//        call.getArgAndReturn("lastPageJson", result) { json in
//            if let content = CASLastPageAdContent.create(from: json) {
//                manager.lastPageAdContent = content
//            }
//        }
//    }

    private func setEnabled(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let manager = getManagerAndCheckNil(call, result),
           let adTypeIndex: Int = call.getArgAndCheckNil("adType", result),
           let enabled: Bool = call.getArgAndCheckNil("enable", result) {
            if adTypeIndex >= 0 || adTypeIndex <= 2,
               let adType = CASType(rawValue: adTypeIndex) {
                manager.setEnabled(enabled, type: adType)
                result(nil)
            } else {
                result(call.error("AdType is not supported"))
            }
        }
    }

    private func isEnabled(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let manager = getManagerAndCheckNil(call, result),
           let adTypeIndex: Int = call.getArgAndCheckNil("adType", result) {
            if adTypeIndex >= 0 || adTypeIndex <= 2,
               let adType = CASType(rawValue: adTypeIndex) {
                result(manager.isEnabled(type: adType))
            } else {
                result(call.error("AdType is not supported"))
            }
        }
    }

    private func loadAd(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let manager = getManagerAndCheckNil(call, result),
           let adType: Int = call.getArgAndCheckNil("adType", result) {
            switch adType {
            case CASType.interstitial.rawValue: manager.loadInterstitial()
            case CASType.rewarded.rawValue: manager.loadRewardedAd()
            default: return result(call.error("AdType is not supported"))
            }
            result(nil)
        }
    }

    private func isReadyAd(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let manager = getManagerAndCheckNil(call, result),
           let adType: Int = call.getArgAndCheckNil("adType", result) {
            switch adType {
            case CASType.interstitial.rawValue: result(manager.isInterstitialReady)
            case CASType.rewarded.rawValue: result(manager.isRewardedAdReady)
            default: return result(call.error("AdType is not supported"))
            }
            result(nil)
        }
    }

    private func showAd(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let manager = getManagerAndCheckNil(call, result),
           let adType: Int = call.getArgAndCheckNil("adType", result) {
            switch adType {
            case CASType.interstitial.rawValue:
                if let viewController = Util.findRootViewController() {
                    manager.presentInterstitial(fromRootViewController: viewController, callback: interstitialListener)
                } else {
                    interstitialListener.didShowAdFailed(error: "rootViewController is nil")
                }
            case CASType.rewarded.rawValue:
                if let viewController = Util.findRootViewController() {
                    manager.presentRewardedAd(fromRootViewController: viewController, callback: rewardedListener)
                } else {
                    rewardedListener.didShowAdFailed(error: "rootViewController is nil")
                }
            default: result(call.error("AdType is not supported"))
            }
            result(nil)
        }
    }

    private func enableAppReturn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let manager = getManagerAndCheckNil(call, result),
           let enable: Bool = call.getArgAndCheckNil("enable", result) {
            if enable {
                manager.enableAppReturnAds(with: appReturnListener)
            } else {
                manager.disableAppReturnAds()
            }
            result(nil)
        }
    }

    private func skipNextAppReturnAds(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let manager = getManagerAndCheckNil(call, result) {
            manager.skipNextAppReturnAds()
            result(nil)
        }
    }

    private var banners = [Int: CASView]()

    private func showBanner(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let manager = getManagerAndCheckNil(call, result),
           let sizeId: Int = call.getArgAndCheckNil("sizeId", result) {
            if let banner = banners[sizeId] {
                banner.showBanner()
            } else {
                guard let viewController = Util.findRootViewController() else {
                    print("showGlobalBannerAd: rootViewController is nil")
                    return
                }
                let casSize: CASSize
                switch sizeId {
                case 2: casSize = .getAdaptiveBanner(inContainer: viewController.view)
                case 3: casSize = .getSmartBanner()
                case 4: casSize = .leaderboard
                case 5: casSize = .mediumRectangle
                default: casSize = .banner
                }

                let bannerView = CASBannerView(adSize: casSize, manager: manager)
                bannerView.rootViewController = viewController

                let flutterCallback = FlutterBannerCallback(sizeId: sizeId)
                flutterCallback.setMethodHandler(handler: self)

                let view = CASView(bannerView: bannerView, view: viewController, callback: flutterCallback)
                banners[sizeId] = view

                viewController.view.addSubview(bannerView)
            }
            result(nil)
        }
    }

    private func hideBanner(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let sizeId: Int = call.getArgAndCheckNil("sizeId", result) {
            banners[sizeId]?.hideBanner()
            result(nil)
        }
    }

    private func setBannerPosition(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let sizeId: Int = call.getArgAndCheckNil("sizeId", result),
           let positionId: Int = call.getArgAndCheckNil("positionId", result),
           let x: Int = call.getArgAndCheckNil("x", result),
           let y: Int = call.getArgAndCheckNil("y", result) {
            banners[sizeId]?.setBannerPosition(positionId: positionId, xOffest: x, yOffset: y)
            result(nil)
        }
    }

    private func getManagerAndCheckNil(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> CASMediationManager? {
        if manager == nil { result(call.errorFieldNil("CASMediationManager")) }
        return manager
    }
}
