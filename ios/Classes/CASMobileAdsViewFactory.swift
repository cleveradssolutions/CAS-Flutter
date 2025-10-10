import Flutter

class CASMobileAdsViewFactory: NSObject, FlutterPlatformViewFactory{
    
    private let manager: AdInstanceManager
    
    init(manager: AdInstanceManager) {
        self.manager = manager
        super.init()
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        var adId = 0
        
        if let argsMap = args as? [String: Any] {
            adId = argsMap["adId"] as! Int
            let width = argsMap["width"] as! Int
            let height = argsMap["height"] as! Int
            
            if let flutterAd = manager.findAd(adId) as? FlutterPlatformView {
                if let nativeAd = flutterAd as? FlutterNativeAd{
                    nativeAd.updatePlatformView(width: CGFloat(width),
                                                height: CGFloat(height))
                }
                
                    return flutterAd
            }
        }

        let reason = "Ad View with the following id could not be found: \(adId)."
        NSException(name: .invalidArgumentException, reason: reason, userInfo: nil).raise()
        fatalError(reason)
    }
    
    func createArgsCodec() -> any FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}
