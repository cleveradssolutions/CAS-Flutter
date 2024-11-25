package com.cleveradssolutions.plugin.flutter.appopen

import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdImpression
import com.cleversolutions.ads.AdPaidCallback

class ContentCallback(
    handler: MappedMethodHandler<*>,
    id: String
) : MappedCallback(handler, id), AdPaidCallback {

    override fun onShown(ad: AdImpression) {
        invokeMethod("onShown", ad.toMap())
    }

    override fun onShowFailed(message: String) {
        invokeMethod("onShowFailed", "error" to message)
    }

    override fun onClicked() {
        invokeMethod("onClicked")
    }

    override fun onAdRevenuePaid(ad: AdImpression) {
        invokeMethod("onAdRevenuePaid", ad.toMap())
    }

    override fun onClosed() {
        invokeMethod("onClosed")
    }

}