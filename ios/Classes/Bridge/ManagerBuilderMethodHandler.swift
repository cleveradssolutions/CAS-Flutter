//
//  ManagerBuilderMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "com.cleveradssolutions.plugin.flutter/manager_builder"

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
        case "withUserId": withUserId(call, result)
        case "withMediationExtras": withMediationExtras(call, result)
        case "build": build(call, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func withTestAdMode(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("isEnabled", result) { isEnabled in
            builder.withTestAdMode(isEnabled)
        }
    }

    private func withUserId(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("userId", result) { userId in
            builder.withUserID(userId)
        }
    }

    private func withMediationExtras(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("key", "value", result) { key, value in
            builder.withMediationExtras(value, forKey: key)
        }
    }

    private func build(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let id: String = call.getArgAndCheckNil("id", result),
           let formats: Int = call.getArgAndCheckNil("formats", result),
           let version: String = call.getArgAndCheckNil("version", result) {
            let manager = builder
                .withAdFlags(CASTypeFlags(rawValue: UInt(formats)))
                .withFramework("Flutter", version: version)
                .withConsentFlow(consentFlowMethodHandler.getConsentFlow())
                .withCompletionHandler({ [weak self] initialConfig in
                    self?.invokeMethod(methodName: "onCASInitialized", args: [
                        "error": initialConfig.error as Any?,
                        "countryCode": initialConfig.countryCode,
                        "isConsentRequired": initialConfig.isConsentRequired,
                        "testMode": initialConfig.manager.isDemoAdMode
                    ])
                })
                .create(withCasId: id)

            mediationManagerMethodHandler.bridge =
                CASBridge(manager, mediationManagerMethodHandler)

            builderField = nil

            result(nil)
        }
    }
}
