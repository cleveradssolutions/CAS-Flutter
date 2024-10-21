import Foundation
import CleverAdsSolutions

public class FlutterAppReturnCallback : CASAppReturnDelegate, FlutterCaller {
    var flutterCaller: completion?
    
    func setFlutterCaller(caller: @escaping(completion)) {
        flutterCaller = caller
    }
    
    func onLoaded() {
        
    }
    
    func onFailed(error: String?) {
        
    }
    
    func onShown() {
        flutterCaller?("OnAppReturnAdShown", nil)
    }
    
    func onImpression(for impression: CASImpression) {
        flutterCaller?("OnAppReturnAdImpression", impression.toDict())
    }
    
    func onShowFailed(message: String) {
        var args = [String: Any]()
        args["message"] = message
        flutterCaller?("OnAppReturnAdFailedToShow", args)
    }
    
    func onClicked() {
        flutterCaller?("OnAppReturnAdClicked", nil)
    }
    
    func onComplete() {
        
    }
    
    func onClosed() {
        flutterCaller?("OnAppReturnAdClosed", nil)
    }
    
    func OnRect(x: Int, y: Int, width: Int, height: Int) {
        
    }
    
    public func viewControllerForPresentingAppReturnAd() -> UIViewController {
        return Util.findRootViewController()!
    }
}
