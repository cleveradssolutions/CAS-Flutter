import 'dart:async';
import 'dart:io';

import 'package:clever_ads_solutions/public/ad_impression.dart';
import 'package:clever_ads_solutions/public/ad_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ad_view_listener.dart';

const String _viewType = '<cas-banner-view>';
final _stream =
    const EventChannel('com.cleveradssolutions.cas.ads.flutter.bannerview')
        .receiveBroadcastStream()
        .map((event) =>
            BannerViewChannelEvent(event["id"], event["event"], event["data"]));

const Map<AdSize, Size> _sizes = {
  AdSize.Banner: Size(320, 50),
  AdSize.Leaderboard: Size(728, 90),
  AdSize.MediumRectangle: Size(300, 250),
  AdSize.Adaptive: Size(728, 90),
};

class BannerViewChannelEvent {
  String id;
  String event;
  Object? data;

  BannerViewChannelEvent(this.id, this.event, this.data);
}

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
  late AdSize size;
  late bool? isAutoloadEnabled;
  late int? refreshInterval;
  late int? maxWidthDpi;
  late AdViewListener? listener;
  late String id;
  late MethodChannel _channel;
  late StreamSubscription<BannerViewChannelEvent> sub;

  @override
  void initState() {
    super.initState();
    size = widget.size;
    isAutoloadEnabled = widget.isAutoloadEnabled;
    refreshInterval = widget.refreshInterval;
    maxWidthDpi = widget.maxWidthDpi;
    listener = widget.listener;
    id = widget.id;
    _channel =
        MethodChannel('com.cleveradssolutions.cas.ads.flutter.bannerview.$id');
    sub = _stream.listen((event) {
      if (event.id == id) {
        handleEvent(event);
      }
    });
  }

  void handleEvent(BannerViewChannelEvent event) {
    switch (event.event) {
      case "onAdViewLoaded":
        listener?.onLoaded();
        break;
      case "onAdViewFailed":
        listener?.onFailed(event.data as String);
        break;
      case "onAdViewPresented":
        var data =
            (event.data as Map<Object?, Object?>).cast<String, dynamic>();
        listener?.onAdViewPresented();
        listener?.onImpression(AdImpression(
          data["adType"] as int,
          data["cpm"] as double,
          data["network"] as String? ?? data["networkName"] as String,
          data["priceAccuracy"] as int,
          data["versionInfo"] as String,
          data["creativeIdentifier"] as String?,
          data["identifier"] as String,
          data["impressionDepth"] as int,
          data["lifetimeRevenue"] as double? ??
              data["lifeTimeRevenue"] as double,
        ));
        break;
      case "onAdViewClicked":
        listener?.onClicked();
        break;
    }
  }

  @override
  void dispose() {
    sub.cancel();
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
    final AdSize size = this.size == AdSize.Smart
        ? isTablet
            ? AdSize.Leaderboard
            : AdSize.Banner
        : this.size;

    Map<String, dynamic> creationParams = <String, dynamic>{
      "id": id,
      "size": <String, dynamic>{
        "size": size.index + 1,
        "maxWidthDpi": maxWidthDpi,
        "isAdaptive": size == AdSize.Adaptive
      },
      "isAutoloadEnabled": isAutoloadEnabled,
      "refreshInterval": refreshInterval,
    };

    return SizedBox(
        width: _sizes[size]?.width ?? 0,
        height: _sizes[size]?.height ?? 0,
        child: Platform.isAndroid
            ? AndroidView(
                viewType: _viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
              )
            : UiKitView(
                viewType: _viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
              ));
  }
}
