import '../mediation_manager.dart';
import 'app_open_ad_listener.dart';
import 'internal/cas_app_open_impl.dart';
import 'load_ad_callback.dart';

abstract class CASAppOpen {
  static CASAppOpen create(String managerId) {
    return CASAppOpenImpl(managerId);
  }

  static Future<CASAppOpen> createFromManager(MediationManager manager) async {
    final managerId = await manager.getManagerID();
    return CASAppOpenImpl(managerId);
  }

  /// Returns the ad manager ID.
  abstract String managerId;

  /// Registers a callback to be invoked when ads show and dismiss full screen content.
  abstract AppOpenAdListener? contentCallback;

  /// Loads an AppOpenAd.
  ///
  /// Note: You must keep a strong link throughout the ad's lifecycle.
  ///
  /// @param context The context.
  /// @param callback An object that handles events for loading an app open ad.
  Future<void> loadAd(LoadAdCallback? callback);

  /// Indicates whether the ad is currently loaded and ready to be shown.
  Future<bool> isAdAvailable();

  /// Shows the AppOpenAd.
  ///
  /// @param activity The activity from which the AppOpenAd is shown from.
  Future<void> show();
}
