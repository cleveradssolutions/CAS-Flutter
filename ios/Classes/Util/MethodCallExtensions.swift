//
//  MethodCallExtensions.swift
//  clever_ads_solutions
//
//  Created by Dmytro Uzhva on 25.09.2024.
//

import Flutter

private let logTag = "[MethodHandler]"

extension FlutterMethodCall {
    /// Try get argument from call, return error if argument null.
    func getArgAndCheckNull<T>(name: String, result: FlutterResult) -> T? {
        if let args = arguments as? [String: Any],
           let arg = args["name"] as? T {
            return arg
        } else {
            result(errorArgNull(name))
            return nil
        }
    }

    /// Try get argument from call, do action with it and return action result.
    func getArgAndReturnResult<T>(
        name: String,
        result: @escaping FlutterResult,
        action: (T) -> Any?
    ) {
        guard let args = arguments as? [String: Any] else { return result(errorArgNull("args")) }
        guard let arg = args[name] as? T else { return result(errorArgNull(name)) }
        result(action(arg))
    }

    /// Try get arguments from call, do action with it and return action result.
    func getArgAndReturnResult<T, T2>(
        name1: String,
        name2: String,
        result: @escaping FlutterResult,
        action: (T, T2) -> Any?
    ) {
        guard let args = arguments as? [String: Any] else { return result(errorArgNull("args")) }
        guard let arg1 = args[name1] as? T else { return result(errorArgNull(name1)) }
        guard let arg2 = args[name2] as? T2 else { return result(errorArgNull(name2)) }
        result(action(arg1, arg2))
    }

    /// Try get argument from call, do action with it and return null.
//    func getArgAndReturn<T>(
//        name: String,
//        result: @escaping FlutterResult,
//        action: (T) -> Void
//    ) {
//        getArgAndReturnResult(name: name, result: result, action: action)
//    }

    func error(_ message: String) -> FlutterError {
        return FlutterError(
            code: "MethodCallError",
            message: "\(logTag) Method: '\(method)', error: \(message)",
            details: nil
        )
    }

    func errorArgNull(_ name: String) -> FlutterError {
        return FlutterError(
            code: "MethodCallArgumentNull",
            message: "\(logTag) Method: '\(method)', error: argument '\(name)' is nil",
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
