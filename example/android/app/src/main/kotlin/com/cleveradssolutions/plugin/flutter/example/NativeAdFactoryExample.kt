package com.cleveradssolutions.plugin.flutter.example

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import com.cleveradssolutions.plugin.flutter.CASNativeAdViewFactory
import com.cleveradssolutions.sdk.nativead.CASNativeView
import com.cleveradssolutions.sdk.nativead.NativeAdContent

class NativeAdFactoryExample : CASNativeAdViewFactory {
    override fun createNativeAdView(
        context: Context,
        nativeAd: NativeAdContent,
        customOptions: Map<String, Any?>
    ): CASNativeView? {
        // Assumes that your ad layout is in a file
        // called `native_ad_layout.xml` in the `res/layout` folder.
        val adView = LayoutInflater.from(context).inflate(
            R.layout.native_ad_layout, null, false
        ) as CASNativeView

        // Simply find and set all the ad assets that are used.
        // CAS will automatically fill in the advertising content in them,
        // or hide the view if the ad asset was not provided in the ad content.
        adView.mediaView = adView.findViewById(R.id.ad_media_view)
        adView.adLabelView = adView.findViewById(R.id.ad_label)
        adView.headlineView = adView.findViewById(R.id.ad_headline)
        adView.iconView = adView.findViewById(R.id.ad_icon)
        adView.callToActionView = adView.findViewById(R.id.ad_call_to_action)
        adView.bodyView = adView.findViewById(R.id.ad_body)
        adView.advertiserView = adView.findViewById(R.id.ad_advertiser)
        adView.storeView = adView.findViewById(R.id.ad_store)
        adView.priceView = adView.findViewById(R.id.ad_price)
        adView.reviewCountView = adView.findViewById(R.id.ad_review_count)
        adView.starRatingView = adView.findViewById(R.id.ad_star_rating)

        // The CAS Flutter plugin will automatically call
        // `adView.setNativeAd(nativeAd)` later in any case.
        return adView
    }
}