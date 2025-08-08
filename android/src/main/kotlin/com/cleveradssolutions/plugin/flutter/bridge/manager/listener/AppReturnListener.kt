package com.cleveradssolutions.plugin.flutter.bridge.manager.listener

import com.cleveradssolutions.plugin.flutter.CASChannel
import com.cleveradssolutions.plugin.flutter.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdPaidCallback
import com.cleversolutions.ads.AdStatusHandler
import com.cleversolutions.ads.LoadAdCallback

@Deprecated("Old implementation")
internal class AppReturnListener(
    private val handler: CASChannel
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
        handler.invokeMethod("OnAppReturnAdFailedToShow", message)
    }

    override fun onClicked() {
        handler.invokeMethod("OnAppReturnAdClicked")
    }

    override fun onClosed() {
        handler.invokeMethod("OnAppReturnAdClosed")
    }
}