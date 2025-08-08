package com.cleveradssolutions.plugin.flutter.banner

import android.content.Context
import com.cleveradssolutions.plugin.flutter.AdContentInfoMethodHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class BannerViewFactory(
    binding: FlutterPluginBinding,
    contentInfoHandler: AdContentInfoMethodHandler
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private val methodHandler = BannerMethodHandler(binding, contentInfoHandler)

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        return BannerView(
            context,
            viewId,
            args as Map<*, *>?,
            methodHandler
        )
    }

}