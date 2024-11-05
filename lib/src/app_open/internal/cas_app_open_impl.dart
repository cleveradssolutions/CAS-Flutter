import 'package:flutter/services.dart';

import '../../ad_callback.dart';
import '../../ad_error.dart';
import '../../mediation_manager.dart';
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
  AdCallback? contentCallback;

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
    }
  }

  @override
  Future<void> loadAd(LoadAdCallback? callback) {
    _loadCallback = callback;
    return _channel.invokeMethod('loadAd');
  }

  @override
  Future<void> show() {
    return _channel.invokeMethod('show');
  }

  @override
  Future<void> setImmersiveMode(bool enabled) {
    return _channel.invokeMethod('setImmersiveMode', {'enabled': enabled});
  }

  @override
  Future<bool> isAdAvailable() async {
    return await _channel.invokeMethod<bool>('isAdAvailable') ?? false;
  }
}
