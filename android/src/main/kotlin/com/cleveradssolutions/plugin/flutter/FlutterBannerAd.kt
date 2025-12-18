package com.cleveradssolutions.plugin.flutter

import android.app.Activity
import android.util.Size
import com.cleveradssolutions.sdk.AdContentInfo
import com.cleveradssolutions.sdk.OnAdImpressionListener
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdViewListener
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.plugin.platform.PlatformView
import kotlin.math.roundToInt

internal class FlutterBannerAd(
    override val adId: Int,
    private val manager: AdInstanceManager,
    private val adView: CASBannerView
) : FlutterAd, AdViewListener, OnAdImpressionListener {

    init {
        adView.adListener = this
        adView.onImpressionListener = this
    }

    override val contentInfo: AdContentInfo?
        get() = adView.contentInfo

    override var isAutoloadEnabled: Boolean
        get() = adView.isAutoloadEnabled
        set(value) {
            adView.isAutoloadEnabled = value
        }

    override var isAutoshowEnabled: Boolean
        get() = false
        set(value) {}

    override var interval: Int
        get() = adView.refreshInterval
        set(value) {
            adView.refreshInterval = value
        }

    override fun isLoaded(): Boolean = adView.isLoaded

    override fun load() {
        adView.load()
    }

    override fun showScreen(activity: Activity?) {
        // ignore
    }

    override fun getPlatformView(width: Int, height: Int): PlatformView {
        return FlutterPlatformView(adView)
    }

    override fun dispose() {
        adView.destroy()
    }

    override fun onAdViewLoaded(view: CASBannerView) {
        val adLayout = view.getChildAt(0)?.layoutParams
        val contentSize = if (adLayout != null) {
            val density = view.context.resources.displayMetrics.density
            Size(
                (adLayout.width / density).roundToInt(),
                (adLayout.height / density).roundToInt()
            )
        } else {
            val adSize = view.size
            Size(adSize.width, adSize.height)
        }
        manager.onAdLoaded(adId, contentSize)
    }

    override fun onAdViewFailed(view: CASBannerView, error: AdError) {
        manager.onAdFailedToLoad(adId, error)
    }

    override fun onAdViewClicked(view: CASBannerView) {
        manager.onAdClicked(adId)
    }

    override fun onAdImpression(ad: AdContentInfo) {
        manager.onAdImpression(adId, ad)
    }
}