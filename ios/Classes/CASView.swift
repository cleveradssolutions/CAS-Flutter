//
//  CASBannerView.swift
//  clever_ads_solutions
//
//  Created by Владислав Горик on 06.12.2023.
//

import Foundation
import CleverAdsSolutions

class CASView : CASBannerDelegate{
    private var bannerView: CASBannerView
    private var view: UIViewController
    private var callback: FlutterBannerCallback
    
    private var activePos = 3
    
    private var xOffset = 0
    private var yOffset = 0
    
    let AD_POSITION_TOP_CENTER = 0
    let AD_POSITION_TOP_LEFT = 1
    let AD_POSITION_TOP_RIGHT = 2
    let AD_POSITION_BOTTOM_CENTER = 3
    let AD_POSITION_BOTTOM_LEFT = 4
    let AD_POSITION_BOTTOM_RIGHT = 5
    
    init(bannerView: CASBannerView, view: UIViewController, callback: FlutterBannerCallback) {
        self.bannerView = bannerView
        self.view = view
        self.callback = callback
            
        bannerView.adDelegate = self
    }
    
    func bannerAdViewDidLoad(_ view: CASBannerView) {
        callback.bannerAdViewDidLoad(view)
        refreshPosition()
    }
    
    func bannerAdView(_ adView: CASBannerView, willPresent impression: CASImpression) {
        callback.bannerAdView(adView, willPresent: impression)
    }
    
    func bannerAdViewDidRecordClick(_ adView: CASBannerView) {
        callback.bannerAdViewDidRecordClick(adView)
    }
    
    func bannerAdView(_ adView: CASBannerView, didFailWith error: CASError) {
        callback.bannerAdView(adView, didFailWith: error)
    }
    
    func loadNextBanner() {
        bannerView.loadNextAd()
    }
    
    func isBannerViewAdReady() -> Bool {
        bannerView.isAdReady
    }
    
    func showBanner() {
        bannerView.isHidden = false
    }
    
    func hideBanner() {
        bannerView.isHidden = true
    }
    
    func setBannerAdRefreshRate(refresh: Int) {
        bannerView.refreshInterval = refresh
    }
    
    func disableBannerRefresh() {
       bannerView.disableAdRefresh()
    }
    
    
    func setBannerPosition(positionId: Int, xOffest: Int, yOffset: Int) {
        if (positionId < AD_POSITION_TOP_CENTER || positionId > AD_POSITION_BOTTOM_RIGHT) {
            activePos = AD_POSITION_BOTTOM_CENTER
        } else {
            activePos = positionId
        }
        
        self.xOffset = xOffest
        self.yOffset = yOffset
        
        refreshPosition()
    }
    
    func refreshPosition() {
        let parentBounds = getSafeBoundsView()
        var adSize = bannerView.intrinsicContentSize
        
        if (CGSizeEqualToSize(CGSize.zero, adSize)) {
            adSize = bannerView.adSize.toCGSize()
        }
        
        var verticalPos: CGFloat
        let bottom = CGRectGetMaxY(parentBounds) - adSize.height
        
        switch activePos {
        case AD_POSITION_TOP_CENTER, AD_POSITION_TOP_LEFT, AD_POSITION_TOP_RIGHT:
            verticalPos = min(CGRectGetMinY(parentBounds) + CGFloat(yOffset), bottom)
            
        default:
            verticalPos = bottom
        }
        
        var horizontalPos: CGFloat

        let right = parentBounds.maxX - adSize.width

        switch activePos {
        case AD_POSITION_TOP_LEFT, AD_POSITION_BOTTOM_LEFT:
            horizontalPos = min(parentBounds.minX + CGFloat(xOffset), right)

        case AD_POSITION_TOP_RIGHT, AD_POSITION_BOTTOM_RIGHT:
            horizontalPos = right

        default:
            horizontalPos = view.view.bounds.midX - adSize.width * 0.5
        }
        
        bannerView.frame = CGRectMake(horizontalPos, verticalPos, adSize.width, adSize.height)

    }
    
    func getSafeBoundsView() -> CGRect {
        let safeAreaFrame = view.view.safeAreaLayoutGuide.layoutFrame
        
        if (!CGSizeEqualToSize(CGSize.zero, safeAreaFrame.size)) {
            return safeAreaFrame
        }
        
        return view.view.bounds
    }
    
    func disposeBanner() {
        bannerView.destroy()
    }
}
