import 'targeting_options.dart';
import 'consent_flow.dart';
import 'internal_bridge.dart';

/// Represents the CAS.AI SDK.
class CASMobileAds {
  CASMobileAds._();

  /// You can now easily tailor the way you serve your ads to fit a specific audience!
  ///
  /// You’ll need to inform our servers of the users’ details so the SDK will
  /// know to serve ads according to the segment the user belongs to.
  ///
  /// Note: Must be set before initializing the SDK.
  static final TargetingOptions targetingOptions = TargetingOptions();

  /// Initializes the CAS Mobile Ads SDK.
  ///
  /// Call this method as early as possible after the app launches to reduce
  /// latency on the session's first ad load.
  ///
  /// If this method is not called, the first ad load automatically
  /// initializes the CAS Mobile Ads SDK with CAS Id defined in ad load arguments.
  ///
  /// **Note:** This [Future] may take an unexpectedly long time to complete,
  /// as it will only resolve once the SDK has either successfully initialized
  /// or failed with a error.
  ///
  /// If an error occurs, the SDK will attempt automatic reinitialization internally.
  /// However, this [Future] will not be updated with subsequent [InitializationStatus].
  /// For the most up-to-date [InitializationStatus], call this method again at a later time.
  ///
  /// #### [casId]
  /// The unique identifier for the CAS content registered for your app on each platform.
  /// You can use the value demo to force test ads mode on all devices if you haven't registered a casId yet.
  ///
  /// #### [targetAudience]
  /// Indicates the target [Audience] of the app for regulatory and content purposes.
  /// This may affect how the SDK handles data collection, personalization,
  /// and content rendering, especially for audiences such as children.
  ///
  /// #### [showConsentFormIfRequired]
  /// Shows the consent form only if it is required and the user has not responded previously.
  /// If the consent status is required, the SDK loads a form and immediately presents it.
  ///
  /// #### [forceTestAds]
  /// Enable test ads mode that will always return test ads for all devices.
  /// **Attention** Don't forget to set it to False after the tests are completed.
  ///
  /// #### [testDeviceIds]
  /// Add a test device ID corresponding to test devices which will always request test ads.
  /// List of test devices should be defined before first MediationManager initialized.
  ///
  /// 1. Run an app with the CAS SDK initialize() call.
  /// 2. Check the console or logcat output for a message that looks like this:
  /// "To get test ads on this device, set ... "
  /// 3. Copy your alphanumeric test device ID to your clipboard.
  /// 4. Add the test device ID to the [testDeviceIds] list.
  ///
  /// #### [debugPrivacyGeography]
  /// Sets the debug geography for testing purposes.
  ///
  /// This setting only works during test sessions enabled via
  /// [forceTestAds] or [testDeviceIds].
  ///
  /// #### [mediationExtras]
  /// Additional mediation settings.
  static Future<InitializationStatus> initialize({
    required String casId,
    Audience targetAudience = Audience.undefined,
    bool showConsentFormIfRequired = true,
    bool forceTestAds = false,
    List<String>? testDeviceIds,
    PrivacyGeography debugPrivacyGeography =
        PrivacyGeography.europeanEconomicArea,
    Map<String, String>? mediationExtras,
  }) {
    return casInternalBridge.initializeSDK(
      casId: casId,
      targetAudience: targetAudience.index,
      showConsentFlow: showConsentFormIfRequired,
      forceTestAds: forceTestAds,
      testDeviceIds: testDeviceIds,
      debugGeography: debugPrivacyGeography,
      mediationExtras: mediationExtras,
    );
  }

  /// Gets the version string of CAS Mobile Ads SDK.
  static Future<String> getSDKVersion() {
    return casInternalBridge.getSDKVersion();
  }

  /// Sets whether the ad sourced is muted.
  ///
  /// Affects initial mute state for fullscreen ads.
  /// Use this method only if your application has its own volume controls
  /// (e.g., custom music or sound effect muting).
  ///
  /// Not muted by default.
  static Future<void> setAdSoundsMuted(bool muted) {
    return casInternalBridge.setAdSoundsMuted(muted);
  }

  /// Enables or disables debug logging to the console.
  ///
  /// When set to `true`, the SDK will output detailed debug information
  /// to the console, which can be useful during development and troubleshooting.
  static Future<void> setDebugLoggingEnabled(bool enabled) {
    return casInternalBridge.setDebugLoggingEnabled(enabled);
  }

  /// Defines the time interval, in seconds, starting from the moment of the initial app installation,
  /// during which users can use the application without ads being displayed while still retaining
  /// access to the Rewarded Ads format.
  /// Within this interval, users enjoy privileged access to the application's features without intrusive advertisements.
  ///
  /// - Default: 0 seconds
  /// - Units: Seconds
  static Future<void> setTrialAdFreeInterval(int interval) {
    return casInternalBridge.setTrialAdFreeInterval(interval);
  }
}

/// The status of the SDK initialization.
class InitializationStatus {
  /// Indicates that device network connection is not stable enough.
  ///
  /// For the most up-to-date [InitializationStatus],
  /// call [CASMobileAds.initialize] method again at a later time.
  static const errorNoConnection = "Connection failed";

  /// Indicates that the CAS ID is not registered in system.
  /// Contact support to clarify the reasons.
  static const errorNotRegisteredId = "Not registered ID";

  /// Indicates that the SDK version is no longer compatible.
  /// Please update to the latest SDK.
  static const errorVerification = "Verification failed";

  /// Indicates a temporary problem with the server.
  /// If the error could be 100% replicated, please give feedback to us.
  static const errorServer = "Server error";

  /// Initialization error or null if success.
  /// Check [error] with [InitializationStatus] error constants.
  final String? error;

  /// User Country code ISO 2 or null if not allowed.
  final String? countryCode;

  /// Indicates the privacy options button is required.
  final bool isPrivacyOptionsRequired;

  /// Consent flow status code. Check constant codes from [ConsentFlow] class.
  final int consentFlowStatus;

  /// Default constructor to create an [InitializationStatus].
  ///
  /// Returned when calling [CASMobileAds.initialize];
  InitializationStatus({
    required this.error,
    required this.countryCode,
    required this.isPrivacyOptionsRequired,
    required this.consentFlowStatus,
  });
}

/// Prohibition on Personal Information from Children
enum Audience {
  /// If your app's target age groups include both children and older audiences, any ads that may be shown to children must comply with Google Play's Families Ads Program.
  ///
  /// A neutral age screen must be implemented so that any ads not suitable for children are only shown to older audiences.
  /// A neutral age screen is a mechanism to verify a user's age in a way that doesn't encourage them to falsify their age
  /// and gain access to areas of your app that aren't designed for children, for example, an age gate.
  undefined,

  /// Compliance with all applicable legal regulations and industry standards relating to advertising to children.
  children,

  /// Audiences over the age of 13 NOT subject to the restrictions of child protection laws.
  notChildren
}

/// User consent status
enum ConsentStatus {
  /// Mediation ads network behavior
  undefined,

  /// User consents to behavioral targeting in compliance with GDPR.
  accepted,

  /// User does not consent to behavioral targeting in compliance with GDPR.
  denied
}

/// User's geography for determining consent flow.
enum PrivacyGeography {
  /// Geography is unknown.
  unknown(0),

  /// Geography appears as in European Economic Area.
  europeanEconomicArea(1),

  /// Geography appears as in a regulated US State.
  regulatedUSState(3),

  /// Geography appears as in a region with no regulation in force.
  unregulated(4);

  /// Value for native SDK.
  final int value;

  /// Constructor
  const PrivacyGeography(this.value);
}
