package com.cleveradssolutions.plugin.flutter.bannerview

import android.content.Context
import com.cleversolutions.ads.AdSize
import com.cleversolutions.ads.MediationManager
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.plugin.platform.PlatformView

class BannerView(
    context: Context,
    viewId: Int,
    args: Map<*, *>?,
    manager: MediationManager?,
    methodHandler: BannerMethodHandler
) : PlatformView {

    private val banner = CASBannerView(context, manager)
    val id: String

    init {
        banner.id = viewId

        id = args?.get("id") as? String ?: ""
        methodHandler[id] = this
        banner.adListener = BannerCallback(methodHandler, id)

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