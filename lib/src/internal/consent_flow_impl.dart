import '../consent_flow.dart';
import '../on_dismiss_listener.dart';
import 'native_object.dart';

class ConsentFlowImpl extends NativeObject implements ConsentFlow {
  ConsentFlowImpl() : super('cleveradssolutions/consent_flow');

  @override
  ConsentFlow disableFlow() {
    channel.invokeMethod('disable');
    return this;
  }

  @override
  ConsentFlow withDismissListener(OnDismissListener listener) {
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'OnDismissListener':
          {
            listener.onConsentFlowDismissed(call.arguments);
            break;
          }
      }
    });
    return this;
  }

  @override
  ConsentFlow withPrivacyPolicy(String? privacyPolicy) {
    print("DevDebug: try to call withPrivacyPolicy from flutter");
    channel.invokeMethod('withPrivacyPolicy', {'url': privacyPolicy});
    return this;
  }

  @override
  Future<void> showIfRequired() {
    return channel.invokeMethod('show', {'force': false});
  }

  @override
  Future<void> show() {
    return channel.invokeMethod('show', {'force': true});
  }
}
