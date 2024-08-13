//
//  MethodHandler.swift
//  Runner
//
//  Created by Dmytro Uzhva on 12.08.2024.
//

import Flutter

protocol MethodHandler {
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool
}

extension MethodHandler {
    func tryGetArg<T>(
        name: String,
        call: FlutterMethodCall,
        result: @escaping FlutterResult,
        action: (T) -> Any?
    ) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let arg = args[name] as? T {
            result(action(arg))
        } else {
            result(FlutterError(
                code: "MethodHandler",
                message: "Method: '\(call.method)', arg: '\(name)' is nil",
                details: nil
            ))
        }
    }

    func tryGetArgSetValue<T>(
        name: String,
        call: FlutterMethodCall,
        result: @escaping FlutterResult,
        action: (T) -> Void
    ) {
        tryGetArg(name: name, call: call, result: result) { arg in
            action(arg)
            return nil
        }
    }
}
