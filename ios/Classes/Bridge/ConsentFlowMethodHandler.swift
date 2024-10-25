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
    private var consentFlow: CASConsentFlow?
    private var consentFlowDismissListener: CASConsentCompletionHandler?

    init(with registrar: FlutterPluginRegistrar) {
        super.init(with: registrar, on: channelName)
        consentFlowDismissListener = { [weak self] status in
            self?.invokeMethod("OnDismissListener", ["status": status.rawValue])
        }
    }

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "withPrivacyPolicy": withPrivacyPolicy(call, result)
        case "disable": disable(result)
        case "show": show(call, result)
        default: super.onMethodCall(call, result)
        }
    }

    func getConsentFlow() -> CASConsentFlow {
        if let consentFlow = consentFlow { return consentFlow }

        consentFlow = CASConsentFlow()
            .withViewControllerToPresent(Util.findRootViewController())
            .withCompletionHandler(consentFlowDismissListener)

        return consentFlow!
    }

    private func withPrivacyPolicy(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("url", result) { url in
            getConsentFlow().withPrivacyPolicy(url)
        }
    }

    private func disable(_ result: @escaping FlutterResult) {
        consentFlow = CASConsentFlow(isEnabled: false)
            .withCompletionHandler(consentFlowDismissListener)
        result(nil)
    }

    private func show(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("force", result) { force in
            if force {
                getConsentFlow().present()
            } else {
                getConsentFlow().presentIfRequired()
            }
        }
        result(nil)
    }
}
