@file:Suppress("NOTHING_TO_INLINE")

package com.cleveradssolutions.plugin.flutter

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

/**
 * Try get argument from call, return error if argument null.
 */
inline fun <T> MethodCall.getArgAndCheckNull(name: String, result: Result): T? {
    val arg = argument<T>(name)
    if (arg == null) result.errorArgNull(this, name)
    return arg
}

/**
 * Try get argument from call, do action with it and return action result.
 */
inline fun <T> MethodCall.getArgAndReturnResult(
    name: String,
    result: Result,
    action: (T) -> Any?
) {
    result.success(
        action(
            getArgAndCheckNull<T>(name, result) ?: return
        )
    )
}

inline fun <T, T2> MethodCall.getArgAndReturnResult(
    name1: String,
    name2: String,
    result: Result,
    action: (T, T2) -> Any?
) {
    result.success(
        action(
            getArgAndCheckNull<T>(name1, result) ?: return,
            getArgAndCheckNull<T2>(name2, result) ?: return
        )
    )
}

/**
 * Try get argument from call, do action with it and return null(void).
 */
inline fun <T> MethodCall.getArgAndReturn(name: String, result: Result, action: (T) -> Unit) =
    getArgAndReturnResult<T>(name, result) { action(it); null }

inline fun <T, T2> MethodCall.getArgAndReturn(
    name1: String,
    name2: String,
    result: Result,
    action: (T, T2) -> Unit
) = getArgAndReturnResult<T, T2>(name1, name2, result) { v1, v2 -> action(v1, v2); null }

inline fun Result.success() = success(null)

inline fun Result.error(call: MethodCall, message: String) = error(
    "MethodCallError",
    "Method: '${call.method}', error: $message",
    null
)

inline fun Result.errorArgNull(call: MethodCall, name: String) = error(
    "MethodCallArgumentNull",
    "Method: '${call.method}', error: argument '$name' is null",
    null
)

inline fun Result.errorFieldNull(call: MethodCall, name: String) = error(
    "MethodCallArgumentNull",
    "Method: '${call.method}', error: field '$name' is null",
    null
)

inline fun Result.errorInvalidArg(call: MethodCall, name: String) = error(
    "MethodCallInvalidArgument",
    "Method: '${call.method}', error: argument '$name' is invalid",
    null
)