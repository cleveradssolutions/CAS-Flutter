import Foundation
import CleverAdsSolutions

public class FlutterInitCallback : CASInitCallback {
    
    var flutterCaller: completion?
    
    func setFlutterCaller(caller: @escaping(completion)) {
        flutterCaller = caller
    }
    
    func onCASInitialized(error: String?, countryCode: String?, isConsentRequired: Bool, isTestMode: Bool) {
        var args = [String: Any?]()
        args["error"] = error
        args["countryCode"] = countryCode
        args["isConsentRequired"] = isConsentRequired
        args["testMode"] = isTestMode
        flutterCaller?("onCASInitialized", args)
    }
}
