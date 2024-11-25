package com.cleveradssolutions.plugin.flutter.bridge.base

import com.cleveradssolutions.plugin.flutter.util.errorFieldNull
import com.cleveradssolutions.plugin.flutter.util.getArgAndCheckNull
import com.cleveradssolutions.plugin.flutter.util.success
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

abstract class MappedMethodHandler<T>(
    binding: FlutterPlugin.FlutterPluginBinding,
    channelName: String
) : MethodHandler(binding, channelName) {

    private val map: MutableMap<String, T> = HashMap()

    final override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val id = call.getArgAndCheckNull<String>("id", result) ?: return
        when (call.method) {
            "init" -> {
                map[id] = initInstance(id)
                result.success()
            }

            "dispose" -> {
                map.remove(id)
                result.success()
            }

            else -> {
                val instance = map[id] ?: return result.errorFieldNull(call, "$id in $this")
                onMethodCall(instance, call, result)
            }
        }
    }

    open fun onMethodCall(instance: T, call: MethodCall, result: MethodChannel.Result) {
        super.onMethodCall(call, result)
    }

    abstract fun initInstance(id: String): T

    operator fun get(id: String): T? = map[id]

    fun invokeMethod(id: String, methodName: String, args: Map<String, Any?>) {
        invokeMethod(methodName, args + ("id" to id))
    }

    fun invokeMethod(id: String, methodName: String, vararg args: Pair<String, Any?>) {
        invokeMethod(methodName, "id" to id, *args)
    }

}
