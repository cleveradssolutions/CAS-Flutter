import 'package:clever_ads_solutions/src/consent_status.dart';
import 'package:flutter/services.dart';

import 'ads_settings.dart';
import 'audience.dart';
import 'ccpa_status.dart';
import 'consent_flow.dart';
import 'gender.dart';
import 'internal/internal_cas_consent_flow.dart';
import 'internal/internal_listener_container.dart';
import 'internal/internal_manager_builder.dart';
import 'loading_mode.dart';
import 'manager_builder.dart';
import 'targeting_options.dart';
import 'user_consent.dart';

/// Represents the CAS.AI SDK.
class CAS {
  static const String _pluginVersion = "0.5.1";

  static const MethodChannel _channel =
      MethodChannel("com.cleveradssolutions.plugin.flutter");

  /// Get singleton instance for configure all mediation managers
  static final AdsSettings settings = AdsSettings(_channel);

  /// You can now easily tailor the way you serve your ads to fit a specific audience!
  /// You’ll need to inform our servers of the users’ details
  /// so the SDK will know to serve ads according to the segment the user belongs to.
  ///
  /// - **Attention:** Must be set before initializing the SDK.
  static final TargetingOptions targetingOptions = TargetingOptions(_channel);

  static final InternalListenerContainer _listenerContainer =
      InternalListenerContainer(_channel);

  @Deprecated("This method is no longer maintained and should not be used.")
  static setFlutterVersion(String flutterVersion) {}

  static ConsentFlow buildConsentFlow() {
    return InternalCASConsentFlow(_channel, _listenerContainer);
  }

  /// Create [MediationManager] builder.
  /// Don't forget to call the [ManagerBuilder.build] method to create manager instance.
  static ManagerBuilder buildManager() {
    return InternalManagerBuilder(_channel, _listenerContainer, _pluginVersion);
  }

  @Deprecated("Use CAS.settings.setDebugMode(bool isEnable) instead")
  static Future<void> setDebugMode(bool isEnable) async {
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
  static Future<void> validateIntegration() async {
    return _channel.invokeMethod('validateIntegration');
  }

  @Deprecated("Use CAS.targetingOptions.setAge(int age) instead")
  static Future<void> setAge(int age) async {
    return CAS.targetingOptions.setAge(age);
  }

  @Deprecated("Use CAS.targetingOptions.setGender(Gender gender) instead")
  static Future<void> setGender(Gender gender) async {
    return CAS.targetingOptions.setGender(gender);
  }

  @Deprecated("Use CAS.settings.setUserConsent(ConsentStatus consent) instead")
  static Future<void> setUserConsent(UserConsent consent) async {
    final ConsentStatus converted = ConsentStatus.values[consent.index];
    return CAS.settings.setUserConsent(converted);
  }

  @Deprecated("Use CAS.settings.getUserConsentStatus() instead")
  static Future<UserConsent> getUserConsentStatus() async {
    final ConsentStatus consent = await CAS.settings.getUserConsent();
    return UserConsent.values[consent.index];
  }

  @Deprecated("Use CAS.settings.setCCPAStatus(CCPAStatus status) instead")
  static Future<void> setCCPAStatus(CCPAStatus status) async {
    return CAS.settings.setCCPAStatus(status);
  }

  @Deprecated("Use CAS.settings.getCCPAStatus() instead")
  static Future<CCPAStatus> getCPPAStatus() async {
    return CAS.settings.getCPPAStatus();
  }

  @Deprecated("Use CAS.settings.setTaggedAudience(Audience audience) instead")
  static Future<void> setTaggedAudience(Audience audience) async {
    return CAS.settings.setTaggedAudience(audience);
  }

  @Deprecated("Use CAS.settings.getTaggedAudience() instead")
  static Future<Audience> getTaggedAudience() async {
    return CAS.settings.getTaggedAudience();
  }

  @Deprecated("Use CAS.settings.setMutedAdSounds(bool muted) instead")
  static Future<void> setMutedAdSounds(bool mute) async {
    return CAS.settings.setMutedAdSounds(mute);
  }

  @Deprecated(
      "Use CAS.settings.setLoadingMode(LoadingMode loadingMode) instead")
  static Future<void> setLoadingMode(LoadingMode loadingMode) async {
    return CAS.settings.setLoadingMode(loadingMode);
  }

  @Deprecated(
      "Use CAS.settings.setTestDeviceIds(Set<String> deviceIds) instead")
  static Future<void> setTestDeviceIds(List<String> deviceIds) async {
    return CAS.settings.setTestDeviceIds(deviceIds.toSet());
  }

  @Deprecated("Use CAS.settings.addTestDeviceId(String deviceId) instead")
  static Future<void> addTestDeviceId(String deviceId) async {
    return CAS.settings.addTestDeviceId(deviceId);
  }

  @Deprecated("Use CAS.settings.clearTestDeviceIds() instead")
  static Future<void> clearTestDeviceIds() async {
    return CAS.settings.clearTestDeviceIds();
  }

  @Deprecated("Use CAS.settings.clearTestDeviceIds() instead")
  static Future<void> setInterstitialInterval(int delay) async {
    return CAS.settings.setInterstitialInterval(delay);
  }

  @Deprecated("Use CAS.settings.getInterstitialInterval() instead")
  static Future<int> getInterstitialInterval() async {
    return CAS.settings.getInterstitialInterval();
  }

  @Deprecated("Use CAS.settings.restartInterstitialInterval() instead")
  static Future<void> restartInterstitialInterval() async {
    return CAS.settings.restartInterstitialInterval();
  }

  @Deprecated(
      "Use CAS.settings.allowInterstitialAdsWhenVideoCostAreLower(bool isAllow) instead")
  static Future<void> allowInterstitialAdsWhenVideoCostAreLower(
      final bool isAllow) async {
    return CAS.settings.allowInterstitialAdsWhenVideoCostAreLower(isAllow);
  }
}
