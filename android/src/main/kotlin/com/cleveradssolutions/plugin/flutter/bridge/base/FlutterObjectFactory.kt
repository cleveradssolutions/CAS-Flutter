package com.cleveradssolutions.plugin.flutter.bridge.base

import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

abstract class FlutterObjectFactory<T>(
    binding: FlutterPlugin.FlutterPluginBinding,
    channelName: String
) : MethodHandler(binding, channelName) {

    private val map: MutableMap<String, T> = HashMap()

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<String>("id", result) { id ->
            when (call.method) {
                "initObject" -> map[id] = initInstance(id)
                "disposeObject" -> map.remove(id)
                else -> super.onMethodCall(call, result)
            }
        }
    }

    abstract fun initInstance(id: String): T

    operator fun get(id: String): T? = map[id]

}
