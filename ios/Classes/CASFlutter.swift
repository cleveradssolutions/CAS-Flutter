import CleverAdsSolutions
import Flutter

public class CASFlutter: NSObject, FlutterPlugin {
    public static let cleverAdsSolutions: CleverAds = CleverAds(
        rootViewController: UIApplication.shared.delegate!.window!!.rootViewController!
    )

    private var methodHandlers: [MethodHandler]

    init(with registrar: FlutterPluginRegistrar) {
        //        self.pluginChannel = pluginChannel
        methodHandlers = [
            AdSizeMethodHandler(),
            AdsSettingsMethodHandler(),
            CASMethodHandler(),
            ConsentFlowMethodHandler(),
            ManagerBuilderMethodHandler(),
            MediationManagerMethodHandler(),
            TargetingOptionsMethodHandler(),
        ]
        methodHandlers.forEach { handler in
            handler.onAttachedToFlutter(registrar)
        }

        registrar.register(BannerViewFactory(messenger: registrar.messenger(), bridge: CASFlutter.cleverAdsSolutions.getCasBridge), withId: "<cas-banner-view>")
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
//        let channel = FlutterMethodChannel(name: "com.cleveradssolutions.plugin.flutter/mediation_manager", binaryMessenger: registrar.messenger())
        //let instance =
        CASFlutter(with: registrar)

//        registrar.addMethodCallDelegate(instance, channel: channel)

//        CASFlutter.cleverAdsSolutions.setFlutterCallerToCallbacks(caller: instance.invokeChannelMethod)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        methodHandlers.forEach { handler in
            handler.onDetachedFromFlutter()
        }
        methodHandlers = []
    }

//    private let pluginChannel: FlutterMethodChannel

//    private func invokeChannelMethod(methodName: String, args: Any? = nil) {
//        if flutterInit {
//            pluginChannel.invokeMethod(methodName, arguments: args)
//        }
//    }
}
