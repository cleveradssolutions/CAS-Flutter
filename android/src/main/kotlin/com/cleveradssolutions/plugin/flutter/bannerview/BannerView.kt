package com.cleveradssolutions.plugin.flutter.bannerview

import android.content.Context
import com.cleveradssolutions.plugin.flutter.CASBridge
import com.cleversolutions.ads.AdSize
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.platform.PlatformView

class BannerView(
    context: Context,
    viewId: Int,
    args: Map<*, *>?,
    flutterPluginBinding: FlutterPluginBinding,
    bridgeProvider: () -> CASBridge?
) : PlatformView {

    private val flutterId = args?.get("id") as? String ?: ""

    private var banner: CASBannerView
    private var methodHandler: BannerMethodHandler? = null
    private var eventHandler: BannerEventHandler? = null

    init {
        val manager = bridgeProvider()?.mediationManager
        val banner = CASBannerView(context, manager)
        this.banner = banner
        banner.id = viewId

        methodHandler = BannerMethodHandler(flutterId, this, banner).also {
            it.onAttachedToFlutter(flutterPluginBinding)
        }
        eventHandler = BannerEventHandler(flutterId).also {
            it.onAttachedToFlutter(flutterPluginBinding)
        }
        banner.adListener = eventHandler

        (args?.get("size") as? Map<*, *>)?.let { size ->
            if (size["isAdaptive"] == true) {
                banner.size = (size["maxWidthDpi"] as? Int).let {
                    if (it == null || it == 0) {
                        AdSize.getAdaptiveBannerInScreen(context)
                    } else {
                        AdSize.getAdaptiveBanner(context, it)
                    }
                }
            } else {
                val width = size["width"]
                val height = size["height"]
                val mode = size["mode"]

                val adSizeClass = Class.forName("com.cleversolutions.ads.AdSize")
                val intClass = Int::class.java
                val constructor = adSizeClass.getDeclaredConstructor(intClass, intClass, intClass)
                constructor.isAccessible = true
                val adSize = constructor.newInstance(width, height, mode) as AdSize

                banner.size = adSize
            }
        }

        (args?.get("isAutoloadEnabled") as? Boolean)?.let {
            banner.isAutoloadEnabled = it
        }

        (args?.get("refreshInterval") as? Int)?.let {
            banner.refreshInterval = it
        }
    }

    override fun getView(): CASBannerView {
        return banner
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
        banner.destroy()
    }

}