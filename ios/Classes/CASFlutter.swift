//
//  CASFlutter.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

let casLogTag = "[CAS.AI.Flutter]"

public class CASFlutter: NSObject, FlutterPlugin {
    private var methodHandlers: [Any] = []

    
    init(with registrar: FlutterPluginRegistrar) {
        let contentInfoHandler = AdContentInfoMethodHandler(with: registrar)
        let consentFlowMethodHandler = ConsentFlowMethodHandler(with: registrar)
        let mediationManagerMethodHandler = MediationManagerMethodHandler(with: registrar)

        methodHandlers = [
            AdSizeMethodHandler(with: registrar),
            AdsSettingsMethodHandler(with: registrar),
            ScreenAdMethodHandler(with: registrar, on: "app_open", contentInfoHandler),
            ScreenAdMethodHandler(with: registrar, on: "interstitial", contentInfoHandler),
            ScreenAdMethodHandler(with: registrar, on: "rewarded", contentInfoHandler),
            CASMethodHandler(with: registrar),
            consentFlowMethodHandler,
            ManagerBuilderMethodHandler(
                with: registrar,
                consentFlowMethodHandler,
                mediationManagerMethodHandler
            ),
            mediationManagerMethodHandler,
            TargetingOptionsMethodHandler(with: registrar),
        ]

        let bannerViewFactory = BannerViewFactory(with: registrar, contentInfoHandler)
        registrar.register(bannerViewFactory, withId: "<cas-banner-view>")
    }

    public static func register(with registrar: any FlutterPluginRegistrar) {
        let instance = CASFlutter(with: registrar)
        registrar.publish(instance)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        methodHandlers = []
    }
}
