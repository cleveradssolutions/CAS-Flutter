import '../consent_flow.dart';
import '../on_dismiss_listener.dart';
import 'mapped_object.dart';

class ConsentFlowImpl extends MappedObject implements ConsentFlow {
  ConsentFlowImpl() : super('cleveradssolutions/consent_flow');

  @override
  ConsentFlow disableFlow() {
    invokeMethod('disable');
    return this;
  }

  @override
  ConsentFlow setOnDismissCallback(OnConsentFlowDismissedCallback callback) {
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onDismiss':
          {
            final int? index = call.arguments['status'];
            callback.call(index ?? 0);
            break;
          }
      }
    });
    return this;
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  ConsentFlow withDismissListener(OnDismissListener listener) {
    return setOnDismissCallback(listener.onConsentFlowDismissed);
  }

  @override
  ConsentFlow withPrivacyPolicy(String? privacyPolicy) {
    invokeMethod('withPrivacyPolicy', {'url': privacyPolicy});
    return this;
  }

  @override
  Future<void> showIfRequired() {
    return invokeMethod('show', {'force': false});
  }

  @override
  Future<void> show() {
    return invokeMethod('show', {'force': true});
  }
}
