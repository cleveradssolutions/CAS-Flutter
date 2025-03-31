//
//  InterstitialMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "cleveradssolutions/intertitial"

class InterstitialMethodHandler: AdMethodHandler<CASInterstitial> {
    private var contentDelegate: ScreenContentDelegateHandler?
    private var impressionDelegate: ImpressionDelegateHandler?

    init(with registrar: FlutterPluginRegistrar, _ contentInfoMethodHandler: AdContentInfoMethodHandler) {
        super.init(with: registrar, on: channelName, contentInfoMethodHandler)
    }

    override func initInstance(_ id: String) -> AdMethodHandler<CASInterstitial>.Ad {
        let interstitial = CASInterstitial(casID: id)
        let contentInfoId = "interstitial_\(id)"
        let contentDelegate = ScreenContentDelegateHandler(self, id, contentInfoId)
        self.contentDelegate = contentDelegate
        interstitial.delegate = contentDelegate
        let impressionDelegate = ImpressionDelegateHandler(self, id, contentInfoId)
        interstitial.impressionDelegate = impressionDelegate
        self.impressionDelegate = impressionDelegate
        return Ad(ad: interstitial, id: id, contentInfoId: contentInfoId)
    }

    override func onMethodCall(_ instance: Ad, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "isAutoloadEnabled":
            isAutoloadEnabled(instance.ad, result)
        case "setAutoloadEnabled":
            setAutoloadEnabled(instance.ad, call, result)
        case "isAutoshowEnabled":
            isAutoshowEnabled(instance.ad, result)
        case "setAutoshowEnabled":
            setAutoshowEnabled(instance.ad, call, result)
        case "isLoaded":
            isLoaded(instance.ad, result)
        case "getContentInfo":
            getContentInfo(instance.contentInfoId, result)
        case "load":
            load(instance.ad, result)
        case "show":
            show(instance.ad, result)
        case "destroy":
            destroy(instance, result)
        case "getMinInterval":
            getMinInterval(instance.ad, result)
        case "setMinInterval":
            setMinInterval(instance.ad, call, result)
        case "restartInterval":
            restartInterval(instance.ad, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func isAutoloadEnabled(_ interstitial: CASInterstitial, _ result: @escaping FlutterResult) {
        result(interstitial.isAutoloadEnabled)
    }

    private func setAutoloadEnabled(_ interstitial: CASInterstitial, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("isEnabled", result) { isEnabled in
            interstitial.isAutoloadEnabled = isEnabled
        }
    }

    private func isAutoshowEnabled(_ interstitial: CASInterstitial, _ result: @escaping FlutterResult) {
        result(interstitial.isAutoshowEnabled)
    }

    private func setAutoshowEnabled(_ interstitial: CASInterstitial, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("isEnabled", result) { isEnabled in
            interstitial.isAutoshowEnabled = isEnabled
        }
    }

    private func isLoaded(_ interstitial: CASInterstitial, _ result: @escaping FlutterResult) {
        result(interstitial.isAdLoaded)
    }

    private func getContentInfo(_ contentInfoId: String, _ result: @escaping FlutterResult) {
        result(contentInfoId)
    }

    private func load(_ interstitial: CASInterstitial, _ result: @escaping FlutterResult) {
        interstitial.loadAd()

        result(nil)
    }

    private func show(_ interstitial: CASInterstitial, _ result: @escaping FlutterResult) {
        interstitial.present()

        result(nil)
    }

    private func destroy(_ ad: AdMethodHandler<CASInterstitial>.Ad, _ result: @escaping FlutterResult) {
        contentDelegate = nil
        impressionDelegate = nil
        destroy(ad: ad)
        ad.ad.destroy()

        result(nil)
    }

    private func getMinInterval(_ interstitial: CASInterstitial, _ result: @escaping FlutterResult) {
        result(interstitial.minInterval)
    }

    private func setMinInterval(_ interstitial: CASInterstitial, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("interval", result) { interval in
            interstitial.minInterval = interval
        }
    }

    private func restartInterval(_ interstitial: CASInterstitial, _ result: @escaping FlutterResult) {
        interstitial.restartInterval()

        result(nil)
    }
}
