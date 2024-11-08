import 'package:flutter/services.dart';

import 'ads_settings.dart';
import 'audience.dart';
import 'ccpa_status.dart';
import 'consent_flow.dart';
import 'consent_status.dart';
import 'gender.dart';
import 'internal/ads_settings_impl.dart';
import 'internal/internal_cas_consent_flow.dart';
import 'internal/internal_manager_builder.dart';
import 'internal/targeting_options_impl.dart';
import 'loading_mode.dart';
import 'manager_builder.dart';
import 'targeting_options.dart';
import 'user_consent.dart';

/// Represents the CAS.AI SDK.
class CAS {
  static const String _pluginVersion = "0.6.3";

  static const MethodChannel _channel =
      MethodChannel("com.cleveradssolutions.plugin.flutter/cas");

  /// Get singleton instance for configure all mediation managers
  static final AdsSettings settings = AdsSettingsImpl();

  /// You can now easily tailor the way you serve your ads to fit a specific audience!
  /// You’ll need to inform our servers of the users’ details
  /// so the SDK will know to serve ads according to the segment the user belongs to.
  ///
  /// - **Attention:** Must be set before initializing the SDK.
  static final TargetingOptions targetingOptions = TargetingOptionsImpl();

  @Deprecated("This method is no longer maintained and should not be used")
  static setFlutterVersion(String flutterVersion) {}

  static ConsentFlow buildConsentFlow() {
    return InternalCASConsentFlow();
  }

  /// Create [MediationManager] builder.
  /// Don't forget to call the [ManagerBuilder.build] method to create manager instance.
  static ManagerBuilder buildManager() {
    return InternalManagerBuilder(_pluginVersion);
  }

  @Deprecated("Use CAS.settings.setDebugMode(bool isEnable) instead")
  static Future<void> setDebugMode(bool isEnable) {
    return settings.setDebugMode(isEnable);
  }

  static Future<String> getSDKVersion() async {
    String? sdkVersion = await _channel.invokeMethod<String>('getSDKVersion');
    return sdkVersion ?? "";
  }

  static String getPluginVersion() {
    return _pluginVersion;
  }

  /// Call Integration Helper and check current integration in logcat(Android) or console(iOS).
  /// LOG TAG: CASIntegrationHelper
  ///
  /// Call Integration Helper and check current integration in console.
  /// Log tag: [CASIntegrationHelper]
  static Future<void> validateIntegration() {
    return _channel.invokeMethod('validateIntegration');
  }

  @Deprecated("Use CAS.targetingOptions.setAge(int age) instead")
  static Future<void> setAge(int age) {
    return CAS.targetingOptions.setAge(age);
  }

  @Deprecated("Use CAS.targetingOptions.setGender(Gender gender) instead")
  static Future<void> setGender(Gender gender) {
    return CAS.targetingOptions.setGender(gender);
  }

  @Deprecated("Use CAS.settings.setUserConsent(ConsentStatus consent) instead")
  static Future<void> setUserConsent(UserConsent consent) {
    final ConsentStatus converted = ConsentStatus.values[consent.index];
    return CAS.settings.setUserConsent(converted);
  }

  @Deprecated("Use CAS.settings.getUserConsentStatus() instead")
  static Future<UserConsent> getUserConsentStatus() async {
    final ConsentStatus consent = await CAS.settings.getUserConsent();
    return UserConsent.values[consent.index];
  }

  @Deprecated("Use CAS.settings.setCCPAStatus(CCPAStatus status) instead")
  static Future<void> setCCPAStatus(CCPAStatus status) {
    return CAS.settings.setCCPAStatus(status);
  }

  @Deprecated("Use CAS.settings.getCCPAStatus() instead")
  static Future<CCPAStatus> getCPPAStatus() {
    return CAS.settings.getCPPAStatus();
  }

  @Deprecated("Use CAS.settings.setTaggedAudience(Audience audience) instead")
  static Future<void> setTaggedAudience(Audience audience) {
    return CAS.settings.setTaggedAudience(audience);
  }

  @Deprecated("Use CAS.settings.getTaggedAudience() instead")
  static Future<Audience> getTaggedAudience() {
    return CAS.settings.getTaggedAudience();
  }

  @Deprecated("Use CAS.settings.setMutedAdSounds(bool muted) instead")
  static Future<void> setMutedAdSounds(bool mute) {
    return CAS.settings.setMutedAdSounds(mute);
  }

  @Deprecated(
      "Use CAS.settings.setLoadingMode(LoadingMode loadingMode) instead")
  static Future<void> setLoadingMode(LoadingMode loadingMode) {
    return CAS.settings.setLoadingMode(loadingMode);
  }

  @Deprecated(
      "Use CAS.settings.setTestDeviceIds(Set<String> deviceIds) instead")
  static Future<void> setTestDeviceIds(List<String> deviceIds) {
    return CAS.settings.setTestDeviceIds(deviceIds.toSet());
  }

  @Deprecated("This method is no longer maintained and should not be used")
  static Future<void> addTestDeviceId(String deviceId) {
    return CAS.settings.addTestDeviceId(deviceId);
  }

  @Deprecated("Use CAS.settings.setTestDeviceIds({}) instead")
  static Future<void> clearTestDeviceIds() {
    return CAS.settings.setTestDeviceIds({});
  }

  @Deprecated("Use CAS.settings.setInterstitialInterval(delay) instead")
  static Future<void> setInterstitialInterval(int delay) {
    return CAS.settings.setInterstitialInterval(delay);
  }

  @Deprecated("Use CAS.settings.getInterstitialInterval() instead")
  static Future<int> getInterstitialInterval() {
    return CAS.settings.getInterstitialInterval();
  }

  @Deprecated("Use CAS.settings.restartInterstitialInterval() instead")
  static Future<void> restartInterstitialInterval() {
    return CAS.settings.restartInterstitialInterval();
  }

  @Deprecated(
      "Use CAS.settings.allowInterstitialAdsWhenVideoCostAreLower(bool isAllow) instead")
  static Future<void> allowInterstitialAdsWhenVideoCostAreLower(
      final bool isAllow) {
    return CAS.settings.allowInterstitialAdsWhenVideoCostAreLower(isAllow);
  }
}
