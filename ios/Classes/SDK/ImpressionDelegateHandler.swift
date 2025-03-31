//
//  CASImpressionDelegateHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

class ImpressionDelegateHandler: MappedCallback, CASImpressionDelegate {
    private let handler: AdMethodHandlerProtocol
    private let contentInfoId: String

    init(_ handler: AdMethodHandlerProtocol, _ id: String, _ contentInfoId: String) {
        self.handler = handler
        self.contentInfoId = contentInfoId
        super.init(handler, id)
    }

    func adDidRecordImpression(info: AdContentInfo) {
        handler.onAdContentLoaded(contentInfoId, info)
        invokeMethod("onAdImpression", ["contentInfoId": contentInfoId])
    }
}
