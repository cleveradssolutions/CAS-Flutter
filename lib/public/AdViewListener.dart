import 'package:clever_ads_solutions/public/AdImpression.dart';

abstract class AdViewListener {
  void onAdViewPresented();
  void onLoaded();
  void onImpression(AdImpression? adImpression);
  void onFailed(String? message);
  void onClicked();
}
