import 'consent_flow.dart';
import 'init_config.dart';
import 'initialization_listener.dart';
import 'mediation_manager.dart';

abstract class ManagerBuilder {
  /// An CAS ID is a unique ID number assigned to each of your ad placements when they're created in CAS.
  /// - The CAS ID is added to your app's code and used to identify ad requests.
  /// Often the CAS ID is the same as the App Bundle ID, so you can use a constant:
  /// ```
  /// .withCasId(BuildConfig.APPLICATION_ID)
  /// ```
  /// - If you haven't created an CAS account and registered an app yet, now's a great time to do so at [cleveradssolutions.com](https://cleveradssolutions.com).
  /// - In a real app, it is important that you use your actual CAS ID.
  ManagerBuilder withCasId(final String casId);

  /// Set listener to receive a callback after all CAS initialization processes have completed.
  ManagerBuilder withCompletionListener(Function(InitConfig config) listener);

  /// Enable demo ad mode that will always request test ads.
  ///
  /// **Attention** Don't forget to set it to False after the tests are completed.
  ManagerBuilder withTestMode(final bool isEnabled);

  /// Using Ad types in current session.
  /// By default: All Ad types are used.
  /// Set [AdType.None] to disable all ad types requests.
  ///
  /// Ad types can be enabled manually after initialize by [MediationManager.setEnabled]
  @Deprecated("This method is no longer maintained and should not be used.")
  ManagerBuilder withAdTypes(final int adTypes);

  /// The userID is a unique identifier supplied by your application and must be static for each user across sessions.
  /// Your userID should not contain any personally identifiable information such as
  /// an email address, screen name, Android ID (AID), or Google Advertising ID (GAID).
  ManagerBuilder withUserId(final String userId);

  /// Create and attach the Consent flow configuration for initialization.
  /// ```
  /// .withConsentFlow(
  ///    ConsentFlow()
  ///       .withPrivacyPolicy("https://url_to_privacy_policy")
  /// )
  /// ```
  /// By default, the consent flow will be shown to users who are protected by laws.
  /// You can prevent us from showing the consent dialog to the user ussing followed lines:
  /// ```
  /// .withConsentFlow(ConsentFlow(isEnabled = false))
  /// ```
  ManagerBuilder withConsentFlow(ConsentFlow consentFlow);

  /// Additional mediation settings.
  ///
  /// @param key Use constant key from [AdNetwork]
  ManagerBuilder withMediationExtras(String key, String value);

  @Deprecated("Use withMediationExtras(String key, String value) instead")
  ManagerBuilder addExtras(String key, String value) {
    withMediationExtras(key, value);
    return this;
  }

  @Deprecated(
      "Use withCompletionListener(Function(InitConfig config) onCASInitialized) instead")
  ManagerBuilder withInitializationListener(InitializationListener listener) {
    withCompletionListener(listener.onCASInitialized);
    return this;
  }

  /// Create new or get valid [MediationManager].
  /// Can be called for different identifiers to create different managers.
  MediationManager build();

  /// Create new or get valid [MediationManager].
  /// Can be called for different identifiers to create different managers.
  MediationManager initialize();
}
