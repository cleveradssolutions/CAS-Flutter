package com.cleveradssolutions.plugin.flutter.bannerview

import com.cleveradssolutions.plugin.flutter.bridge.base.MappedCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdImpression
import com.cleversolutions.ads.AdViewListener
import com.cleversolutions.ads.android.CASBannerView

class BannerCallback(
    private val sizeListener: BannerSizeListener,
    handler: MappedMethodHandler<*>,
    id: String
) : MappedCallback(handler, id), AdViewListener {

    override fun onAdViewLoaded(view: CASBannerView) {
        invokeMethod("onAdViewLoaded")
        sizeListener.updateSize(view.size)
    }

    override fun onAdViewFailed(view: CASBannerView, error: AdError) {
        invokeMethod("onAdViewFailed", "error" to error.message)
    }

    override fun onAdViewPresented(view: CASBannerView, info: AdImpression) {
        invokeMethod("onAdViewPresented", info.toMap())
    }

    override fun onAdViewClicked(view: CASBannerView) {
        invokeMethod("onAdViewClicked")
    }

}