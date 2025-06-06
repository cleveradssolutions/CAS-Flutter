package com.cleveradssolutions.plugin.flutter.sdk

import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.sdk.AdContentInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/ad_content_info"

class AdContentInfoMethodHandler(binding: FlutterPluginBinding) :
    MappedMethodHandler<AdContentInfo>(binding, CHANNEL_NAME) {

    override fun onMethodCall(
        instance: AdContentInfo,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val value = with(instance) {
            when (call.method) {
                "getFormat" -> format.value
                "getSourceName" -> sourceName
                "getSourceId" -> sourceId
                "getSourceUnitId" -> sourceUnitId
                "getCreativeId" -> creativeId
                "getRevenue" -> revenue
                "getRevenuePrecision" -> revenuePrecision
                "getImpressionDepth" -> impressionDepth
                "getRevenueTotal" -> revenueTotal
                else -> return super.onMethodCall(instance, call, result)
            }
        }
        result.success(value)
    }

}