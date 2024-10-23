//
//  CASBridgeBuilder.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Foundation

public class CASBridgeBuilder /* : FlutterCaller*/ {
//    var flutterCaller: completion?

    let rootViewController: UIViewController

    let managerBuilder: CASManagerBuilder

    let initCallback: CASInitCallback

    init(_ rootViewController: UIViewController, _ initCallback: CASInitCallback) {
        self.rootViewController = rootViewController

//        consent = CASConsentFlow()
//            .withViewControllerToPresent(rootViewController)
        managerBuilder = CAS.buildManager() // .withConsentFlow(consent)

        self.initCallback = initCallback
    }

//    func setFlutterCaller(caller: @escaping(completion)) {
//        flutterCaller = caller
//        self.consentHandler = { status in
//            var args = [String: Any]()
//            args["status"] = status.rawValue
//            self.flutterCaller?("OnDismissListener", args)
//        }
//        consent.withCompletionHandler(consentHandler)
//    }

    func withTestMode(isEnabled: Bool) {
        managerBuilder.withTestAdMode(isEnabled)
    }

    func setUserId(id: String) {
        managerBuilder.withUserID(id)
    }

    func addExtras(keyString: String, valueString: String) {
        managerBuilder.withMediationExtras(valueString, forKey: keyString)
    }

    func build(
        id: String,
        flutterVersion: String,
        formats: CASTypeFlags,
        consentFlow: CASConsentFlow,
        mediationManagerMethodHandler: MediationManagerMethodHandler
    ) -> CASBridge {
        return buildInternal(id: id, flutterVersion: flutterVersion, formats: formats, consentFlow: consentFlow, mediationManagerMethodHandler: mediationManagerMethodHandler)
    }

    func buildInternal(
        id: String,
        flutterVersion: String,
        formats: CASTypeFlags,
        consentFlow: CASConsentFlow,
        mediationManagerMethodHandler: MediationManagerMethodHandler
    ) -> CASBridge {
        managerBuilder.withAdFlags(formats)
        managerBuilder.withFramework("Flutter", version: flutterVersion)

        let bridge = CASBridge(builder: self, casID: id, mediationManagerMethodHandler: mediationManagerMethodHandler)
        bridge.getManager().adLoadDelegate = bridge
        return bridge
    }
}
