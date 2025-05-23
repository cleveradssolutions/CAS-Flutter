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
  ConsentFlow withDismissListener(OnDismissListener listener) {
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onDismiss':
          {
            final int? index = call.arguments['status'];
            // final consentFlow = index == null
            //     ? ConsentStatus.undefined
            //     : ConsentStatus.values[index];
            listener.onConsentFlowDismissed(index ?? 0);
            break;
          }
      }
    });
    return this;
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
