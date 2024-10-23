//
//  MediationManagerMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "com.cleveradssolutions.plugin.flutter/mediation_manager"

class MediationManagerMethodHandler: MethodHandler {
    private let bridgeProvider: () -> CASBridge?

    let flutterInterstitialListener: CASFlutterCallback = FlutterInterstitialCallback()
    let flutterRewardedListener: CASFlutterCallback = FlutterRewardedCallback()
    let flutterAppReturnListener: FlutterAppReturnCallback

    init(with registrar: FlutterPluginRegistrar, _ bridgeProvider: @escaping () -> CASBridge?) {
        self.bridgeProvider = bridgeProvider
        flutterAppReturnListener = FlutterAppReturnCallback()
        super.init(with: registrar, on: channelName)
        flutterInterstitialListener.setFlutterCaller(caller: invokeMethod)
        flutterRewardedListener.setFlutterCaller(caller: invokeMethod)
        flutterAppReturnListener.setFlutterCaller(caller: invokeMethod)
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

        case "createBannerView": showBanner(call, result)
        case "showBanner": showBanner(call, result)
        case "hideBanner": hideBanner(call, result)
        case "setBannerPosition": setBannerPosition(call, result)
        default: super.onMethodCall(call, result)
        }
    }

//    private func setLastPageContent(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
//        call.getArgAndReturn("lastPageJson", result) { json in
//            CASFlutter.cleverAdsSolutions.getCasBridge()?.setLastPageContent(json: json)
//        }
//    }

    private func loadAd(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let bridge = getBridgeAndCheckNil(call, result),
           let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int {
            if adType == 1 {
                bridge.loadInterstitial()
                result(nil)
            } else if adType == 2 {
                bridge.loadRewarded()
                result(nil)
            } else {
                result(FlutterError(code: "", message: "AdType is not supported", details: nil))
            }
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func isReadyAd(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let bridge = getBridgeAndCheckNil(call, result),
           let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int {
            if adType == 1 {
                let ready = bridge.isInterstitialReady()
                result(Bool(ready))
            } else if adType == 2 {
                let ready = bridge.isRewardedAdReady()
                result(Bool(ready))
            } else {
                result(FlutterError(code: "", message: "AdType is not supported", details: nil))
            }
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func showAd(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let bridge = getBridgeAndCheckNil(call, result),
           let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int {
            if adType == 1 {
                bridge.showInterstitial()
                result(nil)
            } else if adType == 2 {
                bridge.showRewarded()
                result(nil)
            } else {
                result(FlutterError(code: "", message: "AdType is not supported", details: nil))
            }
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func enableAppReturn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let bridge = getBridgeAndCheckNil(call, result),
           let args = call.arguments as? Dictionary<String, Any>,
           let enable = args["enable"] as? Bool {
            if enable {
                bridge.enableReturnAds()
            } else {
                bridge.disableReturnAds()
            }
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func skipNextAppReturnAds(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let bridge = getBridgeAndCheckNil(call, result) {
            bridge.skipNextReturnAds()
            result(nil)
        }
    }

    private func setEnabled(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let bridge = getBridgeAndCheckNil(call, result),
           let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int,
           let enabled = args["enable"] as? Bool {
            if adType < 0 || adType > 2 {
                result(FlutterError(code: "", message: "AdType is not correct", details: nil))
            } else {
                bridge.setEnabled(type: adType, enable: enabled)
                result(nil)
            }
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func isEnabled(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let bridge = getBridgeAndCheckNil(call, result),
           let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int {
            if adType < 0 || adType > 2 {
                result(FlutterError(code: "", message: "AdType is not correct", details: nil))
            } else {
                result(bridge.isEnabled(type: adType))
            }
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func showBanner(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let bridge = getBridgeAndCheckNil(call, result),
           let sizeId: Int = call.getArgAndCheckNil("sizeId", result) {
            bridge.showGlobalBannerAd(mediationManagerMethodHandler: self, sizeId: sizeId)
            result(nil)
        }
    }

    private func hideBanner(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let bridge = getBridgeAndCheckNil(call, result),
           let sizeId: Int = call.getArgAndCheckNil("sizeId", result) {
            bridge.hideBanner(sizeId: sizeId)
            result(nil)
        }
    }

    private func setBannerPosition(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let bridge = getBridgeAndCheckNil(call, result),
           let sizeId: Int = call.getArgAndCheckNil("sizeId", result),
           let positionId: Int = call.getArgAndCheckNil("positionId", result),
           let xOffset: Int = call.getArgAndCheckNil("x", result),
           let yOffset: Int = call.getArgAndCheckNil("y", result) {
            bridge.setBannerPosition(sizeId: sizeId, positionId: positionId, x: xOffset, y: yOffset)
            result(nil)
        }
    }

    private func getBridgeAndCheckNil(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> CASBridge? {
        let bridge = bridgeProvider()
        if bridge == nil { result(call.errorFieldNil("CASBridge")) }
        return bridge
    }
}
