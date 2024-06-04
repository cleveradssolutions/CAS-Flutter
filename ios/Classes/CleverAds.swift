import Foundation
import CleverAdsSolutions

public class CleverAds
{
    private let rootViewController: UIViewController
    
    private let flutterInitListener : CASInitCallback = FlutterInitCallback()
    private let flutterInterstitialListener : CASFlutterCallback = FlutterInterstitialCallback()
    private let flutterRewardedListener : CASFlutterCallback = FlutterRewardedCallback()

    private let flutterAppReturnListener : FlutterAppReturnCallback
    
    private let casBridgeBuilder : CASBridgeBuilder
    private var casBridge : CASBridge?
    
        
    init(rootViewController: UIViewController?) {
        self.rootViewController = rootViewController.unsafelyUnwrapped
        
        flutterAppReturnListener = FlutterAppReturnCallback(viewController: self.rootViewController)
        
        casBridgeBuilder = CASBridgeBuilder(
            rootViewController: self.rootViewController,
            initCallback: flutterInitListener,
            interListener: flutterInterstitialListener,
            rewardListener: flutterRewardedListener,
            appReturnListener: flutterAppReturnListener
        )
    }
    
    public func getCasBridgeBuilder() -> CASBridgeBuilder {
        return casBridgeBuilder
    }
    
    public func getCasBridge() -> CASBridge? {
        return casBridge
    }
    
    public func buildBridge(id: String, flutterVersion: String, formats: Int) {
        casBridge = casBridgeBuilder.build(id: id, flutterVersion: flutterVersion, formats: CASTypeFlags(rawValue: UInt(formats)))
    }
    
    public func setFlutterCallerToCallbacks(caller: @escaping(completion)) {
        flutterInitListener.setFlutterCaller(caller: caller)
        flutterInterstitialListener.setFlutterCaller(caller: caller)
        flutterRewardedListener.setFlutterCaller(caller: caller)
        flutterAppReturnListener.setFlutterCaller(caller: caller)
        casBridgeBuilder.setFlutterCaller(caller: caller)
    }
}
