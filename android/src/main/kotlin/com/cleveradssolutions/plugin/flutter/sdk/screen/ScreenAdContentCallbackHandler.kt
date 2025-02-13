package com.cleveradssolutions.plugin.flutter.sdk.screen

import com.cleveradssolutions.plugin.flutter.bridge.base.IMappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleveradssolutions.sdk.AdContent
import com.cleveradssolutions.sdk.AdFormat
import com.cleveradssolutions.sdk.screen.ScreenAdContentCallback
import com.cleversolutions.ads.AdError

class ScreenAdContentCallbackHandler(
    handler: MappedMethodHandler<*>,
    id: String
) : ScreenAdContentCallback(), IMappedCallback by MappedCallback(handler, id) {

    override fun onAdLoaded(ad: AdContent) {
        invokeMethod("onAdLoaded")
    }

    override fun onAdFailedToLoad(format: AdFormat, error: AdError) {
        invokeMethod("onAdFailedToLoad", error.toMap())
    }

    override fun onAdShowed(ad: AdContent) {
        invokeMethod("onAdShowed", ad.toMap())
    }

    override fun onAdFailedToShow(format: AdFormat, error: AdError) {
        invokeMethod("onAdFailedToShow", error.toMap())
    }

    override fun onAdClicked(ad: AdContent) {
        invokeMethod("onAdClicked")
    }

    override fun onAdDismissed(ad: AdContent) {
        invokeMethod("onAdDismissed")
    }

}