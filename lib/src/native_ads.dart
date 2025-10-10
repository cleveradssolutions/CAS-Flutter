part of 'ad_instances.dart';

/// Indicates preferred location of AdChoices icon.
enum AdChoicesPlacement {
  /// Top left corner.
  topLeftCorner,

  /// Top right corner.
  topRightCorner,

  /// Bottom right corner.
  bottomRightCorner,

  /// Bottom left corner.
  bottomLeftCorner
}

/// A Native Ad Content.
///
/// Native ads are ad assets that are presented to users via UI components that
/// are native to the platform.
///
/// To display this ad, instantiate an [CASWidget] with this as a parameter after
/// calling [onAdLoaded].
class CASNativeContent extends AdViewInstance {
  CASNativeContent._({
    this.factoryId,
    super.onAdLoaded,
    super.onAdFailedToLoad,
    super.onAdImpression,
    super.onAdClicked,
    this.customOptions,
  }) : super(format: AdFormat.native);

  /// Create [CASNativeContent] and load ad content.
  ///
  /// Typically you will override [onAdLoaded] and [onAdFailedToLoad]:
  /// ```dart
  /// CASNativeContent.load(
  ///   onAdLoaded: (ad) {
  ///     // Ad successfully loaded - display an CASWidget with the native ad.
  ///     _nativeAd = ad;
  ///   },
  ///   onAdFailedToLoad: (ad, error) {
  ///     // Ad failed to load - log the error.
  ///   }
  /// )
  /// ```
  ///
  /// - [casId] - The unique identifier of the CAS content for each platform.
  /// Leave blank to use the initialization identifier.
  /// - [factoryId] - An identifier for the platform factory that creates the Platform view.
  /// If you do not provide a [factoryId] for the native factory, CAS will build
  /// a default template view based on the size you specify for the [CASWidget].
  /// - [adChoicesPlacement] - Where to place the AdChoices icon.
  /// - [startVideoMuted] - If enabled, the videos will start muted.
  /// - [templateStyle] - Style options for native templates.
  /// The style is also applied to the view created in the custom factory.
  /// - [customOptions] - These options are passed to the platform's `NativeAdFactory`.
  /// - [onAdLoaded] - Callback to be invoked when the ad content has been successfully loaded.
  /// - [onAdFailedToLoad] - Callback to be invoked when the ad content fails to load.
  /// - [onAdImpression] - Callback to be invoked when an ad is estimated to have earned money.
  /// - [onAdClicked] - Callback to be invoked when the ad content is clicked by the user.
  static void load({
    String? casId,
    String? factoryId,
    AdChoicesPlacement adChoicesPlacement = AdChoicesPlacement.topRightCorner,
    bool startVideoMuted = true,
    NativeTemplateStyle? templateStyle,
    Map<String, Object>? customOptions,
    required OnAdViewCallback onAdLoaded,
    OnAdFailedCallback? onAdFailedToLoad,
    OnAdContentCallback? onAdImpression,
    OnAdCallback? onAdClicked,
  }) {
    final CASNativeContent ad = CASNativeContent._(
      factoryId: factoryId,
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
      onAdImpression: onAdImpression,
      onAdClicked: onAdClicked,
      customOptions: customOptions,
    );

    casInternalBridge.createAdInstance(
        ad: ad,
        shouldLoad: true,
        casId: casId,
        arguments: <String, dynamic>{
          'factoryId': factoryId,
          'adChoicesPlacement': adChoicesPlacement.index,
          'startVideoMuted': startVideoMuted,
          'customOptions': customOptions,
          'templateStyle': templateStyle,
        });
  }

  /// An identifier for the factory that creates the Platform view.
  final String? factoryId;

  /// Optional options used to create the [CASNativeContent].
  ///
  /// These options are passed to the platform's `NativeAdFactory`.
  Map<String, Object>? customOptions;
}

/// Style options for native templates.
///
/// Can be used when loading a [CASNativeContent].
class NativeTemplateStyle {
  /// Create a [NativeTemplateStyle].
  ///
  /// All options can be set to null to use default template style.
  NativeTemplateStyle({
    this.backgroundColor,
    this.primaryColor,
    this.primaryTextColor,
    this.headlineTextColor,
    this.headlineFontStyle,
    this.secondaryTextColor,
    this.secondaryFontStyle,
  });

  /// The background color.
  final Color? backgroundColor;

  /// The primary color for Call to action button background.
  final Color? primaryColor;

  /// The text color for Call To Action button.
  final Color? primaryTextColor;

  /// The Headline text color.
  final Color? headlineTextColor;

  /// The Headline text font style.
  final NativeTemplateFontStyle? headlineFontStyle;

  /// The Secondary (other) text color.
  final Color? secondaryTextColor;

  /// The Secondary (other) text font style.
  final NativeTemplateFontStyle? secondaryFontStyle;
}

/// Font types for native templates.
enum NativeTemplateFontStyle {
  /// Default text
  normal,

  /// Bold
  bold,

  /// Italic
  italic,

  /// Monospace
  monospace
}
