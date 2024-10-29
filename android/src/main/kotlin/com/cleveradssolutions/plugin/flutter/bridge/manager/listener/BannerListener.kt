package com.cleveradssolutions.plugin.flutter.bridge.manager.listener

import com.cleveradssolutions.plugin.flutter.CASViewWrapperListener
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdStatusHandler

internal class BannerListener(
    private val handler: MethodHandler,
    sizeId: Int
) : CASViewWrapperListener {

    private val name = getBannerName(sizeId)

    override fun onLoaded() {
        handler.invokeMethod("OnBannerAdLoaded", mapOf("banner" to name))
    }

    override fun onFailed(error: Int) {
        handler.invokeMethod(
            "OnBannerAdFailedToLoad",
            mapOf(
                "banner" to name,
                "message" to AdError(error).message
            )
        )
    }

    override fun onShown() {
        handler.invokeMethod("OnBannerAdShown", mapOf("banner" to name))
    }

    override fun onImpression(impression: AdStatusHandler?) {
        handler.invokeMethod(
            "OnBannerAdImpression",
            mapOf("banner" to name) + (impression?.toMap() ?: emptyMap())
        )
    }

    override fun onClicked() {
        handler.invokeMethod("OnBannerAdClicked", mapOf("banner" to name))
    }

    override fun onRect(x: Int, y: Int, width: Int, height: Int) {
        handler.invokeMethod(
            "OnBannerAdRect",
            mapOf(
                "banner" to name,
                "x" to x,
                "y" to y,
                "width" to width,
                "height" to height
            )
        )
    }

    companion object {
        fun getBannerName(sizeId: Int): String {
            return when (sizeId) {
                2 -> "adaptive"
                3 -> "smart"
                4 -> "leader"
                5 -> "mrec"
                else -> "standard"
            }
        }
    }
}