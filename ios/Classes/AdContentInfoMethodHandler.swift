//
//  AdContentInfoHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

class AdContentInfoMethodHandler: CASMappedChannel<AdContentInfo> {
    init(with registrar: FlutterPluginRegistrar) {
        super.init(with: registrar, on: "ad_content_info")
    }

    override func onMethodCall(_ instance: AdContentInfo, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let value: Any?
        switch call.method {
        case "getFormat":
            value = instance.format.value
        case "getSourceName":
            value = instance.sourceName
        case "getSourceId":
            value = instance.sourceID.rawValue
        case "getSourceUnitId":
            value = instance.sourceUnitID
        case "getCreativeId":
            value = instance.creativeID
        case "getRevenue":
            value = instance.revenue
        case "getRevenuePrecision":
            value = instance.revenuePrecision.rawValue
        case "getImpressionDepth":
            value = instance.impressionDepth
        case "getRevenueTotal":
            value = instance.revenueTotal
        default:
            super.onMethodCall(instance, call, result)
            return
        }

        result(value)
    }
}
