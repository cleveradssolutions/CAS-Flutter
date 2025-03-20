package com.cleveradssolutions.plugin.flutter.bridge.base

import com.cleveradssolutions.plugin.flutter.sdk.AdContentInfoHandler
import com.cleveradssolutions.sdk.AdContentInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin

abstract class AdMethodHandler<T>(
    binding: FlutterPlugin.FlutterPluginBinding,
    channelName: String,
    private val contentInfoHandler: AdContentInfoHandler
) : MappedMethodHandler<AdMethodHandler.Ad<T>>(binding, channelName) {

    class Ad<T>(
        val ad: T,
        val id: String,
        val contentInfoId: String
    )

    fun onAdContentLoaded(contentInfoId: String, contentInfo: AdContentInfo) {
        contentInfoHandler[contentInfoId] = contentInfo
    }

    fun destroy(ad: Ad<T>) {
        remove(ad.id)
        contentInfoHandler.remove(ad.contentInfoId)
    }

}