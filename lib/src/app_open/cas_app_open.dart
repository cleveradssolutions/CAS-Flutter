import '../mediation_manager.dart';
import '../sdk/screen/cas_app_open.dart' as new_impl;
import '../sdk/screen/internal/cas_app_open_impl.dart';

@Deprecated('Use sdk/screen/cas_app_open.dart instead')
abstract class CASAppOpen {
  static new_impl.CASAppOpen create(String managerId) {
    return CASAppOpenImpl(managerId);
  }

  static Future<new_impl.CASAppOpen> createFromManager(
      MediationManager manager) async {
    final managerId = await manager.getManagerID();
    return CASAppOpenImpl(managerId);
  }
}
