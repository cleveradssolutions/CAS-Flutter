//
//  ManagerBuilderMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "cleveradssolutions/manager_builder"

class ManagerBuilderMethodHandler: MethodHandler {
    private let consentFlowMethodHandler: ConsentFlowMethodHandler
    private let mediationManagerMethodHandler: MediationManagerMethodHandler

    private var builderField: CleverAdsSolutions.CASManagerBuilder?
    private var builder: CleverAdsSolutions.CASManagerBuilder {
        if let builder = builderField { return builder }
        let instance = CAS.buildManager()
        builderField = instance
        return instance
    }

    init(
        with registrar: FlutterPluginRegistrar,
        _ consentFlowMethodHandler: ConsentFlowMethodHandler,
        _ mediationManagerMethodHandler: MediationManagerMethodHandler
    ) {
        self.consentFlowMethodHandler = consentFlowMethodHandler
        self.mediationManagerMethodHandler = mediationManagerMethodHandler
        super.init(with: registrar, on: channelName)
    }

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "withTestAdMode": withTestAdMode(call, result)
        case "withAdTypes": withAdTypes(call, result)
        case "withUserId": withUserId(call, result)
        case "withConsentFlow": withConsentFlow(call, result)
        case "withMediationExtras": withMediationExtras(call, result)
        case "withFramework": withFramework(call, result)
        case "build": build(call, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func withTestAdMode(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("isEnabled", result) { isEnabled in
            builder.withTestAdMode(isEnabled)
        }
    }

    private func withAdTypes(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("adTypes", result) { (adTypes: Int) in
            builder.withAdFlags(CASTypeFlags(rawValue: UInt(adTypes)))
        }
    }

    private func withUserId(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("userId", result) { userId in
            builder.withUserID(userId)
        }
    }

    private func withConsentFlow(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let id: String = call.getArgAndCheckNil("id", result) {
            if let consentFlow = consentFlowMethodHandler[id] {
                builder.withConsentFlow(consentFlow)
                result(nil)
            } else {
                result(call.errorFieldNil("consentFlow"))
            }
        }
    }

    private func withMediationExtras(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("key", "value", result) { key, value in
            builder.withMediationExtras(value, forKey: key)
        }
    }

    private func withFramework(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("pluginVersion", result) { pluginVersion in
            builder.withFramework("Flutter", version: pluginVersion)
        }
    }

    private func build(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("id", result) { id in
            let manager = builder
                .withCompletionHandler({ [weak self] initialConfig in
                    self?.invokeMethod("onCASInitialized", [
                        "error": initialConfig.error as Any?,
                        "countryCode": initialConfig.countryCode,
                        "isConsentRequired": initialConfig.isConsentRequired,
                        "testMode": initialConfig.manager.isDemoAdMode,
                    ])
                })
                .create(withCasId: id)

            mediationManagerMethodHandler.setManager(manager)

            builderField = nil
        }
    }
}
