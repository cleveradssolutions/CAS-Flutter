import 'package:clever_ads_solutions/clever_ads_solutions.dart';

@Deprecated(
    'Use setOnDismissCallback(OnConsentFlowDismissedCallback) instead. This listener always returns ConsentStatus.undefined.')
class OnDismissListener {
  /// This method will be invoked when the form is dismissed.
  final void Function(ConsentStatus status) _onConsentFlowDismissed;

  const OnDismissListener(
    Function(ConsentStatus status) onConsentFlowDismissed,
  ) : _onConsentFlowDismissed = onConsentFlowDismissed;

  void onConsentFlowDismissed(int status) {
    _onConsentFlowDismissed(ConsentStatus.undefined);
  }
}
