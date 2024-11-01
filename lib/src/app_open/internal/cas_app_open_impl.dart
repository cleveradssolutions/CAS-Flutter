import 'package:flutter/services.dart';

import '../../ad_callback.dart';
import '../../ad_load_callback.dart';
import '../../mediation_manager.dart';
import '../cas_app_open.dart';

class CASAppOpenImpl extends CASAppOpen {
  static const MethodChannel _channel =
      MethodChannel("com.cleveradssolutions.plugin.flutter/app_open");

  @override
  String managerId;
  MediationManager? manager;
  bool immersiveModeEnabled = false;

  AdLoadCallback? _loadCallback;
  AdCallback? contentCallback;

  CASAppOpenImpl(this.managerId, [this.manager]);

  @override
  void loadAd(AdLoadCallback? callback) {}

  @override
  void show() {}

  @override
  void setImmersiveMode(bool enabled) {}

  @override
  Future<bool> isAdAvailable() async {
    return await _channel.invokeMethod<bool>('isAdAvailable') ?? false;
  }
}
