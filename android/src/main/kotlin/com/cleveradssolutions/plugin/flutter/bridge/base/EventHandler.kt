package com.cleveradssolutions.plugin.flutter.bridge.base

import androidx.annotation.CallSuper
import androidx.annotation.MainThread
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.EventChannel

abstract class EventHandler(
    private val channelName: String
) : EventChannel.StreamHandler {

    private var channel: EventChannel? = null
    private var eventSink: EventChannel.EventSink? = null

    @CallSuper
    @MainThread
    open fun onAttachedToFlutter(flutterPluginBinding: FlutterPluginBinding) {
        channel = EventChannel(flutterPluginBinding.binaryMessenger, channelName).also {
            it.setStreamHandler(this)
        }
    }

    @CallSuper
    @MainThread
    open fun onDetachedFromFlutter() {
        channel?.let {
            it.setStreamHandler(null)
            channel = null
        }
    }

    @CallSuper
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    @CallSuper
    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    protected fun success(vararg pairs: Pair<*, *>) {
        eventSink?.success(pairs.toMap())
    }

}