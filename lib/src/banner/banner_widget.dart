import "dart:async";

import "package:clever_ads_solutions/src/internal/mapped_object.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../ad_impression.dart";
import "../ad_size.dart";
import "ad_view_listener.dart";

const String _viewType = "<cas-banner-view>";

@Deprecated("Use BannerWidget instead")
typedef BannerView = BannerWidget;

class BannerWidget extends StatefulWidget {
  final String _id = UniqueKey().toString();

  final AdViewListener? listener;

  final AdSize size;
  final bool? isAutoloadEnabled;
  final int? refreshInterval;
  @Deprecated("Use AdSize.getAdaptiveBanner(maxWidthDpi) instead")
  final int? maxWidthDpi;

  BannerWidget(
      {super.key,
      this.size = AdSize.banner,
      this.isAutoloadEnabled,
      this.refreshInterval,
      this.maxWidthDpi,
      this.listener});

  @override
  State<StatefulWidget> createState() {
    return _BannerWidgetState();
  }
}

@Deprecated("Use BannerWidgetState instead")
typedef BannerViewState = BannerWidgetState;

abstract class BannerWidgetState extends State<BannerWidget> {
  /// Through the use of single advanced [AdViewListener], you can listen for ads load events.
  /// Repeats the behavior of [loadCallback] and [contentCallback]
  /// and brings the description of callbacks to a more understandable form.
  void setAdListener(AdViewListener listener);

  /// Current banner ad size.
  ///
  /// If autoload disabled ([isAutoloadEnabled] = false) then please call [loadNextAd] after banner size changed.
  Future<void> setSize(AdSize size);

  /// Check ready banner ads
  Future<bool> isAdReady();

  /// A Boolean value that determines whether autoloading of ads in the receiver is enabled.
  /// If enabled, you do not need to call the [loadNextAd] method to load ads.
  /// - By default enabled if global state [AdsSettings.loadingMode] is NOT [LoadingManagerMode.Manual].
  /// - This value will override global state of [AdsSettings.loadingMode] for specific Banner View.
  Future<bool> isAutoloadEnabled();

  /// See [isAutoloadEnabled]
  Future<void> setAutoloadEnabled(bool isEnabled);

  /// Set the number of seconds an ad is displayed before a new ad is shown.
  /// After the interval has passed, a new advertisement will be automatically loaded.
  /// - This value will override global [AdsSettings.bannerRefreshInterval]
  Future<int> getRefreshInterval();

  /// See [getRefreshInterval]
  Future<void> setRefreshInterval(int interval);

  /// Disable auto refresh ads.
  Future<void> disableAdRefresh();

  /// Manual load Banner Ad or reload current loaded Ad to skip impression.
  /// - If autoload disabled ([isAutoloadEnabled] = false) then you should use [loadNextAd] before present ad.
  /// - This functionality is available only after [CAS.buildManager].
  /// - You can get a callback for the successful loading of an ad by subscribe to [loadCallback].
  Future<void> loadNextAd();

  /// Destroy ad in the Banner View.
  /// Call when banner ad is no longer needed.
  @override
  Future<void> dispose();
}

class _BannerWidgetState extends BannerWidgetState with MappedObjectImpl {
  late AdViewListener? _listener;

  late AdSize _size;
  late bool? _isAutoloadEnabled;
  late int? _refreshInterval;
  late int? _maxWidthDpi;

  @override
  void initState() {
    super.initState();
    init('cleveradssolutions/banner', widget._id, true);
    _listener = widget.listener;
    _size = widget.size;
    _isAutoloadEnabled = widget.isAutoloadEnabled;
    _refreshInterval = widget.refreshInterval;
    _maxWidthDpi = widget.maxWidthDpi;

    channel.setMethodCallHandler(handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "onAdViewLoaded":
        _listener?.onLoaded();
        break;
      case "onAdViewFailed":
        _listener?.onFailed(call.arguments);
        break;
      case "onAdViewPresented":
        _listener?.onAdViewPresented();
        final data = call.arguments;
        _listener?.onImpression(AdImpression(
          data["adType"] as int,
          data["cpm"] as double,
          data["networkName"] as String,
          data["priceAccuracy"] as int,
          data["versionInfo"] as String,
          data["creativeIdentifier"] as String?,
          data["identifier"] as String,
          data["impressionDepth"] as int,
          data["lifetimeRevenue"] as double,
        ));
        break;
      case "onAdViewClicked":
        _listener?.onClicked();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool isTablet = shortestSide > 600;
    final AdSize size = _size == AdSize.Smart
        ? isTablet
            ? AdSize.leaderboard
            : AdSize.banner
        : _size;

    Map<String, dynamic> creationParams = <String, dynamic>{
      'id': id,
      'size': _sizeToMap(size, _maxWidthDpi),
      'isAutoloadEnabled': _isAutoloadEnabled,
      'refreshInterval': _refreshInterval,
    };

    dynamic widget;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        widget = AndroidView(
          viewType: _viewType,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          // onPlatformViewCreated: _onPlatformViewCreated,
        );
        break;
      case TargetPlatform.iOS:
        widget = UiKitView(
          viewType: _viewType,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
        break;
      default:
        widget = const Text("Platform is not supported");
        break;
    }

    return SizedBox(
        width: _size.width.toDouble(),
        height: _size.height.toDouble(),
        child: widget);
  }

  @override
  Future<void> dispose() {
    super.dispose();
    return invokeMethod('dispose');
  }

  @override
  void setAdListener(AdViewListener listener) {
    _listener = listener;
  }

  @override
  Future<void> setSize(AdSize size) {
    return invokeMethod('setSize', _sizeToMap(size, _maxWidthDpi));
  }

  @override
  Future<bool> isAdReady() async {
    final bool? isAdReady = await invokeMethod<bool>('isAdReady');
    return isAdReady ?? false;
  }

  @override
  Future<bool> isAutoloadEnabled() async {
    final bool? isEnabled = await invokeMethod<bool>('isAutoloadEnabled');
    return isEnabled ?? false;
  }

  @override
  Future<void> setAutoloadEnabled(bool isEnabled) {
    return invokeMethod('setAutoloadEnabled', {'isEnabled': isEnabled});
  }

  @override
  Future<int> getRefreshInterval() async {
    final int? interval = await invokeMethod<int>('getRefreshInterval');
    return interval ?? 0;
  }

  @override
  Future<void> setRefreshInterval(int interval) {
    return invokeMethod('setRefreshInterval', {'interval': interval});
  }

  @override
  Future<void> disableAdRefresh() {
    return invokeMethod('disableBannerRefresh');
  }

  @override
  Future<void> loadNextAd() {
    return invokeMethod('loadNextAd');
  }

  Map<String, dynamic> _sizeToMap(AdSize size, int? maxWidthDpi) {
    return <String, dynamic>{
      'width': size.width,
      'height': size.height,
      'mode': size.mode,
      'maxWidthDpi': maxWidthDpi,
      'isAdaptive': size == AdSize.Adaptive
    };
  }
}
