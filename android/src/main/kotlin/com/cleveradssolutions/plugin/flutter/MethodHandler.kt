package com.cleveradssolutions.plugin.flutter

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

interface MethodHandler {
    fun onMethodCall(call: MethodCall, result: MethodChannel.Result): Boolean
}

inline fun <T> MethodHandler.tryGetArg(
    name: String,
    call: MethodCall,
    result: MethodChannel.Result,
    action: (T) -> Any?
) {
    call.argument<T>(name)?.let { result.success(action(it)) }
        ?: result.error(
            "MethodHandler",
            "Method: '${call.method}', arg: '$name' is null",
            null)
}

inline fun <T> MethodHandler.tryGetArgSetValue(
    name: String,
    call: MethodCall,
    result: MethodChannel.Result,
    action: (T) -> Unit
) {
    tryGetArg<T>(name, call, result) {
        action(it)
        null
    }
}