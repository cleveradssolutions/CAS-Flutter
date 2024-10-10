package com.cleveradssolutions.plugin.flutter.bannerview

import com.cleveradssolutions.plugin.flutter.bridge.base.EventHandler
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdImpression
import com.cleversolutions.ads.AdViewListener
import com.cleversolutions.ads.android.CASBannerView

private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/banner."

class BannerEventHandler(
    flutterId: String
) : AdViewListener, EventHandler(CHANNEL_NAME + flutterId) {

    override fun onAdViewLoaded(view: CASBannerView) {
        success("event" to "onAdViewLoaded")
    }

    override fun onAdViewFailed(view: CASBannerView, error: AdError) {
        success(
            "event" to "onAdViewFailed",
            "data" to error.message
        )
    }

    override fun onAdViewPresented(view: CASBannerView, info: AdImpression) {
        success(
            "event" to "onAdViewPresented",
            "data" to info.toMap()
        )
    }

    override fun onAdViewClicked(view: CASBannerView) {
        success("event" to "onAdViewClicked")
    }

}