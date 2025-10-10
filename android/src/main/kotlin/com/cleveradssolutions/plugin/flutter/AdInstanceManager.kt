package com.cleveradssolutions.plugin.flutter

import android.app.Activity
import android.util.Size
import com.cleveradssolutions.sdk.AdContentInfo
import com.cleversolutions.ads.AdError
import io.flutter.plugin.common.MethodChannel

/**
 * Maintains reference to ad instances for the CASMobileAdsPlugin.
 *
 * When an Ad is loaded from Dart, an equivalent ad object is created
 * and maintained here to provide access until the ad is disposed.
 */
internal class AdInstanceManager(
    private val channel: MethodChannel
) {
    var activity: Activity? = null

    private val ads = HashMap<Int, FlutterAd>()

    fun findAd(adId: Int): FlutterAd? = ads[adId]

    fun trackAd(ad: FlutterAd) {
        require(ads[ad.adId] == null) {
            "Ad for following adId already exists: ${ad.adId}"
        }
        ads[ad.adId] = ad
    }

    fun disposeAd(adId: Int) {
        ads.remove(adId)?.dispose()
    }

    fun disposeAllAds() {
        for ((_, value) in ads) {
            value.dispose()
        }
        ads.clear()
    }

    fun onAdLoaded(adId: Int, size: Size?) {
        val args = HashMap<String, Any>()
        args["adId"] = adId
        if (size != null)
            args["size"] = size
        channel.invokeMethod("onAdLoaded", args)
    }

    fun onAdFailedToLoad(adId: Int, error: AdError) {
        val args = HashMap<String, Any>()
        args["adId"] = adId
        args["error"] = error
        channel.invokeMethod("onAdFailedToLoad", args)
    }

    fun onAdFailedToShow(adId: Int, error: AdError) {
        val args = HashMap<String, Any>()
        args["adId"] = adId
        args["error"] = error
        channel.invokeMethod("onAdFailedToShow", args)
    }

    fun onAdShowed(adId: Int) {
        invokeOnAdEvent("onAdShowed", adId)
    }

    fun onAdClicked(adId: Int) {
        invokeOnAdEvent("onAdClicked", adId)
    }

    fun onAdImpression(adId: Int, contentInfo: AdContentInfo) {
        val args = HashMap<String, Any>()
        args["adId"] = adId
        args["info"] = contentInfo
        channel.invokeMethod("onAdImpression", args)
    }

    fun onAdDismissed(adId: Int) {
        invokeOnAdEvent("onAdDismissed", adId)
    }

    fun onAdUserEarnedReward(adId: Int) {
        invokeOnAdEvent("onAdUserEarnedReward", adId)
    }

    private fun invokeOnAdEvent(name: String, adId: Int) {
        val args = HashMap<String, Any>()
        args["adId"] = adId
        channel.invokeMethod(name, args)
    }

}