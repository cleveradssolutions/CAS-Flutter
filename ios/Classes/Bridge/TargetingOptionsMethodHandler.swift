//
//  CASMethodHandler.swift
//  clever_ads_solutions
//
//  Created by Dmytro Uzhva on 13.08.2024.
//

import CleverAdsSolutions
import Flutter

private let channelName = "com.cleveradssolutions.plugin.flutter/targeting_options"

class TargetingOptionsMethodHandler: MethodHandler {
    init() {
        super.init(channelName: channelName)
    }

    override func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getGender": getGender(result: result)
        case "setGender": setGender(call: call, result: result)
        case "getAge": getAge(result: result)
        case "setAge": setAge(call: call, result: result)
        case "getLocationLatitude": getLocationLatitude(result: result)
        case "setLocationLatitude": setLocationLatitude(call: call, result: result)
        case "getLocationLongitude": getLocationLongitude(result: result)
        case "setLocationLongitude": setLocationLongitude(call: call, result: result)
        case "isLocationCollectionEnabled": isLocationCollectionEnabled(result: result)
        case "setLocationCollectionEnabled": setLocationCollectionEnabled(call: call, result: result)
        case "getKeywords": getKeywords(result: result)
        case "setKeywords": setKeywords(call: call, result: result)
        case "getContentUrl": getContentUrl(result: result)
        case "setContentUrl": setContentUrl(call: call, result: result)
        default: super.onMethodCall(call: call, result: result)
        }
    }

    private func getGender(result: @escaping FlutterResult) {
        result(CAS.targetingOptions.gender)
    }

    private func setGender(call: FlutterMethodCall, result: @escaping FlutterResult) {
        call.getArgAndReturnResult(name: "gender", result: result) { gender in
            CAS.targetingOptions.gender = gender
        }
    }

    private func getAge(result: @escaping FlutterResult) {
        result(CAS.targetingOptions.age)
    }

    private func setAge(call: FlutterMethodCall, result: @escaping FlutterResult) {
        call.getArgAndReturnResult(name: "age", result: result) { age in
            CAS.targetingOptions.age = age
        }
    }

    private func getLocationLatitude(result: @escaping FlutterResult) {
        result(CAS.targetingOptions.locationLatitude)
    }

    private func setLocationLatitude(call: FlutterMethodCall, result: @escaping FlutterResult) {
        call.getArgAndReturnResult(name: "latitude", result: result) { latitude in
            CAS.targetingOptions.locationLatitude = latitude
        }
    }

    private func getLocationLongitude(result: @escaping FlutterResult) {
        result(CAS.targetingOptions.locationLongitude)
    }

    private func setLocationLongitude(call: FlutterMethodCall, result: @escaping FlutterResult) {
        call.getArgAndReturnResult(name: "longitude", result: result) { longitude in
            CAS.targetingOptions.locationLongitude = longitude
        }
    }

    private func isLocationCollectionEnabled(result: @escaping FlutterResult) {
        result(CAS.targetingOptions.locationCollectionEnabled)
    }

    private func setLocationCollectionEnabled(call: FlutterMethodCall, result: @escaping FlutterResult) {
        call.getArgAndReturnResult(name: "isEnabled", result: result) { isEnabled in
            CAS.targetingOptions.locationCollectionEnabled = isEnabled
        }
    }

    private func getKeywords(result: @escaping FlutterResult) {
        result(CAS.targetingOptions.keywords)
    }

    private func setKeywords(call: FlutterMethodCall, result: @escaping FlutterResult) {
        call.getArgAndReturnResult(name: "keywords", result: result) { keywords in
            CAS.targetingOptions.keywords = keywords
        }
    }

    private func getContentUrl(result: @escaping FlutterResult) {
        result(CAS.targetingOptions.contentUrl)
    }

    private func setContentUrl(call: FlutterMethodCall, result: @escaping FlutterResult) {
        call.getArgAndReturnResult(name: "contentUrl", result: result) { contentUrl in
            CAS.targetingOptions.contentUrl = contentUrl
        }
    }
}
