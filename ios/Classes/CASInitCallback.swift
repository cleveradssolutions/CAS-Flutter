//
//  CASInitCallback.swift
//  clever_ads_solutions
//
//  Created by Владислав Горик on 08.08.2023.
//

import Foundation

protocol CASInitCallback : FlutterCaller {
    func onCASInitialized(error: String, countryCode: String, isConsentRequired: Bool, isTestMode: Bool)
}
