//
//  AppOpenMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "cleveradssolutions/app_open"

class AppOpenMethodHandler: AdMethodHandler<CASAppOpen> {
    private var contentDelegate: ScreenContentDelegateHandler?
    private var impressionDelegate: ImpressionDelegateHandler?
    
    init(with registrar: FlutterPluginRegistrar, _ contentInfoMethodHandler: AdContentInfoMethodHandler) {
        super.init(with: registrar, on: channelName, contentInfoMethodHandler)
    }

    override func initInstance(_ id: String) -> AdMethodHandler<CASAppOpen>.Ad {
        let appOpen = CASAppOpen(casID: id)
        let contentInfoId = "app_open_\(id)"
        let contentDelegate = ScreenContentDelegateHandler(self, id, contentInfoId)
        self.contentDelegate = contentDelegate
        appOpen.delegate = contentDelegate
        let impressionDelegate = ImpressionDelegateHandler(self, id, contentInfoId)
        appOpen.impressionDelegate = impressionDelegate
        self.impressionDelegate = impressionDelegate
        return Ad(ad: appOpen, id: id, contentInfoId: contentInfoId)
    }

    override func onMethodCall(_ instance: Ad, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "isAutoloadEnabled":
            isAutoloadEnabled(instance.ad, result)
        case "setAutoloadEnabled":
            setAutoloadEnabled(instance.ad, call, result)
        case "isAutoshowEnabled":
            isAutoshowEnabled(instance.ad, result)
        case "setAutoshowEnabled":
            setAutoshowEnabled(instance.ad, call, result)
        case "isLoaded":
            isLoaded(instance.ad, result)
        case "getContentInfo":
            getContentInfo(instance.contentInfoId, result)
        case "load":
            load(instance.ad, result)
        case "show":
            show(instance.ad, result)
        case "destroy":
            destroy(instance, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func isAutoloadEnabled(_ appOpen: CASAppOpen, _ result: @escaping FlutterResult) {
        result(appOpen.isAutoloadEnabled)
    }

    private func setAutoloadEnabled(_ appOpen: CASAppOpen, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("isEnabled", result) { isEnabled in
            appOpen.isAutoloadEnabled = isEnabled
        }
    }

    private func isAutoshowEnabled(_ appOpen: CASAppOpen, _ result: @escaping FlutterResult) {
        result(appOpen.isAutoshowEnabled)
    }

    private func setAutoshowEnabled(_ appOpen: CASAppOpen, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("isEnabled", result) { isEnabled in
            appOpen.isAutoshowEnabled = isEnabled
        }
    }

    private func isLoaded(_ appOpen: CASAppOpen, _ result: @escaping FlutterResult) {
        result(appOpen.isAdLoaded)
    }

    private func getContentInfo(_ contentInfoId: String, _ result: @escaping FlutterResult) {
        result(contentInfoId)
    }

    private func load(_ appOpen: CASAppOpen, _ result: @escaping FlutterResult) {
        appOpen.loadAd()

        result(nil)
    }

    private func show(_ appOpen: CASAppOpen, _ result: @escaping FlutterResult) {
        appOpen.present()

        result(nil)
    }

    private func destroy(_ ad: AdMethodHandler<CASAppOpen>.Ad, _ result: @escaping FlutterResult) {
        contentDelegate = nil
        impressionDelegate = nil
        destroy(ad: ad)
        ad.ad.destroy()

        result(nil)
    }
}
