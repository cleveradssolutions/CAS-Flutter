//
//  ScreenAdInstance.swift
//  clever_ads_solutions
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

class ScreenAdInstance: AdInstance, CASScreenContentDelegate, CASImpressionDelegate {
    weak var handler: AdMethodHandler<ScreenAdInstance>?
    let content: CASScreenContent

    init(_ id: String, _ contentInfoId: String, _ content: CASScreenContent) {
        self.content = content
        super.init(id: id, contentInfoId: contentInfoId)
        content.delegate = self
        content.impressionDelegate = self
    }

    open func onMethodCall(_ call: FlutterMethodCall, _ result: FlutterResult) {
        switch call.method {
        case "isAutoloadEnabled":
            isAutoloadEnabled(result)
        case "setAutoloadEnabled":
            setAutoloadEnabled(call, result)
        case "isLoaded":
            isLoaded(result)
        case "getContentInfo":
            getContentInfo(result)
        case "load":
            loadAd(result)
        case "show":
            present(result)
        case "destroy":
            destroy(result)

        case "isAutoshowEnabled":
            isAutoshowEnabled(result)
        case "setAutoshowEnabled":
            setAutoshowEnabled(call, result)

        case "getMinInterval":
            getMinInterval(result)
        case "setMinInterval":
            setMinInterval(call, result)
        case "restartInterval":
            restartInterval(result)

        case "isExtraFillInterstitialAdEnabled":
            isExtraFillInterstitialAdEnabled(result)
        case "setExtraFillInterstitialAdEnabled":
            setExtraFillInterstitialAdEnabled(call, result)

        default:
            print("\(casLogTag) Unknown method '\(call.method)'")
            result(FlutterMethodNotImplemented)
        }
    }

    private func isAutoloadEnabled(_ result: FlutterResult) {
        result(content.isAutoloadEnabled)
    }

    private func setAutoloadEnabled(_ call: FlutterMethodCall, _ result: FlutterResult) {
        call.getArgAndReturn("isEnabled", result) { isEnabled in
            content.isAutoloadEnabled = isEnabled
        }
    }

    private func isAutoshowEnabled(_ result: FlutterResult) {
        if let inter = content as? CASInterstitial {
            result(inter.isAutoshowEnabled)
        } else if let appOpen = content as? CASAppOpen {
            result(appOpen.isAutoshowEnabled)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func setAutoshowEnabled(_ call: FlutterMethodCall, _ result: FlutterResult) {
        guard let isEnabled: Bool = call.getArgAndCheckNil("isEnabled", result) else {
            return
        }
        if let inter = content as? CASInterstitial {
            inter.isAutoshowEnabled = isEnabled
            result(nil)
        } else if let appOpen = content as? CASAppOpen {
            appOpen.isAutoshowEnabled = isEnabled
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func isLoaded(_ result: FlutterResult) {
        result(content.isAdLoaded)
    }

    private func getContentInfo(_ result: FlutterResult) {
        result(contentInfoId)
    }

    private func loadAd(_ result: FlutterResult) {
        content.loadAd()

        result(nil)
    }

    private func present(_ result: FlutterResult) {
        let contentInfoId = contentInfoId
        let id = id

        if let inter = content as? CASInterstitial {
            inter.present()
        } else if let reward = content as? CASRewarded {
            reward.present(userDidEarnRewardHandler: { [weak handler] _ in
                handler?.invokeMethod(id, "onUserEarnedReward", ["contentInfoId": contentInfoId])
            })
        } else if let appOpen = content as? CASAppOpen {
            appOpen.present()
        }

        result(nil)
    }

    private func destroy(_ result: FlutterResult) {
        handler?.destroy(instance: self)
        content.destroy()

        result(nil)
    }

    // MARK: Interstitial

    private func getMinInterval(_ result: FlutterResult) {
        if let inter = content as? CASInterstitial {
            result(inter.minInterval)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func setMinInterval(_ call: FlutterMethodCall, _ result: FlutterResult) {
        if let inter = content as? CASInterstitial {
            if let interval: Int = call.getArgAndCheckNil("minInterval", result) {
                inter.minInterval = interval
                result(nil)
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func restartInterval(_ result: FlutterResult) {
        if let inter = content as? CASInterstitial {
            inter.restartInterval()
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: Rewarded

    private func isExtraFillInterstitialAdEnabled(_ result: FlutterResult) {
        result((content as? CASRewarded)?.isExtraFillInterstitialAdEnabled == true)
    }

    private func setExtraFillInterstitialAdEnabled(_ call: FlutterMethodCall, _ result: FlutterResult) {
        if let rewarded = content as? CASRewarded {
            if let isEnabled: Bool = call.getArgAndCheckNil("isEnabled", result) {
                rewarded.isExtraFillInterstitialAdEnabled = isEnabled
                result(nil)
            }
        } else {
            result(nil)
        }
    }

    // MARK: - CASScreenContentDelegate

    func screenAdDidLoadContent(_ ad: CASScreenContent) {
        handler?.onAdContentLoaded(contentInfoId, ad.contentInfo)
        handler?.invokeMethod(id, "onAdLoaded", ["contentInfoId": contentInfoId])
    }

    func screenAd(_ ad: CASScreenContent, didFailToLoadWithError error: AdError) {
        handler?.invokeMethod(
            id,
            "onAdFailedToLoad",
            [
                "format": ad.contentInfo?.format.value,
                "error": error.toDict(),
            ]
        )
    }

    func screenAdWillPresentContent(_ ad: CASScreenContent) {
        handler?.invokeMethod(id, "onAdShowed", ["contentInfoId": contentInfoId])
    }

    func screenAd(_ ad: CASScreenContent, didFailToPresentWithError error: AdError) {
        handler?.invokeMethod(
            id,
            "onAdFailedToShow",
            [
                "format": ad.contentInfo?.format.value,
                "error": error.toDict(),
            ]
        )
    }

    func screenAdDidClickContent(_ ad: CASScreenContent) {
        handler?.invokeMethod(id, "onAdClicked", ["contentInfoId": contentInfoId])
    }

    func screenAdDidDismissContent(_ ad: CASScreenContent) {
        handler?.invokeMethod(id, "onAdDismissed", ["contentInfoId": contentInfoId])
    }

    // MARK: - CASImpressionDelegate

    func adDidRecordImpression(info: AdContentInfo) {
        handler?.onAdContentLoaded(contentInfoId, info)
        handler?.invokeMethod(id, "onAdImpression", ["contentInfoId": contentInfoId])
    }
}
