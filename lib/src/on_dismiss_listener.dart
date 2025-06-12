import 'package:clever_ads_solutions/clever_ads_solutions.dart';

class OnDismissListener {
  /// This method will be invoked when the form is dismissed.
  final void Function(ConsentStatus status) _onConsentFlowDismissed;

  const OnDismissListener(
    Function(ConsentStatus status) onConsentFlowDismissed,
  ) : _onConsentFlowDismissed = onConsentFlowDismissed;

  void onConsentFlowDismissed(int status) {
    final consentFlow = ConsentStatus.values[status];
    _onConsentFlowDismissed(consentFlow);
  }
}
