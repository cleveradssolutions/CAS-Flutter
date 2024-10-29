import '../../ad_callback.dart';
import '../../ad_load_callback.dart';
import '../../mediation_manager.dart';
import '../cas_app_open.dart';

class CASAppOpenImpl extends CASAppOpen {
  @override
  String managerId;
  MediationManager? manager;
  bool immersiveModeEnabled = false;

  AdLoadCallback? _loadCallback;
  AdCallback? _contentCallback;

  CASAppOpenImpl(this.managerId, [this.manager]);

  @override
  void loadAd(AdLoadCallback? callback) {}

  @override
  void show() {}

  @override
  void setImmersiveMode(bool enabled) {}

  @override
  Future<bool> isAdAvailable() {
    return _channel.invokeMethod('isAdAvailable');
  }
}
