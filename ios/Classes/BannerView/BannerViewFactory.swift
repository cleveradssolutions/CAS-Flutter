//
//  BannerViewFactory.swift
//  clever_ads_solutions
//
//  Created by MacMini on 2.04.24.
//

import Flutter
import Foundation

class BannerViewFactory: NSObject, FlutterPlatformViewFactory {

    private var messenger: FlutterBinaryMessenger
    private var bridge: () -> CASBridge?

    init(messenger: FlutterBinaryMessenger, bridge: @escaping () -> CASBridge?) {
        self.messenger = messenger
        self.bridge = bridge
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return BannerView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            bridgeFactory: bridge,

        )
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

}
