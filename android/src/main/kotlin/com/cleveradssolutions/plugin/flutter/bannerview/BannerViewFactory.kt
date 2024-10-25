package com.cleveradssolutions.plugin.flutter.bannerview

import android.content.Context
import com.cleveradssolutions.plugin.flutter.bridge.MediationManagerMethodHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class BannerViewFactory(
    private val binding: FlutterPluginBinding,
    private val managerHandler: MediationManagerMethodHandler
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<*, *>?
        return BannerView(
            context,
            viewId,
            creationParams,
            binding,
            managerHandler.manager
        )
    }

}