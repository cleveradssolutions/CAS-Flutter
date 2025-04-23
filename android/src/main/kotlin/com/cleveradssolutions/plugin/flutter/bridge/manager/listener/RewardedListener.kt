package com.cleveradssolutions.plugin.flutter.bridge.manager.listener

import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdPaidCallback
import com.cleversolutions.ads.AdStatusHandler
import com.cleversolutions.ads.LoadAdCallback

internal class RewardedListener(
    private val handler: MethodHandler
) : AdPaidCallback, LoadAdCallback {

    override fun onAdLoaded() {
        handler.invokeMethod("OnRewardedAdLoaded")
    }

    override fun onAdFailedToLoad(error: AdError) {
        handler.invokeMethod(
            "OnRewardedAdFailedToLoad",
            mapOf("message" to error.message)
        )
    }

    override fun onShown(ad: AdStatusHandler) {
        handler.invokeMethod("OnRewardedAdShown")
    }

    override fun onAdRevenuePaid(ad: AdStatusHandler) {
        handler.invokeMethod("OnRewardedAdImpression", ad.toMap())
    }

    override fun onShowFailed(message: String) {
        handler.invokeMethod("OnRewardedAdFailedToShow", message)
    }

    override fun onClicked() {
        handler.invokeMethod("OnRewardedAdClicked")
    }

    override fun onComplete() {
        handler.invokeMethod("OnRewardedAdCompleted")
    }

    override fun onClosed() {
        handler.invokeMethod("OnRewardedAdClosed")
    }
}