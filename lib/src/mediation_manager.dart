// ignore_for_file: deprecated_member_use_from_same_package

part of 'manager_builder.dart';

/// WARNING: This API is still supported but no longer recommended.
/// Migrate to new [CASMobileAds] implementation.
class MediationManager {
  final String _casId;
  final bool _testAds;
  bool _isInterstitialAutoshow = false;
  bool _isInterstitialAutoload = false;
  bool _isRewardedAutoload = false;
  AdLoadCallback? _loadCallback;
  AdCallback? _interstitialCallback;
  AdCallback? _rewardedCallback;
  AdCallback? _appReturnCallback;

  CASInterstitial? _interstitial;
  CASRewarded? _rewarded;

  MediationManager._(this._casId, this._testAds);

  /// CAS manager (Placement) identifier
  Future<String> getManagerID() {
    return Future.value(_casId);
  }

  /// Check is visible AdType.interstitial or AdType.rewarded right now.
  Future<bool> isFullscreenAdVisible() {
    return Future.value(
        _interstitialCallback != null || _rewardedCallback != null);
  }

  /// Is test mode enabled
  Future<bool> isDemoAdMode() {
    return Future.value(_testAds);
  }

  /// Manual load Interstitial Ad.
  Future<void> loadInterstitial() {
    if (_interstitial != null) {
      return _interstitial!.load();
    }
    _interstitial = CASInterstitial.createAndLoad(
      casId: _casId,
      autoReload: _isInterstitialAutoload &&
          !casInternalBridge.deprecatedManualLoadUsed,
      autoShow: _isInterstitialAutoshow,
      minInterval: -1,
      onAdLoaded: (ad) {
        _loadCallback?.onAdLoaded(AdType.Interstitial);
      },
      onAdFailedToLoad: (ad, error) {
        _loadCallback?.onAdFailedToLoad(AdType.Interstitial, error.message);
      },
      onAdFailedToShow: (ad, error) {
        if (_interstitialCallback != null) {
          _interstitialCallback?.onShowFailed(error.message);
          _interstitialCallback = null;
        } else {
          _appReturnCallback?.onShowFailed(error.message);
        }
      },
      onAdShowed: (ad) {
        AdCallback? callback = _interstitialCallback ?? _appReturnCallback;
        callback?.onShown();
      },
      onAdClicked: (ad) {
        AdCallback? callback = _interstitialCallback ?? _appReturnCallback;
        callback?.onClicked();
      },
      onAdDismissed: (ad) {
        if (_interstitialCallback != null) {
          _interstitialCallback?.onClosed();
          _interstitialCallback = null;
        } else {
          _appReturnCallback?.onClosed();
        }
      },
      onAdImpression: (ad, info) async {
        AdCallback? callback = _interstitialCallback ?? _appReturnCallback;
        _handleAdImpression(callback, info, AdType.Interstitial);
      },
    );
    return Future.value();
  }

  /// Manual load Rewarded Video Ad.
  Future<void> loadRewarded() {
    if (_rewarded != null) {
      return _rewarded!.load();
    }
    _rewarded = CASRewarded.createAndLoad(
      casId: _casId,
      autoReload:
          _isRewardedAutoload && !casInternalBridge.deprecatedManualLoadUsed,
      onAdLoaded: (ad) {
        _loadCallback?.onAdLoaded(AdType.Rewarded);
      },
      onAdFailedToLoad: (ad, error) {
        _loadCallback?.onAdFailedToLoad(AdType.Rewarded, error.message);
      },
      onAdFailedToShow: (ad, error) {
        _rewardedCallback?.onShowFailed(error.message);
        _rewardedCallback = null;
      },
      onAdShowed: (ad) {
        _rewardedCallback?.onShown();
      },
      onAdClicked: (ad) {
        _rewardedCallback?.onClicked();
      },
      onAdDismissed: (ad) {
        _rewardedCallback?.onClosed();
        _rewardedCallback = null;
      },
      onAdImpression: (ad, info) async {
        _handleAdImpression(_rewardedCallback, info, AdType.Rewarded);
      },
      onUserEarnedReward: (ad) {
        _rewardedCallback?.onComplete();
      },
    );
    return Future.value();
  }

  /// Check if Interstitial ad is ready to be shown.
  Future<bool> isInterstitialReady() {
    return _interstitial != null
        ? _interstitial!.isLoaded()
        : Future.value(false);
  }

  /// Check if Rewarded ad is ready to be shown.
  Future<bool> isRewardedAdReady() {
    return _rewarded != null ? _rewarded!.isLoaded() : Future.value(false);
  }

