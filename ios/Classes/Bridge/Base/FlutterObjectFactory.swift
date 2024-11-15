//
//  MethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import Flutter

class FlutterObjectFactory<T> {
    private var map: [String: T] = [:]

    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "initObject":
                call.getArgAndReturn("id", result) { id in
                    map[id] = initInstance(id: id)
                }
            case "disposeObject":
                call.getArgAndReturn("id", result) { id in
                    map.removeValue(forKey: id)
                }
            default:
                break
        }
    }

    func initInstance(id: String) -> T

    subscript(id: String) -> T? {
        return map[id]
    }
}
