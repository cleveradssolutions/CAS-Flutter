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

    open fun initInstance(id: String): T =
        throw NotImplementedError("MappedMethodHandler<T>.initInstance(id:) must be overridden in a subclass!")

    operator fun get(id: String): T? = map[id]

    operator fun set(id: String, value: T) {
        map[id] = value
    }

    fun remove(id: String) = map.remove(id)

    fun invokeMethod(
        id: String,
        methodName: String,
        args: Map<String, Any?>? = null,
        callback: MethodChannel.Result? = null
    ) {
        invokeMethod(
            methodName,
            if (args == null) mapOf("id" to id) else args + ("id" to id),
            callback
        )
    }

    fun invokeMethod(
        id: String,
        methodName: String,
        vararg args: Pair<String, Any?>,
        callback: MethodChannel.Result? = null
    ) {
        invokeMethod(methodName, args.toMap() + ("id" to id), callback)
    }

}
