package com.cleveradssolutions.plugin.flutter.bannerview

import android.util.Log
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdImpression
import com.cleversolutions.ads.AdViewListener
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.plugin.common.EventChannel

class BannerViewEventListener : AdViewListener, EventChannel.StreamHandler {

    val flutterIds = HashMap<Int, String>()
    private var eventSink: EventChannel.EventSink? = null

    override fun onAdViewLoaded(view: CASBannerView) {
        eventSink?.success(
            mapOf(
                "id" to flutterIds[view.id],
                "event" to "onAdViewLoaded"
            )
        )
    }

    override fun onAdViewFailed(view: CASBannerView, error: AdError) {
        eventSink?.success(
            mapOf(
                "id" to flutterIds[view.id],
                "event" to "onAdViewFailed",
                "data" to error.message
            )
        )
    }

    override fun onAdViewPresented(view: CASBannerView, info: AdImpression) {
        eventSink?.success(
            mapOf(
                "id" to flutterIds[view.id],
                "event" to "onAdViewPresented",
                "data" to info.toMap()
            )
        )
    }

    override fun onAdViewClicked(view: CASBannerView) {
        eventSink?.success(
            mapOf(
                "id" to flutterIds[view.id],
                "event" to "onAdViewClicked"
            )
        )
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}