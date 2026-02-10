package com.cleveradssolutions.plugin.flutter

import android.app.Activity
import android.content.Context
import android.util.Log
import com.cleveradssolutions.sdk.AdContentInfo
import com.cleveradssolutions.sdk.AdErrorCode
import com.cleveradssolutions.sdk.OnAdImpressionListener
import com.cleveradssolutions.sdk.nativead.CASNativeLoader
import com.cleveradssolutions.sdk.nativead.CASNativeView
import com.cleveradssolutions.sdk.nativead.NativeAdContent
import com.cleveradssolutions.sdk.nativead.NativeAdContentCallback
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdSize
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.platform.PlatformView

internal class FlutterNativeAd(
    override val adId: Int,
    private val manager: AdInstanceManager,
    call: MethodCall,
    casId: String,
    private val context: Context,
    private val viewFactory: CASNativeAdViewFactory?,
) : NativeAdContentCallback(), FlutterAd, OnAdImpressionListener {
    private val loader = CASNativeLoader(context, casId, this)
    private val customOptions: Map<String, Any> = call.argument("customOptions") ?: emptyMap()
    private val templateStyle: NativeTemplateStyle? = call.argument("templateStyle")
    private var adContent: NativeAdContent? = null
    private var adView: CASNativeView? = null
    private var templateSize: AdSize? = null

    init {
        call.argument<Int>("adChoicesPlacement")?.let {
            if (it >= 0) {
                loader.adChoicesPlacement = it
            }
        }
        call.argument<Boolean>("startVideoMuted")?.let {
            loader.isStartVideoMuted = it
        }
    }

    override val contentInfo: AdContentInfo?
        get() = adContent?.contentInfo

    override var isAutoloadEnabled: Boolean
        get() = false
        set(value) {}
    override var isAutoshowEnabled: Boolean
        get() = false
        set(value) {}
    override var interval: Int
        get() = 0
        set(value) {}

    override fun isLoaded(): Boolean = adContent?.isExpired == false

    override fun load() {
        loader.load()
    }

    override fun showScreen(activity: Activity?) {
        // ignore
    }

    override fun getPlatformView(width: Int, height: Int): PlatformView? =
        adView?.let {
            if (viewFactory == null) {
                val size = templateSize
                if (size == null || size.width != width || size.height != height) {
                    val newSize = AdSize.getInlineBanner(width, height)
                    templateSize = newSize
                    it.setAdTemplateSize(newSize)
                    templateStyle?.applyToView(it)
                    it.bindAdContent(adContent)
                }
            }
            FlutterPlatformView(it)
        }

    override fun dispose() {
        adContent?.destroy()
        adContent = null
    }

    override fun onNativeAdLoaded(nativeAd: NativeAdContent, ad: AdContentInfo) {
        adContent = nativeAd

        adView = if (viewFactory != null) {
            val errorMessage = "Custom Native Ad View factory not create view"
            val view = try {
                viewFactory.createNativeAdView(context, nativeAd, customOptions)
            } catch (e: Throwable) {
                Log.e("CAS.AI.Flutter", errorMessage, e)
                null
            }
            if (view == null) {
                manager.onAdFailedToLoad(
                    adId,
                    AdError(AdErrorCode.INTERNAL_ERROR, errorMessage)
                )
                return
            }
            view.bindAdContent(nativeAd)

            if (adContent == null) {
                // onNativeAdFailedToShow called from bindAdContent()
                // so adContent already destroyed
                return
            }
            templateStyle?.applyToView(view)
            view
        } else {
            CASNativeView(context)
        }

        nativeAd.onImpressionListener = this
        manager.onAdLoaded(adId, null)
    }

    override fun onNativeAdFailedToLoad(error: AdError) {
        manager.onAdFailedToLoad(adId, error)
    }

    override fun onNativeAdClicked(nativeAd: NativeAdContent, ad: AdContentInfo) {
        manager.onAdClicked(adId)
    }

    override fun onNativeAdFailedToShow(nativeAd: NativeAdContent, error: AdError) {
        // Flutter have not Failed to Show for Native ad
        // so we just destroy ad and fire Failed to load
        dispose()
        manager.onAdFailedToLoad(adId, error)
    }

    override fun onAdImpression(ad: AdContentInfo) {
        manager.onAdImpression(adId, ad)
    }
}