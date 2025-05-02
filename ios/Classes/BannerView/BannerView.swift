//
//  BannerView.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let logTag = "[BannerView]"

class BannerView: NSObject, FlutterPlatformView {
    private let methodHandler: BannerMethodHandler

    private let id: String

    let banner: CASBannerView
    private let bannerCallback: BannerCallback

    init(
        frame: CGRect,
        viewId: Int64,
        args: [String: Any?]?,
        methodHandler: BannerMethodHandler
    ) {
        self.methodHandler = methodHandler

        id = args?["id"] as? String ?? ""
        let contentInfoId = "banner_\(id)"

        let size = if let map = args?["size"] as? [String: Any?] { BannerMethodHandler.getAdSize(map, frame) } else { CASSize.banner }
        banner = CASBannerView(casID: id, size: size)
        banner.tag = Int(viewId)
        let sizeListener = BannerSizeListener(banner, methodHandler, id)
        bannerCallback = BannerCallback(sizeListener, methodHandler, id)
        banner.delegate = bannerCallback

        super.init()

        methodHandler[id] = AdMethodHandler<BannerView>.Ad(ad: self, id: id, contentInfoId: contentInfoId)

        if let args = args {
            if let isAutoloadEnabled = args["isAutoloadEnabled"] as? Bool {
                banner.isAutoloadEnabled = isAutoloadEnabled
            }

            if let refreshInterval = args["refreshInterval"] as? Int {
                banner.refreshInterval = refreshInterval
            }
        } else {
            print("\(logTag) BannerView args is nil")
        }
    }

    func view() -> UIView {
        return banner
    }

    func dispose() {
        _ = methodHandler.remove(id)
        banner.destroy()
    }
}
