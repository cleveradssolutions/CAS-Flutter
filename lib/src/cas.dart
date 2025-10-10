// ignore_for_file: public_member_api_docs

import 'internal_bridge.dart';
import 'mobile_ads.dart';
import 'ads_settings.dart';
import 'consent_flow.dart';
import 'manager_builder.dart';
import 'targeting_options.dart';

/// WARNING: This API is still supported but no longer recommended.
/// Migrate to new [CASMobileAds] implementation.
class CAS {
  /// Get singleton instance for configure all mediation managers
  static final AdsSettings settings = AdsSettings();

  /// You can now easily tailor the way you serve your ads to fit a specific audience!
  /// You’ll need to inform our servers of the users’ details
  /// so the SDK will know to serve ads according to the segment the user belongs to.
  @Deprecated("Replaced to CASMobileAds.targetingOptions")
  static TargetingOptions get targetingOptions {
    return CASMobileAds.targetingOptions;
  }

  /// Create [ConsentFlow].
  @Deprecated("Use ConsentFlow.create() instead")
  static ConsentFlow buildConsentFlow() {
    return ConsentFlow.create();
  }

  /// Create [MediationManager] builder.
  /// Don't forget to call the [ManagerBuilder.build] method to create manager instance.
  @Deprecated("Please use new CASMobileAds.initialize() function.")
  static ManagerBuilder buildManager() {
    return ManagerBuilder();
  }

  @Deprecated("Replaced to CASMobileAds.getSDKVersion()")
  static Future<String> getSDKVersion() {
    return CASMobileAds.getSDKVersion();
  }

  /// Call Integration Helper and check current integration in logcat(Android) or console(iOS).
  /// LOG TAG: CASIntegrationHelper
  ///
  /// Call Integration Helper and check current integration in console.
  /// Log tag: [CASIntegrationHelper]
  static Future<void> validateIntegration() {
    return casInternalBridge.validateIntegration();
  }

  @Deprecated("Use CASMobileAds.setDebugLoggingEnabled() instead")
  static Future<void> setDebugMode(bool isEnable) {
    return CASMobileAds.setDebugLoggingEnabled(isEnable);
  }

  @Deprecated("Use CASMobileAds.targetingOptions.setAge(int age) instead")
  static Future<void> setAge(int age) {
    return CAS.targetingOptions.setAge(age);
  }

  @Deprecated(
      "Use CASMobileAds.targetingOptions.setGender(Gender gender) instead")
  static Future<void> setGender(Gender gender) {
    return CAS.targetingOptions.setGender(gender);
  }

  @Deprecated("Use CAS.settings.setCCPAStatus(CCPAStatus status) instead")
  static Future<void> setCCPAStatus(CCPAStatus status) {
    return CAS.settings.setCCPAStatus(status);
  }

  @Deprecated("Use CAS.settings.getCCPAStatus() instead")
  static Future<CCPAStatus> getCPPAStatus() {
    return CAS.settings.getCPPAStatus();
  }

  @Deprecated("Please set Audience in CASMobileAds.initialize(audience:)")
  static Future<void> setTaggedAudience(Audience audience) {
    return CAS.settings.setTaggedAudience(audience);
  }

  @Deprecated("Please set Audience in CASMobileAds.initialize(audience:)")
  static Future<Audience> getTaggedAudience() {
    return CAS.settings.getTaggedAudience();
  }

  @Deprecated("Please use CASMobileAds.setAdSoundsMuted() instead.")
  static Future<void> setMutedAdSounds(bool mute) {
    return CASMobileAds.setAdSoundsMuted(mute);
  }

  @Deprecated(
      "Use CAS.settings.setLoadingMode(LoadingMode loadingMode) instead")
  static Future<void> setLoadingMode(LoadingMode loadingMode) {
    return CAS.settings.setLoadingMode(loadingMode);
  }

  @Deprecated(
      "Please set interval for each CASInterstitial.createAndLoad(minInterval:).")
  static Future<void> setInterstitialInterval(int delay) {
    return CAS.settings.setInterstitialInterval(delay);
  }

  @Deprecated(
      "Please set interval for each CASInterstitial.createAndLoad(minInterval:).")
  static Future<int> getInterstitialInterval() {
    return CAS.settings.getInterstitialInterval();
  }

  @Deprecated("Use CAS.settings.restartInterstitialInterval() instead")
  static Future<void> restartInterstitialInterval() {
    return CAS.settings.restartInterstitialInterval();
  }
}
