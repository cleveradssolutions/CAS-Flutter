//
//  EventHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import Flutter

class EventHandler: NSObject, FlutterStreamHandler {
    private var channelName: String
    private var channel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?

    init(channelName: String) {
        self.channelName = channelName
    }

    open func onAttachedToFlutter(_ registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger()
        channel = FlutterEventChannel(name: channelName, binaryMessenger: binaryMessenger)
        channel!.setStreamHandler(self)
    }

    open func onDetachedFromFlutter() {
        channel?.setStreamHandler(nil)
        channel = nil
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    internal func success(_ map: [String: Any?]) {
        eventSink?(map)
    }
}
