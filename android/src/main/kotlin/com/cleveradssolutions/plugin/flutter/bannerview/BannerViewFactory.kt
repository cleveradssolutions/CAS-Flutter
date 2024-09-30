package com.cleveradssolutions.plugin.flutter.bannerview

import android.content.Context
import com.cleveradssolutions.plugin.flutter.CASBridge
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class BannerViewFactory(
    private val binaryMessenger: BinaryMessenger,
    private val bridgeProvider: () -> CASBridge?
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<*, *>?
        return BannerView(
            context,
            viewId,
            creationParams,
            binaryMessenger,
            bridgeProvider
        )
    }

}