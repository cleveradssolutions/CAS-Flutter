//
//  BannerView.swift
//  clever_ads_solutions
//
//  Created by MacMini on 2.04.24.
//

import Foundation
import Flutter
import CleverAdsSolutions

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
        
        self.flutterId = args["id"] as? String ?? ""
        self.channel = FlutterMethodChannel(name: "com.cleveradssolutions.cas.ads.flutter.bannerview.\(self.flutterId)", binaryMessenger: messenger!)
        
        super.init()
        
        self.channel.setMethodCallHandler(self.handle)
        
        guard let bridge = factory() else {
            fatalError("No bridge module!")
        }
        
        banner = CASBannerView(adSize: CASSize.banner, manager: bridge.getManager())
        banner.tag = Int(viewId)
        
        banner.adDelegate = listener
        listener.flutterIds[banner.tag] = self.flutterId
        
        if let sizeMap = args["size"] as? NSDictionary {
            let serializedSize = sizeMap["size"] as? Int ?? 0
            var size = CASSize.banner
            let isAdaptive = sizeMap["isAdaptive"] as? Bool
            
            if isAdaptive == true {
                if let maxWidth = sizeMap["maxWidthDpi"] as? Int {
                    size = maxWidth == 0 ? CASSize.getAdaptiveBanner(forMaxWidth: frame.width) 
                    : CASSize.getAdaptiveBanner(forMaxWidth: CGFloat(maxWidth))
                }
            } else {
                switch(serializedSize) {
                case 1: size = CASSize.banner
                case 3: size = CASSize.getSmartBanner()
                case 4: size = CASSize.leaderboard
                case 5: size = CASSize.mediumRectangle
                default: fatalError("Unknown CAS BannerView size")
                }
            }
            
            banner.adSize = size
        }
        
        if let isAutoloadEnabled = args["isAutoloadEnabled"] as? Bool {
            banner.isAutoloadEnabled = isAutoloadEnabled
        }
        
        if let refreshInterval = args["refreshInterval"] as? Int {
            banner.refreshInterval = refreshInterval
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
        case "isAdReady":
            result(banner.isAdReady)
        case "loadNextAd":
            banner.loadNextAd()
        default:
            fatalError("Unknown method")
        }
    }
}
