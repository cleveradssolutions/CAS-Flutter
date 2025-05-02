//
//  ConsentFlowMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "cleveradssolutions/consent_flow"

class ConsentFlowMethodHandler: MappedMethodHandler<CASConsentFlow> {
    init(with registrar: FlutterPluginRegistrar) {
        super.init(with: registrar, on: channelName)
    }

    override func initInstance(_ id: String) -> CASConsentFlow {
       return CASConsentFlow()
            .withViewControllerToPresent(Util.findRootViewController())
            .withCompletionHandler(createDismissListener(id))
    }

    override func onMethodCall(_ consentFlow: CASConsentFlow, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "withPrivacyPolicy": withPrivacyPolicy(consentFlow, call, result)
        case "disable": disable(consentFlow, result)
        case "show": show(consentFlow, call, result)
        default: super.onMethodCall(consentFlow, call, result)
        }
    }

    private func withPrivacyPolicy(_ consentFlow: CASConsentFlow, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("url", result) { url in
            consentFlow.withPrivacyPolicy(url)
        }
    }

    private func disable(_ consentFlow: CASConsentFlow, _ result: @escaping FlutterResult) {
        consentFlow.isEnabled = false
        result(nil)
    }

    private func show(_ consentFlow: CASConsentFlow, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("force", result) { force in
            if force {
                consentFlow.present()
            } else {
                consentFlow.presentIfRequired()
            }
        }
    }

    private func createDismissListener(_ id: String) -> CASConsentCompletionHandler {
        return { [weak self] status in
            self?.invokeMethod(id, "onDismiss", ["status": status.rawValue])
        }
    }
}
