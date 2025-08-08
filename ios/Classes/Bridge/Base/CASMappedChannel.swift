//
//  CASMappedChannel.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import Flutter

class CASMappedChannel<T> {
    private var map: [String: T] = [:]
    var channelName: String
    private var channel: FlutterMethodChannel

    init(with registrar: FlutterPluginRegistrar, on channelName: String) {
        self.channelName = channelName
        let binaryMessenger = registrar.messenger()
        channel = FlutterMethodChannel(name: "cleveradssolutions/" + channelName, binaryMessenger: binaryMessenger)
        channel.setMethodCallHandler { [weak self] call, result in
            self?.onMethodCall(call, result)
        }
    }

    final func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
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

    open func onMethodCall(_ instance: T, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        print("\(casLogTag) Unknown method '\(call.method)' in '\(channelName)'")
        result(FlutterMethodNotImplemented)
    }

    open func initInstance(_ id: String) -> T {
        fatalError("CASMappedChannel<T>.initInstance(id:) must be overridden in a subclass!")
    }

    subscript(_ id: String) -> T? {
        get {
            return map[id]
        }
        set(newValue) {
            map[id] = newValue
        }
    }

    func remove(_ id: String) -> T? {
        return map.removeValue(forKey: id)
    }

    func invokeMethod(_ id: String, _ methodName: String) {
        channel.invokeMethod(methodName, arguments: ["id": id], result: nil)
    }

    func invokeMethod(_ id: String, _ methodName: String, _ args: [String: Any?]) {
        var newArgs = args
        newArgs["id"] = id
        channel.invokeMethod(methodName, arguments: newArgs, result: nil)
    }
}
