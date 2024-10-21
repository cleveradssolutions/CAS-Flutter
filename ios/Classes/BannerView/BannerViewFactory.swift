//
//  BannerViewFactory.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import Flutter
import Foundation

class BannerViewFactory: NSObject, FlutterPlatformViewFactory {

    private var registrar: FlutterPluginRegistrar
    private var bridgeProvider: () -> CASBridge?

    init(with registrar: FlutterPluginRegistrar, bridgeProvider: @escaping () -> CASBridge?) {
        self.registrar = registrar
        self.bridgeProvider = bridgeProvider
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let args = args as? [String: Any?]
        return BannerView(
            frame: frame,
            viewId: viewId,
            args: args,
            registrar: registrar,
            bridgeProvider: bridgeProvider
        )
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

}
