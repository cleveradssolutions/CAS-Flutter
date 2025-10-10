part of 'ad_instances.dart';

/// The base class for ads displayed in a [CASWidget].
abstract class AdViewInstance extends AdInstance {
  /// Default constructor, used by subclasses.
  AdViewInstance({
    required super.format,
    this.onAdLoaded,
    super.onAdFailedToLoad,
    super.onAdClicked,
    super.onAdImpression,
  });

  /// Called when the ad content has been successfully loaded.
  ///
  /// This function provides an opportunity to handle successful ad loading,
  /// such as preparing the ad for display.
  OnAdViewCallback? onAdLoaded;

  /// Returns true if the ad Id is already mounted in a WidgetAd managed
  /// by the instanceManager.
  bool get isMounted {
    return casInternalBridge.isAdWidgetMounted(this);
  }
}

/// Displays an [AdViewInstance] as a Flutter widget.
///
/// This widget takes ads inheriting from [CASBanner] and [CASNativeContent]
/// and allows them to be added to the Flutter widget tree.
class CASWidget extends StatefulWidget {
  /// Create [CASWidget] for [CASBanner] or [CASNativeContent].
  ///
  /// - For [CASNativeContent] is recommended to set both [width] and [height]
  /// for displaying the default template view.
  ///
  /// - For [CASBanner], setting width and height is optional.
  /// If not specified, the widget will automatically match the banner ad size.
  const CASWidget({
    super.key,
    required this.ad,
    this.width,
    this.height,
  });

  /// Ad to be displayed as a widget.
  final AdViewInstance ad;

  /// The width to set for the ad widget.
  /// The value [double.infinity] is not supported for [CASNativeContent].
  final double? width;

  /// The width to set for the ad widget.
  /// The value [double.infinity] is not supported for [CASNativeContent].
  final double? height;

  @override
  State<CASWidget> createState() => _CASWidgetState();
}

class _CASWidgetState extends State<CASWidget> {
  bool _adIdAlreadyMounted = false;

  @override
  void initState() {
    super.initState();
    _adIdAlreadyMounted = !casInternalBridge.tryMountAdWidget(widget.ad);
  }

  @override
  void dispose() {
    super.dispose();
    AdViewInstance ad = widget.ad;
    if (ad is CASBanner) {
      ad._onPlatformViewSizeChanged = null;
    }
    casInternalBridge.unmountAdWidgetId(ad);
  }

  @override
  Widget build(BuildContext context) {
    if (_adIdAlreadyMounted) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('This CASWidget is already in the Widget tree'),
        ErrorHint(
            'If you placed this CASWidget in a list, make sure you create a new instance '
            'in the builder function with a unique ad object.'),
        ErrorHint(
            'Make sure you are not using the same ad object in more than one CASWidget.'),
      ]);
    }

    double width = 0;
    double height = 0;

    final widgetAd = widget.ad;
    if (widgetAd is CASBanner) {
      final Size? platformAdSize = widgetAd.platformViewSize;
      if (platformAdSize != null) {
        width = platformAdSize.width.toDouble();
        height = platformAdSize.height.toDouble();
      }

      widgetAd._onPlatformViewSizeChanged = (ad, size) {
        if (mounted) {
          setState(() {});
        }
      };

      final widgetWidth = widget.width;
      if (widgetWidth != null && widgetWidth > width) {
        width = widgetWidth;
      }
      final widgetHeight = widget.height;
      if (widgetHeight != null && widgetHeight > height) {
        height = widgetHeight;
      }
    } else {
      width = widget.width ?? 350;
      height = widget.height ?? 350;
    }

    if (width < 2 || height < 2) {
      // Platform Ad View is not loaded
      return SizedBox(width: 1, height: 1);
    }

    final String viewType = '${casInternalBridge.channel.name}/ad_widget';
    final Map<String, dynamic> creationParams = {
      'adId': casInternalBridge.adIdFor(widget.ad),
      'width': width.isFinite ? width.truncate() : 350,
      'height': height.isFinite ? height.truncate() : 350
    };

    Widget platformView;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        platformView = PlatformViewLink(
            viewType: viewType,
            surfaceFactory:
                (BuildContext context, PlatformViewController controller) {
              return AndroidViewSurface(
                controller: controller as AndroidViewController,
                gestureRecognizers: const <Factory<
                    OneSequenceGestureRecognizer>>{},
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
              );
            },
            onCreatePlatformView: (PlatformViewCreationParams params) {
              return PlatformViewsService.initSurfaceAndroidView(
                id: params.id,
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: StandardMessageCodec(),
              )
                ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                ..create();
            });
        break;
      case TargetPlatform.iOS:
        platformView = UiKitView(
          viewType: viewType,
          creationParams: creationParams,
          creationParamsCodec: StandardMessageCodec(),
        );
        break;
      default:
        return const SizedBox.shrink();
    }

    return SizedBox(
      width: width,
      height: height,
      child: platformView,
    );
  }
}
