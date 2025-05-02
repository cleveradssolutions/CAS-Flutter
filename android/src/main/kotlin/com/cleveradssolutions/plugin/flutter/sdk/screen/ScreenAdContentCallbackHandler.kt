package com.cleveradssolutions.plugin.flutter.sdk.screen

import com.cleveradssolutions.plugin.flutter.bridge.base.AdMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.base.FlutterCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleveradssolutions.sdk.AdContentInfo
import com.cleveradssolutions.sdk.AdFormat
import com.cleveradssolutions.sdk.screen.ScreenAdContentCallback
import com.cleversolutions.ads.AdError

class ScreenAdContentCallbackHandler(
    private val handler: AdMethodHandler<*>,
    id: String,
    private val contentInfoId: String
) : ScreenAdContentCallback(), FlutterCallback by MappedCallback(handler, id) {

    override fun onAdLoaded(ad: AdContentInfo) {
        handler.onAdContentLoaded(contentInfoId, ad)
        invokeMethod("onAdLoaded", "contentInfoId" to contentInfoId)
    }

    override fun onAdFailedToLoad(format: AdFormat, error: AdError) {
        invokeMethod(
            "onAdFailedToLoad",
            "format" to format.value,
            "error" to error.toMap()
        )
    }

    override fun onAdShowed(ad: AdContentInfo) {
        invokeMethod("onAdShowed", "contentInfoId" to contentInfoId)
    }

    override fun onAdFailedToShow(format: AdFormat, error: AdError) {
        invokeMethod(
            "onAdFailedToShow",
            "format" to format.value,
            "error" to error.toMap()
        )
    }

    override fun onAdClicked(ad: AdContentInfo) {
        invokeMethod("onAdClicked", "contentInfoId" to contentInfoId)
    }

    override fun onAdDismissed(ad: AdContentInfo) {
        invokeMethod("onAdDismissed", "contentInfoId" to contentInfoId)
    }

}