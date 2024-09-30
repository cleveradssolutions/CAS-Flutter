//
//  CASFlutterCallback.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import Foundation
import CleverAdsSolutions

protocol CASFlutterCallback : FlutterCaller {
    func onLoaded();
    
    func onFailed(error: String?)
    
    func onShown()
    
    func onImpression(for impression: CASImpression)
    
    func onShowFailed(message: String)
    
    func onClicked()
    
    func onComplete()
    
    func onClosed()
    
    func OnRect(x: Int, y: Int, width: Int, height: Int)
}
