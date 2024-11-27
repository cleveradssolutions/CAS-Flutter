//
//  BannerView.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

class BannerView: NSObject, FlutterPlatformView {
    let banner: CASBannerView
    private let methodHandler: BannerMethodHandler
    let id: String

    init(
        frame: CGRect,
        viewId: Int64,
        args: [String: Any?]?,
        manager: CASMediationManager?,
        methodHandler: BannerMethodHandler
    ) {
        self.methodHandler = methodHandler

        banner = CASBannerView(adSize: BannerView.getAdSize(args, frame), manager: manager)
        banner.tag = Int(viewId)

        id = args?["id"] as? String ?? ""
        super.init()
        methodHandler[id] = self
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
