package com.cleveradssolutions.plugin.flutter.appopen

import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.LoadAdCallback

class LoadCallback(
    handler: MappedMethodHandler<*>,
    id: String
) : MappedCallback(handler, id), LoadAdCallback {

    override fun onAdFailedToLoad(error: AdError) {
        invokeMethod("onAdFailedToLoad", "error" to error.message)
    }

    override fun onAdLoaded() {
        invokeMethod("onAdLoaded")
    }

}