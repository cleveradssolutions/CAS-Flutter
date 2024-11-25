//
//  AppOpenMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "cleveradssolutions/app_open"

class AppOpenMethodHandler: MappedMethodHandler<AppOpenMethodHandler.AppOpenHolder> {
    init(with registrar: FlutterPluginRegistrar) {
        super.init(with: registrar, on: channelName)
    }

    override func initInstance(_ id: String) -> AppOpenHolder {
        let appOpen = CASAppOpen.create(managerId: id)
        let contentCallback = ContentCallback(self, id)
        appOpen.contentCallback = contentCallback
        return AppOpenHolder(ad: appOpen, contentCallback: contentCallback)
    }

    override func onMethodCall(_ appOpen: AppOpenHolder, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "getManagerId": getManagerId(appOpen.ad, result)
        case "loadAd": loadAd(appOpen.ad, result)
        case "isAdAvailable": isAdAvailable(appOpen.ad, result)
        case "show": show(appOpen.ad, call, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func getManagerId(_ appOpen: CASAppOpen, _ result: @escaping FlutterResult) {
        result(appOpen.managerId)
    }

    private func loadAd(_ appOpen: CASAppOpen, _ result: @escaping FlutterResult) {
        appOpen.loadAd(completionHandler: createAdCompletionCallback())
        result(nil)
    }

    private func isAdAvailable(_ appOpen: CASAppOpen, _ result: @escaping FlutterResult) {
        result(appOpen.isAdAvailable())
    }

    private func show(_ appOpen: CASAppOpen, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let viewController = Util.findRootViewController() {
            appOpen.present(fromRootViewController: viewController)
            result(nil)
        } else {
            result(call.errorFieldNil("rootViewController"))
        }
    }

    private func createAdCompletionCallback() -> CASAppOpenAdCompletionHandler {
        return { [weak self] _, error in
            if let error = error {
                self?.invokeMethod("onAdFailedToLoad", error)
            } else {
                self?.invokeMethod("onAdLoaded")
            }
        }
    }

    struct AppOpenHolder {
        let ad: CASAppOpen
        let contentCallback: ContentCallback
    }
}
