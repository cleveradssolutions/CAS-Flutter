## 4.6.0
- Updated CAS [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) dependencies to 4.6.0
- [iOS] **This release requires a minimum Xcode version of 26.0.**

## 4.5.4
- Updated CAS [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) dependencies to 4.5.4

## 4.5.3
- [Android] Fixed build error `Unresolved reference 'AdImpression'`.

## 4.5.2
- Updated CAS [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) dependencies to 4.5.2

## 4.5.0
- Updated CAS [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) dependencies to 4.5.0
- Fixed issue #49: support for Flutter 3.0–3.27.  
  > Previously only 3.27+. The plugin has not been tested on every version; using the latest stable Flutter is recommended.

## 4.4.2
- Updated CAS [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) dependencies to 4.4.2

## 4.4.1
- Updated CAS [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) dependencies to 4.4.1
- Renamed `AdError.rejected` to `AdError.codeRejected` for consistency with other error codes.
- Migration to the new [Developer Docs](https://docs.page/cleveradssolutions/docs/Flutter)

## 4.3.0
### Major changes
- Version bumped to 4.3 to align with native SDK versions.
- Completely rewritten Android and iOS platform code for improved performance, stability, and better integration with native SDKs.
- Introduced new `CASMobileAds` class. Deprecated `CAS` and `MediationManager` classes are still available for use but they may be removed in a future release.
- The CAS SDK initialization is now done via a single function `CASMobileAds.initialize(...)` that uses a `Future` to return the new `InitializationStatus` structure.
- The Ad format management has been modernized and streamlined. All ad classes now extend the base AdInstance class and share similar callbacks.
- Introduced `createAndLoad(...)` method for each ad format, accepting all possible configuration options and automatically initiating ad loading. This improvement simplifies and optimizes the creation of ad instances.
- Introduced support for Native Ads using built-in templates or native platform view factories.
- The Banner ad management is now handled via the `CASBanner` class, which can be `createAndLoad()` independently of the widget state and displayed using the new `CASWidget`. Platform view rendering has been optimized by simplifying the widget class.
- The CAS ID only needs to be passed once during initialization if you are using a single ID.
- The `AdContentInfo` structure now provides ad information synchronously, without requiring `await` of `Future`.
- Added the `debugGeography` to override `PrivacyGeography` for `ConsentFlow` to test different consent dialogs.
- The `ConsentFlow.show()` functions now complete `Future<int>` only after the consent form is dismissed and return the resulting consent flow status.
- For detailed information on all new functions, please refer to the updated wiki.
- Removed several functions that were previously deprecated.
### Migration table
Deprecated functions are still supported but no longer recommended.
| Deprecated  | Replacement | 
| ----------- | ----------- | 
| `CAS.buildManager()...` | `CASMobileAds.initialize(...)` | 
| `CAS.targetingOptions...` | `CASMobileAds.targetingOptions...` | 
| `CAS.settings.setMutedAdSounds()` | `CASMobileAds.setAdSoundsMuted()` |
| `CAS.settings.setDebugMode()` | `CASMobileAds.setDebugLoggingEnabled()` |
| `CAS.settings.setTrialAdFreeInterval()` | `CASMobileAds.setTrialAdFreeInterval()` |
| `CAS.settings.setTaggedAudience()` | `CASMobileAds.initialize(targetAudience:)` |
| `CAS.settings.setTestDeviceId()` | `CASMobileAds.initialize(testDeviceIds:)` |
| `CASInterstitial.create()` | `CASInterstitial.createAndLoad(...)` |
| `CASInterstitial.impressionListener` | `CASInterstitial.onAdImpression` |
| `CASInterstitial.contentCallback` | `CASInterstitial.onAdLoaded` and others |
| `CASAppOpen.create()` | `CASAppOpen.createAndLoad(...)` |
| `CASAppOpen.impressionListener` | `CASAppOpen.onAdImpression` |
| `CASAppOpen.contentCallback` | `CASAppOpen.onAdLoaded` and others |
| `CASRewarded.create()` | `CASRewarded.createAndLoad(...)` |
| `CASRewarded.impressionListener` | `CASRewarded.onAdImpression` |
| `CASRewarded.contentCallback` | `CASRewarded.onAdLoaded` and others |
| `OnRewardEarnedListener` | `CASRewarded.onUserEarnedReward` |
| `BannerWidgetState()...` | `CASBanner.createAndLoad(...)` |
| `BannerWidget(...)` | `CASWidget(ad:)` |
| `AdSize.getAdaptiveBannerInScreen()` | `maxWidth = MediaQuery.of(context).size.width`<br>and `AdSize.getAdaptiveBanner(maxWidth)` | 


## 0.9.0
- Updated CAS [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) dependencies to 4.3.0
- Updated `AdError` codes for compatibility with CAS 4.
### Bug Fixes
- Fixed a type mismatch issue in `AdErrorFactory`. [#46](https://github.com/cleveradssolutions/CAS-Flutter/issues/46)
- Fixed an `IndexOutOfRangeException` in `onConsentFlowDismissed()`.
- Fixed a `MissingPluginException` in `CASInterstitial.setMinInterval()`.
- [iOS] Fixed `OnImpressionListener` not being triggered for `BannerWidget`.
### Deprecations
> The following functions are deprecated. They are still supported for now but are not recommended for use in new implementations.

- Deprecated `ConsentFlow.withDismissListener(OnDismissListener)` as it always returns `ConsentStatus.undefined`. Use `ConsentFlow.setOnDismissCallback(OnConsentFlowDismissedCallback)` instead, which provides a valid `int` status. Refer to constants in `ConsentFlow` for status values.
- Deprecated `MediationManager.enableAppReturn()`. Migrate to the new `CASAppOpen` or `CASInterstitial` APIs and enable this feature via the `isAutoshowEnabled` property.
- Deprecated `MediationManager.setAdLoadCallback()` as it's no longer the recommended way to listen for ad loading events. Use the new implementation in individual ad classes instead.
- Deprecated `AdContentInfo.getSourceId()` as it's no longer recommended and will be removed in future versions. Use `getSourceName()` instead.
- Deprecated `AdsSettings.setLoadingMode()` in favor of the new ad class implementation, which provides full control over the ad lifecycle.

## 0.8.9
- Fixed `BannerWidgetStateImpl.dispose` failed to call `super.dispose` issue #45.

## 0.8.8
- [Android] Fixed build failure related to missing style attribute `windowOptOutEdgeToEdgeEnforcement` by increasing `compileSdkVersion` to 35 in the plugin.

## 0.8.7
- Updates CAS [Android](https://github.com/cleveradssolutions/CAS-Android/releases) 4.2.0 and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 4.2.1 dependency

## 0.8.5
- Wraps 4.1.2 [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) SDK.

## 0.8.4
- Hotfix the native [4.1.0.1 iOS](https://github.com/cleveradssolutions/CAS-iOS/releases).

## 0.8.3
- Wraps 4.1.0 [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) SDK.
- Resolved all Flutter/Dart static analysis warnings.

## 0.8.2
### Features
- Wraps [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 4.0.2.1 SDK.
### Bug Fixes
- [iOS] Fixed an issue with invalid argument types in the `getSourceId` and `getRevenuePrecision` methods of `AdContentInfo`.

## 0.8.1
### Features
- Made methods in `ScreenAdContentCallback` and `AdViewListener` optional.
### Bug Fixes
- Fixed an issue with invalid argument types for ad errors.

## 0.8.0
### Features
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 4.0.2 SDK.
### Changes
- Please check the updated Wiki for details about the CAS 4 release.
- All ad formats are now managed using a **CAS ID string** with the new `CASAppOpen`, `CASInterstitial`, and `CASRewarded` ad objects.
  Read more about the new implementation below.
  Previously, ad management required working with a `MediationManager` instance.
  You can now preload and cache multiple instances of each ad format, reducing latency and improving ad display performance.
- All ad formats have `OnAdImpressionListener` to collect impression data via new `AdContentInfo` structure.
- Added Autoload mode for `CASAppOpen`, `CASInterstitial` and `CASRewarded` ad instances.
- Added automatic initialization of the **Tenjin SDK** when the API key is provided in the CAS SDK initialization parameters.
- `AdError.description` now provides more detailed error information.
  A single error code may include multiple detailed messages.
### Bug Fixes
- Fixed an issue with the wrong arguments in the `setGender` and `setLoadingMode` methods.
- Fixed an error on call `withUserId` method.

## 0.7.6
### Features
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.9.9 SDK.
### Changes
- [Android] (From DTExchange SDK update) Fixed usage of Android Advertising ID to be compliant with Google Play Ads policy.
- [iOS] Requires apps to build with Xcode 16.1 or above.
### Bug Fixes
- Fixed an issue where the banner was white.
- Fixed an issue with the wrong argument type in the `onAdViewFailed` method.

## 0.7.5
### Bug Fixes
- Fixed a bug where `OnDismissListener` callback was not called.

## 0.7.4
### Features
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.9.8 SDK.
- The `BannerWidget` is invisible when no ad is loaded.
- When the ad content is smaller than the requested `AdSize` of the `BannerWidget`, the widget adjusts its size to match the received ad content.

## 0.7.3
### Bug Fixes
- Fixed an issue with creating AppOpen ads via MediationManager.
- Fixed an issue where Banner events were received only by the last banner listener.

## 0.7.2
### Changes
- Reworked AdSize so the BannerWidget constructor can accept the result of AdSize methods.
### Bug Fixes
- Fixed crash when calling AdSize.getAdaptiveBanner(maxWidthDp).
- [iOS] Fixed crash when calling AdSize.getAdaptiveBannerInScreen().

## 0.7.1
### Bug Fixes
- Fixed issues with AppOpen ads.

## 0.7.0
### Features
- Added support for AppOpen ads.
### Changes
- [Android] Requires a minimum `minSdk` of 23.
### Bug Fixes
- [Android] Fixed error: `PlatformException(Platform views cannot be displayed below API level 23)`.
- Fixed error: `MissingPluginException(No implementation found for method dispose on channel 'banner')`.

## 0.6.3
### Features
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.9.7 SDK.
### Bug Fixes
- Fixed a crash on banner disposal.

## 0.6.2
### Features
- Update doc
### Bug Fixes
- Fixed ad event handling on app return
- Fixed issues with AdSize method calls
- Fixed issues with consent flow handling

## 0.6.1
### Features
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.9.6 SDK.

## 0.6.0
### Features
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.9.5 SDK.
### Changes
- Methods for configuring ads settings and targeting options in the `CAS` class deprecated.
  Use dedicated singletons of the `AdsSettings` and `TargetingOptions` classes in CAS:
  - `CAS.settings`;
  - `CAS.targetingOptions`.
- Floating banners deprecated; use banners in the widget tree.
  - `CASBannerView` and `BannerView` deprecated; use `BannerWidget` instead.
  - `MediationManager.getAdView(AdSize)` deprecated. Use `BannerWidget` instead.
- Most enum values renamed to follow Dart's naming convention, using camelCase.
  - `UserConsent` deprecated; use `ConsentStatus` instead.
- `AdSize` reworked, added new methods:
  - `getSmartBanner()` replaces deprecated `AdSize.Smart`;
  - `getInlineBanner(int width, int maxHeight)`;
  - `getAdaptiveBanner(int maxWidthDp)` replaces deprecated `BannerView.maxWidthDpi`;
  - `getAdaptiveBannerInScreen()` replaces deprecated `AdSize.Adaptive`.
### Bug Fixes
- Fixed error: `channel sent a message from native to Flutter on a non-platform thread`.
### Update Adapters
> Below are important changes in the adapters that should be noted. Please refer to the native SDKs release notes for a complete overview of all adapter updates.
- [Android] Yandex Ads
  - ⚠️ [SDK] The minimum AppMetrica version is now 7.2.0 [(Flutter plugin 3.1.0)](https://github.com/appmetrica/appmetrica-flutter-plugin/releases). This is only important if your project already has the AppMetrica Flutter Plugin integrated. You can skip the integration if you are not using it.
  - ⚠️ [SDK] The minimum Android Gradle plugin version is now 7.0.

## 0.5.1
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.9.2 SDK.
### Bug Fixes
- [Android] No longer requires to add ads repositories to your project-level build.gradle.

## 0.5.0
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.9.1 SDK.
### Changes
- [Android] Requires a minimum `compileSdkVersion` of 34.
- [iOS] Requires apps to build with Xcode 15.3 or above.
- The CASExchange adapter has been included to the Optimal Ads Solutions.
- Previously beta adapters are now available to all: CASExchange, HyprMX, and StartIO.
- All the package files have been renamed to comply with naming conventions for files.  
Please use `import 'package:clever_ads_solutions/clever_ads_solutions.dart';` instead.
- Removed the deprecated dependency `package_info_plus`.
### Bug Fixes
- [iOS] Fixed rare fatal error: `No bridge module`.

## 0.4.0

### Features
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.8.1 SDK.
- Added `import 'package:clever_ads_solutions/clever_ads_solutions.dart';` which includes all package imports.
### New ads networks support in closed beta
- CASExchange - is a cutting-edge exchange platform designed to extend our SDK, enabling integration with Demand Side Platforms (DSPs).
- Ogury
- LoopMe
### Bug Fixes
- [Android] Fixed `IllegalArgumentException` from BannerView (#10)

## 0.3.1
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.7.3 SDK.
### Bug Fixes
- Added compatibility with CAS 3.7.0+ for iOS
- Fixed rarely issue `Unhandled Exception: PlatformException(CASFlutterBridgeError, failed to get manager, null, null)`

## 0.3.0
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.6.0 SDK.
### Features
- Added banner ads as widgets
### Bug Fixes
- Fixed common issue `Unhandled Exception: PlatformException(CASFlutterBridgeError, failed to get manager, null, null)`
  with CAS 3.6.0 and later
