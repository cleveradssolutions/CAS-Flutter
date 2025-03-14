package com.cleveradssolutions.plugin.flutter.sdk.screen

import com.cleveradssolutions.plugin.flutter.bridge.base.FlutterCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.sdk.AdContentInfoHandler
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleveradssolutions.sdk.AdContentInfo
import com.cleveradssolutions.sdk.AdFormat
import com.cleveradssolutions.sdk.screen.ScreenAdContentCallback
import com.cleversolutions.ads.AdError

class ScreenAdContentCallbackHandler(
    handler: MappedMethodHandler<*>,
    id: String,
    private val adContentInfoHandler: AdContentInfoHandler
) : ScreenAdContentCallback(), FlutterCallback by MappedCallback(handler, id) {

    private val adContentInfoId = "app_open_$id"

    override fun onAdLoaded(ad: AdContentInfo) {
        adContentInfoHandler[adContentInfoId] = ad
        invokeMethod("onAdLoaded", "adContentInfoId" to adContentInfoId)
    }

    override fun onAdFailedToLoad(format: AdFormat, error: AdError) {
        invokeMethod(
            "onAdFailedToLoad",
            "format" to format.toMap(),
            "error" to error.toMap()
        )
    }

    override fun onAdShowed(ad: AdContentInfo) {
        invokeMethod("onAdShowed","adContentInfoId" to adContentInfoId)
    }

    override fun onAdFailedToShow(format: AdFormat, error: AdError) {
        invokeMethod(
            "onAdFailedToShow",
            "format" to format.toMap(),
            "error" to error.toMap()
        )
    }

    override fun onAdClicked(ad: AdContentInfo) {
        invokeMethod("onAdClicked", "adContentInfoId" to adContentInfoId)
    }

    override fun onAdDismissed(ad: AdContentInfo) {
        invokeMethod("onAdDismissed", "adContentInfoId" to adContentInfoId)
    }

}