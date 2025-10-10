// ignore_for_file: public_member_api_docs

// ignore_for_file: deprecated_member_use_from_same_package

// ignore_for_file: deprecated_member_use

// ignore_for_file: constant_identifier_names

import 'mobile_ads.dart';
import 'internal_bridge.dart';

enum CCPAStatus { undefined, optOutSale, optInSale }

/// This API is still supported but no longer recommended.
/// Migrate to new [CASMobileAds] implementation.
class AdsSettings {
  /// Ad filters by Audience
  ///
  /// Default: [Audience.undefined]
  /// See [Audience]
  @Deprecated("Please set Audience in CASMobileAds.initialize(audience:)")
  Future<Audience> getTaggedAudience() async {
    final int? index =
        await casInternalBridge.channel.invokeMethod<int>('getTaggedAudience');
    return Audience.values[index ?? 0];
  }

  /// See [getTaggedAudience]
  @Deprecated("Please set Audience in CASMobileAds.initialize(audience:)")
  Future<void> setTaggedAudience(Audience audience) {
    return casInternalBridge.channel
        .invokeMethod("setTaggedAudience", audience.index);
  }

  /// GDPR User consent status of data collection.
  ///
  /// - Default: [ConsentStatus.undefined]
  /// See [ConsentStatus]
  Future<ConsentStatus> getUserConsent() async {
    final int? index =
        await casInternalBridge.channel.invokeMethod<int>("getUserConsent");
    return ConsentStatus.values[index ?? 0];
  }

  /// See [getUserConsent]
  Future<void> setUserConsent(ConsentStatus consent) {
    return casInternalBridge.channel
        .invokeMethod("setUserConsent", consent.index);
  }

  /// Parses the SharedPreferences string with key `IABTCF_VendorConsents`
  /// to determine the consent status of the IAB vendor with the provided ID.
  ///
  /// @param vendorId Vendor ID as defined in the Global Vendor List.
  /// @return [ConsentStatus.accepted] if the advertising entity has consent, [ConsentStatus.denied] if not, or [ConsentStatus.undefined] if VendorConsents is not available on disk.
  /// @see <a href="https://iabeurope.eu/vendor-list-tcf/">TCF Vendor List</a>
  Future<ConsentStatus> getVendorConsent(int vendorId) async {
    return casInternalBridge.getVendorConsent(vendorId);
  }

  /// Parses the SharedPreferences string with key `IABTCF_AddtlConsent`
  /// to determine the consent status of the advertising entity with the provided Ad Technology Provider (ATP) ID.
  ///
  /// @param providerId ATP ID of the advertising entity (e.g. 89 for Meta Audience Network).
  /// @return [ConsentStatus.accepted] if the advertising entity has consent, [ConsentStatus.denied] if not, or [ConsentStatus.undefined] if AddtlConsent is not available on disk.
  /// @see <a href="https://support.google.com/admanager/answer/9681920">Google’s Additional Consent Mode technical specification</a>
  /// @see <a href="https://storage.googleapis.com/tcfac/additional-consent-providers.csv">List of Google ATPs and their IDs</a>
  Future<ConsentStatus> getAdditionalConsent(int providerId) {
    return casInternalBridge.getAdditionalConsent(providerId);
  }

  /// Whether or not user has opted out of the sale of their personal information.
  ///
  /// Default: [CCPAStatus.undefined]
  /// See [CCPAStatus]
  Future<CCPAStatus> getCPPAStatus() async {
    final int? index =
        await casInternalBridge.channel.invokeMethod<int>('getCPPAStatus');
    return CCPAStatus.values[index ?? 0];
  }

  /// See [getCPPAStatus]
  Future<void> setCCPAStatus(CCPAStatus status) {
    return casInternalBridge.channel
        .invokeMethod("setCCPAStatus", status.index);
  }

  /// Indicates if the application’s audio is muted. Affects initial mute state for
  /// all ads. Use this method only if your application has its own volume controls
  /// (e.g., custom music or sound effect muting).
  ///
  /// Disabled by default.
  @Deprecated("Please use CASMobileAds.setAdSoundsMuted() instead.")
  Future<bool> getMutedAdSounds() {
    return Future.value(false);
  }

