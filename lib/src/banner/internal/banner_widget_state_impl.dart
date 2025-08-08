import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../internal/ad_size_impl.dart';
import '../../internal/mapped_object.dart';
import '../../sdk/screen/internal/ad_mapped_object.dart';
import '../ad_view_listener.dart';
import '../banner_widget.dart';
import '../../ad_size.dart';
import '../../sdk/on_ad_impression_listener.dart';

const String _viewType = '<cas-banner-view>';

class BannerWidgetStateImpl extends BannerWidgetState
    with MappedObjectImpl, AdMappedObject {
  AdViewListener? _adListenerField;
  OnAdImpressionListener? _adImpressionListenerField;

  AdViewListener? get _adListener =>
      widget.adListener ??
      // ignore: deprecated_member_use_from_same_package
      widget.listener ??
      _adListenerField;

  OnAdImpressionListener? get _adImpressionListener =>
      widget.onImpressionListener ?? _adImpressionListenerField;

  AdSize? _size;
  AdSize? _newSize;
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
    _updateSize();
  }

  void _updateSize() async {
    AdSize size = widget.size;
    if (size is FutureAdSize) {
      size = await size.future;
    }
    if (size != _size) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          setState(() {
            _newSize = size;
            _sizeChanged = true;
            _size = null;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_sizeChanged) {
              setState(() {
                _sizeChanged = false;
                _size = _newSize;
              });
            }
          });
          break;
        default:
          setState(() {
            _size = size;
          });
          // ignore: deprecated_member_use_from_same_package
          invokeMethod('setSize', _sizeToMap(size, widget.maxWidthDpi));
      }
    }
  }

  @override
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAdViewLoaded':
        if (_sizeChanged) {
          _sizeChanged = false;

          setState(() {
            _size = _newSize;
          });
        }

        _adListener?.onAdViewLoaded?.call();
        break;
      case 'onAdViewFailed':
        _adListener?.onAdViewFailed?.call(call.arguments['error']);
        break;
      case 'onAdViewClicked':
        _adListener?.onAdViewClicked?.call();
        break;

      case 'onAdImpression':
        _adImpressionListener?.onAdImpression(getContentInfoFromCall(call));
        // ignore: deprecated_member_use_from_same_package
        _adListener?.onAdViewPresented();
        break;

      case 'updateWidgetSize':
        final completer = Completer<void>();

        setState(() {
          final data = call.arguments;
          _width = data['width'] as double;
          _height = data['height'] as double;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          completer.complete();
        });

        return completer.future;
    }
  }

  @override
  Widget build(BuildContext context) {
    AdSize? size = _size;
    if (size == null) {
      return const SizedBox.shrink();
    }
    // ignore: deprecated_member_use_from_same_package
    if (size == AdSize.Smart) {
      size = AdSize.getSmartBanner(context);
    }

    Map<String, dynamic> creationParams = <String, dynamic>{
      'id': id,
      'casId': widget.casId,
      // ignore: deprecated_member_use_from_same_package
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
        return const SizedBox.shrink();
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

    return SizedBox(
      width: width,
      height: height,
      child: platformWidget,
    );
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
  void setOnImpressionListener(OnAdImpressionListener listener) {
    _adImpressionListenerField = listener;
  }

  @override
  Future<void> setSize(AdSize size) async {
    if (size is FutureAdSize) {
      size = await size.future;
    }
    if (size != _size) {
      _newSize = size;
      _sizeChanged = true;
      // ignore: deprecated_member_use_from_same_package
      return invokeMethod('setSize', _sizeToMap(size, widget.maxWidthDpi));
    }
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
    disposeContent();
    _adListenerField = null;
    super.dispose();
    return invokeMethod('dispose');
  }

  Map<String, dynamic> _sizeToMap(AdSize size, int? maxWidthDpi) {
    return <String, dynamic>{
      'width': size.width,
      'height': size.height,
      'mode': (size as AdSizeBase).mode,
      'maxWidthDpi': maxWidthDpi,
      // ignore: deprecated_member_use_from_same_package
      'isAdaptive': size == AdSize.Adaptive
    };
  }
}
