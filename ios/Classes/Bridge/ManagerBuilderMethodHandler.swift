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

    private let rootViewControllerProvider: () -> UIViewController?
    private let onManagerBuilt: (CASBridge) -> Void

    private var casBridgeBuilder: CASBridgeBuilder?
    private let queue = DispatchQueue(label: "com.cleveradssolutions.plugin.flutter/manager_builder.casBridgeBuilder")

    init(
        _ consentFlowMethodHandler: ConsentFlowMethodHandler,
        _ mediationManagerMethodHandler: MediationManagerMethodHandler,
        _ rootViewControllerProvider: @escaping () -> UIViewController?,
        _ onManagerBuilt: @escaping (CASBridge) -> Void
    ) {
        self.consentFlowMethodHandler = consentFlowMethodHandler
        self.mediationManagerMethodHandler = mediationManagerMethodHandler
        self.rootViewControllerProvider = rootViewControllerProvider
        self.onManagerBuilt = onManagerBuilt
        super.init(channelName: channelName)
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
        guard let builder = getCASBridgeBuilder(call, result) else { return }

        call.getArgAndReturn("isEnabled", result) { isEnabled in
            builder.withTestMode(isEnabled: isEnabled)
        }
    }

    private func withUserId(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let builder = getCASBridgeBuilder(call, result) else { return }

        call.getArgAndReturn("userId", result) { userId in
            builder.setUserId(id: userId)
        }
    }

    private func withMediationExtras(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let builder = getCASBridgeBuilder(call, result) else { return }

        call.getArgAndReturn("key", "value", result) { key, value in
            builder.addExtras(keyString: key, valueString: value)
        }
    }

    private func build(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let builder = getCASBridgeBuilder(call, result),
           let casId: String = call.getArgAndCheckNil("id", result),
           let formats: Int = call.getArgAndCheckNil("formats", result),
           let version: String = call.getArgAndCheckNil("version", result) {
            let casBridge = builder.build(id: casId, flutterVersion: casId, formats: CASTypeFlags(rawValue: UInt(formats)), mediationManagerMethodHandler: mediationManagerMethodHandler)
            onManagerBuilt(casBridge)

            casBridgeBuilder = nil

            result(nil)
        }
    }

    private func getCASBridgeBuilder(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> CASBridgeBuilder? {
        return casBridgeBuilder ?? queue.sync {
            casBridgeBuilder ?? createCASBridgeBuilder(call, result)
        }
    }

    private func createCASBridgeBuilder(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) -> CASBridgeBuilder? {
        if let rootViewController = rootViewControllerProvider() {
            casBridgeBuilder = CASBridgeBuilder(rootViewController, FlutterInitCallback())
            return casBridgeBuilder
        } else {
            result(call.error("Failed to create CASBridgeBuilder because rootViewController is nil"))
            return nil
        }
    }
}
