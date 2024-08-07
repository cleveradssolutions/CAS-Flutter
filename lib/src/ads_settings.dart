import 'package:clever_ads_solutions/src/consent_status.dart';
import 'package:flutter/services.dart';

import 'audience.dart';
import 'ccpa_status.dart';
import 'loading_mode.dart';

class AdsSettings {
  final MethodChannel _channel;

  AdsSettings(this._channel);

  /// Ad filters by Audience
  ///
  /// Default: [Audience.UNDEFINED]
  /// See [Audience]
  Future<Audience> getTaggedAudience() async {
    final int? index = await _channel.invokeMethod<int>('getTaggedAudience');
    return index == null ? Audience.UNDEFINED : Audience.values[index];
  }

  /// See [getTaggedAudience]
  Future<void> setTaggedAudience(Audience audience) async {
    return _channel.invokeMethod(
      "setTaggedAudience",
      {"taggedAudience": audience.index},
    );
  }

  /// GDPR User consent status of data collection.
  ///
  /// - Default: [ConsentStatus.undefined]
  /// See [ConsentStatus]
  Future<ConsentStatus> getUserConsent() async {
    final int? index = await _channel.invokeMethod<int>("getUserConsent");
    return index == null
        ? ConsentStatus.undefined
        : ConsentStatus.values[index];
  }

  /// See [getUserConsent]
  Future<void> setUserConsent(ConsentStatus consent) async {
    return _channel.invokeMethod(
      "setUserConsent",
      {"userConsent": consent.index},
    );
  }

  /// Whether or not user has opted out of the sale of their personal information.
  ///
  /// Default: [CCPAStatus.UNDEFINED]
  /// See [CCPAStatus]
  Future<CCPAStatus> getCPPAStatus() async {
    final int? index = await _channel.invokeMethod<int>('getCPPAStatus');
    return index == null ? CCPAStatus.UNDEFINED : CCPAStatus.values[index];
  }

  /// See [getCPPAStatus]
  Future<void> setCCPAStatus(CCPAStatus status) async {
    return _channel.invokeMethod("setCCPAStatus", {"ccpa": status.index});
  }

  /// Indicates if the application’s audio is muted. Affects initial mute state for
  /// all ads. Use this method only if your application has its own volume controls
  /// (e.g., custom music or sound effect muting).
  ///
  /// Disabled by default.
  Future<bool> getMutedAdSounds() async {
    final bool? muted = await _channel.invokeMethod<bool>("getMutedAdSounds");
    return muted ?? false;
  }

  /// See [getMutedAdSounds]
  Future<void> setMutedAdSounds(bool muted) async {
    return _channel.invokeMethod("setMutedAdSounds", {"muted": muted});
  }

  /// The enabled Debug Mode will display a lot of useful information for debugging about the states of the sdk with tag CAS.
  /// Disabling Debug Mode may improve application performance.
  ///
  /// Disabled by default.
  Future<bool> getDebugMode() async {
    final bool? isDebugModeEnabled =
        await _channel.invokeMethod<bool>("getDebugMode");
    return isDebugModeEnabled ?? false;
  }

  /// See [getDebugMode]
  Future<void> setDebugMode(bool isEnable) async {
    return _channel.invokeMethod("setDebugMode", {"enable": isEnable});
  }

  /// Add a test device ID corresponding to test devices which will always request test ads.
  /// List of test devices should be defined before first MediationManager initialized.
  ///
  /// 1. Run an app configured with the CAS SDK.
  /// 2. Check the console or logcat output for a message that looks like this:
  /// "To get test ads on this device, set ... "
  /// 3. Copy your alphanumeric test device ID to your clipboard.
  /// 4. Add the test device ID to the list before call initialize MediationManager.
  Future<Set<String>> getTestDeviceIds() async {
    final Set<String>? testDeviceIds =
        await _channel.invokeMethod<Set<String>>("getTestDeviceIds");
    return testDeviceIds ?? <String>{};
  }

  /// See [getTestDeviceIds]
  Future<void> addTestDeviceId(String deviceId) async {
    return _channel.invokeMethod("addTestDeviceId", {"deviceId": deviceId});
  }

