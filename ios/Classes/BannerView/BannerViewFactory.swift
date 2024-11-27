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
    private let managerHandler: MediationManagerMethodHandler
    private let methodHandler: BannerMethodHandler

    init(with registrar: FlutterPluginRegistrar, managerHandler: MediationManagerMethodHandler) {
        self.registrar = registrar
        self.managerHandler = managerHandler
        methodHandler = BannerMethodHandler(with: registrar)
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return BannerView(
            frame: frame,
            viewId: viewId,
            args: args as? [String: Any?],
            manager: managerHandler.manager,
            methodHandler: methodHandler
        )
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
