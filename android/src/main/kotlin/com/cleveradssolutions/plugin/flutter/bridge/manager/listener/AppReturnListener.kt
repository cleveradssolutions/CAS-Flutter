package com.cleveradssolutions.plugin.flutter.bridge.manager.listener

import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdPaidCallback
import com.cleversolutions.ads.AdStatusHandler
import com.cleversolutions.ads.LoadAdCallback

internal class AppReturnListener(
    private val handler: MethodHandler
) : AdPaidCallback, LoadAdCallback {
    override fun onAdLoaded() {}

    override fun onAdFailedToLoad(error: AdError) {}

    override fun onShown(ad: AdStatusHandler) {
        handler.invokeMethod("OnAppReturnAdShown")
    }

    override fun onAdRevenuePaid(ad: AdStatusHandler) {
        handler.invokeMethod("OnAppReturnAdImpression", ad.toMap())
    }

    override fun onShowFailed(message: String) {
        handler.invokeMethod("OnAppReturnAdFailedToShow", mapOf("message" to message))
    }

    override fun onClicked() {
        handler.invokeMethod("OnAppReturnAdClicked")
    }

    override fun onClosed() {
        handler.invokeMethod("OnAppReturnAdClosed")
    }
}