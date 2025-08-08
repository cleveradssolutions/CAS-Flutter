package com.cleveradssolutions.plugin.flutter.bridge.manager.listener

import com.cleveradssolutions.plugin.flutter.CASChannel
import com.cleveradssolutions.plugin.flutter.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdStatusHandler

@Deprecated("Old implementation")
internal class BannerListener(
    private val handler: CASChannel,
    sizeId: Int
) {

    private val name = getBannerName(sizeId)

    fun onLoaded() {
        handler.invokeMethod("OnBannerAdLoaded", hashMapOf("banner" to name))
    }

    fun onFailed(error: Int) {
        handler.invokeMethod(
            "OnBannerAdFailedToLoad",
            hashMapOf(
                "banner" to name,
                "message" to AdError(error).message
            )
        )
    }

    fun onShown() {
        handler.invokeMethod("OnBannerAdShown", hashMapOf("banner" to name))
    }

    fun onImpression(impression: AdStatusHandler?) {
        val args = impression?.toMap() ?: HashMap()
        args["banner"] = name
        handler.invokeMethod("OnBannerAdImpression", args)
    }

    fun onClicked() {
        handler.invokeMethod("OnBannerAdClicked", hashMapOf("banner" to name))
    }

    fun onRect(x: Int, y: Int, width: Int, height: Int) {
        handler.invokeMethod(
            "OnBannerAdRect",
            hashMapOf(
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