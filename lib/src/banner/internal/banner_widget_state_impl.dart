import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ad_impression.dart';
import '../../ad_size.dart';
import '../../internal/ad_size_impl.dart';
import '../../internal/mapped_object.dart';
import '../ad_view_listener.dart';
import '../banner_widget.dart';

const String _viewType = '<cas-banner-view>';

class BannerWidgetStateImpl extends BannerWidgetState with MappedObjectImpl {
  AdViewListener? _listenerField;

  AdViewListener? get _listener => _listenerField ?? widget.listener;

  AdSize? _size;
  bool _sizeChanged = false;

  double _width = 0;
  double _height = 0;

  @override
  void initState() {
    super.initState();
    init('cleveradssolutions/banner', null, true);

    final size = widget.size;
    if (size is FutureAdSize) {
      size.future.then((value) => setState(() {
            _size = value;
          }));
    } else {
      _size = size;
    }
  }

  @override
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAdViewLoaded':
        _listener?.onLoaded();
        break;
      case 'onAdViewFailed':
        _listener?.onFailed(call.arguments);
        break;
      case 'onAdViewPresented':
        _listener?.onAdViewPresented();
        final data = call.arguments;
        _listener?.onImpression(AdImpression(
          data['adType'] as int,
          data['cpm'] as double,
          data['networkName'] as String,
          data['priceAccuracy'] as int,
          data['versionInfo'] as String,
          data['creativeIdentifier'] as String?,
          data['identifier'] as String,
          data['impressionDepth'] as int,
          data['lifetimeRevenue'] as double,
        ));
        break;
      case 'onAdViewClicked':
        _listener?.onClicked();
        break;

      case 'updateWidgetSize':
        setState(() {
          final data = call.arguments;
          _width = data['width'] as double;
          _height = data['height'] as double;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    AdSize? size = _size;
    if (size == null) {
      return const SizedBox.shrink();
    }
    if (size == AdSize.Smart) {
      size = AdSize.getSmartBanner(context);
    }

    Map<String, dynamic> creationParams = <String, dynamic>{
      'id': id,
      'size': _sizeToMap(size, widget.maxWidthDpi),
      'isAutoloadEnabled': widget.isAutoloadEnabled,
      'refreshInterval': widget.refreshInterval,
    };

    dynamic platformWidget;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        platformWidget = AndroidView(
          viewType: _viewType,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          // onPlatformViewCreated: _onPlatformViewCreated,
        );
        break;
      case TargetPlatform.iOS:
        platformWidget = UiKitView(
          viewType: _viewType,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
        break;
      default:
        return SizedBox(
          width: size.width.toDouble(),
          height: size.height.toDouble(),
          child: const Center(child: Text('Platform is not supported')),
        );
    }

    final isSizeCalculated = _width != 0;
    double width;
    double height;
    if (isSizeCalculated) {
      width = _width;
      height = _height;
    } else {
      width = size.width.toDouble();
      height = size.height.toDouble();
    }

    return SizedBox(
      width: width,
      height: height,
      child: platformWidget,
    );
  }

  @override
  Future<void> dispose() {
    super.dispose();
    return invokeMethod('dispose');
  }

  @override
  void setAdListener(AdViewListener listener) {
    _listenerField = listener;
  }

  @override
  Future<void> setSize(AdSize size) async {
    if (size is FutureAdSize) {
      size = await size.future;
    }
    _size = size;
    _sizeChanged = true;
    return invokeMethod('setSize', _sizeToMap(size, widget.maxWidthDpi));
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
    if (_sizeChanged) {
      _sizeChanged = false;
      setState(() {});
    }
    return invokeMethod('loadNextAd');
  }

  Map<String, dynamic> _sizeToMap(AdSize size, int? maxWidthDpi) {
    return <String, dynamic>{
      'width': size.width,
      'height': size.height,
      'mode': (size as AdSizeBase).mode,
      'maxWidthDpi': maxWidthDpi,
      'isAdaptive': size == AdSize.Adaptive
    };
  }
}
