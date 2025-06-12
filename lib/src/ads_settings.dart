import 'package:clever_ads_solutions/src/loading_mode.dart';

import 'audience.dart';
import 'ccpa_status.dart';
import 'consent_status.dart';

abstract class AdsSettings {
  /// Ad filters by Audience
  ///
  /// Default: [Audience.undefined]
  /// See [Audience]
  Future<Audience> getTaggedAudience();

  /// See [getTaggedAudience]
  Future<void> setTaggedAudience(Audience audience);

  /// GDPR User consent status of data collection.
  ///
  /// - Default: [ConsentStatus.undefined]
  /// See [ConsentStatus]
  Future<ConsentStatus> getUserConsent();

  /// See [getUserConsent]
  Future<void> setUserConsent(ConsentStatus consent);

  /// Parses the [SharedPreferences] string with key `IABTCF_VendorConsents`
  /// to determine the consent status of the IAB vendor with the provided ID.
  ///
  /// @param vendorId Vendor ID as defined in the Global Vendor List.
  /// @return [ConsentStatus.accepted] if the advertising entity has consent, [ConsentStatus.denied] if not, or [ConsentStatus.undefined] if VendorConsents is not available on disk.
  /// @see <a href="https://iabeurope.eu/vendor-list-tcf/">TCF Vendor List</a>
  Future<ConsentStatus> getVendorConsent(int vendorId);

  /// Parses the [SharedPreferences] string with key `IABTCF_AddtlConsent`
  /// to determine the consent status of the advertising entity with the provided Ad Technology Provider (ATP) ID.
  ///
  /// @param providerId ATP ID of the advertising entity (e.g. 89 for Meta Audience Network).
  /// @return [ConsentStatus.accepted] if the advertising entity has consent, [ConsentStatus.denied] if not, or [ConsentStatus.undefined] if AddtlConsent is not available on disk.
  /// @see <a href="https://support.google.com/admanager/answer/9681920">Google’s Additional Consent Mode technical specification</a>
  /// @see <a href="https://storage.googleapis.com/tcfac/additional-consent-providers.csv">List of Google ATPs and their IDs</a>
  Future<ConsentStatus> getAdditionalConsent(int providerId);

  /// Whether or not user has opted out of the sale of their personal information.
  ///
  /// Default: [CCPAStatus.undefined]
  /// See [CCPAStatus]
  Future<CCPAStatus> getCPPAStatus();

  /// See [getCPPAStatus]
  Future<void> setCCPAStatus(CCPAStatus status);

  /// Indicates if the application’s audio is muted. Affects initial mute state for
  /// all ads. Use this method only if your application has its own volume controls
  /// (e.g., custom music or sound effect muting).
  ///
  /// Disabled by default.
  Future<bool> getMutedAdSounds();

  /// See [getMutedAdSounds]
  Future<void> setMutedAdSounds(bool muted);

  /// The enabled Debug Mode will display a lot of useful information for debugging about the states of the sdk with tag CAS.
  /// Disabling Debug Mode may improve application performance.
  ///
  /// Disabled by default.
  Future<bool> getDebugMode();

  /// See [getDebugMode]
  Future<void> setDebugMode(bool isEnable);

  @Deprecated("This method is no longer maintained and should not be used.")
  Future<void> addTestDeviceId(String deviceId);

  /// Add a test device ID corresponding to test devices which will always request test ads.
  /// List of test devices should be defined before first MediationManager initialized.
  ///
  /// 1. Run an app configured with the CAS SDK.
  /// 2. Check the console or logcat output for a message that looks like this:
  /// "To get test ads on this device, set ... "
  /// 3. Copy your alphanumeric test device ID to your clipboard.
  /// 4. Add the test device ID to the list before call initialize MediationManager.
  Future<void> setTestDeviceId(String deviceId);

  /// See [setTestDeviceId]
  Future<void> setTestDeviceIds(Set<String> deviceIds);

  /// Defines the time interval, in seconds, starting from the moment of the initial app installation,
  /// during which users can use the application without ads being displayed while still retaining
  /// access to the Rewarded Ads format.
  /// Within this interval, users enjoy privileged access to the application's features without intrusive advertisements.
  ///
  ///  - Default: 0 seconds
  /// - Units: Seconds
  Future<int> getTrialAdFreeInterval();

  /// See [getTrialAdFreeInterval]
  Future<void> setTrialAdFreeInterval(int interval);

  /// Set the number of seconds an ad is displayed before a new ad is shown.
  /// After the interval has passed, a new advertisement will be automatically loaded.
  /// - [CASBannerView._refreshInterval] will override this value for a specific view.
  ///
  /// - Default: 30 seconds
  /// - Min: 5 seconds
  /// - Units: Seconds
  Future<int> getBannerRefreshInterval();

  /// See [getBannerRefreshInterval]
  Future<void> setBannerRefreshInterval(int interval);

  /// The interval between impressions Interstitial Ad in seconds.
  ///
  /// - Default: 0 seconds
  /// - Units: Seconds
  Future<int> getInterstitialInterval();

  /// See [getInterstitialInterval]
  Future<void> setInterstitialInterval(int interval);

  /// Restart interval until next Interstitial ad display.
  ///
  /// - By default, the interval before first Interstitial Ad impression is ignored.
  /// - You can use this method to delay displaying ad.
  Future<void> restartInterstitialInterval();

  /// This option will compare ad cost and serve regular interstitial ads
  /// when rewarded video ads are expected to generate less revenue.
  /// Interstitial Ads does not require to watch the video to the end,
  /// but the [AdCallback.onComplete] callback will be triggered in any case.
  ///
  /// Enabled by default.
  Future<bool> isAllowInterstitialAdsWhenVideoCostAreLower();

  /// See [isAllowInterstitialAdsWhenVideoCostAreLower]
  Future<void> allowInterstitialAdsWhenVideoCostAreLower(bool isAllow);

  /// Mediation waterfall loading mode.
  ///
  /// Default: [LoadingMode.Optimal]
  /// See [LoadingMode]
  Future<LoadingMode> getLoadingMode();

  /// See [getLoadingMode]
  Future<void> setLoadingMode(LoadingMode loadingMode);
}
