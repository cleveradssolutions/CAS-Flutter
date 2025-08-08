//
//  RewardedMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

class ScreenAdMethodHandler: AdMethodHandler<ScreenAdInstance> {
    override func initInstance(_ id: String) -> ScreenAdInstance {
        let content: CASScreenContent
        switch channelName {
        case "rewarded":
            content = CASRewarded(casID: id)
        case "app_open":
            content = CASAppOpen(casID: id)
        default:
            content = CASInterstitial(casID: id)
        }
        let contentInfoId = channelName + "_" + id
        let instance = ScreenAdInstance(id, contentInfoId, content)
        instance.handler = self
        return instance
    }

    override func onMethodCall(_ instance: ScreenAdInstance, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        instance.onMethodCall(call, result)
    }
}
