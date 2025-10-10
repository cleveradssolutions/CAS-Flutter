// ignore_for_file: public_member_api_docs

// ignore_for_file: deprecated_member_use_from_same_package

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'internal_bridge.dart';
import 'ad_instances.dart';
import 'ad_size.dart';
import 'ad_error.dart';

/// WARNING: This API is still supported but no longer recommended.
/// Migrate to new [CASWidget] with [CASBanner] implementation.
@Deprecated("Please migrate to new CASBanner.createAndLoad() and CASWidget")
class AdViewListener {
  /// Invokes this callback when ad loaded and ready to present.
  final void Function()? onAdViewLoaded;

  /// Invokes this callback when an error occurred with the ad.
  /// - To see the error code, see [AdError.code].
  /// - To see a description of the error, see [AdError.message].
  final void Function(String? message)? onAdViewFailed;

  /// Invokes this callback when the ad did present for a user with info about the impression.
  /// Deprecated note: Use [BannerWidget.onImpressionListener] and [OnAdImpressionListener] to get impression info.
  final void Function()? _onAdViewPresented;

  /// Invokes this callback when a user clicks the ad.
  final void Function()? onAdViewClicked;

  const AdViewListener({
    Function()? this.onAdViewLoaded,
    Function(String? message)? this.onAdViewFailed,
    Function()? onAdViewPresented,
    Function()? this.onAdViewClicked,
  }) : _onAdViewPresented = onAdViewPresented;
}

@Deprecated("Please migrate to new CASBanner.createAndLoad() and CASWidget")
typedef BannerView = BannerWidget;

/// WARNING: This API is still supported but no longer recommended.
/// Migrate to new [CASWidget] with [CASBanner] implementation.
class BannerWidget extends StatefulWidget {
  /// The unique identifier for the CAS content, typically an application bundle name.
  final String? casId;

  /// Through the use of [AdViewListener], you can listen for banner ads events.
  final AdViewListener? adListener;

  /// Gets or sets the listener for ad impression events.
  ///
  /// This listener is notified when an ad impression is recorded and will be paid. It allows you to track when
  /// the ad has been successfully shown and the impression has been accounted for. You can use this to handle
  /// actions that should occur upon a successful ad impression, such as logging or updating analytics.
  final OnAdImpressionListener? onImpressionListener;

  /// Current banner ad size.
  ///
  /// If autoload disabled ([isAutoloadEnabled] = false) then please call [load] after banner size changed.
  final AdSize size;

  /// A Boolean value that determines whether autoloading of ads in the receiver is enabled.
  /// If enabled, you do not need to call the [load] method to load ads.
  final bool? isAutoloadEnabled;

  /// Set the number of seconds an ad is displayed before a new ad is shown.
  /// After the interval has passed, a new advertisement will be automatically loaded.
  /// - This value will override global [AdsSettings.bannerRefreshInterval]
  final int? refreshInterval;

  const BannerWidget({
    super.key,
    this.casId,
    this.adListener,
    this.onImpressionListener,
    this.size = AdSize.banner,
    this.isAutoloadEnabled,
    this.refreshInterval,
  });

  @override
  State<StatefulWidget> createState() {
    return BannerWidgetState();
  }
}

@Deprecated("Please migrate to new CASBanner.createAndLoad() and CASWidget")
typedef BannerViewState = BannerWidgetState;

@Deprecated("Please migrate to new CASBanner.createAndLoad() and CASWidget")
class BannerWidgetState extends State<BannerWidget> {
  String? _casId;
  AdViewListener? _adListener;
  OnAdImpressionListener? _adImpressionListener;
  AdSize? _adSize;
  CASBanner? _bannerAd;
  bool? _isAutoload;
  int? _refreshInterval;

  /// See [BannerWidget.casId]
  Future<String> getCASId() {
    String? casId = _casId;
    if (mounted) {
      casId ??= widget.casId;
    }
    return Future.value(casId ?? '');
  }

  /// See [BannerWidget.casId]
  Future<void> setCASId(String casId) {
    _casId = casId;
    return Future.value();
  }

  /// Through the use of [AdViewListener], you can listen for banner ads events.
  void setAdListener(AdViewListener listener) {
    _adListener = listener;
  }

  /// Gets or sets the listener for ad impression events.
  ///
  /// This listener is notified when an ad impression is recorded and will be paid. It allows you to track when
  /// the ad has been successfully shown and the impression has been accounted for. You can use this to handle
  /// actions that should occur upon a successful ad impression, such as logging or updating analytics.
  void setOnImpressionListener(OnAdImpressionListener listener) {
    _adImpressionListener = listener;
  }

  /// See [BannerWidget.size]
  Future<void> setSize(AdSize size) async {
    if (_bannerAd != null && size != _bannerAd!.size) {
      _bannerAd?.dispose();
      _bannerAd = null;
      _adSize = size;
      if (mounted) {
        setState(() {});
      }
      if (await isAutoloadEnabled()) {
        await load();
      }
    } else {
      _adSize = size;
    }
  }

  AdSize _getSize() {
    AdSize? size = _adSize;
    if (mounted) {
      size ??= widget.size;
    }
    return size ?? AdSize.banner;
  }

