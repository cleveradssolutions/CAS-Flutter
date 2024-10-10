import CleverAdsSolutions
import Flutter

public class CASFlutter: NSObject, FlutterPlugin {
    public static let cleverAdsSolutions: CleverAds = CleverAds(
        rootViewController: UIApplication.shared.delegate!.window!!.rootViewController!
    )

    private var methodHandlers: [MethodHandler]

    init(with registrar: FlutterPluginRegistrar) {
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

        registrar.register(BannerViewFactory(registrar: registrar, bridgeProvider: CASFlutter.cleverAdsSolutions.getCasBridge), withId: "<cas-banner-view>")
    }

    public static func register(with registrar: any FlutterPluginRegistrar) {
        let instance = CASFlutter(with: registrar)
        registrar.publish(instance)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        methodHandlers.forEach { handler in
            handler.onDetachedFromFlutter()
        }
        methodHandlers = []
    }
}
