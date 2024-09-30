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
    private var channel: FlutterMethodChannel?

    init(channelName: String) {
        self.channelName = channelName
    }

    open func onAttachedToFlutter(_ registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger()
        channel = FlutterMethodChannel(name: channelName, binaryMessenger: binaryMessenger)
        channel!.setMethodCallHandler(onMethodCall)
    }

    open func onDetachedFromFlutter() {
        channel?.setMethodCallHandler(nil)
        channel = nil
    }

    open func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        print("\(logTag) Unknown method '\(call.method)' in '\(channelName)'")
        result(FlutterMethodNotImplemented)
    }

    func invokeMethod(methodName: String, args: [String: Any?]? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.channel?.invokeMethod(methodName, arguments: args, result: { (result: Any?) in
                if let error = result as? FlutterError {
                    print("\(logTag) Error: invokeMethod '\(methodName)' failed, errorCode: \(error.code), message: \(error.message ?? ""), details: \(String(describing: error.details))")
                } else if FlutterMethodNotImplemented.isEqual(result) {
                    print("\(logTag) Critical Error: invokeMethod '\(methodName)' notImplemented")
                }
            })
        }
    }
}
