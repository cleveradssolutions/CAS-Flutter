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
    init() {
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
        call.getArgAndReturn("isEnabled", result) { isEnabled in
            CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().withTestMode(isEnabled: isEnabled)
        }
    }

    private func withUserId(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("userId", result) { userId in
            CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().setUserId(id: userId)
        }
    }

    private func withMediationExtras(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("key", "value", result) { key, value in
            CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().addExtras(keyString: key, valueString: value)
        }
    }

    private func build(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let casId: String = call.getArgAndCheckNil("id", result),
           let formats: Int = call.getArgAndCheckNil("formats", result),
           let version: String = call.getArgAndCheckNil("version", result) {
            CASFlutter.cleverAdsSolutions.buildBridge(id: casId, flutterVersion: version, formats: formats)
            result(nil)
        }
    }
}
