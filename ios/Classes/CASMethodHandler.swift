//
//  CASMethodHandler.swift
//  Runner
//
//  Created by Dmytro Uzhva on 12.08.2024.
//

import CleverAdsSolutions
import Flutter

private let logTag = "CASMethodHandler"

class CASMethodHandler: MethodHandler {
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool {
        switch call.method {
        case "getSDKVersion": getSDKVersion(result: result)
        case "validateIntegration": validateIntegration(result: result)
        default: return false
        }
        return true
    }

    private func getSDKVersion(result: @escaping FlutterResult) {
        result(CAS.getSDKVersion())
    }

    private func validateIntegration(result: @escaping FlutterResult) {
        CAS.validateIntegration()
        result(nil)
    }
}
