import CleverAdsSolutions
import Flutter

public class CASFlutter: NSObject, FlutterPlugin {
    private var methodHandlers: [MethodHandler] = []

    private var casBridge: CASBridge?

    init(with registrar: FlutterPluginRegistrar) {
        super.init()
        let bridgeProvider: () -> CASBridge? = { self.casBridge }
        let consentFlowMethodHandler = ConsentFlowMethodHandler(with: registrar)
        let mediationManagerMethodHandler = MediationManagerMethodHandler(with: registrar, bridgeProvider)

        methodHandlers = [
            AdSizeMethodHandler(with: registrar),
            AdsSettingsMethodHandler(with: registrar),
            CASMethodHandler(with: registrar),
            consentFlowMethodHandler,
            ManagerBuilderMethodHandler(
                with: registrar,
                consentFlowMethodHandler,
                mediationManagerMethodHandler
            ) { casBridge in self.casBridge = casBridge },
            mediationManagerMethodHandler,
            TargetingOptionsMethodHandler(with: registrar)
        ]

        registrar.register(BannerViewFactory(with: registrar, bridgeProvider: bridgeProvider), withId: "<cas-banner-view>")
    }

    public static func register(with registrar: any FlutterPluginRegistrar) {
        let instance = CASFlutter(with: registrar)
        registrar.publish(instance)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        methodHandlers = []
    }
}
