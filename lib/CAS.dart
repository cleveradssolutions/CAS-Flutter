import 'package:clever_ads_solutions/internal/InternalListenerContainer.dart';
import 'package:clever_ads_solutions/public/Audience.dart';
import 'package:clever_ads_solutions/public/CCPAStatus.dart';
import 'package:clever_ads_solutions/public/ConsentFlow.dart';
import 'package:clever_ads_solutions/public/LoadingMode.dart';
import 'package:clever_ads_solutions/public/ManagerBuilder.dart';
import 'package:clever_ads_solutions/internal/InternalManagerBuilder.dart';
import 'package:clever_ads_solutions/public/TargetingOptions.dart';
import 'package:clever_ads_solutions/public/UserConsent.dart';
import 'package:flutter/services.dart';
import 'package:clever_ads_solutions/internal/InternalCASConsentFlow.dart';

class CAS {
  static String _flutterVersion = "3.13.0";

  static MethodChannel _channel =
      MethodChannel("com.cleveradssolutions.cas.ads.flutter");

  static InternalListenerContainer _listenerContainer =
      new InternalListenerContainer(_channel);

  static setFlutterVersion(String flutterVersion) {
    _flutterVersion = flutterVersion;
  }

  static ConsentFlow buildConsentFlow() {
    return InternalCASConsentFlow(_channel, _listenerContainer);
  }

  static ManagerBuilder buildManager() {
    return InternalManagerBuilder(
        _channel, _listenerContainer, _flutterVersion);
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

    if (consent == null)
      return UserConsent.UNDEFINED;
    else
      return UserConsent.values[consent];
  }

  static Future<void> setCCPAStatus(CCPAStatus status) async {
    return _channel.invokeMethod("setCCPAStatus", {"ccpa": status.index});
  }

  static Future<CCPAStatus> getCPPAStatus() async {
    int? ccpa = await _channel.invokeMethod<int>('getCPPAStatus');

    if (ccpa == null)
      return CCPAStatus.UNDEFINED;
    else
      return CCPAStatus.values[ccpa];
  }

  static Future<void> setTaggedAudience(Audience audience) async {
    return _channel
        .invokeMethod("setTaggedAudience", {"taggedAudience": audience.index});
  }

  static Future<Audience> getTaggedAudience() async {
    int? audience = await _channel.invokeMethod<int>('getTaggedAudience');

    if (audience == null)
      return Audience.UNDEFINED;
    else
      return Audience.values[audience];
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
