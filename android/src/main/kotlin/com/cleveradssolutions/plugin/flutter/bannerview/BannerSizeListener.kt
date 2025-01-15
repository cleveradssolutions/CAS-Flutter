package com.cleveradssolutions.plugin.flutter.bannerview

import android.view.View
import android.view.ViewTreeObserver
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.util.pxToDp
import io.flutter.plugin.common.MethodChannel

class BannerSizeListener(
    private val banner: View,
    handler: MappedMethodHandler<*>,
    id: String
) : MappedCallback(handler, id), ViewTreeObserver.OnGlobalLayoutListener {

    private var lastWidth: Float = 0f
    private var lastHeight: Float = 0f

    override fun onGlobalLayout() {
        banner.viewTreeObserver.removeOnGlobalLayoutListener(this)

        val context = banner.context
        val currentWidth = banner.width.pxToDp(context)
        val currentHeight = banner.height.pxToDp(context)

        if (currentWidth != lastWidth || currentHeight != lastHeight) {
            lastWidth = currentWidth
            lastHeight = currentHeight

            invokeMethod(
                "updateWidgetSize",
                "width" to currentWidth,
                "height" to currentHeight
            )
        }
    }

    fun updateSize(widthInt: Int, heightInt: Int) {
        val width = widthInt.toFloat()
        val height = heightInt.toFloat()

        if (width != lastWidth || height != lastHeight) {
            lastWidth = width
            lastHeight = width

            invokeMethod(
                "updateWidgetSize",
                "width" to width,
                "height" to height,
                callback = object : MethodChannel.Result {
                    override fun success(result: Any?) {
                        if (width > 0) {
                            banner.post {
                                banner.viewTreeObserver.addOnGlobalLayoutListener(this@BannerSizeListener)
                                banner.invalidate()
                            }
                        }
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