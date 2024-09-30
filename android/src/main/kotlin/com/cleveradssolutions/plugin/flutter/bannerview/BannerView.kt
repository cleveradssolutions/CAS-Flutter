package com.cleveradssolutions.plugin.flutter.bannerview

import android.content.Context
import android.view.View
import com.cleveradssolutions.plugin.flutter.CASBridge
import com.cleversolutions.ads.AdSize
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView

class BannerView(
    context: Context,
    viewId: Int,
    creationParams: Map<*, *>?,
    binaryMessenger: BinaryMessenger,
    bridgeProvider: () -> CASBridge?
) : PlatformView {

    private val flutterId = creationParams?.get("id") as? String ?: ""

    private var banner: CASBannerView? = null
    private var methodHandler: BannerMethodHandler? = null
    private var eventHandler: BannerEventHandler? = null

    init {
        val manager = bridgeProvider()?.mediationManager;
        val banner = CASBannerView(context, manager)
        this.banner = banner
        banner.id = viewId

        methodHandler = BannerMethodHandler(flutterId, banner, bridgeProvider, ::dispose).also {
            it.onAttachedToFlutter(binaryMessenger)
        }
        eventHandler = BannerEventHandler(flutterId).also {
            it.onAttachedToFlutter(binaryMessenger)
        }
        banner.adListener = eventHandler

//        banner.layoutParams = ViewGroup.LayoutParams( ???
//            ViewGroup.LayoutParams.WRAP_CONTENT,
//            ViewGroup.LayoutParams.MATCH_PARENT
//        )

        (creationParams?.get("size") as? Map<*, *>)?.let { size ->
//            var size: AdSize = AdSize.BANNER

            if (size["isAdaptive"] == true) {
                banner.size = (size["maxWidthDpi"] as? Int).let {
                    if (it == null || it == 0) {
                        AdSize.getAdaptiveBannerInScreen(view.context)
                    } else {
                        AdSize.getAdaptiveBanner(view.context, it)
                    }
                }
            } else {
//            else {
//                when (size["size"] as Int) {
//                    3 -> size = AdSize.getSmartBanner(context)
//                    4 -> size = AdSize.LEADERBOARD
//                    5 -> size = AdSize.MEDIUM_RECTANGLE
//                }
//            }
                val width = size["width"]
                val height = size["height"]
                val mode = size["mode"]

                val adSizeClass = Class.forName("AdSize")
                val intClass = Integer::class.java
                val constructor = adSizeClass.getDeclaredConstructor(intClass, intClass, intClass)
                constructor.isAccessible = true

                banner.size = constructor.newInstance(width, height, mode) as AdSize
            }
        }

        (creationParams?.get("isAutoloadEnabled") as? Boolean)?.let {
            banner.isAutoloadEnabled = it
        }

        (creationParams?.get("refreshInterval") as? Int)?.let {
            banner.refreshInterval = it
        }
    }

    override fun getView(): View {
        return banner!!
    }

    override fun dispose() {
        methodHandler?.let {
            it.onDetachedFromFlutter()
            methodHandler = null
        }
        eventHandler?.let {
            it.onDetachedFromFlutter()
            eventHandler = null
        }
        banner.let {
            it?.destroy()
            banner = null
        }
    }

}