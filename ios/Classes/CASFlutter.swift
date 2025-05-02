//
//  CASFlutter.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

public class CASFlutter: NSObject, FlutterPlugin {
    private var methodHandlers: [MethodHandler] = []

    init(with registrar: FlutterPluginRegistrar) {
        let contentInfoHandler = AdContentInfoMethodHandler(with: registrar)
        let consentFlowMethodHandler = ConsentFlowMethodHandler(with: registrar)
        let mediationManagerMethodHandler = MediationManagerMethodHandler(with: registrar)

        methodHandlers = [
            AdSizeMethodHandler(with: registrar),
            AdsSettingsMethodHandler(with: registrar),
            AppOpenMethodHandler(with: registrar, contentInfoHandler),
            CASMethodHandler(with: registrar),
            InterstitialMethodHandler(with: registrar, contentInfoHandler),
            consentFlowMethodHandler,
            ManagerBuilderMethodHandler(
                with: registrar,
                consentFlowMethodHandler,
                mediationManagerMethodHandler
            ),
            RewardedMethodHandler(with: registrar, contentInfoHandler),
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
