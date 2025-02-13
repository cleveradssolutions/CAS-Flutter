package com.cleveradssolutions.plugin.flutter.sdk.screen

import com.cleveradssolutions.plugin.flutter.bridge.base.IMappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleveradssolutions.sdk.AdContent
import com.cleveradssolutions.sdk.screen.OnRewardEarnedListener

class OnRewardEarnedListenerHandler(
    handler: MappedMethodHandler<*>,
    id: String
) : OnRewardEarnedListener, IMappedCallback by MappedCallback(handler, id) {

    override fun onUserEarnedReward(ad: AdContent) {
        invokeMethod("onUserEarnedReward", ad.toMap())
    }

}