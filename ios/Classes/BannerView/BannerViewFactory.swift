//
//  BannerViewFactory.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import Flutter
import Foundation

class BannerViewFactory: NSObject, FlutterPlatformViewFactory {
    private let registrar: FlutterPluginRegistrar
    private let methodHandler: BannerMethodHandler

    init(with registrar: FlutterPluginRegistrar, _ contentInfoHandler: AdContentInfoMethodHandler) {
        self.registrar = registrar
        methodHandler = BannerMethodHandler(with: registrar, contentInfoHandler)
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return BannerView(
            frame: frame,
            viewId: viewId,
            args: args as? [String: Any?],
            methodHandler: methodHandler
        )
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
