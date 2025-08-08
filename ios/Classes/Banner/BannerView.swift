//
//  BannerView.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

class BannerView: AdInstance, FlutterPlatformView, CASBannerDelegate, CASImpressionDelegate {
    private weak var handler: BannerMethodHandler?
    private var lastWidth: CGFloat = 0
    private var lastHeight: CGFloat = 0

    let banner: CASBannerView

    init(
        frame: CGRect,
        viewId: Int64,
        args: [String: Any?]?,
        methodHandler: BannerMethodHandler
    ) {
        handler = methodHandler

        let id = args?["id"] as? String ?? ""
        let contentInfoId = "banner_\(id)"

        let size = if let map = args?["size"] as? [String: Any?] { BannerMethodHandler.getAdSize(map, frame) } else { CASSize.banner }

        banner = CASBannerView(casID: args?["casId"] as? String ?? "", size: size)
        banner.tag = Int(viewId)

        super.init(id: id, contentInfoId: contentInfoId)

        banner.delegate = self
        banner.impressionDelegate = self

        methodHandler[id] = self

        if let args = args {
            if let isAutoloadEnabled = args["isAutoloadEnabled"] as? Bool {
                banner.isAutoloadEnabled = isAutoloadEnabled
            }

            if let refreshInterval = args["refreshInterval"] as? Int {
                banner.refreshInterval = refreshInterval
            }
        } else {
            print("\(casLogTag) BannerView args is nil")
        }
    }

    func view() -> UIView {
        return banner
    }

    func dispose() {
        _ = handler?.remove(id)
        banner.destroy()
    }

    private func updateSize(_ width: Double, _ height: Double) {
        if width != lastWidth || height != lastHeight {
            lastWidth = width
            lastHeight = height

            handler?.invokeMethod(
                id,
                "updateWidgetSize",
                [
                    "width": width,
                    "height": height,
                ]
            )
        }
    }

    // MARK: - CASBannerDelegate

    func bannerAdViewDidLoad(_ view: CASBannerView) {
        handler?.invokeMethod(id, "onAdViewLoaded")

        let size = view.intrinsicContentSize
        updateSize(size.width, size.height)
    }

    func bannerAdView(_ adView: CASBannerView, didFailWith error: CASError) {
        handler?.invokeMethod(id, "onAdViewFailed", ["error": error.description])

        updateSize(0, 0)
    }

    func bannerAdViewDidRecordClick(_ adView: CASBannerView) {
        handler?.invokeMethod(id, "onAdViewClicked")
    }

    // MARK: - CASImpressionDelegate

    func adDidRecordImpression(info: AdContentInfo) {
        handler?.onAdContentLoaded(contentInfoId, info)
        handler?.invokeMethod(id, "onAdImpression", ["contentInfoId": contentInfoId])
    }
}
