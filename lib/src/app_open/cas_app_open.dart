import '../ad_callback.dart';
import '../mediation_manager.dart';
import 'internal/cas_app_open_impl.dart';
import 'load_ad_callback.dart';

abstract class CASAppOpen {
  static CASAppOpen create(String managerId) {
    return CASAppOpenImpl(managerId);
  }

  static Future<CASAppOpen> createFromManager(MediationManager manager) async {
    final managerId = await manager.getManagerID();
    return CASAppOpenImpl(managerId, manager);
  }

  /// Returns the ad manager ID.
  abstract String managerId;

  /// Registers a callback to be invoked when ads show and dismiss full screen content.
  abstract AdCallback? contentCallback;

  /// Loads an AppOpenAd.
  ///
  /// Note: You must keep a strong link throughout the ad's lifecycle.
  ///
  /// @param context The context.
  /// @param callback An object that handles events for loading an app open ad.
  void loadAd(LoadAdCallback? callback);

  Future<bool> isAdAvailable();

  /// Sets a flag that controls if this app open ad object will be displayed in immersive mode.
  ///
  /// Call this method before [show].
  /// During show time, if this flag is on and immersive mode is supported,
  /// SYSTEM_UI_FLAG_IMMERSIVE_STICKY & SYSTEM_UI_FLAG_HIDE_NAVIGATION will be turned on for the app open ad.
  void setImmersiveMode(bool enabled);

  /// Shows the AppOpenAd.
  ///
  /// @param activity The activity from which the AppOpenAd is shown from.
  void show();
}
