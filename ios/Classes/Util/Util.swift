//
//  Util.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

class Util {
    public static func findRootViewController() -> UIViewController? {
        // UIApplication.sharedApplication.delegate.window is not guaranteed to be
        // set. Use the keyWindow in this case.
        var root = UIApplication.shared.delegate?.window??.rootViewController ?? UIApplication.shared.keyWindow?.rootViewController

        // Get the presented view controller.
        while let presented = root?.presentedViewController, !presented.isBeingDismissed {
            if let tabBarController = root as? UITabBarController {
                root = tabBarController.selectedViewController
            } else if let navigationController = root as? UINavigationController {
                root = navigationController.visibleViewController
            } else {
                root = presented
            }
        }
        return root
    }
}
