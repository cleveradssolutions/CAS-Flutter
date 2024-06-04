//
//  BannerViewFactory.swift
//  clever_ads_solutions
//
//  Created by MacMini on 2.04.24.
//

import Foundation
import Flutter

class BannerViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var bridge: () -> CASBridge?
    private let listener: BannerViewEventListener
    private let channel: FlutterEventChannel

    init(bridge: @escaping () -> CASBridge?, messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        self.bridge = bridge
        self.listener = BannerViewEventListener()
        self.channel = FlutterEventChannel(name: "com.cleveradssolutions.cas.ads.flutter.bannerview", binaryMessenger: self.messenger)
        self.channel.setStreamHandler(listener)
        
        super.init()
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return BannerView(
                    frame: frame,
                    viewIdentifier: viewId,
                    arguments: args,
                    binaryMessenger: messenger,
                    bridgeFactory: bridge,
                    listener: listener)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
