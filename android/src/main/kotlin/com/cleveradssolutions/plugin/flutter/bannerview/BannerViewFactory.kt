package com.cleveradssolutions.plugin.flutter.bannerview

import android.content.Context
import com.cleveradssolutions.plugin.flutter.CASBridge
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class BannerViewFactory(
    private val bridgeProvider: () -> CASBridge?,
    private val binaryMessenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    private val channel: EventChannel =
        EventChannel(binaryMessenger, "com.cleveradssolutions.plugin.flutter.bannerview")
    private val listener = BannerViewEventListener()

    init {
        channel.setStreamHandler(listener)
    }

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?

        return BannerView(context, viewId, creationParams, bridgeProvider, binaryMessenger, listener)
    }
}