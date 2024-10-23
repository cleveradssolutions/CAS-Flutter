package com.cleveradssolutions.plugin.flutter.bannerview

import android.content.Context
import com.cleveradssolutions.plugin.flutter.CASBridge
import com.cleveradssolutions.plugin.flutter.bridge.MediationManagerMethodHandler
import com.cleversolutions.ads.AdSize
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.platform.PlatformView

class BannerView(
    context: Context,
    viewId: Int,
    args: Map<*, *>?,
    binding: FlutterPluginBinding,
    managerHandler: MediationManagerMethodHandler
) : PlatformView {

    private var banner: CASBannerView
    private var methodHandler: BannerMethodHandler

    init {
        val manager = managerHandler.bridge?.mediationManager
        banner = CASBannerView(context, manager)
        banner.id = viewId

        val flutterId = args?.get("id") as? String ?: ""
        methodHandler = BannerMethodHandler(binding, flutterId, banner)
        banner.adListener = methodHandler

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
                val width = size["width"] as Int
                val height = size["height"] as Int
                val mode = size["mode"] as Int

                banner.size = when (mode) {
                    2 -> AdSize.getAdaptiveBanner(context, width)
                    3 -> AdSize.getInlineBanner(width, height)
                    else -> when (width) {
                        300 -> AdSize.MEDIUM_RECTANGLE
                        728 -> AdSize.LEADERBOARD
                        else -> AdSize.BANNER
                    }
                }
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
        banner.destroy()
    }

}