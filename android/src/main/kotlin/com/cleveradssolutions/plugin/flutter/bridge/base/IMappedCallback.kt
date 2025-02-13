package com.cleveradssolutions.plugin.flutter.bridge.base

import io.flutter.plugin.common.MethodChannel

interface IMappedCallback {

    fun invokeMethod(
        methodName: String,
        args: Map<String, Any?>? = null,
        callback: MethodChannel.Result? = null
    )

    fun invokeMethod(
        methodName: String,
        vararg args: Pair<String, Any?>,
        callback: MethodChannel.Result? = null
    )

}
