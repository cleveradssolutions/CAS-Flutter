import CleverAdsSolutions
import Flutter

public class CASFlutter: NSObject, FlutterPlugin {
    private var methodHandlers: [MethodHandler] = []

    init(with registrar: FlutterPluginRegistrar) {
        let consentFlowFactory = ConsentFlowMethodHandler.Factory(with: registrar)
        let mediationManagerMethodHandler = MediationManagerMethodHandler(with: registrar)

        methodHandlers = [
            AdSizeMethodHandler(with: registrar),
            AdsSettingsMethodHandler(with: registrar),
            CASMethodHandler(with: registrar),
            consentFlowFactory,
            ManagerBuilderMethodHandler(
                with: registrar,
                consentFlowFactory,
                mediationManagerMethodHandler
            ),
            mediationManagerMethodHandler,
            TargetingOptionsMethodHandler(with: registrar)
        ]

        registrar.register(BannerViewFactory(with: registrar, managerHandler: mediationManagerMethodHandler), withId: "<cas-banner-view>")
    }

    public static func register(with registrar: any FlutterPluginRegistrar) {
        let instance = CASFlutter(with: registrar)
        registrar.publish(instance)
    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        methodHandlers = []
    }
}
