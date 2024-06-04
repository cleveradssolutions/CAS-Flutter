import 'dart:async';
import 'dart:io';

import 'package:clever_ads_solutions/public/AdImpression.dart';
import 'package:clever_ads_solutions/public/AdSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'AdViewListener.dart';

const String _viewType = '<cas-banner-view>';
final _stream = EventChannel('com.cleveradssolutions.cas.ads.flutter.bannerview')
    .receiveBroadcastStream()
    .map((event) => BannerViewChannelEvent(event["id"], event["event"], event["data"]));

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

  BannerView({
    Key? key,
    this.size = AdSize.Banner,
    this.isAutoloadEnabled,
    this.refreshInterval,
    this.maxWidthDpi,
    this.listener
  }): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BannerViewState(
      size: size,
      isAutoloadEnabled: isAutoloadEnabled,
      refreshInterval: refreshInterval,
      maxWidthDpi: maxWidthDpi,
      listener: listener,
      id: id
    );
  }

}

class BannerViewState extends State<BannerView> {
  final AdSize size;
  final bool? isAutoloadEnabled;
  final int? refreshInterval;
  final int? maxWidthDpi;
  final AdViewListener? listener;
  final String id;
  late MethodChannel _channel;
  late StreamSubscription<BannerViewChannelEvent> sub;

  BannerViewState({
    this.size = AdSize.Banner,
    this.isAutoloadEnabled,
    this.refreshInterval,
    this.maxWidthDpi,
    this.listener,
    this.id = ""
  }) {
    _channel = MethodChannel('com.cleveradssolutions.cas.ads.flutter.bannerview.$id');
    sub = _stream
        .listen((event) {
          if (event.id == id) {
            handleEvent(event);
          }
        });
  }

  void handleEvent(BannerViewChannelEvent event) {
    if (event.event == "onAdViewLoaded") {
      listener?.onLoaded();
    } else if (event.event == "onAdViewFailed") {
      listener?.onFailed(event.data as String);
    } else if (event.event == "onAdViewPresented") {
      var data = (event.data as Map<Object?, Object?>).cast<String, dynamic>();
      listener?.onAdViewPresented();
      listener?.onImpression(
          AdImpression(
              data["adType"] as int,
              data["cpm"] as double,
              data["network"] as String? ?? data["networkName"] as String,
              data["priceAccuracy"] as int,
              data["versionInfo"] as String,
              data["creativeIdentifier"] as String?,
              data["identifier"] as String,
              data["impressionDepth"] as int,
              data["lifetimeRevenue"] as double? ?? data["lifeTimeRevenue"] as double)
      );
    } else if (event.event == "onAdViewClicked") {
      listener?.onClicked();
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
    final AdSize _size = size == AdSize.Smart ? isTablet ? AdSize.Leaderboard : AdSize.Banner : size;

    Map<String, dynamic> creationParams = <String, dynamic>{
       "id": id,
       "size": <String, dynamic> {
         "size": _size.index + 1,
         "maxWidthDpi": maxWidthDpi,
         "isAdaptive": _size == AdSize.Adaptive
       },
       "isAutoloadEnabled": isAutoloadEnabled,
       "refreshInterval": refreshInterval,
    };

    return SizedBox(
      width: _sizes[_size]?.width ?? 0,
      height: _sizes[_size]?.height ?? 0,
      child: Platform.isAndroid ? AndroidView(
        viewType: _viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      ) : UiKitView(
        viewType: _viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      )
    );
  }
}