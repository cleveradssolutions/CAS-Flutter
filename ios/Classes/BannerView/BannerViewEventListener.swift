//
//  BannerViewEventListener.swift
//  clever_ads_solutions
//
//  Created by MacMini on 2.04.24.
//

import Foundation
import CleverAdsSolutions
import Flutter

class BannerViewEventListener: NSObject, CASBannerDelegate, FlutterStreamHandler {
    var flutterIds: [Int:String] = [Int:String]()
    private var eventSink: FlutterEventSink?
    
    func bannerAdViewDidLoad(_ view: CASBannerView) {
        if let sink = self.eventSink {
            sink([
                "id": flutterIds[view.tag],
                "event": "onAdViewLoaded"
            ])
        }
    }
    
    func bannerAdView(_ adView: CASBannerView, willPresent impression: CASImpression) {
        if let sink = self.eventSink {
            sink([
                "id": flutterIds[adView.tag],
                "event": "onAdViewPresented",
                "data": impression.toDict()
            ])
        }
    }
    
    func bannerAdViewDidRecordClick(_ adView: CASBannerView) {
        if let sink = self.eventSink {
            sink([
                "id": flutterIds[adView.tag],
                "event": "onAdViewClicked"
            ])
        }
    }
    
    func bannerAdView(_ adView: CASBannerView, didFailWith error: CASError) {
        if let sink = self.eventSink {
            sink([
                "id": flutterIds[adView.tag],
                "event": "onAdViewFailed",
                "data": error.message
            ])
        }
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