  /// See [getTestDeviceIds]
  Future<void> setTestDeviceIds(Set<String> deviceIds) async {
    return _channel.invokeMethod("setTestDeviceIds", {"devices": deviceIds});
  }

  /// See [getTestDeviceIds]
  Future<void> clearTestDeviceIds() async {
    return _channel.invokeMethod("clearTestDeviceIds");
  }

  /// Defines the time interval, in seconds, starting from the moment of the initial app installation,
  /// during which users can use the application without ads being displayed while still retaining
  /// access to the Rewarded Ads format.
  /// Within this interval, users enjoy privileged access to the application's features without intrusive advertisements.
  ///
  ///  - Default: 0 seconds
  /// - Units: Seconds
  Future<int> getTrialAdFreeInterval() async {
    final int? interval =
        await _channel.invokeMethod<int>('getTrialAdFreeInterval');
    return interval ?? 0;
  }

  /// See [getTrialAdFreeInterval]
  Future<void> setTrialAdFreeInterval(int interval) async {
    return _channel.invokeMethod(
      'setTrialAdFreeInterval',
      {"interval": interval},
    );
  }

  /// Set the number of seconds an ad is displayed before a new ad is shown.
  /// After the interval has passed, a new advertisement will be automatically loaded.
  /// - [CASBannerView.refreshInterval] will override this value for a specific view.
  ///
  /// - Default: 30 seconds
  /// - Min: 5 seconds
  /// - Units: Seconds
  Future<int> getBannerRefreshInterval() async {
    final int? interval =
        await _channel.invokeMethod<int>('getBannerRefreshInterval');
    return interval ?? 0;
  }

  /// See [getBannerRefreshInterval]
  Future<void> setBannerRefreshInterval(int interval) async {
    return _channel.invokeMethod(
      'setBannerRefreshInterval',
      {"interval": interval},
    );
  }

  /// The interval between impressions Interstitial Ad in seconds.
  ///
  /// - Default: 0 seconds
  /// - Units: Seconds
  Future<int> getInterstitialInterval() async {
    final int? interval =
        await _channel.invokeMethod<int>('getInterstitialInterval');
    return interval ?? 0;
  }

  /// See [getInterstitialInterval]
  Future<void> setInterstitialInterval(int interval) async {
    return _channel.invokeMethod(
      'setInterstitialInterval',
      {"interval": interval},
    );
  }

  /// Restart interval until next Interstitial ad display.
  ///
  /// - By default, the interval before first Interstitial Ad impression is ignored.
  /// - You can use this method to delay displaying ad.
  Future<void> restartInterstitialInterval() async {
    return _channel.invokeMethod("restartInterstitialInterval");
  }

  /// This option will compare ad cost and serve regular interstitial ads
  /// when rewarded video ads are expected to generate less revenue.
  /// Interstitial Ads does not require to watch the video to the end,
  /// but the [AdCallback.onComplete] callback will be triggered in any case.
  ///
  /// Enabled by default.
  Future<bool> isAllowInterstitialAdsWhenVideoCostAreLower() async {
    final bool? isAllow = await _channel
        .invokeMethod<bool>("isAllowInterstitialAdsWhenVideoCostAreLower");
    return isAllow ?? false;
  }

  /// See [isAllowInterstitialAdsWhenVideoCostAreLower]
  Future<void> allowInterstitialAdsWhenVideoCostAreLower(bool isAllow) async {
    return _channel.invokeMethod(
      'allowInterstitialAdsWhenVideoCostAreLower',
      {'enable': isAllow},
    );
  }

  /// Mediation waterfall loading mode.
  ///
  /// Default: [LoadingMode.Optimal]
  /// See [LoadingMode]
  Future<LoadingMode> getLoadingMode() async {
    final int? index = await _channel.invokeMethod<int>("getLoadingMode");
    return index == null ? LoadingMode.Optimal : LoadingMode.values[index];
  }

  /// See [getLoadingMode]
  Future<void> setLoadingMode(LoadingMode loadingMode) async {
    return _channel.invokeMethod(
      "setLoadingMode",
      {"loadingMode": loadingMode.index},
    );
  }
}
