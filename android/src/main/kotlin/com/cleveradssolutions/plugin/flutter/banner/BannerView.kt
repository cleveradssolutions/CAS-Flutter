package com.cleveradssolutions.plugin.flutter.banner

import android.content.Context
import android.util.Log
import android.view.ViewTreeObserver
import com.cleveradssolutions.plugin.flutter.AdMethodHandler
import com.cleveradssolutions.plugin.flutter.CAS_LOG_TAG
import com.cleveradssolutions.sdk.AdContentInfo
import com.cleveradssolutions.sdk.OnAdImpressionListener
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdImpression
import com.cleversolutions.ads.AdViewListener
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class BannerView(
    context: Context,
    viewId: Int,
    args: Map<*, *>?,
    private val handler: BannerMethodHandler
) : PlatformView, AdViewListener, ViewTreeObserver.OnGlobalLayoutListener,
    OnAdImpressionListener {

    private val id: String = args?.get("id") as? String ?: ""
    private val contentInfoId: String = "banner_$id"

    private val banner: CASBannerView

    private var lastWidth: Float = 0f
    private var lastHeight: Float = 0f

    init {
        val casId = args?.get("casId") as? String

        banner = if (casId != null) CASBannerView(context, casId) else CASBannerView(context)
        banner.id = viewId
        banner.adListener = this
        banner.onImpressionListener = this

        handler[id] = AdMethodHandler.Ad(this, id, contentInfoId)

        if (args == null) {
            Log.e(CAS_LOG_TAG, "BannerView args is null")
        } else {
            (args["size"] as? Map<*, *>)?.let { size ->
                banner.size = BannerMethodHandler.getAdSize(context, size)
            }

            (args["isAutoloadEnabled"] as? Boolean)?.let {
                banner.isAutoloadEnabled = it
            }

            (args["refreshInterval"] as? Int)?.let {
                banner.refreshInterval = it
            }
        }
    }

    override fun getView(): CASBannerView {
        return banner
    }

    override fun dispose() {
        handler.remove(id)
        banner.destroy()
    }

    override fun onAdViewLoaded(view: CASBannerView) {
        handler.invokeMethod(id, "onAdViewLoaded")

        val size = view.size
        updateSize(size.width, size.height)
    }

    override fun onAdViewFailed(view: CASBannerView, error: AdError) {
        handler.invokeMethod(id, "onAdViewFailed", hashMapOf("error" to error.message))

        updateSize(0, 0)
    }

    override fun onAdViewPresented(view: CASBannerView, info: AdImpression) {
    }

    override fun onAdViewClicked(view: CASBannerView) {
        handler.invokeMethod(id, "onAdViewClicked")
    }

    override fun onAdImpression(ad: AdContentInfo) {
        handler.onAdContentLoaded(contentInfoId, ad) // Required only for the banner
        handler.invokeMethod(id, "onAdImpression", hashMapOf("contentInfoId" to contentInfoId))
    }

    override fun onGlobalLayout() {
        banner.viewTreeObserver.removeOnGlobalLayoutListener(this)

        val context = banner.context
        val density = context.resources.displayMetrics.density
        val currentWidthDp = banner.width.toFloat() / density
        val currentHeightDp = banner.height.toFloat() / density

        if (currentWidthDp != lastWidth || currentHeightDp != lastHeight) {
            lastWidth = currentWidthDp
            lastHeight = currentHeightDp

            handler.invokeMethod(
                id,
                "updateWidgetSize",
                hashMapOf(
                    "width" to currentWidthDp,
                    "height" to currentHeightDp
                )
            )
        }
    }

    private fun updateSize(widthInt: Int, heightInt: Int) {
        val width = widthInt.toFloat()
        val height = heightInt.toFloat()

        if (width != lastWidth || height != lastHeight) {
            lastWidth = width
            lastHeight = width

            val callback = if (width > 0) {
                object : MethodChannel.Result {
                    override fun success(result: Any?) {
                        if (width > 0) {
                            banner.post {
                                banner.viewTreeObserver.addOnGlobalLayoutListener(this@BannerView)
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
            } else null

            handler.invokeMethod(
                id,
                "updateWidgetSize",
                hashMapOf(
                    "width" to width,
                    "height" to height
                ),
                callback = callback
            )
        }
    }

}