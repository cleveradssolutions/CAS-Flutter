import 'dart:async';

import 'package:clever_ads_solutions/src/internal/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../ad_impression.dart';
import '../../ad_size.dart';
import '../../internal/ad_size_impl.dart';
import '../../internal/mapped_object.dart';
import '../../sdk/screen/internal/ad_mapped_object.dart';
import '../ad_view_listener.dart';
import '../banner_widget.dart';

const String _viewType = '<cas-banner-view>';

class BannerWidgetStateImpl extends BannerWidgetState
    with MappedObjectImpl, AdMappedObject {
  AdViewListener? _adListenerField;

  AdViewListener? get _adListener =>
      _adListenerField ?? widget.adListener ?? widget.listener;

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
      size.future.then((value) {
        setState(() {
          logDebug(
              'BannerWidgetStateImpl -> initState() -> await future size, setState()');
          _size = value;
        });
      });
    } else {
      _size = size;
    }
  }

  @override
  void didUpdateWidget(BannerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // final size = widget.size;
    // if (oldWidget.size != size) {
    //   setSize(size);
    // }
    _updateSize();
  }

  void _updateSize() async {
    logDebug(
        'BannerWidgetStateImpl -> _updateSize()');
    final oldSize = _size;
    _size = null;

    AdSize size = widget.size;
    if (size is FutureAdSize) {
      size = await size.future;
    }
    if (size != oldSize) {
      await setSize(size);
      setState(() {
        logDebug(
            'BannerWidgetStateImpl -> _updateSize() -> widget size changed, setState()');
      });
    } else {
      _size = oldSize;
    }
  }

  @override
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAdViewLoaded':
        _adListener?.onLoaded();
        break;
      case 'onAdViewFailed':
        _adListener?.onFailed(call.arguments['error']);
        break;
      case 'onAdViewPresented':
        _adListener?.onAdViewPresented();
        final data = call.arguments;
        _adListener?.onImpression(AdImpression(
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
        _adListener?.onClicked();
        break;

      case 'onAdImpression':
        widget.onImpressionListener
            ?.onAdImpression(getContentInfoFromCall(call));
        break;

      case 'updateWidgetSize':
        final completer = Completer<void>();

        setState(() {
          final data = call.arguments;
          _width = data['width'] as double;
          _height = data['height'] as double;
          logDebug(
              'BannerWidgetStateImpl -> handleMethodCall() -> Set widget state with width $_width and height $_height, setState()');
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          completer.complete();
        });

        return completer.future;
    }
  }

  final GlobalKey _sizedBoxKey = GlobalKey();
  final GlobalKey _androidViewKey = GlobalKey();
  final GlobalKey _uiKitViewKey = GlobalKey();
  final GlobalKey _placeholderKey = GlobalKey();

  int _updates = 0;

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
          key: _androidViewKey,
          viewType: _viewType,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          // onPlatformViewCreated: _onPlatformViewCreated,
        );
        break;
      case TargetPlatform.iOS:
        platformWidget = UiKitView(
          key: _uiKitViewKey,
          viewType: _viewType,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
        break;
      default:
        return SizedBox(
          key: _placeholderKey,
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
      final dpr = MediaQuery.of(context).devicePixelRatio;
      final pixel = 1.0 / dpr;
      width = pixel;
      height = pixel;
    }

    // змінюється розмір SizedBox, і в child стає неправильна позиція
    final parent = SizedBox(
      key: _sizedBoxKey,
      width: width,
      height: height,
      child: platformWidget,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      logDebug('>   >   >   >   >   >   >   >   >   >   >');
      logDebug('Build[${++_updates}] widget with size $width $height');
      _printWidgetInfo(_sizedBoxKey, "SizedBox");
      _printWidgetInfo(_androidViewKey, "AndroidView");
      _printWidgetInfo(_uiKitViewKey, "UiKitView");
      _printWidgetInfo(_placeholderKey, "Placeholder");
      logDebug('_   _   _   _   _   _   _   _   _   _   _');
    });

    return parent;
  }

  void _printWidgetInfo(GlobalKey key, String name) {
    final context = key.currentContext;
    if (context != null) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      logDebug('$name position: (${position.dx}, ${position.dy})');
      logDebug('$name size: ${renderBox.size}');
    }
  }

  @override
  Future<String> getCASId() async {
    final String? casId = await invokeMethod<String>('getCASId');
    return casId ?? '';
  }

  @override
  Future<void> setCASId(String casId) {
    return invokeMethod('setCASId', {'casId': casId});
  }

  @override
  void setAdListener(AdViewListener listener) {
    _adListenerField = listener;
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
  Future<bool> isLoaded() async {
    final bool? isLoaded = await invokeMethod<bool>('isLoaded');
    return isLoaded ?? false;
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
  Future<void> load() {
    if (_sizeChanged) {
      _sizeChanged = false;
      setState(() {
        logDebug('BannerWidgetStateImpl -> load() -> setState()');
      });
    }
    return invokeMethod('load');
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
    return invokeMethod('disableAdRefresh');
  }

  @override
  Future<void> dispose() {
    destroy();
    super.dispose();
    return invokeMethod('dispose');
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
