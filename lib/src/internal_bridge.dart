// ignore_for_file: public_member_api_docs

// ignore_for_file: deprecated_member_use_from_same_package

// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mobile_ads.dart';
import 'ad_instances.dart';
import 'ad_error.dart';
import 'ad_size.dart';
import 'consent_flow.dart';

InternalBridge casInternalBridge = InternalBridge._('clever_ads_solutions')
  .._init();

class InternalBridge {
  static const String _keyAdId = 'adId';
  static const String _keyDefault = "value";

  final MethodChannel channel;
  final Map<int, AdInstance> _adInstances = <int, AdInstance>{};
  final Map<AdInstance, int> _adInstancesInverse = <AdInstance, int>{};
  final Set<int> _mountedWidgetAdIds = <int>{};
  int _nextAdId = 0;

  int defaultBannerRefreshInterval = 30;
  int defaultInterstitialMinInterval = 0;
  bool deprecatedManualLoadUsed = false;

  AdInstance? adFor(int adId) {
    return _adInstances[adId];
  }

  int adIdFor(AdInstance ad) {
    assert(
      _adInstancesInverse[ad] != null,
      '$ad has already been disposed. Please make sure that the ad instance is not used after dispose.',
    );
    return _adInstancesInverse[ad] ?? -1;
  }

  InternalBridge._(String channelName)
      : channel = MethodChannel(
          channelName,
          StandardMethodCodec(_AdMessageCodec()),
        ) {
    channel.setMethodCallHandler(_onAdEvent);
  }

  /// Internal init to cleanup state for hot restart.
  void _init() {
    channel.invokeMethod("_init");
  }

  bool tryMountAdWidget(AdViewInstance ad) {
    final int adId = adIdFor(ad);
    return adId >= 0 && _mountedWidgetAdIds.add(adId);
  }

  bool isAdWidgetMounted(AdViewInstance ad) {
    final int adId = adIdFor(ad);
    return _mountedWidgetAdIds.contains(adId);
  }

  void unmountAdWidgetId(AdViewInstance ad) {
    final int? adId = _adInstancesInverse[ad];
    if (adId != null) {
      _mountedWidgetAdIds.remove(adId);
    }
  }

  Future<InitializationStatus> initializeSDK({
    required String casId,
    int targetAudience = 0,
    bool showConsentFlow = true,
    bool forceTestAds = false,
    List<String>? testDeviceIds,
    PrivacyGeography debugGeography = PrivacyGeography.europeanEconomicArea,
    Map<String, String>? mediationExtras,
  }) async {
    return (await channel.invokeMethod<InitializationStatus>(
      'initialize',
      {
        'casId': casId,
        'audience': targetAudience,
        'showConsentFlow': showConsentFlow,
        'forceTestAds': forceTestAds,
        'testDeviceIds': testDeviceIds,
        'mediationExtras': mediationExtras,
        'debugGeography': debugGeography.value,
      },
    ))!;
  }

  Future<String> getSDKVersion() async {
    return await channel.invokeMethod<String>('getSDKVersion') ?? '';
  }

  Future<void> setAdSoundsMuted(bool muted) {
    return channel.invokeMethod('setAdSoundsMuted', muted);
  }

  Future<void> setDebugLoggingEnabled(bool enabled) {
    return channel.invokeMethod('setDebugLoggingEnabled', enabled);
  }

  Future<void> setTrialAdFreeInterval(int interval) {
    return channel.invokeMethod('setTrialAdFreeInterval', interval);
  }

  Future<ConsentStatus> getVendorConsent(int vendorId) async {
    final int? index =
        await channel.invokeMethod<int>("getVendorConsent", vendorId);
    return ConsentStatus.values[index ?? 0];
  }

  Future<ConsentStatus> getAdditionalConsent(int providerId) async {
    final int? index =
        await channel.invokeMethod<int>("getAdditionalConsent", providerId);
    return ConsentStatus.values[index ?? 0];
  }

  Future<void> validateIntegration() {
    return channel.invokeMethod('validateIntegration');
  }

  Future<int> showConsentFlow(ConsentFlow flow, bool force) async {
    int status = await channel.invokeMethod<int>(
          'showConsentFlow',
          {
            'force': force,
            'debugGeography': flow.debugGeography.value,
            'policyUrl': flow.privacyPolicyUrl,
          },
        ) ??
        0;
    flow.onDismissed?.call(status);
    return status;
  }

