package com.cleveradssolutions.plugin.flutter.sdk

import com.cleveradssolutions.plugin.flutter.bridge.base.AdMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.base.FlutterCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.sdk.AdContentInfo
import com.cleveradssolutions.sdk.OnAdImpressionListener

class OnAdImpressionListenerHandler(
    private val handler: AdMethodHandler<*>,
    id: String,
    private val contentInfoId: String
) : OnAdImpressionListener, FlutterCallback by MappedCallback(handler, id) {

    override fun onAdImpression(ad: AdContentInfo) {
        handler.onAdContentLoaded(contentInfoId, ad) // Required only for the banner
        invokeMethod("onAdImpression", "contentInfoId" to contentInfoId)
    }

}