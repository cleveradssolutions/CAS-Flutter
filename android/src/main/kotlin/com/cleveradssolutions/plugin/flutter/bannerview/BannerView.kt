package com.cleveradssolutions.plugin.flutter.bannerview

import android.content.Context
import android.util.Log
import android.view.ViewGroup
import com.cleversolutions.ads.AdSize
import com.cleversolutions.ads.MediationManager
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.plugin.platform.PlatformView

private const val LOG_TAG = "CAS.AI.Flutter/BannerView"

class BannerView(
    context: Context,
    viewId: Int,
    args: Map<*, *>?,
    manager: MediationManager?,
    methodHandler: BannerMethodHandler
) : PlatformView {

    val id: String = args?.get("id") as? String ?: ""

    private val banner = CASBannerView(context, manager)
    private val sizeListener = BannerSizeListener(banner, methodHandler, id)

    init {
        banner.id = viewId
        banner.adListener = BannerCallback(sizeListener, methodHandler, id)
        banner.viewTreeObserver.addOnGlobalLayoutListener(sizeListener)

        methodHandler[id] = this

        if (args == null) {
            Log.e(LOG_TAG, "BannerView args is null")
        } else {
            (args["size"] as? Map<*, *>)?.let { size ->
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

            (args["isAutoloadEnabled"] as? Boolean)?.let {
                banner.isAutoloadEnabled = it
            }

            (args["refreshInterval"] as? Int)?.let {
                banner.refreshInterval = it
            }
        }
    }

    override fun getView(): CASBannerView {
        return banner
    }

    override fun dispose() {
        banner.viewTreeObserver.removeOnGlobalLayoutListener(sizeListener)
        banner.destroy()
    }

}