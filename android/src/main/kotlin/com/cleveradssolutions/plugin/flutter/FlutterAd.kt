package com.cleveradssolutions.plugin.flutter

import android.app.Activity
import com.cleveradssolutions.sdk.AdContentInfo
import io.flutter.plugin.platform.PlatformView

internal interface FlutterAd {
    val adId: Int
    val contentInfo: AdContentInfo?
    var isAutoloadEnabled: Boolean
    var isAutoshowEnabled: Boolean
    var interval: Int

    fun isLoaded(): Boolean

    fun load()

    fun showScreen(activity: Activity?)

    /**
     * Gets the PlatformView for the ad. Default behavior is to return null. Should be overridden by
     * ads with platform views, such as banner and native ads.
     */
    fun getPlatformView(width: Int, height: Int): PlatformView?

    /**
     * Invoked when dispose() is called on the corresponding Flutter ad object. This perform any
     * necessary cleanup.
     */
    fun dispose()
}