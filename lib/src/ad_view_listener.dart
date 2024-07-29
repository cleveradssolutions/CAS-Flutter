import 'ad_impression.dart';

abstract class AdViewListener {
  void onAdViewPresented();

  void onLoaded();

  void onImpression(AdImpression? adImpression);

  void onFailed(String? message);

  void onClicked();
}
