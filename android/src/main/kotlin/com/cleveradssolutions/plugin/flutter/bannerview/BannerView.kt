package com.cleveradssolutions.plugin.flutter.bannerview

import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import com.cleveradssolutions.plugin.flutter.CASBridge
import com.cleversolutions.ads.AdSize
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class BannerView(
        context: Context,
        private val id: Int,
        creationParams: Map<String?, Any?>?,
        bridgeProvider: () -> CASBridge?,
        binaryMessenger: BinaryMessenger,
        private val listener: BannerViewEventListener
): PlatformView, MethodChannel.MethodCallHandler {
    private val banner: CASBannerView
    private val flutterId: String

    override fun getView(): View {
        return banner
    }

    override fun dispose() {
        listener.flutterIds.remove(id)
        banner.destroy()
    }

    init {
        val manager = bridgeProvider()?.mediationManager;
        banner = CASBannerView(context, manager)
        banner.id = id;
        banner.adListener = listener

        banner.layoutParams = ViewGroup.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.MATCH_PARENT
        )

        flutterId = creationParams?.get("id") as? String ?: ""

        MethodChannel(binaryMessenger, "com.cleveradssolutions.plugin.flutter.bannerview.$flutterId")
            .setMethodCallHandler(this)

        listener.flutterIds[id] = flutterId

        (creationParams?.get("size") as? Map<String?, Any?>)?.let { sizeMap ->
            var serializedSize = sizeMap["size"] as Int
            var size: AdSize = AdSize.BANNER

            if (sizeMap["isAdaptive"] as? Boolean == true) {
                (sizeMap["maxWidthDpi"] as? Int)?.let {
                    size = if (it == 0) {
                        AdSize.getAdaptiveBannerInScreen(view.context)
                    } else {
                        AdSize.getAdaptiveBanner(view.context, it)
                    }
                }
            } else {
                when (serializedSize) {
                    3 -> size = AdSize.getSmartBanner(context)
                    4 -> size = AdSize.LEADERBOARD
                    5 -> size = AdSize.MEDIUM_RECTANGLE
                }
            }

            banner.size = size
        }

        (creationParams?.get("isAutoloadEnabled") as? Boolean)?.let {
            banner.isAutoloadEnabled = it
        }

        (creationParams?.get("s") as? Int)?.let {
            banner.refreshInterval = it
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "isAdReady" -> {
                    result.success(banner.isAdReady)
                }
                "loadNextAd" -> {
                    banner.loadNextAd()
                }
                else -> return result.notImplemented()
            }
        } catch (exception: Exception) {
            result.error("CAS", exception.message, null)
        }
    }
}