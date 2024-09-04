import 'package:flutter/services.dart';

import '../ads_settings.dart';
import '../audience.dart';
import '../ccpa_status.dart';
import '../consent_status.dart';
import '../loading_manager_mode.dart';

class AdsSettingsImpl extends AdsSettings {
  static const MethodChannel _channel =
      MethodChannel("com.cleveradssolutions.plugin.flutter/ads_settings");

  @override
  Future<Audience> getTaggedAudience() async {
    final int? index = await _channel.invokeMethod<int>('getTaggedAudience');
    return index == null ? Audience.undefined : Audience.values[index];
  }

  @override
  Future<void> setTaggedAudience(Audience audience) async {
    return _channel.invokeMethod(
      "setTaggedAudience",
      {"taggedAudience": audience.index},
    );
  }

  @override
  Future<ConsentStatus> getUserConsent() async {
    final int? index = await _channel.invokeMethod<int>("getUserConsent");
    return index == null
        ? ConsentStatus.undefined
        : ConsentStatus.values[index];
  }

  @override
  Future<void> setUserConsent(ConsentStatus consent) async {
    return _channel.invokeMethod(
      "setUserConsent",
      {"userConsent": consent.index},
    );
  }

  @override
  Future<ConsentStatus> getVendorConsent(int vendorId) async {
    final int? index = await _channel.invokeMethod<int>(
      "getVendorConsent",
      {"vendorId": vendorId},
    );
    return index == null
        ? ConsentStatus.undefined
        : ConsentStatus.values[index];
  }

  @override
  Future<ConsentStatus> getAdditionalConsent(int providerId) async {
    final int? index = await _channel.invokeMethod<int>(
      "getAdditionalConsent",
      {"providerId": providerId},
    );
    return index == null
        ? ConsentStatus.undefined
        : ConsentStatus.values[index];
  }

  @override
  Future<CCPAStatus> getCPPAStatus() async {
    final int? index = await _channel.invokeMethod<int>('getCPPAStatus');
    return index == null ? CCPAStatus.UNDEFINED : CCPAStatus.values[index];
  }

  @override
  Future<void> setCCPAStatus(CCPAStatus status) async {
    return _channel.invokeMethod("setCCPAStatus", {"ccpa": status.index});
  }

  @override
  Future<bool> getMutedAdSounds() async {
    final bool? muted = await _channel.invokeMethod<bool>("getMutedAdSounds");
    return muted ?? false;
  }

  @override
  Future<void> setMutedAdSounds(bool muted) async {
    return _channel.invokeMethod("setMutedAdSounds", {"muted": muted});
  }

  @override
  Future<bool> getDebugMode() async {
    final bool? isDebugModeEnabled =
        await _channel.invokeMethod<bool>("getDebugMode");
    return isDebugModeEnabled ?? false;
  }

  @override
  Future<void> setDebugMode(bool isEnable) async {
    return _channel.invokeMethod("setDebugMode", {"enable": isEnable});
  }

  @override
  Future<void> addTestDeviceId(String deviceId) async {
    return _channel.invokeMethod("addTestDeviceId", {"deviceId": deviceId});
  }

  @override
  Future<void> setTestDeviceId(String deviceIds) async {
    return _channel.invokeMethod("setTestDeviceIds", {"devices": deviceIds});
  }

  @override
  Future<void> setTestDeviceIds(Set<String> deviceIds) async {
    return _channel.invokeMethod("setTestDeviceIds", {"devices": deviceIds});
  }

  @override
  Future<void> clearTestDeviceIds() async {
    return _channel.invokeMethod("clearTestDeviceIds");
  }

  @override
  Future<int> getTrialAdFreeInterval() async {
    final int? interval =
        await _channel.invokeMethod<int>('getTrialAdFreeInterval');
    return interval ?? 0;
  }

  @override
  Future<void> setTrialAdFreeInterval(int interval) async {
    return _channel.invokeMethod(
      'setTrialAdFreeInterval',
      {"interval": interval},
    );
  }

  @override
  Future<int> getBannerRefreshInterval() async {
    final int? interval =
        await _channel.invokeMethod<int>('getBannerRefreshInterval');
    return interval ?? 0;
  }

  @override
  Future<void> setBannerRefreshInterval(int interval) async {
    return _channel.invokeMethod(
      'setBannerRefreshInterval',
      {"interval": interval},
    );
  }

  @override
  Future<int> getInterstitialInterval() async {
    final int? interval =
        await _channel.invokeMethod<int>('getInterstitialInterval');
    return interval ?? 0;
  }

  @override
  Future<void> setInterstitialInterval(int interval) async {
    return _channel.invokeMethod(
      'setInterstitialInterval',
      {"interval": interval},
    );
  }

  @override
  Future<void> restartInterstitialInterval() async {
    return _channel.invokeMethod("restartInterstitialInterval");
  }

  @override
  Future<bool> isAllowInterstitialAdsWhenVideoCostAreLower() async {
    final bool? isAllow = await _channel
        .invokeMethod<bool>("isAllowInterstitialAdsWhenVideoCostAreLower");
    return isAllow ?? false;
  }

  @override
  Future<void> allowInterstitialAdsWhenVideoCostAreLower(bool isAllow) async {
    return _channel.invokeMethod(
      'allowInterstitialAdsWhenVideoCostAreLower',
      {'enable': isAllow},
    );
  }

  @override
  Future<LoadingManagerMode> getLoadingMode() async {
    final int? index = await _channel.invokeMethod<int>("getLoadingMode");
    return index == null
        ? LoadingManagerMode.optimal
        : LoadingManagerMode.values[index];
  }

  @override
  Future<void> setLoadingMode(LoadingManagerMode loadingMode) async {
    return _channel.invokeMethod(
      "setLoadingMode",
      {"loadingMode": loadingMode.index},
    );
  }
}
