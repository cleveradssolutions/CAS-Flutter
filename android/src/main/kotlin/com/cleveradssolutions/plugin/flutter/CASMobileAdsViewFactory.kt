package com.cleveradssolutions.plugin.flutter

import android.content.Context
import android.graphics.Color
import android.util.Log
import android.view.View
import android.widget.TextView
import io.flutter.BuildConfig
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

internal class CASMobileAdsViewFactory(
    private val manager: AdInstanceManager
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val argsMap = args as? Map<*, *>
        var adId = 0
        if (argsMap != null) {
            adId = argsMap["adId"] as Int
            val width = argsMap["width"] as Int
            val height = argsMap["height"] as Int

            val flutterAd = manager.findAd(adId)
            val adView = flutterAd?.getPlatformView(width, height)
            if (adView != null) {
                return adView
            }
        }

        val message = "Ad View with the following id could not be found: $adId."
        Log.e("CAS.AI.Flutter", message)
        if (BuildConfig.DEBUG) {
            val errorView = TextView(context)
            errorView.text = message
            errorView.setBackgroundColor(Color.RED)
            errorView.setTextColor(Color.YELLOW)
            return FlutterPlatformView(errorView)
        } else {
            return FlutterPlatformView(View(context))
        }
    }
}