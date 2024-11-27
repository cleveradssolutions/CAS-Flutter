package com.cleveradssolutions.plugin.flutter.bannerview

import android.content.Context
import com.cleveradssolutions.plugin.flutter.bridge.manager.MediationManagerMethodHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class BannerViewFactory(
    binding: FlutterPluginBinding,
    private val managerHandler: MediationManagerMethodHandler
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private val methodHandler = BannerMethodHandler(binding)

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return BannerView(
            context,
            viewId,
            args as Map<*, *>?,
            managerHandler.manager,
            methodHandler
        )
    }

}