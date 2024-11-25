import 'package:flutter/services.dart';

import '../../ad_error.dart';
import '../../ad_impression.dart';
import '../../internal/mapped_object.dart';
import '../app_open_ad_listener.dart';
import '../cas_app_open.dart';
import '../load_ad_callback.dart';

class CASAppOpenImpl extends MappedObject implements CASAppOpen {
  @override
  String managerId;

  LoadAdCallback? _loadCallback;
  @override
  AppOpenAdListener? contentCallback;

  CASAppOpenImpl(this.managerId)
      : super('cleveradssolutions/app_open', managerId) {
    channel.setMethodCallHandler(handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAdLoaded':
        _loadCallback?.onAdLoaded();
        break;
      case 'onAdFailedToLoad':
        _loadCallback?.onAdFailedToLoad(AdError(call.arguments));
        break;
      case 'onShown':
        final callback = contentCallback;
        if (callback != null) {
          callback.onShown();
          callback.onImpression(AdImpression.tryParse(call));
        }
        break;
      case 'onShowFailed':
        contentCallback?.onShowFailed(call.arguments);
        break;
      case 'onClosed':
        contentCallback?.onClosed();
        break;
    }
  }

  @override
  Future<void> loadAd(LoadAdCallback? callback) {
    _loadCallback = callback;
    return invokeMethod('loadAd');
  }

  @override
  Future<bool> isAdAvailable() async {
    return await invokeMethod<bool>('isAdAvailable') ?? false;
  }

  @override
  Future<void> show() {
    return invokeMethod('show');
  }
}
