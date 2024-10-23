//
//  MethodCallExtensions.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import Flutter

private let logTag = "[MethodHandler]"

extension FlutterMethodCall {
    /// Try get argument from call, return error if argument null.
    func getArgAndCheckNil<T>(_ name: String, _ result: FlutterResult) -> T? {
        if let args = arguments as? [String: Any],
           let arg = args[name] as? T {
            return arg
        } else {
            result(errorArgNil(name))
            return nil
        }
    }

    /// Try get argument from call, do action with it and return action result.
    func getArgAndReturnResult<T>(
        _ name: String,
        _ result: @escaping FlutterResult,
        _ action: (T) -> Any?
    ) {
        guard let args = arguments as? [String: Any] else { return result(errorArgNil("args")) }
        guard let arg = args[name] as? T else { return result(errorArgNil(name)) }
        result(action(arg))
    }

    /// Try get arguments from call, do action with it and return action result.
    func getArgAndReturnResult<T, T2>(
        _ name1: String,
        _ name2: String,
        _ result: @escaping FlutterResult,
        _ action: (T, T2) -> Any?
    ) {
        guard let args = arguments as? [String: Any] else { return result(errorArgNil("args")) }
        guard let arg1 = args[name1] as? T else { return result(errorArgNil(name1)) }
        guard let arg2 = args[name2] as? T2 else { return result(errorArgNil(name2)) }
        result(action(arg1, arg2))
    }

    /// Try get argument from call, do action with it and return null.
    func getArgAndReturn<T>(_ name: String, _ result: @escaping FlutterResult, _ action: (T) -> Void) {
        getArgAndReturnResult(name, result) { value in action(value); return nil }
    }

    /// Try get argument from call, do action with it and return null.
    func getArgAndReturn<T, T2>(_ name1: String, _ name2: String, _ result: @escaping FlutterResult, _ action: (T, T2) -> Void) {
        getArgAndReturnResult(name1, name2, result) { v1, v2 in action(v1, v2); return nil }
    }

    func error(_ message: String) -> FlutterError {
        return FlutterError(
            code: "MethodCallError",
            message: "\(logTag) Method: '\(method)', error: \(message)",
            details: nil
        )
    }

    func errorArgNil(_ name: String) -> FlutterError {
        return FlutterError(
            code: "MethodCallArgumentNull",
            message: "\(logTag) Method: '\(method)', error: argument '\(name)' is nil",
            details: nil
        )
    }

    func errorFieldNil(_ name: String) -> FlutterError {
        return FlutterError(
            code: "MethodCallArgumentNull",
            message: "\(logTag) Method: '\(method)', error: field '\(name)' is nil",
            details: nil
        )
    }

    func errorInvalidArg(_ name: String) -> FlutterError {
        return FlutterError(
            code: "MethodCallInvalidArgument",
            message: "\(logTag) Method: '\(method)', error: argument '\(name)' is invalid",
            details: nil
        )
    }
}