  /// Shows the Interstitial ad if available.
  /// @param activity The activity from which the Interstitial ad should be shown.
  /// @param callback The callback for Interstitial ad events.
  Future<void> showInterstitial(AdCallback? callback) {
    if (_interstitial == null) {
      callback?.onShowFailed("Not ready");
      return Future.value();
    }
    _interstitialCallback = callback;
    return _interstitial!.show();
  }

  /// Shows the Rewarded ad if available.
  /// @param activity The activity from which the Rewarded ad should be shown.
  /// @param callback The callback for Rewarded ad events.
  Future<void> showRewarded(AdCallback? callback) {
    if (_rewarded == null) {
      callback?.onShowFailed("Not ready");
      return Future.value();
    }
    _rewardedCallback = callback;
    return _rewarded!.show();
  }

  /// Set [enabled] ad [type] to processing.
  /// The state will not be saved between sessions.
  @Deprecated(
      "If you want more precise control over ad memory, you should switch to using the new CAS classes for each format.")
  Future<void> setEnabled(int adType, bool isEnable) async {
    final bool autoload =
        isEnable && !casInternalBridge.deprecatedManualLoadUsed;
    if (adType & AdTypeFlags.interstitial == AdTypeFlags.interstitial) {
      _isInterstitialAutoload = isEnable;
      if (_interstitial != null) {
        await _interstitial?.setAutoloadEnabled(autoload);
      } else if (autoload) {
        await loadInterstitial();
      }
    }
    if (adType & AdTypeFlags.rewarded == AdTypeFlags.rewarded) {
      _isRewardedAutoload = isEnable;
      if (_rewarded != null) {
        await _rewarded?.setAutoloadEnabled(autoload);
      } else if (autoload) {
        await loadInterstitial();
      }
    }
  }

  /// Ad [type] is processing.
  Future<bool> isEnabled(int adType) {
    bool enabled = false;
    if (adType & AdTypeFlags.interstitial == AdTypeFlags.interstitial) {
      enabled = _isInterstitialAutoload;
    } else if (adType & AdTypeFlags.rewarded == AdTypeFlags.rewarded) {
      enabled = _isRewardedAutoload;
    }
    return Future.value(enabled);
  }

  /// The Return Ad which is displayed once the user returns to your application after a certain period of time.
  /// To minimize the intrusiveness, short time periods are ignored.
  ///
  /// Return ads are disabled by default.
  /// If you want to enable this feature, simply pass AdCallback as the parameter of the method.
  @Deprecated(
      "Please migrate to new `CASAppOpen` or `CASInterstitial` to enable this feature with the `isAutoshowEnabled` property.")
  Future<void> enableAppReturn(AdCallback? callback) {
    _appReturnCallback = callback;
    _isInterstitialAutoshow = true;
    return _interstitial?.setAutoshowEnabled(true) ?? Future.value();
  }

  /// Disable the Return Ad which is displayed once the user returns to your application after a certain period of time.
  Future<void> disableAppReturn() {
    _isInterstitialAutoshow = false;
    return _interstitial?.setAutoshowEnabled(false) ?? Future.value();
  }

  /// Calling this method will indicate to skip one next ad impression when returning to the app.
  ///
  /// You can call this method when you intentionally redirect the user to another application (for example Google Play)
  /// and do not want them to see ads when they return to your application.
  @Deprecated("Not available")
  Future<void> skipNextAppReturnAds() {
    return Future.value();
  }

  /// Set [AdLoadCallback]
  @Deprecated(
      "If you want to receive convenient ad loading callbacks, you should switch to using the new CAS classes for each format.")
  void setAdLoadCallback(AdLoadCallback? callback) {
    _loadCallback = callback;
  }

  Future<void> _handleAdImpression(
      AdCallback? callback, AdContentInfo info, AdType adType) async {
    if (callback != null) {
      callback.onImpression(AdImpression(
        adType: adType,
        cpm: await info.getRevenue() * 1000.0,
        network: await info.getSourceName(),
        priceAccuracy:
            await info.getRevenuePrecision() == AdRevenuePrecision.precise
                ? PriceAccuracy.BID
                : PriceAccuracy.FLOOR,
        versionInfo: "",
        creativeIdentifier: await info.getCreativeId(),
        identifier: await info.getSourceUnitId(),
        impressionDepth: await info.getImpressionDepth(),
        lifetimeRevenue: await info.getRevenueTotal(),
      ));
    }
  }
}
