import 'package:flutter/services.dart';

import 'audience.dart';
import 'ccpa_status.dart';
import 'consent_flow.dart';
import 'internal/internal_cas_consent_flow.dart';
import 'internal/internal_listener_container.dart';
import 'internal/internal_manager_builder.dart';
import 'loading_mode.dart';
import 'manager_builder.dart';
import 'targeting_options.dart';
import 'user_consent.dart';

class CAS {
  static const String _pluginVersion = "0.5.1";

  static const MethodChannel _channel =
      MethodChannel("com.cleveradssolutions.cas.ads.flutter");

  static final InternalListenerContainer _listenerContainer =
      InternalListenerContainer(_channel);

  @Deprecated("This method is no longer maintained and should not be used.")
  static setFlutterVersion(String flutterVersion) {}

  static ConsentFlow buildConsentFlow() {
    return InternalCASConsentFlow(_channel, _listenerContainer);
  }

  static ManagerBuilder buildManager() {
    return InternalManagerBuilder(_channel, _listenerContainer, _pluginVersion);
  }

  static Future<void> validateIntegration() async {
    return _channel.invokeMethod('validateIntegration');
  }

  static Future<void> setDebugMode(bool isEnable) async {
    return _channel.invokeMethod("setNativeDebug", {"enable": isEnable});
  }

  static Future<String> getSDKVersion() async {
    String? sdkVersion = await _channel.invokeMethod<String>('getSDKVersion');
    return sdkVersion ?? "";
  }

  static Future<void> setAge(int age) async {
    return _channel.invokeMethod("setAge", {"age": age});
  }

  static Future<void> setGender(Gender gender) async {
    return _channel.invokeMethod("setGender", {"gender": gender.index});
  }

  static Future<void> setUserConsentStatus(UserConsent consent) async {
    return _channel
        .invokeMethod("setUserConsentStatus", {"userConsent": consent.index});
  }

  static Future<UserConsent> getUserConsentStatus() async {
    int? consent = await _channel.invokeMethod<int>('getUserConsentStatus');

    if (consent == null) {
      return UserConsent.UNDEFINED;
    } else {
      return UserConsent.values[consent];
    }
  }

  static Future<void> setCCPAStatus(CCPAStatus status) async {
    return _channel.invokeMethod("setCCPAStatus", {"ccpa": status.index});
  }

  static Future<CCPAStatus> getCPPAStatus() async {
    int? ccpa = await _channel.invokeMethod<int>('getCPPAStatus');

    if (ccpa == null) {
      return CCPAStatus.UNDEFINED;
    } else {
      return CCPAStatus.values[ccpa];
    }
  }

  static Future<void> setTaggedAudience(Audience audience) async {
    return _channel
        .invokeMethod("setTaggedAudience", {"taggedAudience": audience.index});
  }

  static Future<Audience> getTaggedAudience() async {
    int? audience = await _channel.invokeMethod<int>('getTaggedAudience');

    if (audience == null) {
      return Audience.UNDEFINED;
    } else {
      return Audience.values[audience];
    }
  }

  static Future<void> setMutedAdSounds(bool mute) async {
    return _channel.invokeMethod("setMutedAdSounds", {"muted": mute});
  }

  static Future<void> setLoadingMode(LoadingMode loadingMode) async {
    return _channel
        .invokeMethod("setLoadingMode", {"loadingMode": loadingMode.index});
  }

  static Future<void> setTestDeviceIds(List<String> deviceIds) async {
    return _channel.invokeMethod("addTestDeviceId", {"devices": deviceIds});
  }

  static Future<void> addTestDeviceId(String deviceId) async {
    return _channel.invokeMethod("addTestDeviceId", {"deviceId": deviceId});
  }

  static Future<void> clearTestDeviceIds() async {
    return _channel.invokeMethod("clearTestDeviceIds");
  }

  static Future<void> setInterstitialInterval(int delay) async {
    return _channel
        .invokeMethod("setInterstitialInterval", {"interval": delay});
  }

  static Future<int> getInterstitialInterval() async {
    final interval =
        await _channel.invokeMethod<int>('getInterstitialInterval');
    return interval ?? 0;
  }

  static Future<void> restartInterstitialInterval() async {
    return _channel.invokeMethod("restartInterstitialInterval");
  }

  static Future<void> allowInterstitialAdsWhenVideoCostAreLower(
      final bool isAllow) async {
    return _channel.invokeMethod(
        'allowInterstitialAdsWhenVideoCostAreLower', {'enable': isAllow});
  }
}