  void createAdInstance({
    required AdInstance ad,
    required bool shouldLoad,
    String? casId,
    Map<String, dynamic>? arguments,
  }) {
    assert(!_adInstancesInverse.containsKey(ad));
    final int adId = _nextAdId++;
    assert(!_adInstances.containsKey(adId));
    _adInstances[adId] = ad;
    _adInstancesInverse[ad] = adId;

    arguments ??= <String, dynamic>{};
    arguments[_keyAdId] = adId;
    arguments['casId'] = casId;
    arguments['format'] = ad.format.index;
    arguments['shouldLoad'] = shouldLoad;

    unawaited(channel.invokeMethod<void>('createAdInstance', arguments));
  }

  Future<void> loadAd(AdInstance ad) {
    return channel.invokeMethod<void>('loadAd', adIdFor(ad));
  }

  Future<bool> isAdLoaded(AdInstance ad) {
    return _getBoolValueForAd(ad, 'isAdLoaded');
  }

  Future<bool> isAutoloadEnabled(AdInstance ad) {
    return _getBoolValueForAd(ad, 'isAutoloadEnabled');
  }

  Future<void> setAutoloadEnabled(AdInstance ad, bool enabled) {
    return channel.invokeMethod<void>(
      'setAutoloadEnabled',
      <dynamic, dynamic>{_keyAdId: adIdFor(ad), _keyDefault: enabled},
    );
  }

  Future<bool> isAutoshowEnabled(AdInstance ad) {
    return _getBoolValueForAd(ad, 'isAutoshowEnabled');
  }

  Future<void> setAutoshowEnabled(AdInstance ad, bool enabled) {
    return channel.invokeMethod<void>(
      'setAutoshowEnabled',
      <dynamic, dynamic>{_keyAdId: adIdFor(ad), _keyDefault: enabled},
    );
  }

  Future<void> showScreenAd(AdScreenInstance ad) {
    return channel.invokeMethod<void>('showScreenAd', adIdFor(ad));
  }

  Future<int> getAdInterval(AdInstance ad) async {
    return await channel.invokeMethod<int>('getAdInterval', adIdFor(ad)) ?? 0;
  }

  Future<void> setAdInterval(AdInstance ad, int interval) {
    return channel.invokeMethod<void>(
      'setAdInterval',
      <dynamic, dynamic>{_keyAdId: adIdFor(ad), _keyDefault: interval},
    );
  }

  Future<void> restartInterstitialAdInterval() {
    return channel.invokeMethod<void>('restartInterstitialAdInterval');
  }

  Future<AdContentInfo?> getContentInfo(AdInstance ad) {
    return channel.invokeMethod<AdContentInfo>("getContentInfo", adIdFor(ad));
  }

  void disposeAd(AdInstance ad) {
    final int? adId = _adInstancesInverse.remove(ad);
    if (adId != null) {
      _adInstances.remove(adId);
      unawaited(channel.invokeMethod<void>('disposeAd', adId));
    }
  }

  Future<bool> _getBoolValueForAd(AdInstance ad, String method) async {
    return await channel.invokeMethod<bool>(method, adIdFor(ad)) ?? false;
  }

  Future<dynamic> _onAdEvent(MethodCall call) async {
    final String eventName = call.method;
    final int adId = call.arguments[_keyAdId];
    final AdInstance? ad = casInternalBridge.adFor(adId);
    if (ad == null) {
      debugPrint('Ad with id `$adId` is not available for $eventName.');
      return;
    }
    switch (eventName) {
      case 'onAdLoaded':
        if (ad is AdViewInstance) {
          if (ad is CASBanner) {
            ad.platformViewSize = call.arguments['size'];
          }
          ad.onAdLoaded?.call(ad);
          return;
        } else if (ad is AdScreenInstance) {
          ad.onAdLoaded?.call(ad);
          if (ad.contentCallback?.onAdLoaded != null) {
            ad.contentCallback?.onAdLoaded?.call((await ad.getContentInfo())!);
          }
          return;
        }
        break;
      case 'onAdFailedToLoad':
        final AdError error = call.arguments['error'];
        ad.onAdFailedToLoad?.call(ad, error);
        if (ad is CASNativeContent) {
          ad.dispose();
        } else if (ad is CASBanner) {
          ad.platformViewSize = null;
        } else if (ad is AdScreenInstance) {
          ad.contentCallback?.onAdFailedToLoad?.call(ad.format, error);
        }
        return;
      case 'onAdFailedToShow':
        if (ad is AdScreenInstance) {
          final AdError error = call.arguments['error'];
          ad.onAdFailedToShow?.call(ad, error);
          ad.contentCallback?.onAdFailedToShow?.call(ad.format, error);
          return;
        }
        break;
      case 'onAdShowed':
        if (ad is AdScreenInstance) {
          ad.onAdShowed?.call(ad);
          if (ad.contentCallback?.onAdShowed != null) {
            ad.contentCallback?.onAdShowed?.call((await ad.getContentInfo())!);
          }
          return;
        }
        break;
      case 'onAdClicked':
        ad.onAdClicked?.call(ad);
        if (ad is AdScreenInstance) {
          if (ad.contentCallback?.onAdClicked != null) {
            ad.contentCallback?.onAdClicked?.call((await ad.getContentInfo())!);
          }
        }
        return;
      case 'onAdImpression':
        final AdContentInfo info = call.arguments['info'];
        ad.onAdImpression?.call(ad, info);
        if (ad is AdScreenInstance) {
          ad.impressionListener?.onAdImpression.call(info);
        }
        return;
      case 'onAdDismissed':
        if (ad is AdScreenInstance) {
          ad.onAdDismissed?.call(ad);
          if (ad.contentCallback?.onAdDismissed != null) {
            ad.contentCallback?.onAdDismissed
                ?.call((await ad.getContentInfo())!);
          }
          return;
        }
        break;
      case 'onAdUserEarnedReward':
        if (ad is CASRewarded) {
          ad.onUserEarnedReward?.call(ad);
          return;
        }
        break;
    }

    debugPrint('Invalid ad: $ad, for event name: $eventName');
  }
}

