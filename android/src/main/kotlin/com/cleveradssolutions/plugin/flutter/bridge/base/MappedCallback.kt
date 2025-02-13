package com.cleveradssolutions.plugin.flutter.bridge.base

import io.flutter.plugin.common.MethodChannel

open class MappedCallback(
    private val handler: MappedMethodHandler<*>,
    private val id: String
) : IMappedCallback {

    override fun invokeMethod(
        methodName: String,
        args: Map<String, Any?>?,
        callback: MethodChannel.Result?
    ) {
        handler.invokeMethod(id, methodName, args, callback)
    }

    override fun invokeMethod(
        methodName: String,
        vararg args: Pair<String, Any?>,
        callback: MethodChannel.Result?
    ) {
        handler.invokeMethod(id, methodName, args.toMap(), callback)
    }

}