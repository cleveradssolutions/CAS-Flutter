import 'package:flutter/services.dart';

import '../../ad_error.dart';
import '../../ad_impression.dart';
import '../../mediation_manager.dart';
import '../app_open_ad_listener.dart';
import '../cas_app_open.dart';
import '../load_ad_callback.dart';

class CASAppOpenImpl extends CASAppOpen {
  static const MethodChannel _channel =
      MethodChannel("cleveradssolutions/app_open");

  @override
  String managerId;
  MediationManager? manager;
  bool immersiveModeEnabled = false;

  LoadAdCallback? _loadCallback;
  @override
  AppOpenAdListener? contentCallback;

  CASAppOpenImpl(this.managerId, [this.manager]) {
    _channel.setMethodCallHandler(handleMethodCall);
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
        contentCallback?.onShown();
        break;
      case 'onImpression':
        contentCallback?.onImpression(AdImpression.tryParse(call));
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
    return _channel.invokeMethod('loadAd');
  }

  @override
  Future<bool> isAdAvailable() async {
    return await _channel.invokeMethod<bool>('isAdAvailable') ?? false;
  }

  @override
  Future<void> show() {
    return _channel.invokeMethod('show');
  }
}
