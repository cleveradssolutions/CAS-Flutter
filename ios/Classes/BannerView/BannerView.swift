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
    private var banner: CASBannerView
    private var methodHandler: BannerMethodHandler

    init(
        frame: CGRect,
        viewId: Int64,
        args: [String: Any?]?,
        registrar: FlutterPluginRegistrar,
        bridgeProvider: @escaping () -> CASBridge?
    ) {
        let manager = bridgeProvider()?.mediationManager
        banner = CASBannerView(adSize: BannerView.getAdSize(args, frame), manager: manager)
        banner.tag = Int(viewId)

        let flutterId = args?["id"] as? String ?? ""
        methodHandler = BannerMethodHandler(with: registrar, flutterId, banner)
        banner.adDelegate = methodHandler

        if let isAutoloadEnabled = args?["isAutoloadEnabled"] as? Bool {
            banner.isAutoloadEnabled = isAutoloadEnabled
        }

        if let refreshInterval = args?["refreshInterval"] as? Int {
            banner.refreshInterval = refreshInterval
        }
    }

    func view() -> UIView {
        return banner
    }

    func dispose() {
        banner.destroy()
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
                let width = size["width"] as? CGFloat ?? 0
                let height = size["height"] as? CGFloat ?? 0
                let mode = size["mode"] as? CGFloat ?? 0

                switch mode {
                case 2: return CASSize.getAdaptiveBanner(forMaxWidth: width)
                case 3: return CASSize.getInlineBanner(width: width, maxHeight: height)
                default: switch width {
                    case 300: return CASSize.mediumRectangle
                    case 728: return CASSize.leaderboard
                    default: return CASSize.banner
                    }
                }
            }
        }
        return CASSize.banner
    }
}
