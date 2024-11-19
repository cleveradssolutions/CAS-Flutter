//
//  AppOpenMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "cleveradssolutions/app_open"

class AppOpenMethodHandler: MethodHandler {
    class Factory: FlutterObjectFactory<AppOpenMethodHandler> {
        private let registrar: FlutterPluginRegistrar

        init(with registrar: FlutterPluginRegistrar) {
            self.registrar = registrar
            super.init(with: registrar, on: channelName)
        }

        override func initInstance(id: String) -> AppOpenMethodHandler {
            AppOpenMethodHandler(with: registrar, id: id)
        }
    }

    private let appOpen: CASAppOpen
    private let contentCallback: ContentCallback

    init(with registrar: FlutterPluginRegistrar, id: String) {
        appOpen = CASAppOpen.create(managerId: id)
        contentCallback = ContentCallback()
        appOpen.contentCallback = contentCallback
        super.init(with: registrar, on: "\(channelName).\(id)")
    }

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "getManagerId": getManagerId(result)
        case "loadAd": loadAd(result)
        case "isAdAvailable": isAdAvailable(result)
        case "show": show(call, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func getManagerId(_ result: @escaping FlutterResult) {
        result(appOpen.managerId)
    }

    private func loadAd(_ result: @escaping FlutterResult) {
        appOpen.loadAd(completionHandler: createAdCompletionCallback())
        result(nil)
    }

    private func isAdAvailable(_ result: @escaping FlutterResult) {
        result(appOpen.isAdAvailable())
    }

    private func show(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
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
}
