import 'package:clever_ads_solutions/public/ad_impression.dart';

abstract class AdCallback {
  void onShown();

  void onImpression(AdImpression? adImpression);

  void onShowFailed(String? message);

  void onClicked();

  void onComplete();

  void onClosed();
}
