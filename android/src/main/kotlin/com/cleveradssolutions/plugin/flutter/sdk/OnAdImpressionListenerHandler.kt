package com.cleveradssolutions.plugin.flutter.sdk

import com.cleveradssolutions.plugin.flutter.bridge.base.FlutterCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.sdk.OnAdImpressionListener

class OnAdImpressionListenerHandler(
    handler: MappedMethodHandler<*>,
    id: String,
    private val adContentInfoHandler: AdContentInfoHandler
) : OnAdImpressionListener, FlutterCallback by MappedCallback(handler, id) {

    private val adContentInfoId = "app_open_$id"

    override fun onAdImpression(ad: AdContentInfo) {
        invokeMethod("onAdImpression", "adContentInfoId" to adContentInfoId)
    }

}