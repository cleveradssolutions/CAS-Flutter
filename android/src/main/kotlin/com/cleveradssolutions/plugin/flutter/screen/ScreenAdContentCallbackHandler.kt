package com.cleveradssolutions.plugin.flutter.screen

import com.cleveradssolutions.plugin.flutter.AdMethodHandler
import com.cleveradssolutions.plugin.flutter.toMap
import com.cleveradssolutions.sdk.AdContentInfo
import com.cleveradssolutions.sdk.AdFormat
import com.cleveradssolutions.sdk.OnAdImpressionListener
import com.cleveradssolutions.sdk.screen.OnRewardEarnedListener
import com.cleveradssolutions.sdk.screen.ScreenAdContentCallback
import com.cleversolutions.ads.AdError

class ScreenAdContentCallbackHandler(
    private val handler: AdMethodHandler<*>,
    private val id: String,
    private val contentInfoId: String
) : ScreenAdContentCallback(), OnRewardEarnedListener, OnAdImpressionListener {

    override fun onAdLoaded(ad: AdContentInfo) {
        handler.onAdContentLoaded(contentInfoId, ad)
        handler.invokeMethod(id, "onAdLoaded", hashMapOf("contentInfoId" to contentInfoId))
    }

    override fun onAdFailedToLoad(format: AdFormat, error: AdError) {
        handler.invokeMethod(
            id,
            "onAdFailedToLoad",
            hashMapOf(
                "format" to format.value,
                "error" to error.toMap()
            )
        )
    }

    override fun onAdShowed(ad: AdContentInfo) {
        handler.invokeMethod(id, "onAdShowed", hashMapOf("contentInfoId" to contentInfoId))
    }

    override fun onAdFailedToShow(format: AdFormat, error: AdError) {
        handler.invokeMethod(
            id,
            "onAdFailedToShow",
            hashMapOf(
                "format" to format.value,
                "error" to error.toMap()
            )
        )
    }

    override fun onAdClicked(ad: AdContentInfo) {
        handler.invokeMethod(id, "onAdClicked", hashMapOf("contentInfoId" to contentInfoId))
    }

    override fun onAdDismissed(ad: AdContentInfo) {
        handler.invokeMethod(id, "onAdDismissed", hashMapOf("contentInfoId" to contentInfoId))
    }

    override fun onUserEarnedReward(ad: AdContentInfo) {
        handler.invokeMethod(
            id,
            "onUserEarnedReward",
            hashMapOf("contentInfoId" to contentInfoId)
        )
    }

    override fun onAdImpression(ad: AdContentInfo) {
        handler.onAdContentLoaded(contentInfoId, ad) // Required only for the banner
        handler.invokeMethod(id, "onAdImpression", hashMapOf("contentInfoId" to contentInfoId))
    }
}