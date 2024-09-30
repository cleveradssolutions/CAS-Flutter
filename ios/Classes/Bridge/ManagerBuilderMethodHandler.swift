//
//  ManagerBuilderMethodHandler.swift
//  clever_ads_solutions
//
//  Created by Dmytro Uzhva on 19.09.2024.
//

import CleverAdsSolutions
import Flutter

private let channelName = "com.cleveradssolutions.plugin.flutter/manager_builder"

class ManagerBuilderMethodHandler: MethodHandler {
    init() {
        super.init(channelName: channelName)
    }

    override func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "withTestAdMode": withTestAdMode(call: call, result: result)
        case "withUserId": setUserId(call: call, result: result)
        case "withMediationExtras": withMediationExtras(call: call, result: result)
        case "build": buildBridge(call: call, result: result)
        default: super.onMethodCall(call: call, result: result)
        }
    }

    private func withTestAdMode(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let enabled = args["enabled"] as? Bool {
            CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().withTestMode(enable: enabled)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func withUserId(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let id = args["userId"] as? String {
            CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().setUserId(id: id)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func withMediationExtras(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let key = args["key"] as? String,
           let value = args["value"] as? String {
            CASFlutter.cleverAdsSolutions.getCasBridgeBuilder().addExtras(keyString: key, valueString: value)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func build(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let casId = args["id"] as? String,
           let formats = args["formats"] as? Int,
           let version = args["version"] as? String {
            flutterInit = true
            CASFlutter.cleverAdsSolutions.buildBridge(id: casId, flutterVersion: version, formats: formats)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }
}
