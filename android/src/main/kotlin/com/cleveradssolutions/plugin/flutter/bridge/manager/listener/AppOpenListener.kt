package com.cleveradssolutions.plugin.flutter.bridge.manager.listener

import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdPaidCallback
import com.cleversolutions.ads.AdStatusHandler
import com.cleversolutions.ads.LoadAdCallback

class AppOpenListener(
    private val handler: MethodHandler
) : AdPaidCallback, LoadAdCallback {
    override fun onAdLoaded() {
        handler.invokeMethod("OnAppOpenAdLoaded")
    }

    override fun onAdFailedToLoad(error: AdError) {
        handler.invokeMethod(
            "OnAppOpenAdFailedToLoad",
            mapOf("message" to error.message)
        )
    }

    override fun onShown(ad: AdStatusHandler) {
        handler.invokeMethod("OnAppOpenAdShown")
    }

    override fun onAdRevenuePaid(ad: AdStatusHandler) {
        handler.invokeMethod("OnAppOpenAdImpression", ad.toMap())
    }

    override fun onShowFailed(message: String) {
        handler.invokeMethod("OnAppOpenAdFailedToShow", mapOf("message" to message))
    }

    override fun onClicked() {
        handler.invokeMethod("OnAppOpenAdClicked")
    }

    override fun onClosed() {
        handler.invokeMethod("OnAppOpenAdClosed")
    }
} 