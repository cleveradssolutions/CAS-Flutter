package com.cleveradssolutions.plugin.flutter.bannerview

import android.content.Context
import android.util.Log
import com.cleveradssolutions.plugin.flutter.bridge.base.AdMethodHandler
import com.cleveradssolutions.plugin.flutter.sdk.OnAdImpressionListenerHandler
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.plugin.platform.PlatformView

private const val LOG_TAG = "CAS.AI.Flutter/BannerView"

class BannerView(
    context: Context,
    viewId: Int,
    args: Map<*, *>?,
    private val methodHandler: BannerMethodHandler
) : PlatformView {

    private val id: String = args?.get("id") as? String ?: ""

    private val banner: CASBannerView

    init {
        val casId = args?.get("casId") as? String
        val contentInfoId = "banner_$id"

        banner = if (casId != null) CASBannerView(context, casId) else CASBannerView(context)
        banner.id = viewId
        val sizeListener = BannerSizeListener(banner, methodHandler, id)
        banner.adListener = BannerCallback(sizeListener, methodHandler, id)
        banner.onImpressionListener =
            OnAdImpressionListenerHandler(methodHandler, id, contentInfoId)

        methodHandler[id] = AdMethodHandler.Ad(this, id, contentInfoId)

        if (args == null) {
            Log.e(LOG_TAG, "BannerView args is null")
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
        methodHandler.remove(id)
        banner.destroy()
    }

}