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
    init() {
        super.init(channelName: channelName)
    }

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "setLastPageContent": setLastPageContent(call, result)
        case "loadAd": loadAd(call, result)
        case "isReadyAd": isReadyAd(call, result)
        case "showAd": showAd(call, result)
        case "enableAppReturn": enableAppReturn(call, result)
        case "skipNextAppReturnAds": skipNextAppReturnAds(result)
        case "setEnabled": setEnabled(call, result)
        case "isEnabled": isEnabled(call, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func setLastPageContent(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let json = args["lastPageJson"] as? String {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.setLastPageContent(json: json)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func loadAd(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int {
            if adType == 1 {
                CASFlutter.cleverAdsSolutions.getCasBridge()?.loadInterstitial()
                result(nil)
            } else if adType == 2 {
                CASFlutter.cleverAdsSolutions.getCasBridge()?.loadRewarded()
                result(nil)
            } else {
                result(FlutterError(code: "", message: "AdType is not supported", details: nil))
            }
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func isReadyAd(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int {
            if adType == 1 {
                let ready = CASFlutter.cleverAdsSolutions.getCasBridge()?.isInterstitialReady() ?? false
                result(Bool(ready))
            } else if adType == 2 {
                let ready = CASFlutter.cleverAdsSolutions.getCasBridge()?.isRewardedAdReady() ?? false
                result(Bool(ready))
            } else {
                result(FlutterError(code: "", message: "AdType is not supported", details: nil))
            }
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func showAd(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int {
            if adType == 1 {
                CASFlutter.cleverAdsSolutions.getCasBridge()?.showInterstitial()
                result(nil)
            } else if adType == 2 {
                CASFlutter.cleverAdsSolutions.getCasBridge()?.showRewarded()
                result(nil)
            } else {
                result(FlutterError(code: "", message: "AdType is not supported", details: nil))
            }
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func enableAppReturn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let enable = args["enable"] as? Bool {
            if enable {
                CASFlutter.cleverAdsSolutions.getCasBridge()?.enableReturnAds()
            } else {
                CASFlutter.cleverAdsSolutions.getCasBridge()?.disableReturnAds()
            }
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func skipNextAppReturnAds(_ result: @escaping FlutterResult) {
        CASFlutter.cleverAdsSolutions.getCasBridge()?.skipNextReturnAds()
        result(nil)
    }

    private func setEnabled(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int,
           let enabled = args["enable"] as? Bool {
            if adType < 0 || adType > 2 {
                result(FlutterError(code: "", message: "AdType is not correct", details: nil))
            } else {
                CASFlutter.cleverAdsSolutions.getCasBridge()?.setEnabled(type: adType, enable: enabled)
                result(nil)
            }
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func isEnabled(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int {
            if adType < 0 || adType > 2 {
                result(FlutterError(code: "", message: "AdType is not correct", details: nil))
            } else {
                result(CASFlutter.cleverAdsSolutions.getCasBridge()?.isEnabled(type: adType))
            }
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }
}
