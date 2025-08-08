//
//  AdMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

class AdInstance: NSObject {
    let id: String
    let contentInfoId: String

    init(id: String, contentInfoId: String) {
        self.id = id
        self.contentInfoId = contentInfoId
        super.init()
    }
}

class AdMethodHandler<T: AdInstance>: CASMappedChannel<T> {
    private let contentInfoHandler: AdContentInfoMethodHandler

    init(with registrar: FlutterPluginRegistrar, on channelName: String, _ contentInfoHandler: AdContentInfoMethodHandler) {
        self.contentInfoHandler = contentInfoHandler
        super.init(with: registrar, on: channelName)
    }

    func onAdContentLoaded(_ contentInfoId: String, _ contentInfo: AdContentInfo?) {
        if contentInfo != nil {
            contentInfoHandler[contentInfoId] = contentInfo
        } else {
            _ = contentInfoHandler.remove(contentInfoId)
        }
    }

    func destroy(instance: AdInstance) {
        _ = remove(instance.id)
        _ = contentInfoHandler.remove(instance.contentInfoId)
    }
}
