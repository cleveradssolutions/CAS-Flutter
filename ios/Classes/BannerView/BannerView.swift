//
//  BannerView.swift
//  clever_ads_solutions
//
//  Created by MacMini on 2.04.24.
//

import CleverAdsSolutions
import Flutter
import Foundation

class BannerView: NSObject, FlutterPlatformView {
    private var banner: CASBannerView!
    private let channel: FlutterMethodChannel
    private let flutterId: String

    func view() -> UIView {
        return banner
    }

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        bridgeFactory factory: () -> CASBridge?,
        listener: BannerViewEventListener
    ) {
        let args = args as? NSDictionary ?? [:]

        flutterId = args["id"] as? String ?? ""
        channel = FlutterMethodChannel(name: "com.cleveradssolutions.cas.ads.flutter.bannerview.\(flutterId)", binaryMessenger: messenger!)

        super.init()

        channel.setMethodCallHandler(handle)

        guard let bridge = factory() else {
            print("No bridge module!")
            return
        }

        var adSize = CASSize.banner
        if let sizeMap = args["size"] as? NSDictionary {
            let serializedSize = sizeMap["size"] as? Int ?? 0
            let isAdaptive = sizeMap["isAdaptive"] as? Bool

            if isAdaptive == true {
                if let maxWidth = sizeMap["maxWidthDpi"] as? Int {
                    adSize = maxWidth == 0 ? CASSize.getAdaptiveBanner(forMaxWidth: frame.width)
                        : CASSize.getAdaptiveBanner(forMaxWidth: CGFloat(maxWidth))
                }
            } else {
                switch serializedSize {
                case 1: adSize = CASSize.banner
                case 3: adSize = CASSize.getSmartBanner()
                case 4: adSize = CASSize.leaderboard
                case 5: adSize = CASSize.mediumRectangle
                default: print("Unknown CAS BannerView size")
                }
            }
        }

        banner = CASBannerView(adSize: adSize, manager: bridge.getManager())
        banner.tag = Int(viewId)

        banner.adDelegate = listener
        listener.flutterIds[banner.tag] = flutterId

        if let isAutoloadEnabled = args["isAutoloadEnabled"] as? Bool {
            banner.isAutoloadEnabled = isAutoloadEnabled
        }

        if let refreshInterval = args["refreshInterval"] as? Int {
            banner.refreshInterval = refreshInterval
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isAdReady":
            result(banner.isAdReady)
        case "loadNextAd":
            banner.loadNextAd()
        default:
            print("Unknown method: \(call.method)")
            result(FlutterError(code: "UNAVAILABLE", message: "Unknown method: \(call.method)", details: nil))
        }
    }
}
