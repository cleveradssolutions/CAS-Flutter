package com.cleveradssolutions.plugin.flutter

import com.cleveradssolutions.sdk.AdContentInfo
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AdContentInfoMethodHandler(binding: FlutterPluginBinding) :
    CASMappedChannel<AdContentInfo>(binding, "cleveradssolutions/ad_content_info") {

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