//
//  CASBridgeBuilder.swift
//  clever_ads_solutions
//
//  Created by Владислав Горик on 01.08.2023.
//

import Foundation
import CleverAdsSolutions

public class CASBridgeBuilder : FlutterCaller {
    
    var flutterCaller: completion?
    
    let rootViewController: UIViewController
    
    let managerBuilder: CASManagerBuilder
    
    let initCallback: CASInitCallback
    
    let interListener: CASFlutterCallback
    let rewardListener: CASFlutterCallback
    
    let appReturnListener: FlutterAppReturnCallback
    
    private var consent : CASConsentFlow
    
    private var consentHandler : CASConsentCompletionHandler?

    init(rootViewController: UIViewController,
         initCallback: CASInitCallback,
         interListener: CASFlutterCallback,
         rewardListener: CASFlutterCallback,
         appReturnListener: FlutterAppReturnCallback)
    {
        self.rootViewController = rootViewController
        
        consent = CASConsentFlow()
            .withViewControllerToPresent(rootViewController)
        managerBuilder = CAS.buildManager().withConsentFlow(consent)
        
        self.initCallback = initCallback
        self.interListener = interListener
        self.rewardListener = rewardListener
        self.appReturnListener = appReturnListener
    }

    func setFlutterCaller(caller: @escaping(completion)) {
        flutterCaller = caller
        self.consentHandler = { status in
            var args = [String: Any]()
            args["status"] = status.rawValue
            self.flutterCaller?("OnDismissListener", args)
        }
        consent.withCompletionHandler(consentHandler)
    }
    
    func withTestMode(enable: Bool) {
        managerBuilder.withTestAdMode(enable)
    }
    
    func setUserId(id: String) {
        managerBuilder.withUserID(id)
    }
    
    func disableConsentFlow() {
        consent = CASConsentFlow(isEnabled: false)
                .withCompletionHandler(consentHandler)
        managerBuilder.withConsentFlow(consent)
    }
    
    func enableConsentFlow(url: String) {
        consent = CASConsentFlow()
            .withViewControllerToPresent(rootViewController)
            .withCompletionHandler(consentHandler)
            .withPrivacyPolicy(url)
        managerBuilder.withConsentFlow(consent)
    }
    
    func showConsentFlow() {
        consent.present()
    }
    
    func addExtras(keyString: String, valueString: String) {
        managerBuilder.withMediationExtras(valueString, forKey: keyString )
    }
    
    func build(id: String, flutterVersion: String, formats: CASTypeFlags) -> CASBridge {
        return self.buildInternal(id: id, flutterVersion: flutterVersion, formats: formats)
    }
    
    func buildInternal(id: String, flutterVersion: String, formats: CASTypeFlags) -> CASBridge {
        managerBuilder.withAdFlags(formats)
        managerBuilder.withFramework("Flutter", version: flutterVersion)
        
        let bridge = CASBridge(builder: self, casID: id)
        bridge.getManager().adLoadDelegate = bridge
        return bridge
    }
}
