import 'ad_impression.dart';

abstract class AdViewListener {
  void onAdViewPresented();

  void onLoaded();

  void onImpression(AdImpression? adImpression);

  void onFailed(String? message);

  void onClicked();
}
/*
class AdViewAdListener extends AdViewListener {
  const AdViewAdListener({
    required Function() onAdViewPresented,
    required Function() onLoaded,
    required Function(AdImpression? adImpression) onImpression,
    required Function(String? message) onFailed,
    required Function() onClicked,
  });

  @override
  void onAdViewPresented() {
    onAdViewPresented();
  }

  @override
  void onClicked() {
    // TODO: implement onClicked
  }

  @override
  void onFailed(String? message) {
    // TODO: implement onFailed
  }

  @override
  void onImpression(AdImpression? adImpression) {
    // TODO: implement onImpression
  }

  @override
  void onLoaded() {
    // TODO: implement onLoaded
  }
}*/
