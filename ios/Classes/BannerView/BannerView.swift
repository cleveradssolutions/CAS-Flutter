//
//  BannerView.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter
import Foundation

class BannerView: NSObject, FlutterPlatformView {
    private let flutterId: String

    private var banner: CASBannerView?
    private var methodHandler: BannerMethodHandler?
    private var eventHandler: BannerEventHandler?

    init(
        frame: CGRect,
        viewId: Int64,
        args: [String: Any?]?,
        registrar: FlutterPluginRegistrar,
        bridgeProvider: @escaping () -> CASBridge?
    ) {
        flutterId = args?["id"] as? String ?? ""

        super.init()

        let manager = bridgeProvider()?.mediationManager
        let banner = CASBannerView(adSize: BannerView.getAdSize(args, frame), manager: manager)
        self.banner = banner
        banner.tag = Int(viewId)

        methodHandler = BannerMethodHandler(flutterId, banner, bridgeProvider, dispose)
        methodHandler!.onAttachedToFlutter(registrar)

        eventHandler = BannerEventHandler(flutterId)
        eventHandler!.onAttachedToFlutter(registrar)
        banner.adDelegate = eventHandler


        if let isAutoloadEnabled = args?["isAutoloadEnabled"] as? Bool {
            banner.isAutoloadEnabled = isAutoloadEnabled
        }

        if let refreshInterval = args?["refreshInterval"] as? Int {
            banner.refreshInterval = refreshInterval
        }
    }

    func view() -> UIView {
        return banner!
    }

    func dispose() {
        if let methodHandler = methodHandler {
            methodHandler.onDetachedFromFlutter()
            self.methodHandler = nil
        }
        if let eventHandler = eventHandler {
            eventHandler.onDetachedFromFlutter()
            self.eventHandler = nil
        }
        if let banner = banner {
            banner.destroy()
            self.banner = nil
        }
    }

    private static func getAdSize(_ args: [String: Any?]?, _ frame: CGRect) -> CASSize {
        if let size = args?["size"] as? [String: Any?] {
            if size["isAdaptive"] as? Bool == true {
                if let maxWidth = size["maxWidthDpi"] as? Int,
                   maxWidth != 0 {
                    return CASSize.getAdaptiveBanner(forMaxWidth: CGFloat(maxWidth))
                } else {
                    return CASSize.getAdaptiveBanner(forMaxWidth: frame.width)
                }
            } else {
                let width = size["width"]
                let height = size["height"]
                let mode = size["mode"]

                let selector = NSSelectorFromString("init")
                if let myClassType = NSClassFromString("CASSize") as? NSObject.Type,
                   let instance = myClassType.perform(selector)?.takeUnretainedValue() as? CASSize {
                    return instance
                }
            }
        }
        return CASSize.banner
    }
}
