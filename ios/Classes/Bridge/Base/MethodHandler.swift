//
//  MethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import Flutter

private let logTag = "[MethodHandler]"

class MethodHandler {
    private var channelName: String
    private var channel: FlutterMethodChannel

    init(with registrar: FlutterPluginRegistrar, on channelName: String) {
        self.channelName = channelName
        let binaryMessenger = registrar.messenger()
        channel = FlutterMethodChannel(name: channelName, binaryMessenger: binaryMessenger)
        channel.setMethodCallHandler { [weak self] call, result in
            self?.onMethodCall(call, result)
        }
    }

    open func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        print("\(logTag) Unknown method '\(call.method)' in '\(channelName)'")
        result(FlutterMethodNotImplemented)
    }

    func invokeMethod(methodName: String, args: Any? = nil) {
        channel.invokeMethod(methodName, arguments: args, result: nil)
    }
}
