import 'package:flutter/services.dart';

import '../../ad_error.dart';
import '../../ad_impression.dart';
import '../../internal/native_object.dart';
import '../app_open_ad_listener.dart';
import '../cas_app_open.dart';
import '../load_ad_callback.dart';

class CASAppOpenImpl extends NativeObject implements CASAppOpen {
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
        print("CAS.AI.Flutter: onAdLoaded");
        _loadCallback?.onAdLoaded();
        break;
      case 'onAdFailedToLoad':
        print("CAS.AI.Flutter: onAdFailedToLoad");
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
    return channel.invokeMethod('loadAd');
  }

  @override
  Future<bool> isAdAvailable() async {
    return await channel.invokeMethod<bool>('isAdAvailable') ?? false;
  }

  @override
  Future<void> show() {
    return channel.invokeMethod('show');
  }
}
