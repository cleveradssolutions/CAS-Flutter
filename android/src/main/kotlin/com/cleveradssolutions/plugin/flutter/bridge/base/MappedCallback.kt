package com.cleveradssolutions.plugin.flutter.bridge.base

import io.flutter.plugin.common.MethodChannel

abstract class MappedCallback(
    private val handler: MappedMethodHandler<*>,
    private val id: String
) {

    fun invokeMethod(
        methodName: String,
        args: Map<String, Any?>? = null,
        callback: MethodChannel.Result? = null
    ) {
        handler.invokeMethod(id, methodName, args, callback)
    }

    fun invokeMethod(
        methodName: String,
        vararg args: Pair<String, Any?>,
        callback: MethodChannel.Result? = null
    ) {
        handler.invokeMethod(id, methodName, args.toMap(), callback)
    }

}