class _AdMessageCodec extends StandardMessageCodec {
  // The type values below must be consistent for each platform.
  static const int _valueInitStatus = 128;
  static const int _valueAdSize = 129;
  static const int _valueSize = 130;
  static const int _valueAdError = 131;
  static const int _valueTemplateStyle = 132;
  static const int _valueColor = 133;
  static const int _valueAdContentInfo = 134;

  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value == null) {
      buffer.putUint8(0); // null
    } else if (value is AdSize) {
      buffer.putUint8(_valueAdSize);
      if (value.isAdaptive) {
        writeValue(buffer, 1);
      } else if (value.isInline) {
        writeValue(buffer, 2);
      } else {
        writeValue(buffer, 0);
      }
      writeValue(buffer, value.width);
      writeValue(buffer, value.height);
    } else if (value is NativeTemplateStyle) {
      buffer.putUint8(_valueTemplateStyle);
      writeValue(buffer, value.backgroundColor);
      writeValue(buffer, value.primaryColor);
      writeValue(buffer, value.primaryTextColor);
      writeValue(buffer, value.headlineTextColor);
      writeValue(buffer, value.headlineFontStyle?.index);
      writeValue(buffer, value.secondaryTextColor);
      writeValue(buffer, value.secondaryFontStyle?.index);
    } else if (value is Color) {
      buffer.putUint8(_valueColor);
      writeValue(buffer, (value.a * 255).toInt());
      writeValue(buffer, (value.r * 255).toInt());
      writeValue(buffer, (value.g * 255).toInt());
      writeValue(buffer, (value.b * 255).toInt());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  dynamic readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case _valueInitStatus:
        return InitializationStatus(
          error: readValueOfType(buffer.getUint8(), buffer),
          countryCode: readValueOfType(buffer.getUint8(), buffer),
          isPrivacyOptionsRequired: readValueOfType(buffer.getUint8(), buffer),
          consentFlowStatus:
              (readValueOfType(buffer.getUint8(), buffer) as num).toInt(),
        );
      case _valueSize:
        final num width = readValueOfType(buffer.getUint8(), buffer);
        final num height = readValueOfType(buffer.getUint8(), buffer);
        return Size(width.toDouble(), height.toDouble());
      case _valueAdError:
        final num code = readValueOfType(buffer.getUint8(), buffer);
        final String message = readValueOfType(buffer.getUint8(), buffer);
        return AdError(code.toInt(), message);
      case _valueAdContentInfo:
        return AdContentInfo(
          format: AdFormat.values[
              (readValueOfType(buffer.getUint8(), buffer) as num).toInt()],
          sourceName: readValueOfType(buffer.getUint8(), buffer),
          sourceUnitId: readValueOfType(buffer.getUint8(), buffer),
          creativeId: readValueOfType(buffer.getUint8(), buffer),
          revenue:
              (readValueOfType(buffer.getUint8(), buffer) as num).toDouble(),
          revenuePrecision: AdRevenuePrecision.values[
              (readValueOfType(buffer.getUint8(), buffer) as num).toInt()],
          revenueTotal:
              (readValueOfType(buffer.getUint8(), buffer) as num).toDouble(),
          impressionDepth:
              (readValueOfType(buffer.getUint8(), buffer) as num).toInt(),
        );
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}
