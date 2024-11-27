package com.cleveradssolutions.plugin.flutter.bridge.base

abstract class MappedCallback(
    private val handler: MappedMethodHandler<*>,
    private val id: String
) {

    fun invokeMethod(methodName: String, args: Map<String, Any?>) {
        handler.invokeMethod(id, methodName, args)
    }

    fun invokeMethod(methodName: String, vararg args: Pair<String, Any?>) {
        handler.invokeMethod(id, methodName, *args)
    }

}