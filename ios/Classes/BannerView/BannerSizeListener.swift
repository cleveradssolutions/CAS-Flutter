//
//  AppOpenMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

class BannerSizeListener: MappedCallback {
    private let banner: UIView

    private var lastWidth: CGFloat = 0
    private var lastHeight: CGFloat = 0

    init(_ banner: UIView, _ handler: BannerMethodHandler, _ id: String) {
        self.banner = banner
        super.init(handler, id)
    }

    func updateSize(_ size: CGSize) {
        let currentWidth = size.width
        let currentHeight = size.height

        if currentWidth != lastWidth || currentHeight != lastHeight {
            lastWidth = currentWidth
            lastHeight = currentHeight

            invokeMethod(
                "updateWidgetSize",
                [
                    "width": currentWidth,
                    "height": currentHeight,
                ]
            )
        }
    }
}
