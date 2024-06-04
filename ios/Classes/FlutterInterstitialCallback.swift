import Foundation
import CleverAdsSolutions

public class FlutterInterstitialCallback : CASFlutterCallback {
    
    var flutterCaller: completion?
    
    func setFlutterCaller(caller: @escaping(completion)) {
        flutterCaller = caller
    }
    
    func onLoaded() {
        flutterCaller?("OnInterstitialAdLoaded", nil)
    }
    
    func onFailed(error: String?) {
        var args = [String: Any]()
        args["message"] = error != nil ? error! : ""
        flutterCaller?("OnInterstitialAdFailedToLoad", args)
    }
    
    func onShown() {
        flutterCaller?("OnInterstitialAdShown", nil)
    }
    
    func onImpression(for impression: CASImpression) {
        flutterCaller?("OnInterstitialAdImpression", impression.toDict())
    }
    
    func onShowFailed(message: String) {
        var args = [String: Any]()
        args["message"] = message
        flutterCaller?("OnInterstitialAdFailedToShow", args)
    }
    
    func onClicked() {
        flutterCaller?("OnInterstitialAdClicked", nil)
    }
    
    func onComplete() {
        flutterCaller?("OnInterstitialAdComplete", nil)
    }
    
    func onClosed() {
        flutterCaller?("OnInterstitialAdClosed", nil)
    }
    
    func OnRect(x: Int, y: Int, width: Int, height: Int) {
        
    }
}

