import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ad_impression.dart';
import 'ad_size.dart';
import 'ad_view_listener.dart';

const String _viewType = '<cas-banner-view>';

const Map<AdSize, Size> _sizes = {
  AdSize.Banner: Size(320, 50),
  AdSize.Leaderboard: Size(728, 90),
  AdSize.MediumRectangle: Size(300, 250),
  AdSize.Adaptive: Size(728, 90),
};

class BannerView extends StatefulWidget {
  final AdSize size;
  final bool? isAutoloadEnabled;
  final int? refreshInterval;
  final int? maxWidthDpi;
  final AdViewListener? listener;
  final String id = UniqueKey().toString();

  BannerView(
      {super.key,
      this.size = AdSize.Banner,
      this.isAutoloadEnabled,
      this.refreshInterval,
      this.maxWidthDpi,
      this.listener});

  @override
  State<StatefulWidget> createState() {
    return BannerViewState();
  }
}

class BannerViewState extends State<BannerView> {
  late String _id;

  late MethodChannel _channel;
  late StreamSubscription _subscription;
  late AdViewListener? _listener;

  late AdSize _size;
  late bool? _isAutoloadEnabled;
  late int? _refreshInterval;
  late int? _maxWidthDpi;

  @override
  void initState() {
    super.initState();
    _size = widget.size;
    _isAutoloadEnabled = widget.isAutoloadEnabled;
    _refreshInterval = widget.refreshInterval;
    _maxWidthDpi = widget.maxWidthDpi;
    _listener = widget.listener;
    _id = widget.id;
    _channel =
        MethodChannel('com.cleveradssolutions.plugin.flutter/banner_view.$_id');
    _subscription =
        const EventChannel('com.cleveradssolutions.plugin.flutter/banner_view')
            .receiveBroadcastStream()
            .listen((dynamic event) {
      if (event is Map && event["id"] == _id) {
        final eventName = event["event"] as String?;
        if (eventName != null) {
          handleEvent(eventName, event["data"]);
        }
      }
    });
  }

  void handleEvent(String eventName, dynamic data) {
    switch (eventName) {
      case "onAdViewLoaded":
        _listener?.onLoaded();
        break;
      case "onAdViewFailed":
        _listener?.onFailed(data);
        break;
      case "onAdViewPresented":
        _listener?.onAdViewPresented();
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
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<bool> isAdReady() {
    return _channel.invokeMethod<bool>("isAdReady").then((value) => value!);
  }

  Future<void> loadNextAd() {
    return _channel.invokeMethod("loadNextAd");
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool isTablet = shortestSide > 600;
    final AdSize size = this._size == AdSize.Smart
        ? isTablet
            ? AdSize.Leaderboard
            : AdSize.Banner
        : this._size;

    Map<String, dynamic> creationParams = <String, dynamic>{
      "id": _id,
      "size": <String, dynamic>{
        "size": size.index + 1,
        "maxWidthDpi": _maxWidthDpi,
        "isAdaptive": size == AdSize.Adaptive
      },
      "isAutoloadEnabled": _isAutoloadEnabled,
      "refreshInterval": _refreshInterval,
    };

    dynamic widget;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        widget = AndroidView(
          viewType: _viewType,
          // layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
        break;
      case TargetPlatform.iOS:
        widget = UiKitView(
          viewType: _viewType,
          // layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
        break;
      default:
        widget = const Text("Platform is not supported");
        break;
    }

    return SizedBox(
        width: _sizes[size]?.width ?? 0,
        height: _sizes[size]?.height ?? 0,
        child: widget);
  }
}
