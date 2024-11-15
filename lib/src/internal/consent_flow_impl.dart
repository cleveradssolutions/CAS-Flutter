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
    channel.invokeMethod('withPrivacyPolicy', {'url': privacyPolicy});
    return this;
  }

  @override
  void showIfRequired() {
    channel.invokeMethod('show', {'force': false});
  }

  @override
  void show() {
    channel.invokeMethod('show', {'force': true});
  }
}
