package com.cleveradssolutions.plugin.flutter.bannerview

import android.view.View
import android.view.ViewTreeObserver
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.util.pxToDp
import com.cleversolutions.ads.AdSize
import io.flutter.plugin.common.MethodChannel
import kotlin.math.roundToInt

class BannerSizeListener(
    private val banner: View,
    handler: MappedMethodHandler<*>,
    id: String
) : MappedCallback(handler, id), ViewTreeObserver.OnGlobalLayoutListener {

    private var lastWidth: Int = 0
    private var lastHeight: Int = 0

    private var isWaitingFlutter = false

    override fun onGlobalLayout() {
        if (isWaitingFlutter) return

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

    fun updateSize(size: AdSize) {
        isWaitingFlutter = true

        val currentWidth = size.width
        val currentHeight = size.height

        val context = banner.context
        val lastWidthDp = lastWidth.pxToDp(context).roundToInt()
        val lastHeightDp = lastHeight.pxToDp(context).roundToInt()

        if (currentWidth != lastWidthDp || currentHeight != lastHeightDp) {
            invokeMethod(
                "updateWidgetSize",
                "width" to currentWidth.toFloat(),
                "height" to currentHeight.toFloat(),
                callback = object : MethodChannel.Result {
                    override fun success(result: Any?) {
                        lastWidth = currentWidth
                        lastHeight = currentHeight
                        isWaitingFlutter = false
                        banner.invalidate()
                    }

                    override fun error(
                        errorCode: String,
                        errorMessage: String?,
                        errorDetails: Any?
                    ) {
                    }

                    override fun notImplemented() {}
                }
            )
        }
    }

}