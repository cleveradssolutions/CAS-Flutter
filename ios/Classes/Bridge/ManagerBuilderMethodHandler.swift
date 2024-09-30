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
        if let args = call.arguments as? Dictionary<String, Any>,
           let enabled = args["enabled"] as? Bool {
            CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().withTestMode(enable: enabled)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func withUserId(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let id = args["userId"] as? String {
            CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().setUserId(id: id)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func withMediationExtras(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let key = args["key"] as? String,
           let value = args["value"] as? String {
            CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().addExtras(keyString: key, valueString: value)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func build(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let casId = args["id"] as? String,
           let formats = args["formats"] as? Int,
           let version = args["version"] as? String {
            CASFlutter.cleverAdsSolutions.buildBridge(id: casId, flutterVersion: version, formats: formats)
            result(nil)
        } else {
            result(call.errorArgNil("id"))
        }
    }
}
