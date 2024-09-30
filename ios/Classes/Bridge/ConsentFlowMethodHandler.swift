//
//  ConsentFlowMethodHandler.swift
//  clever_ads_solutions
//
//  Created by Dmytro Uzhva on 24.09.2024.
//

import CleverAdsSolutions
import Flutter

private let channelName = "com.cleveradssolutions.plugin.flutter/consent_flow"

class ConsentFlowMethodHandler: MethodHandler {
    init() {
        super.init(channelName: channelName)
    }

    override func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "withPrivacyPolicy": withPrivacyPolicy(call: call, result: result)
        // disable in native
        case "disableConsentFlow": disableConsentFlow(call: call, result: result)
        // show in native
        case "showConsentFlow": showConsentFlow(call: call, result: result)
        default: super.onMethodCall(call: call, result: result)
        }
    }

    private func withPrivacyPolicy(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let url = args["url"] as? String {
            CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().enableConsentFlow(url: url)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func disableConsentFlow(call: FlutterMethodCall, result: @escaping FlutterResult) {
        CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().disableConsentFlow()
        result(nil)
    }

    private func showConsentFlow(call: FlutterMethodCall, result: @escaping FlutterResult) {
        CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().showConsentFlow()
        result(nil)
    }
}
