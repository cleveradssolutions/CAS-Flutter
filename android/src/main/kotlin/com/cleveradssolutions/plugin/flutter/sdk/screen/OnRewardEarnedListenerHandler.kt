package com.cleveradssolutions.plugin.flutter.sdk.screen

import com.cleveradssolutions.plugin.flutter.bridge.base.AdMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.base.FlutterCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.sdk.AdContentInfo
import com.cleveradssolutions.sdk.screen.OnRewardEarnedListener

class OnRewardEarnedListenerHandler(
    private val handler: AdMethodHandler<*>,
    id: String,
    private val contentInfoId: String
) : OnRewardEarnedListener, FlutterCallback by MappedCallback(handler, id) {

    override fun onUserEarnedReward(ad: AdContentInfo) {
        invokeMethod("onUserEarnedReward", "contentInfoId" to contentInfoId)
    }

}