  /// See [getMutedAdSounds]
  @Deprecated("Please use CASMobileAds.setAdSoundsMuted() instead.")
  Future<void> setMutedAdSounds(bool muted) {
    return CASMobileAds.setAdSoundsMuted(muted);
  }

  /// The enabled Debug Mode will display a lot of useful information for debugging about the states of the sdk with tag CAS.
  /// Disabling Debug Mode may improve application performance.
  ///
  /// Disabled by default.
  @Deprecated("Please use CASMobileAds.setDebugLoggingEnabled() instead.")
  Future<bool> getDebugMode() {
    return Future.value(false);
  }

  /// See [getDebugMode]
  @Deprecated("Please use CASMobileAds.setDebugLoggingEnabled() instead.")
  Future<void> setDebugMode(bool isEnable) {
    return CASMobileAds.setDebugLoggingEnabled(isEnable);
  }

  /// Defines the time interval, in seconds, starting from the moment of the initial app installation,
  /// during which users can use the application without ads being displayed while still retaining
  /// access to the Rewarded Ads format.
  /// Within this interval, users enjoy privileged access to the application's features without intrusive advertisements.
  ///
  ///  - Default: 0 seconds
  /// - Units: Seconds
  @Deprecated(
      "Please set interval in CASMobileAds.initialize(trialAdFreeInterval:).")
  Future<int> getTrialAdFreeInterval() {
    return Future.value(0);
  }

  /// See [getTrialAdFreeInterval]
  @Deprecated(
      "Please set interval in CASMobileAds.initialize(trialAdFreeInterval:).")
  Future<void> setTrialAdFreeInterval(int interval) {
    return CASMobileAds.setTrialAdFreeInterval(interval);
  }

  /// Set the number of seconds an ad is displayed before a new ad is shown.
  /// After the interval has passed, a new advertisement will be automatically loaded.
  /// - [CASBannerView._refreshInterval] will override this value for a specific view.
  ///
  /// - Default: 30 seconds
  /// - Min: 5 seconds
  /// - Units: Seconds
  @Deprecated(
      "Please set refreshInterval for each CASBanner.createAndLoad(refreshInterval:).")
  Future<int> getBannerRefreshInterval() {
    return Future.value(casInternalBridge.defaultBannerRefreshInterval);
  }

  /// See [getBannerRefreshInterval]
  @Deprecated(
      "Please set refreshInterval for each CASBanner.createAndLoad(refreshInterval:).")
  Future<void> setBannerRefreshInterval(int interval) {
    casInternalBridge.defaultBannerRefreshInterval = interval;
    return Future.value();
  }

  /// The interval between impressions Interstitial Ad in seconds.
  ///
  /// - Default: 0 seconds
  /// - Units: Seconds
  @Deprecated(
      "Please set interval for each CASInterstitial.createAndLoad(minInterval:).")
  Future<int> getInterstitialInterval() {
    return Future.value(casInternalBridge.defaultInterstitialMinInterval);
  }

  /// See [getInterstitialInterval]
  @Deprecated(
      "Please set interval for each CASInterstitial.createAndLoad(minInterval:).")
  Future<void> setInterstitialInterval(int interval) {
    casInternalBridge.defaultInterstitialMinInterval = interval;
    return Future.value();
  }

  /// Restart interval until next Interstitial ad display.
  ///
  /// - By default, the interval before first Interstitial Ad impression is ignored.
  /// - You can use this method to delay displaying ad.
  Future<void> restartInterstitialInterval() {
    return casInternalBridge.restartInterstitialAdInterval();
  }

  /// Mediation waterfall loading mode.
  Future<LoadingMode> getLoadingMode() {
    return Future.value(casInternalBridge.deprecatedManualLoadUsed
        ? LoadingMode.Manual
        : LoadingMode.Optimal);
  }

  /// See [getLoadingMode]
  Future<void> setLoadingMode(LoadingMode loadingMode) {
    casInternalBridge.deprecatedManualLoadUsed =
        loadingMode == LoadingMode.Manual;
    return Future.value();
  }
}

@Deprecated(
    "Please migrate to the new implementation of ad classes, which will allow you to fully manage the ad lifecycle.")
enum LoadingMode {
  FastestRequests,
  FastRequests,
  Optimal,
  HighPerformance,
  HighestPerformance,
  Manual
}
