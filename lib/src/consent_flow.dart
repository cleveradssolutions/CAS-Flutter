import 'package:flutter/services.dart';

/// Use this object for configure Consent flow forms for GDPR.
/// [isEnabled] - Is enabled auto display consent flow if required on Ads initialization.
///
/// Create and attach the object to CAS initialization.
/// ```
/// CAS.buildManager()
///    .withConsentFlow(
///       ConsentFlow()
///          .withPrivacyPolicy("https://url_to_privacy_policy")
///    )
///    .build()
/// ```
/// By default, the consent flow will be shown to users who are protected by laws.
/// You can prevent us from showing the consent form to the user using followed lines:
/// ```
/// CAS.buildManager()
///    .withConsentFlow(ConsentFlow(isEnabled = false))
///    .build()
/// ```
/// You can also display Consent Flow at any time using the show functions:
/// ```
/// ConsentFlow()
///    .withDismissListener(onConsentFlowDismiss)
///    .showIfRequired()
/// ```
class ConsentFlow {
  static const MethodChannel _channel =
      MethodChannel("com.cleveradssolutions.plugin.flutter/consent_flow");

  @Deprecated("Use ConsentFlow.privacyPolicyUrl instead")
  String privacyPolicy = "";
  @Deprecated("Use ConsentFlow.isEnabled instead")
  bool isEnable = true;

  bool isEnabled;
  String? privacyPolicyUrl;
  OnDismissListener? dismissListener;
  DebugGeography debugGeography = DebugGeography.eea;
  bool forceTesting = false;

  ConsentFlow({this.isEnabled = true});

  /// Override a link to the App's Privacy Policy in the consent form.
  ConsentFlow withPrivacyPolicy(String? url) {
    privacyPolicyUrl = url;
    return this;
  }

  /// The listener is called after the form is dismissed.
  /// If consent is not required, the listener is called immediately.
  /// The [Status] with which the form is dismissed will be passed to the listener function.
  ConsentFlow withDismissListener(void Function(Status status)? listener) {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "OnDismissListener") {
        int value = call.arguments["status"];
        Status status = Status.fromValue(value);
        listener?.call(status);
      }
    });
    return this;
  }

  /// Sets the debug geography for testing purposes.
  /// Note that debug settings only work [withForceTesting] enabled.
  ///
  /// Default value is [DebugGeography.EEA]
  ConsentFlow withDebugGeography(DebugGeography debugGeography) {
    this.debugGeography = debugGeography;
    return this;
  }

  /// Force testing flow respect debug geography settings to enable easier testing.
  ///
  /// Testing enabled for [AdsSettings.testDeviceIDs]
  /// or for auto flow on initialization if [CAS.ManagerBuilder.withTestAdMode] enabled.
  ///
  /// **Attention** Don't forget to set it to False after the tests are completed.
  ///
  /// Disabled by default.
  ConsentFlow withForceTesting(bool forceTesting) {
    this.forceTesting = forceTesting;
    return this;
  }

  /// Shows the consent form only if it is required and the user has not responded previously.
  /// If the consent status is required, the SDK loads a form and immediately presents it.
  void showIfRequired() {
    _show(false);
  }

  /// Force shows the form to modify user  consent at any time.
  ///
  /// When a user interacts with your UI element, call function to show the form
  /// so the user can update their privacy options at any time.6
  void show() {
    _show(true);
  }

  void _show(bool force) {
    if (!isEnabled || !isEnable) {
      _channel.invokeMethod('disableConsentFlow');
    } else {
      if (privacyPolicy.isNotEmpty) {
        _channel.invokeMethod('withPrivacyPolicy', {'url': privacyPolicy});
      }
      if (privacyPolicyUrl != null) {
        _channel.invokeMethod('withPrivacyPolicy', {'url': privacyPolicyUrl});
      }

      _channel.invokeMethod('showConsentFlow');
    }
  }
}

typedef OnDismissListener = void Function(Status status);

class Status {
  final int value;

  const Status._(this.value);

  /// User consent obtained. Personalized vs non-personalized undefined.
  static const Status obtained = Status._(3);

  /// User consent not required.
  static const Status notRequired = Status._(4);

  /// User consent unavailable.
  static const Status unavailable = Status._(5);

  /// There was an internal error.
  static const Status internalError = Status._(10);

  /// There was an error loading data from the network.
  static const Status networkError = Status._(11);

  /// There was an error with the UI context is passed in.
  /// - Activity is null.
  /// - Activity with null windows.
  /// - Activity is destroyed.
  static const Status contextInvalid = Status._(12);

  /// There was an error with another form is still being displayed.
  static const Status flowStillShowing = Status._(13);

  static const List<Status> values = [
    obtained,
    notRequired,
    unavailable,
    internalError,
    networkError,
    contextInvalid,
    flowStillShowing
  ];

  static Status fromValue(int value) {
    for (Status status in values) {
      if (status.value == value) {
        return status;
      }
    }
    return Status.internalError;
  }
}

enum DebugGeography {
  /// Debug geography disabled.
  disabled,

  /// Geography appears as in European Economic Area.
  eea,

  /// Geography appears as not in European Economic Area.
  notEea
}
