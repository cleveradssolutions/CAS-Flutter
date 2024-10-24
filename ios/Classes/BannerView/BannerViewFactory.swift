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
    private var managerHandler: MediationManagerMethodHandler

    init(with registrar: FlutterPluginRegistrar, managerHandler: MediationManagerMethodHandler) {
        self.registrar = registrar
        self.managerHandler = managerHandler
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let args = args as? [String: Any?]
        return BannerView(
            frame: frame,
            viewId: viewId,
            args: args,
            registrar: registrar,
            managerHandler: managerHandler
        )
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

}