  /// Indicates whether the ad is currently loaded and ready to be shown.
  Future<bool> isLoaded() {
    if (_bannerAd != null) {
      return Future.value(_bannerAd!.isLoaded());
    }
    return Future.value(false);
  }

  /// Information about the currently loaded ad.
  ///
  /// This property is `null` if the ad has not been loaded yet or has been destroyed.
  Future<AdContentInfo?> getContentInfo() async {
    return _bannerAd?.getContentInfo();
  }

  /// See [BannerWidget.isAutoloadEnabled]
  Future<bool> isAutoloadEnabled() {
    bool? autoload = _isAutoload;
    if (mounted) {
      autoload ??= widget.isAutoloadEnabled;
    }
    return Future.value(
        autoload ?? !casInternalBridge.deprecatedManualLoadUsed);
  }

  /// See [BannerWidget.isAutoloadEnabled]
  Future<void> setAutoloadEnabled(bool isEnabled) {
    _isAutoload = isEnabled;
    if (_bannerAd != null) {
      return _bannerAd!.setAutoReloadEnabled(isEnabled);
    }
    return Future.value();
  }

  /// Manual load Banner Ad or reload current loaded Ad to skip impression.
  /// - If autoload disabled ([isAutoloadEnabled] = false) then you should use [load] before present ad.
  /// - You can get a callback for the successful loading of an ad by subscribe to [loadCallback].
  Future<void> load() {
    if (_bannerAd != null) {
      return _bannerAd!.load();
    }
    _createAndLoad();
    return Future.value();
  }

  /// See [BannerWidget.refreshInterval]
  Future<int> getRefreshInterval() {
    int? interval = _refreshInterval;
    if (interval != null) {
      return Future.value(_refreshInterval);
    }
    if (mounted) {
      interval ??= widget.refreshInterval;
    }
    return Future.value(
        interval ?? casInternalBridge.defaultBannerRefreshInterval);
  }

  /// See [getRefreshInterval]
  Future<void> setRefreshInterval(int interval) {
    _refreshInterval = interval;
    if (_bannerAd != null) {
      return _bannerAd!.setRefreshInterval(interval);
    }
    return Future.value();
  }

  /// Disable auto refresh ads.
  Future<void> disableAdRefresh() {
    _refreshInterval = 0;
    if (_bannerAd != null) {
      return _bannerAd!.setRefreshInterval(0);
    }
    return Future.value();
  }

  /// Disposes ad in the Banner View.
  /// Call when banner ad is no longer needed.
  /// Automatically called when the widget is removed from the widget tree.
  @override
  Future<void> dispose() async {
    super.dispose();

    if (_bannerAd != null) {
      _bannerAd!.dispose();
    }
    _bannerAd = null;
    _isAutoload = false;
  }

  @Deprecated('Use BannerWidgetState.isLoaded instead')
  Future<bool> isAdReady() => isLoaded();

  @Deprecated('Use BannerWidgetState.load instead')
  Future<void> loadNextAd() => load();

  @override
  void initState() {
    super.initState();
    if (_bannerAd == null) {
      _createAndLoad();
    }
  }

  @override
  void didUpdateWidget(covariant BannerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_bannerAd != null && _bannerAd!.size != widget.size) {
      _bannerAd?.dispose();
      _createAndLoad();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null) {
      return CASWidget(ad: _bannerAd!);
    }
    return const SizedBox(width: 1, height: 1);
  }

  void _createAndLoad() {
    String? casId = _casId;
    bool? autoload = _isAutoload;
    int? interval = _refreshInterval;
    if (mounted) {
      casId ??= widget.casId;
      autoload ??= widget.isAutoloadEnabled;
      interval ??= widget.refreshInterval;
    }

    _bannerAd = CASBanner.createAndLoad(
      size: _getSize(),
      casId: casId,
      autoReload: autoload ?? !casInternalBridge.deprecatedManualLoadUsed,
      refreshInterval:
          interval ?? casInternalBridge.defaultBannerRefreshInterval,
      onAdLoaded: _handleLoaded,
      onAdFailedToLoad: _handleFailedToLoad,
      onAdClicked: _handleClicked,
      onAdImpression: _handleImpression,
    );
  }

  void _handleLoaded(AdViewInstance ad) {
    _adListener?.onAdViewLoaded?.call();
    if (mounted) {
      widget.adListener?.onAdViewLoaded?.call();
    }
  }

  void _handleFailedToLoad(AdInstance ad, AdError error) {
    _adListener?.onAdViewFailed?.call(error.message);
    if (mounted) {
      widget.adListener?.onAdViewFailed?.call(error.message);
    }
  }

  void _handleClicked(AdInstance ad) {
    _adListener?.onAdViewClicked?.call();
    if (mounted) {
      widget.adListener?.onAdViewClicked?.call();
    }
  }

  void _handleImpression(AdInstance ad, AdContentInfo info) {
    _adImpressionListener?.onAdImpression.call(info);
    if (mounted) {
      widget.onImpressionListener?.onAdImpression.call(info);
      widget.adListener?._onAdViewPresented?.call();
    }
  }
}
