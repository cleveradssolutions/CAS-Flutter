//
//  MethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import Flutter

class FlutterObjectFactory<T>: MethodHandler {
    private var map: [String: T] = [:]

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("id", result) { id in
            switch call.method {
            case "initObject": map[id] = initInstance(id: id)
            case "disposeObject": map.removeValue(forKey: id)
            default: super.onMethodCall(call, result)
            }
        }
    }

    open func initInstance(id: String) -> T {
        fatalError("FlutterObjectFactory<T>.initInstance(id:) must be overridden in a subclass!")
    }

    subscript(id: String) -> T? {
        return map[id]
    }
}
