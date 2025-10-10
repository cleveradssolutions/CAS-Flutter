import 'internal_bridge.dart';
import 'mobile_ads.dart';

/// The callback type for when a user earns a reward.
/// Check [status] with [ConsentFlow] status constants.
typedef OnConsentFlowDismissedCallback = void Function(int status);

/// Use this object for configure Consent flow forms for GDPR.
class ConsentFlow {
  /// There was no attempt to show the consent flow.
  static const statusUnknown = 0;

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
  static const statusContextInvalid = 12;

  /// There was an error with another form is still being displayed.
  static const statusFlowStillShowing = 13;

  /// Create Consent Flow form to show.
  ConsentFlow.create({
    this.privacyPolicyUrl,
    this.debugGeography = PrivacyGeography.unknown,
    this.onDismissed,
  });

  /// The callback is called after the form is dismissed.
  /// If consent is not required, the callback is called immediately.
  /// The Integer Status with which the form is dismissed will be passed to the callback.
  OnConsentFlowDismissedCallback? onDismissed;

  /// (Optional) Override a link to the App's Privacy Policy in the consent form.
  String? privacyPolicyUrl;

  /// Sets the debug geography for testing purposes.
  ///
  /// **Attention**: Do not override [debugGeography] in production.
  ///
  /// Leave it set to [PrivacyGeography.unknown] to allow the system
  /// to determine the user's geography automatically.
  PrivacyGeography debugGeography;

  /// Shows the consent form only if it is required and the user has not responded previously.
  /// If the consent status is required, the SDK loads a form and immediately presents it.
  ///
  /// The [Future] will complete only after the dialog is dismissed,
  /// returning the result status as an `int`.
  /// Ensure you `await` the result to handle the outcome properly.
  Future<int> showIfRequired() {
    return casInternalBridge.showConsentFlow(this, false);
  }

  /// Force shows the form to modify user  consent at any time.
  ///
  /// When a user interacts with your UI element, call function to show the form
  /// so the user can update their privacy options at any time.
  ///
  /// The [Future] will complete only after the dialog is dismissed,
  /// returning the result status as an `int`.
  /// Ensure you `await` the result to handle the outcome properly.
  Future<int> show() {
    return casInternalBridge.showConsentFlow(this, true);
  }

  /// The callback is called after the form is dismissed.
  /// If consent is not required, the callback is called immediately.
  /// The Integer Status with which the form is dismissed will be passed to the callback.
  @Deprecated("Please set callback in create(onDismissed:) instead.")
  ConsentFlow setOnDismissCallback(OnConsentFlowDismissedCallback callback) {
    onDismissed = callback;
    return this;
  }

  /// Override a link to the App's Privacy Policy in the consent form.
  @Deprecated("Please set url in create(privacyPolicyUrl:) instead.")
  ConsentFlow withPrivacyPolicy(String? policyUrl) {
    privacyPolicyUrl = policyUrl;
    return this;
  }

  /// Internal property to support deprecated logic.
  @Deprecated(
      "Disable auto consent flow in CASMobileAds.initialize(showConsentFormIfRequired:) instead.")
  bool autoShowWithSDKInitializationEnabled = true;

  /// Disable auto display consent flow if required on Ads initialization.
  @Deprecated(
      "Disable auto consent flow in CASMobileAds.initialize(showConsentFormIfRequired:) instead.")
  ConsentFlow disableFlow() {
    autoShowWithSDKInitializationEnabled = false;
    return this;
  }

  @Deprecated(
      'Please set callback in ConsentFlow.create(onDismissed:) instead. This listener always returns ConsentStatus.undefined.')
  // ignore: public_member_api_docs
  ConsentFlow withDismissListener(OnDismissListener listener) {
    return setOnDismissCallback(listener.onConsentFlowDismissed);
  }
}

@Deprecated(
    'Please set callback in ConsentFlow.create(onDismissed:) instead. This listener always returns ConsentStatus.undefined.')
// ignore: public_member_api_docs
class OnDismissListener {
  /// This method will be invoked when the form is dismissed.
  final void Function(ConsentStatus status) _onConsentFlowDismissed;

  // ignore: public_member_api_docs
  const OnDismissListener(
    Function(ConsentStatus status) onConsentFlowDismissed,
  ) : _onConsentFlowDismissed = onConsentFlowDismissed;

  // ignore: public_member_api_docs
  void onConsentFlowDismissed(int status) {
    _onConsentFlowDismissed(ConsentStatus.undefined);
  }
}
