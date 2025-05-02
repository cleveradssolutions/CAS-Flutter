import '../ad_impression.dart';
import '../sdk/ad_content_info.dart';
import '../sdk/screen/screen_ad_content_callback.dart';

@Deprecated('Use sdk/screen/screen_ad_content_callback.dart instead')
class AppOpenAdListener extends ScreenAdContentCallback {
  AppOpenAdListener({
    required Function(AdImpression? adImpression) onShown,
    required Function(String? message) onShowFailed,
    required Function() onClicked,
    required Function(AdImpression? adImpression) onImpression,
    required Function() onClosed,
  }) : super(
          onAdLoaded: (ad) {},
          onAdFailedToLoad: (format, error) {},
          onAdShowed: (ad) async => onShown(await _tryParseAdContentInfo(ad)),
          onAdFailedToShow: (format, error) => onShowFailed(error.message),
          onAdClicked: (ad) => onClicked(),
          onAdDismissed: (ad) => onClosed(),
        );

  static Future<AdImpression> _tryParseAdContentInfo(AdContentInfo info) async {
    return AdImpression(
      (await info.getFormat()).index,
      await info.getRevenue(),
      await info.getSourceName(),
      (await info.getRevenuePrecision()).index,
      '',
      await info.getCreativeId(),
      (await info.getSourceId()).name,
      await info.getImpressionDepth(),
      await info.getRevenueTotal(),
    );
  }
}
