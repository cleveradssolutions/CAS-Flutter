//
//  AppOpenMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

class BannerSizeListener: MappedCallback {
    private let banner: UIView
    private var observer: NSKeyValueObservation?

    init(_ banner: UIView, _ handler: BannerMethodHandler, _ id: String) {
        self.banner = banner
        super.init(handler, id)

        observer = banner.observe(\.bounds) { [weak self] _, change in
            let newBounds = change.newValue
            let oldBounds = change.oldValue
            let newWidth = newBounds?.width ?? 0
            let newHeight = newBounds?.height ?? 0
            let oldWidth = oldBounds?.width ?? 0
            let oldHeight = oldBounds?.height ?? 0

            if newWidth != oldWidth || newHeight != oldHeight {
                self?.invokeMethod(
                    "updateWidgetSize",
                    [
                        "width": newWidth.pxToDp(),
                        "height": newHeight.pxToDp(),
                    ]
                )
            }
        }
    }

    deinit {
        observer?.invalidate()
    }
}
