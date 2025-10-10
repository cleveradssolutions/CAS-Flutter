package com.cleveradssolutions.plugin.flutter

import android.content.Context
import android.util.Log
import androidx.annotation.Keep
import com.cleveradssolutions.sdk.nativead.CASNativeView
import com.cleveradssolutions.sdk.nativead.NativeAdContent

/**
 * The factory of [CASNativeView] used to display a [NativeAdContent].
 *
 * Added to a [CASMobileAdsPlugin] and creates [CASNativeView]s from Native Ads created in Dart.
 */
@Keep
interface CASNativeAdViewFactory {

    /**
     * Creates a [CASNativeView] with a [NativeAdContent].
     *
     * @param context Application context to create view.
     * @param nativeAd Ad information used to create a [CASNativeView]
     * @param customOptions Used to pass additional custom options to create the [CASNativeView].
     * @return a [CASNativeView] that is overlaid on top of the FlutterView.
     * Or null to fire failed to load of Native ads.
     */
    fun createNativeAdView(
        context: Context,
        nativeAd: NativeAdContent,
        customOptions: Map<String, Any?>
    ): CASNativeView?
}