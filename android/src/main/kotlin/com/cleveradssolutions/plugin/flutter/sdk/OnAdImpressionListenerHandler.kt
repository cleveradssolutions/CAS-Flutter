package com.cleveradssolutions.plugin.flutter.sdk

import com.cleveradssolutions.plugin.flutter.bridge.base.IMappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleveradssolutions.sdk.AdContent
import com.cleveradssolutions.sdk.OnAdImpressionListener

class OnAdImpressionListenerHandler(
    handler: MappedMethodHandler<*>,
    id: String
) : OnAdImpressionListener, IMappedCallback by MappedCallback(handler, id) {

    override fun onAdImpression(ad: AdContent) {
        invokeMethod("onAdImpression", ad.toMap())
    }

}