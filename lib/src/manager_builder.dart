// ignore_for_file: public_member_api_docs

// ignore_for_file: deprecated_member_use_from_same_package

// ignore_for_file: deprecated_member_use

// ignore_for_file: constant_identifier_names

import 'consent_flow.dart';
import 'mobile_ads.dart';
import 'internal_bridge.dart';
import 'ad_instances.dart';

part 'mediation_manager.dart';

MediationManager? _casInternalManager;

/// WARNING: This API is still supported but no longer recommended.
/// Migrate to new [CASMobileAds] implementation.
class AdTypeFlags {
  static const int none = 0;
  static const int banner = 1;
  static const int interstitial = 1 << 1;
  static const int rewarded = 1 << 2;
  static const int appOpen = 1 << 6;

  @Deprecated("Use AdTypeFlags.banner instead")
  static const int Banner = banner;
  @Deprecated("Use AdTypeFlags.interstitial instead")
  static const int Interstitial = interstitial;
  @Deprecated("Use AdTypeFlags.rewarded instead")
  static const int Rewarded = rewarded;
}

@Deprecated("Migrate to new CASMobileAds implementation.")
class InitConfig {
  final String? error;
  final String? countryCode;
  final bool isConsentRequired;
  final bool isTestMode;

  InitConfig(
    this.error,
    this.countryCode,
    this.isConsentRequired,
    this.isTestMode,
  );
}

/// This API is still supported but no longer recommended.
/// Migrate to new [CASMobileAds] implementation.
class ManagerBuilder {
  String _casId = "demo";
  int _adTypes = 0;
  Function(InitConfig config)? _onCompletion;
  ConsentFlow? _consentFlow;
  bool _isTestMode = false;
  final Map<String, String> _mediationExtras = {};

  ManagerBuilder();

  /// An CAS ID is a unique ID number assigned to each of your ad placements when they're created in CAS.
  /// - The CAS ID is added to your app's code and used to identify ad requests.
  /// Often the CAS ID is the same as the App Bundle ID, so you can use a constant:
  ///
  /// - If you haven't created an CAS account and registered an app yet, now's a great time to do so at [cleveradssolutions.com](https://cleveradssolutions.com).
  /// - In a real app, it is important that you use your actual CAS ID.
  ManagerBuilder withCasId(final String casId) {
    _casId = casId;
    return this;
  }

  /// Set listener to receive a callback after all CAS initialization processes have completed.
  ManagerBuilder withCompletionListener(Function(InitConfig config) listener) {
    _onCompletion = listener;
    return this;
  }

  /// Enable demo ad mode that will always request test ads.
  ///
  /// **Attention** Don't forget to set it to False after the tests are completed.
  ManagerBuilder withTestMode(final bool isEnabled) {
    _isTestMode = isEnabled;
    return this;
  }

  /// Using Ad types in current session.
  /// By default: All Ad types are used.
  /// Set [AdTypeFlags.none] to disable all ad types requests.
  ///
  /// Ad types can be enabled manually after initialize by [MediationManager.setEnabled]
  @Deprecated(
      "Use `ManagerBuilder.withAdTypes()` only if you continue to use `MediationManager` for ad requests. For the new `CASInterstitial` and `CASRewarded` implementations, you should skip this function call.")
  ManagerBuilder withAdTypes(final int adTypes) {
    _adTypes = adTypes;
    return this;
  }

  /// The userID is a unique identifier supplied by your application and must be static for each user across sessions.
  /// Your userID should not contain any personally identifiable information such as
  /// an email address, screen name, Android ID (AID), or Google Advertising ID (GAID).
  ManagerBuilder withUserId(final String userId) {
    CASMobileAds.targetingOptions.setUserId(userId);
    return this;
  }

  /// Create and attach the Consent flow configuration for initialization.
  /// ```
  /// .withConsentFlow(
  ///    ConsentFlow.create()
  ///       .withPrivacyPolicy("https://url_to_privacy_policy")
  /// )
  /// ```
  /// By default, the consent flow will be shown to users who are protected by laws.
  /// You can prevent us from showing the consent dialog to the user ussing followed lines:
  /// ```
  /// .withConsentFlow(ConsentFlow.create().disableFlow())
  /// ```
  ManagerBuilder withConsentFlow(ConsentFlow consentFlow) {
    _consentFlow = consentFlow;
    return this;
  }

  /// Additional mediation settings.
  ManagerBuilder withMediationExtras(String key, String value) {
    _mediationExtras[key] = value;
    return this;
  }

  @Deprecated("Use withMediationExtras(String key, String value) instead")
  ManagerBuilder addExtras(String key, String value) {
    withMediationExtras(key, value);
    return this;
  }

  /// Create new or get valid [MediationManager].
  /// Can be called for different identifiers to create different managers.
  MediationManager build() {
    return initialize();
  }

  /// Create new or get valid [MediationManager].
  /// Can be called for different identifiers to create different managers.
  MediationManager initialize() {
    Map<String, String>? mediationExtras;
    if (_mediationExtras.isNotEmpty) {
      mediationExtras = _mediationExtras;
    }

    casInternalBridge
        .initializeSDK(
      casId: _casId,
      showConsentFlow:
          _consentFlow?.autoShowWithSDKInitializationEnabled ?? true,
      forceTestAds: _isTestMode,
      mediationExtras: mediationExtras,
    )
        .then((status) {
      _casInternalManager?.setEnabled(_adTypes, true);

      _consentFlow?.onDismissed?.call(status.consentFlowStatus);

      _onCompletion?.call(InitConfig(status.error, status.countryCode,
          status.isPrivacyOptionsRequired, _isTestMode));
    });

    return _casInternalManager ??= MediationManager._(_casId, _isTestMode);
  }
}
