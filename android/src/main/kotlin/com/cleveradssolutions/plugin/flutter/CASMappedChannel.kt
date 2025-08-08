package com.cleveradssolutions.plugin.flutter

import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

abstract class CASMappedChannel<T>(
    binding: FlutterPlugin.FlutterPluginBinding,
    private val name: String
) : MethodChannel.MethodCallHandler {
    private val channel = MethodChannel(binding.binaryMessenger, name)
    private val map = HashMap<String, T>()

    init {
        @Suppress("LeakingThis")
        channel.setMethodCallHandler(this)
    }

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
        Log.e(CAS_LOG_TAG, "Unknown method '${call.method}' in '$name'")
        result.notImplemented()
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
        args: HashMap<String, Any?>? = null,
        callback: MethodChannel.Result? = null
    ) {
        val map = args ?: HashMap()
        map["id"] = id
        channel.invokeMethod(methodName, map, callback)
    }
}
