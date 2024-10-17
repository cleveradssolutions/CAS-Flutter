//
//  CASInitCallback.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import Foundation

protocol CASInitCallback : FlutterCaller {
    func onCASInitialized(error: String?, countryCode: String?, isConsentRequired: Bool, isTestMode: Bool)
}
