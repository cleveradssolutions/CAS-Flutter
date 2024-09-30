//
//  CASMethodHandler.swift
//  clever_ads_solutions
//
//  Created by Dmytro Uzhva on 12.08.2024.
//

import CleverAdsSolutions
import Flutter

private let channelName = "com.cleveradssolutions.plugin.flutter/cas"

class CASMethodHandler: MethodHandler {
    init() {
        super.init(channelName: channelName)
    }

    override func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getSDKVersion": getSDKVersion(result: result)
        case "validateIntegration": validateIntegration(result: result)
        default: super.onMethodCall(call: call, result: result)
        }
    }

    private func getSDKVersion(result: @escaping FlutterResult) {
        result(CAS.getSDKVersion())
    }

    private func validateIntegration(result: @escaping FlutterResult) {
        CAS.validateIntegration()
        result(nil)
    }
}
