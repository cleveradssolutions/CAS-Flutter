//
//  MethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import Flutter

protocol AnyMappedMethodHandler: AnyObject {
    func invokeMethod(_ id: String, _ methodName: String, _ args: [String: Any?]?)
}

class MappedMethodHandler<T>: MethodHandler, AnyMappedMethodHandler {
    private var map: [String: T] = [:]

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let id: String = call.getArgAndCheckNil("id", result) else { return }
        switch call.method {
        case "init":
            map[id] = initInstance(id)
            result(nil)
        case "dispose":
            map.removeValue(forKey: id)
            result(nil)
        default:
            guard let instance = map[id] else {
                return result(call.errorFieldNil("id"))
            }
            onMethodCall(instance, call, result)
        }
    }

    func onMethodCall(_ instance: T, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        super.onMethodCall(call, result)
    }

    open func initInstance(_ id: String) -> T {
        fatalError("FlutterObjectFactory<T>.initInstance(id:) must be overridden in a subclass!")
    }

    subscript(_ id: String) -> T? {
        return map[id]
    }

    func invokeMethod(_ id: String, _ methodName: String, _ args: [String: Any?]? = nil) {
        guard var args = args else {
            invokeMethod(methodName, ["id": id])
            return
        }
        args["id"] = id;
        invokeMethod(methodName, args)
    }
}
