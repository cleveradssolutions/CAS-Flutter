//
//  AdSizeMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "com.cleveradssolutions.plugin.flutter/ad_size"

class AdSizeMethodHandler: MethodHandler {
    init() {
        super.init(channelName: channelName)
    }

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "getInlineBanner": getInlineBanner(call, result)
        case "getAdaptiveBanner": getAdaptiveBanner(call, result)
        case "getAdaptiveBannerInScreen": getAdaptiveBannerInScreen(call, result)
        case "getSmartBanner": getSmartBanner(call, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func getInlineBanner(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturnResult<Int, Int>("width", "maxHeight", result) { (width: Int, maxHeight: Int) in
            CASSize.getInlineBanner(width: CGFloat(width), maxHeight: CGFloat(maxHeight)).toMap()
        }
    }

    private func getAdaptiveBanner(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturnResult<Int, Int>("maxWidthDp", "orientation", result) { (maxWidthDp: Int, orientation: Int) in
             CASSize.getAdaptiveBanner(forMaxWidth: CGFloat(maxWidthDp)).toMap()
         }
    }

    private func getAdaptiveBannerInScreen(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        result(CASSize.getAdaptiveBanner(inWindow: UIApplication.shared.delegate!.window!!))
    }

    private func getSmartBanner(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        result(CASSize.getSmartBanner().toMap())
    }
}

extension CASSize {
    func toMap() -> [String: Int] {
        return [
//            "width": width, // px instead dp..
//            "height": height,
            "mode": {
                if isAdaptive {
                    return 2
                } else if isInline {
                    return 3
                } else {
                    return 0
                }
            }()
        ]
    }
}
