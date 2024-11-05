//
//  CASMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "cleveradssolutions/cas"

class CASMethodHandler: MethodHandler {
    init(with registrar: FlutterPluginRegistrar) {
        super.init(with: registrar, on: channelName)
    }

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "getSDKVersion": getSDKVersion(result)
        case "validateIntegration": validateIntegration(result)
        default: super.onMethodCall(call, result)
        }
    }

    private func getSDKVersion(_ result: @escaping FlutterResult) {
        result(CAS.getSDKVersion())
    }

    private func validateIntegration(_ result: @escaping FlutterResult) {
        CAS.validateIntegration()
        result(nil)
    }
}
