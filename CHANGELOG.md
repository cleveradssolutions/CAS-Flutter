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
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.9.7 SDK
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
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.9.6 SDK

## 0.6.0
### Features
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.9.5 SDK
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
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.9.2 SDK
### Bug Fixes
- [Android] No longer requires to add ads repositories to your project-level build.gradle.

## 0.5.0
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.9.1 SDK
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
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.8.1 SDK
- Added `import 'package:clever_ads_solutions/clever_ads_solutions.dart';` which includes all package imports.
### New ads networks support in closed beta
- CASExchange - is a cutting-edge exchange platform designed to extend our SDK, enabling integration with Demand Side Platforms (DSPs).
- Ogury
- LoopMe
### Bug Fixes
- [Android] Fixed `IllegalArgumentException` from BannerView (#10)

## 0.3.1
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.7.3 SDK
### Bug Fixes
- Added compatibility with CAS 3.7.0+ for iOS
- Fixed rarely issue `Unhandled Exception: PlatformException(CASFlutterBridgeError, failed to get manager, null, null)`

## 0.3.0
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.6.0 SDK
### Features
- Added banner ads as widgets
### Bug Fixes
- Fixed common issue `Unhandled Exception: PlatformException(CASFlutterBridgeError, failed to get manager, null, null)`
  with CAS 3.6.0 and later
