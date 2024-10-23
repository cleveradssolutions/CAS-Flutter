import 'on_dismiss_listener.dart';

/// Use this object for configure Consent flow forms for GDPR.
abstract class ConsentFlow {
  String? privacyPolicy;
  bool isEnable = true;

  ConsentFlow disableFlow();

  /// The listener is called after the form is dismissed.
  /// If consent is not required, the listener is called immediately.
  /// The [Status] with which the form is dismissed will be passed to the listener function.
  ConsentFlow withDismissListener(OnDismissListener listener);

  /// Override a link to the App's Privacy Policy in the consent form.
  ConsentFlow withPrivacyPolicy(String? privacyPolicy);

  Future<void> show();
}
