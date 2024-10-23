## 0.6.0
### Features
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases)
  and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.9.5 SDK
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
- [iOS] Fixed the display of the required CASExchange version in the adapter integration
  information.
- [iOS] Fixed crash if NSUserTrackingUsageDescription is set but empty in Info.plist.
- [iOS] Fixed build warnings from ModuleCache.noindex.
- [iOS] Fixed URL construction to App-ads.txt of the application for verification in Test Ads mode.

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
