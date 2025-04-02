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
    let id: String

    let banner: CASBannerView
    let frame: CGRect
    private let bannerCallback: BannerCallback
    private let sizeListener: BannerSizeListener

    init(
        frame: CGRect,
        viewId: Int64,
        args: [String: Any?]?,
        methodHandler: BannerMethodHandler
    ) {
        id = args?["id"] as? String ?? ""
        let contentInfoId = "banner_$id"

        self.frame = frame
        banner = CASBannerView(casID: id, size: BannerMethodHandler.getAdSize(args, frame))
        banner.tag = Int(viewId)
        sizeListener = BannerSizeListener(banner, methodHandler, id)
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
        banner.destroy()
    }
}
