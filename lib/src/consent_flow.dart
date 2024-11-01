import 'on_dismiss_listener.dart';

/// Use this object for configure Consent flow forms for GDPR.
abstract class ConsentFlow {
  /// User consent obtained. Personalized vs non-personalized undefined.
  static const statusObtained = 3;

  /// User consent not required.
  static const statusNotRequired = 4;

  /// User consent unavailable.
  static const statusUnavailable = 5;

  /// There was an internal error.
  static const statusInternalError = 10;

  /// There was an error loading data from the network.
  static const statusNetworkError = 11;

  /// There was an error with the UI context is passed in.
  /// - Activity is null.
  /// - Activity with null windows.
  /// - Activity is destroyed.
  static const statusContextInvalid = 12;

  /// There was an error with another form is still being displayed.
  static const statusFlowStillShowing = 13;

  /// Disable auto display consent flow if required on Ads initialization.
  ConsentFlow disableFlow();

  /// The listener is called after the form is dismissed.
  /// If consent is not required, the listener is called immediately.
  /// The [Status] with which the form is dismissed will be passed to the listener function.
  ConsentFlow withDismissListener(OnDismissListener listener);

  /// Override a link to the App's Privacy Policy in the consent form.
  ConsentFlow withPrivacyPolicy(String? privacyPolicy);

  /// Shows the consent form only if it is required and the user has not responded previously.
  /// If the consent status is required, the SDK loads a form and immediately presents it.
  Future<void> showIfRequired();

  /// Force shows the form to modify user  consent at any time.
  ///
  /// When a user interacts with your UI element, call function to show the form
  /// so the user can update their privacy options at any time.
  Future<void> show();
}
