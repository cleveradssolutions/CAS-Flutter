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
        case "disable": disable(result)
        case "show": show(result)
        default: super.onMethodCall(call, result)
        }
    }

    private func withPrivacyPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("url", result) { url in
            CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().enableConsentFlow(url: url)
        }
    }

    private func disable(_ result: @escaping FlutterResult) {
        CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().disableConsentFlow()
        result(nil)
    }

    private func show(_ result: @escaping FlutterResult) {
        CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().showConsentFlow()
        result(nil)
    }
}
