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

        let adSize: CASSize
        if let size = args?["size"] as? [String: Any?] {
            if size["isAdaptive"] as? Bool == true {
                if let maxWidth = size["maxWidthDpi"] as? Int,
                   maxWidth != 0 {
                    adSize = CASSize.getAdaptiveBanner(forMaxWidth: CGFloat(maxWidth))
                } else {
                    adSize = CASSize.getAdaptiveBanner(forMaxWidth: frame.width)
                }
            } else {
                let width = size["width"]
                let height = size["height"]
                let mode = size["mode"]

//                CASSize()

//                switch serializedSize {
//                case 1: adSize = CASSize.banner
//                case 3: adSize = CASSize.getSmartBanner()
//                case 4: adSize = CASSize.leaderboard
//                case 5: adSize = CASSize.mediumRectangle
//                default: print("Unknown CAS BannerView size")
//                }
            }
        } else {
            adSize = CASSize.banner
        }

        let manager = bridgeProvider()?.mediationManager
        let banner = CASBannerView(adSize: adSize, manager: manager)
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
}
