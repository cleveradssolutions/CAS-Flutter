package com.cleveradssolutions.plugin.flutter.bridge.manager.listener

import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdPaidCallback
import com.cleversolutions.ads.AdStatusHandler
import com.cleversolutions.ads.LoadAdCallback

internal class InterstitialListener(
    private val handler: MethodHandler
) : AdPaidCallback, LoadAdCallback {
    override fun onAdLoaded() {
        handler.invokeMethod("OnInterstitialAdLoaded")
    }

    override fun onAdFailedToLoad(error: AdError) {
        handler.invokeMethod(
            "OnInterstitialAdFailedToLoad",
            mapOf("message" to error.message)
        )
    }

    override fun onShown(ad: AdStatusHandler) {
        handler.invokeMethod("OnInterstitialAdShown")
    }

    override fun onAdRevenuePaid(ad: AdStatusHandler) {
        handler.invokeMethod("OnInterstitialAdImpression", ad.toMap())
    }

    override fun onShowFailed(message: String) {
        handler.invokeMethod("OnInterstitialAdFailedToShow", mapOf("message" to message))
    }

    override fun onClicked() {
        handler.invokeMethod("OnInterstitialAdClicked")
    }

    override fun onClosed() {
        handler.invokeMethod("OnInterstitialAdClosed")
    }
}