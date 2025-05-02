//
//  AdMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

protocol AdMethodHandlerProtocol: MappedMethodHandlerProtocol {
    func onAdContentLoaded(_ contentInfoId: String, _ contentInfo: AdContentInfo?)
}

class AdMethodHandler<T>: MappedMethodHandler<AdMethodHandler.Ad>, AdMethodHandlerProtocol {
    struct Ad {
        let ad: T
        let id: String
        let contentInfoId: String
    }

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

    func destroy(ad: Ad) {
        _ = remove(ad.id)
        _ = contentInfoHandler.remove(ad.contentInfoId)
    }
}
