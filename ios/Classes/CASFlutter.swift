import CleverAdsSolutions
import Flutter

public class CASFlutter: NSObject, FlutterPlugin {
    private var methodHandlers: [MethodHandler] = []

    private var casBridge: CASBridge?

    init(with registrar: FlutterPluginRegistrar) {
        super.init()
        let rootViewControllerProvider: () -> UIViewController? = { UIApplication.shared.delegate?.window??.rootViewController }
        let bridgeProvider: () -> CASBridge? = { self.casBridge }
        let consentFlowMethodHandler = ConsentFlowMethodHandler(rootViewControllerProvider)
        let mediationManagerMethodHandler = MediationManagerMethodHandler(rootViewControllerProvider()!, bridgeProvider)

        methodHandlers = [
            AdSizeMethodHandler(),
            AdsSettingsMethodHandler(),
            CASMethodHandler(),
            consentFlowMethodHandler,
            ManagerBuilderMethodHandler(
                consentFlowMethodHandler,
                mediationManagerMethodHandler,
                rootViewControllerProvider
            ) { casBridge in self.casBridge = casBridge },
            mediationManagerMethodHandler,
            TargetingOptionsMethodHandler(),
        ]

        methodHandlers.forEach { handler in
            handler.onAttachedToFlutter(registrar)
        }

        registrar.register(BannerViewFactory(registrar: registrar, bridgeProvider: bridgeProvider), withId: "<cas-banner-view>")
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
