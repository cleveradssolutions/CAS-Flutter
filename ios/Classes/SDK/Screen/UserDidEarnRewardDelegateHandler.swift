//
//  CASUserDidEarnRewardDelegateHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

class UserDidEarnRewardDelegateHandler: MappedCallback, CASUserDidEarnRewardHandler {

    private let handler: AdMethodHandlerProtocol
    private let contentInfoId: String

    init(_ handler: AdMethodHandlerProtocol, _ id: String, _ contentInfoId: String) {
        super.init(handler, id)
    }

    func adDidRecordImpression(info: AdContentInfo) {
        invokeMethod("onUserEarnedReward", ["contentInfoId": contentInfoId])
    }
}
