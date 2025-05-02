//
//  TargetingOptionsMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter
import Foundation

private let channelName = "cleveradssolutions/targeting_options"

class TargetingOptionsMethodHandler: MethodHandler {
    init(with registrar: FlutterPluginRegistrar) {
        super.init(with: registrar, on: channelName)
    }

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "getGender": getGender(result)
        case "setGender": setGender(call, result)
        case "getAge": getAge(result)
        case "setAge": setAge(call, result)
        case "getLocationLatitude": getLocationLatitude(result)
        case "setLocationLatitude": setLocationLatitude(call, result)
        case "getLocationLongitude": getLocationLongitude(result)
        case "setLocationLongitude": setLocationLongitude(call, result)
        case "isLocationCollectionEnabled": isLocationCollectionEnabled(result)
        case "setLocationCollectionEnabled": setLocationCollectionEnabled(call, result)
        case "getKeywords": getKeywords(result)
        case "setKeywords": setKeywords(call, result)
        case "getContentUrl": getContentUrl(result)
        case "setContentUrl": setContentUrl(call, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func getGender(_ result: @escaping FlutterResult) {
        result(CAS.targetingOptions.gender)
    }

    private func setGender(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let index: Int = call.getArgAndCheckNil("gender", result) else { return }
        if let value = Gender(rawValue: index) {
            CAS.targetingOptions.gender = value
            result(nil)
        } else {
            result(call.errorInvalidArg("gender"))
        }
    }

    private func getAge(_ result: @escaping FlutterResult) {
        result(CAS.targetingOptions.age)
    }

    private func setAge(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("age", result) { age in
            CAS.targetingOptions.age = age
        }
    }

    private func getLocationLatitude(_ result: @escaping FlutterResult) {
        result(CAS.targetingOptions.locationLatitude)
    }

    private func setLocationLatitude(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("latitude", result) { latitude in
            let longitude = CAS.targetingOptions.location?.coordinate.longitude ?? 0.0
            CAS.targetingOptions.setLocation(latitude: latitude, longitude: longitude)
        }
    }

    private func getLocationLongitude(_ result: @escaping FlutterResult) {
        result(CAS.targetingOptions.locationLongitude)
    }

    private func setLocationLongitude(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("longitude", result) { longitude in
            let latitude = CAS.targetingOptions.location?.coordinate.latitude ?? 0.0
            CAS.targetingOptions.setLocation(latitude: latitude, longitude: longitude)
        }
    }

    private func isLocationCollectionEnabled(_ result: @escaping FlutterResult) {
        result(CAS.targetingOptions.locationCollectionEnabled)
    }

    private func setLocationCollectionEnabled(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("isEnabled", result) { isEnabled in
            CAS.targetingOptions.locationCollectionEnabled = isEnabled
        }
    }

    private func getKeywords(_ result: @escaping FlutterResult) {
        result(CAS.targetingOptions.keywords)
    }

    private func setKeywords(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("keywords", result) { keywords in
            CAS.targetingOptions.keywords = keywords
        }
    }

    private func getContentUrl(_ result: @escaping FlutterResult) {
        result(CAS.targetingOptions.contentUrl)
    }

    private func setContentUrl(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("contentUrl", result) { contentUrl in
            CAS.targetingOptions.contentUrl = contentUrl
        }
    }
}
