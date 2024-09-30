//
//  AdSizeMethodHandler.swift
//  clever_ads_solutions
//
//  Created by Dmytro Uzhva on 23.09.2024.
//

import CleverAdsSolutions
import Flutter

private let channelName = "com.cleveradssolutions.plugin.flutter/ad_size"

class AdSizeMethodHandler: MethodHandler {
    init() {
        super.init(channelName: channelName)
    }

    override func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getInlineBanner": getInlineBanner(call: call, result: result)
        case "getAdaptiveBanner": getAdaptiveBanner(call: call, result: result)
        case "getAdaptiveBannerInScreen": getAdaptiveBannerInScreen(call: call, result: result)
        case "getSmartBanner": getSmartBanner(call: call, result: result)
        default: super.onMethodCall(call: call, result: result)
        }
    }
}
