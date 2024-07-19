import 'package:clever_ads_solutions/public/ad_impression.dart';

abstract class AdViewListener {
  void onAdViewPresented();

  void onLoaded();

  void onImpression(AdImpression? adImpression);

  void onFailed(String? message);

  void onClicked();
}
