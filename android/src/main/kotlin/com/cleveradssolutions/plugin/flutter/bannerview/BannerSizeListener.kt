package com.cleveradssolutions.plugin.flutter.bannerview

import android.view.View
import android.view.ViewTreeObserver
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.util.pxToDp

class BannerSizeListener(
    private val banner: View,
    handler: MappedMethodHandler<*>,
    id: String
) : MappedCallback(handler, id), ViewTreeObserver.OnGlobalLayoutListener {

    private var lastWidth: Int = 0
    private var lastHeight: Int = 0

    override fun onGlobalLayout() {
        val currentWidth = banner.width
        val currentHeight = banner.height

        if (currentWidth != lastWidth || currentHeight != lastHeight) {
            lastWidth = currentWidth
            lastHeight = currentHeight

            val context = banner.context
            invokeMethod(
                "updateWidgetSize",
                "width" to currentWidth.pxToDp(context),
                "height" to currentHeight.pxToDp(context)
            )
        }
    }

}