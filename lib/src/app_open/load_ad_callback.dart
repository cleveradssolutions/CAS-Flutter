import '../ad_error.dart';
import '../sdk/screen/screen_ad_content_callback.dart';

@Deprecated('Use sdk/screen/screen_ad_content_callback.dart instead')
class LoadAdCallback extends ScreenAdContentCallback {
  LoadAdCallback({
    required Function() onAdLoaded,
    required Function(AdError) onAdFailedToLoad,
  }) : super(
          onAdLoaded: (ad) => onAdLoaded,
          onAdFailedToLoad: (format, error) => onAdFailedToLoad(error),
          onAdShowed: (ad) {},
          onAdFailedToShow: (format, error) {},
          onAdClicked: (ad) {},
          onAdDismissed: (ad) {},
        );
}
