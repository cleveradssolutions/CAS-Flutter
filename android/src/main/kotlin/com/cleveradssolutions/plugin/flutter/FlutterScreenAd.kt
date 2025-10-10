package com.cleveradssolutions.plugin.flutter

import android.app.Activity
import com.cleveradssolutions.sdk.AdContentInfo
import com.cleveradssolutions.sdk.AdErrorCode
import com.cleveradssolutions.sdk.AdFormat
import com.cleveradssolutions.sdk.OnAdImpressionListener
import com.cleveradssolutions.sdk.screen.CASAppOpen
import com.cleveradssolutions.sdk.screen.CASInterstitial
import com.cleveradssolutions.sdk.screen.CASRewarded
import com.cleveradssolutions.sdk.screen.OnRewardEarnedListener
import com.cleveradssolutions.sdk.screen.ScreenAdContent
import com.cleveradssolutions.sdk.screen.ScreenAdContentCallback
import com.cleversolutions.ads.AdError
import io.flutter.plugin.platform.PlatformView

internal class FlutterScreenAd(
    override val adId: Int,
    private val manager: AdInstanceManager,
    private val ad: ScreenAdContent
) : ScreenAdContentCallback(), FlutterAd, OnAdImpressionListener, OnRewardEarnedListener {

    init {
        ad.contentCallback = this
        ad.onImpressionListener = this
    }

    override val contentInfo: AdContentInfo?
        get() = ad.contentInfo

    override var isAutoloadEnabled: Boolean
        get() = ad.isAutoloadEnabled
        set(value) {
            ad.isAutoloadEnabled = value
        }

    override var isAutoshowEnabled: Boolean
        get() = when (ad) {
            is CASAppOpen -> ad.isAutoshowEnabled
            is CASInterstitial -> ad.isAutoshowEnabled
            else -> false
        }
        set(value) {
            when (ad) {
                is CASAppOpen -> ad.isAutoshowEnabled = value
                is CASInterstitial -> ad.isAutoshowEnabled = value
            }
        }

    override var interval: Int
        get() = if (ad is CASInterstitial) ad.minInterval
        else 0
        set(value) {
            if (ad is CASInterstitial) {
                ad.minInterval = value
            }
        }

    override fun isLoaded(): Boolean = ad.isLoaded

    override fun load() {
        ad.load(null)
    }

    override fun showScreen(activity: Activity?) {
        when (ad) {
            is CASInterstitial -> ad.show(activity)
            is CASAppOpen -> ad.show(activity)
            is CASRewarded -> ad.show(activity, this)
            else -> onAdFailedToShow(
                AdFormat.INLINE_BANNER,
                AdError(AdErrorCode.INTERNAL_ERROR, "Not supported format")
            )
        }
    }

    override fun getPlatformView(width: Int, height: Int): PlatformView? = null

    override fun dispose() {
        ad.destroy()
    }

    override fun onAdLoaded(ad: AdContentInfo) {
        manager.onAdLoaded(adId, null)
    }

    override fun onAdFailedToLoad(format: AdFormat, error: AdError) {
        manager.onAdFailedToLoad(adId, error)
    }

    override fun onAdFailedToShow(format: AdFormat, error: AdError) {
        manager.onAdFailedToShow(adId, error)
    }

    override fun onAdShowed(ad: AdContentInfo) {
        manager.onAdShowed(adId)
    }

    override fun onAdClicked(ad: AdContentInfo) {
        manager.onAdClicked(adId)
    }

    override fun onAdDismissed(ad: AdContentInfo) {
        manager.onAdDismissed(adId)
    }

    override fun onAdImpression(ad: AdContentInfo) {
        manager.onAdImpression(adId, ad)
    }

    override fun onUserEarnedReward(ad: AdContentInfo) {
        manager.onAdUserEarnedReward(adId)
    }
}