//
//  ConsentFlowMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "com.cleveradssolutions.plugin.flutter/consent_flow"

class ConsentFlowMethodHandler: MethodHandler {
    init() {
        super.init(channelName: channelName)
    }

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "withPrivacyPolicy": withPrivacyPolicy(call, result)
        // disable in native
        case "disableConsentFlow": disableConsentFlow(call, result)
        // show in native
        case "showConsentFlow": showConsentFlow(call, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func withPrivacyPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let url = args["url"] as? String {
            CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().enableConsentFlow(url: url)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func disableConsentFlow(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().disableConsentFlow()
        result(nil)
    }

    private func showConsentFlow(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().showConsentFlow()
        result(nil)
    }
}
