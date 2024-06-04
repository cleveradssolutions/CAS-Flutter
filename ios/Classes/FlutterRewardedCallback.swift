import Foundation
import CleverAdsSolutions

public class FlutterRewardedCallback : CASFlutterCallback {
    
    var flutterCaller: completion?
    
    func setFlutterCaller(caller: @escaping(completion)) {
        flutterCaller = caller
    }
    
    func onLoaded() {
        flutterCaller?("OnRewardedAdLoaded", nil)
    }
    
    func onFailed(error: String?) {
        var args = [String: Any]()
        args["message"] = error != nil ? error! : ""
        flutterCaller?("OnRewardedAdFailedToLoad", args)
    }
    
    func onShown() {
        flutterCaller?("OnRewardedAdShown", nil)
    }
    
    func onImpression(for impression: CASImpression) {
        flutterCaller?("OnRewardedAdImpression", impression.toDict())
    }
    
    func onShowFailed(message: String) {
        var args = [String: Any]()
        args["message"] = message
        flutterCaller?("OnRewardedAdFailedToShow", args)
    }
    
    func onClicked() {
        flutterCaller?("OnRewardedAdClicked", nil)
    }
    
    func onComplete() {
        flutterCaller?("OnRewardedAdCompleted", nil)
    }
    
    func onClosed() {
        flutterCaller?("OnRewardedAdClosed", nil)
    }
    
    func OnRect(x: Int, y: Int, width: Int, height: Int) {
        
    }
}
