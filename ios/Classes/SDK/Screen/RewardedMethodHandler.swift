//
//  RewardedMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "cleveradssolutions/rewarded"

class RewardedMethodHandler: AdMethodHandler<CASRewarded> {
    private var contentDelegate: ScreenContentDelegateHandler?
    private var impressionDelegate: ImpressionDelegateHandler?
    
    init(with registrar: FlutterPluginRegistrar, _ contentInfoMethodHandler: AdContentInfoMethodHandler) {
        super.init(with: registrar, on: channelName, contentInfoMethodHandler)
    }

    override func initInstance(_ id: String) -> AdMethodHandler<CASRewarded>.Ad {
        let rewarded = CASRewarded(casID: id)
        let contentInfoId = "rewarded_\(id)"
        let contentDelegate = ScreenContentDelegateHandler(self, id, contentInfoId)
        self.contentDelegate = contentDelegate
        rewarded.delegate = contentDelegate
        let impressionDelegate = ImpressionDelegateHandler(self, id, contentInfoId)
        rewarded.impressionDelegate = impressionDelegate
        self.impressionDelegate = impressionDelegate
        return Ad(ad: rewarded, id: id, contentInfoId: contentInfoId)
    }

    override func onMethodCall(_ instance: Ad, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "isAutoloadEnabled":
            isAutoloadEnabled(instance.ad, result)
        case "setAutoloadEnabled":
            setAutoloadEnabled(instance.ad, call, result)
        case "isExtraFillInterstitialAdEnabled":
            isExtraFillInterstitialAdEnabled(instance.ad, result)
        case "setExtraFillInterstitialAdEnabled":
            setExtraFillInterstitialAdEnabled(instance.ad, call, result)
        case "isLoaded":
            isLoaded(instance.ad, result)
        case "getContentInfo":
            getContentInfo(instance.contentInfoId, result)
        case "load":
            load(instance.ad, result)
        case "show":
            show(instance, result)
        case "destroy":
            destroy(instance, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func isAutoloadEnabled(_ rewarded: CASRewarded, _ result: @escaping FlutterResult) {
        result(rewarded.isAutoloadEnabled)
    }

    private func setAutoloadEnabled(_ rewarded: CASRewarded, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("isEnabled", result) { isEnabled in
            rewarded.isAutoloadEnabled = isEnabled
        }
    }

    private func isExtraFillInterstitialAdEnabled(_ rewarded: CASRewarded, _ result: @escaping FlutterResult) {
//        result(rewarded.isExtraFillInterstitialAdEnabled)

        result(nil)
    }

    private func setExtraFillInterstitialAdEnabled(_ rewarded: CASRewarded, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        call.getArgAndReturn("isEnabled", result) { isEnabled in
//            rewarded.isExtraFillInterstitialAdEnabled = isEnabled
//        }

        result(nil)
    }

    private func isLoaded(_ rewarded: CASRewarded, _ result: @escaping FlutterResult) {
        result(rewarded.isAdLoaded)
    }

    private func getContentInfo(_ contentInfoId: String, _ result: @escaping FlutterResult) {
        result(contentInfoId)
    }

    private func load(_ rewarded: CASRewarded, _ result: @escaping FlutterResult) {
        rewarded.loadAd()

        result(nil)
    }

    private func show(_ ad: AdMethodHandler<CASRewarded>.Ad, _ result: @escaping FlutterResult) {
        let userDidEarnRewardHandler = UserDidEarnRewardDelegateHandler(self, ad.id, ad.contentInfoId)
        let id = ad.id
        ad.ad.present(userDidEarnRewardHandler: { info in
            invokeMethod("onUserEarnedReward", ["contentInfoId": contentInfoId])
        })

        result(nil)
    }

    private func destroy(_ ad: AdMethodHandler<CASRewarded>.Ad, _ result: @escaping FlutterResult) {
        contentDelegate = nil
        impressionDelegate = nil
        destroy(ad: ad)
        ad.ad.destroy()

        result(nil)
    }
}
