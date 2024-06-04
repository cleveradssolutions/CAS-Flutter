#0.3.1
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.7.3 SDK

## Bug Fixes
- Added compatibility with CAS 3.7.0+ for iOS
- Fixed rarely issue "Unhandled Exception: PlatformException(CASFlutterBridgeError, failed to get manager, null, null)"

#0.3.0
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.6.0 SDK

## Features
- Added banner ads as widgets

## Bug Fixes
- Fixed common issue "Unhandled Exception: PlatformException(CASFlutterBridgeError, failed to get manager, null, null)" with CAS 3.6.0 and later

#0.2.4
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.5.2 SDK

## Bug Fixes
- Fixed common issue "No implementation found for method setAnalyticsCollectionEnabled"
#0.2.3
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.5.1 SDK

## Bug Fixes
- Fixed an issue with changing position after banner refreshing
## 0.2.2
## Bug Fixes
- Fixed an onCASInitialized callback
## 0.2.1
## Bug Fixes
- Fixed a test mode for iOS platform

## 0.2.0
- Wraps [Android](https://github.com/cleveradssolutions/CAS-Android/releases) and [iOS](https://github.com/cleveradssolutions/CAS-iOS/releases) 3.5.0 SDK

## Features
- Added iOS platform support

## Changes
- Method was deprecated
```dart
adView.setBannerPositionWithOffset(AdPosition.TopCenter, xOffsetInDP, yOffsetInDP);
```
and you should use it one
```
adView.setBannerPositionWithOffset(xOffsetInDP, yOffsetInDP);
```
## 0.1.0
## Features
- Added `ConsentFlow.withDismissListener(OnDismissListener)` to be invoked when the dialog is dismissed.
- Added `ConsentFlow.show()` to manually display ConsentFlow, before and after CAS initialization. 
  > On CAS initialization, the ConsentFlow still can be displayed automatically when conditions are met. 
```dart
CAS.buildConsentFlow().withDismissListener(new DismissListenerWrapper()).show();

class DismissListenerWrapper extends OnDismissListener {
  @override
  onConsentFlowDismissed(int status) {
  }
}
```
- Added `InitialConfiguration.getCountryCode()` and `InitialConfiguration.isConsentRequired()` properties:
```dart
ManagerBuilder builder = CAS.buildManager();
builder.withInitializationListener(new InitializationListenerWrapper());
builder.initialize();
    
class InitializationListenerWrapper extends InitializationListener {
  @override
  void onCASInitialized(InitConfig initialConfig) {
    String error = initialConfig.error;
    String countryCode = initialConfig.countryCode;
    bool isTestMode = initialConfig.isTestMode;
    bool isConsentRequired = initialConfig.isConsentRequired;
  }
}
```
- Added a new page to validate your integration that replaced the test ads.
- Improvements and optimizations.

### Dependencies
- [Android] Wraps [3.1.8 SDK](https://github.com/cleveradssolutions/CAS-Android/releases)

## 0.0.7

## Bug fixes
- Fixed dependency `package_info_plus`

### Dependencies
- [Android] Wraps [3.1.8 SDK](https://github.com/cleveradssolutions/CAS-Android/releases)

## 0.0.6

## Bug fixes
- Fixed crash `An operation is not implemented: Not yet implemented`

### Dependencies
- [Android] Wraps [3.1.7 SDK](https://github.com/cleveradssolutions/CAS-Android/releases)

## 0.0.5

### Dependencies
- [Android] Wraps [3.1.6 SDK](https://github.com/cleveradssolutions/CAS-Android/releases)

## 0.0.4

### Dependencies
- [Android] Wraps [3.1.5 SDK](https://github.com/cleveradssolutions/CAS-Android/releases)
- [iOS] Wraps [3.1.5 SDK](https://github.com/cleveradssolutions/CAS-iOS/releases)
### Bug Fixes
- [Android] Fixed `Reply already submitted` error

## 0.0.3

### Dependencies
- [Android] Wraps [3.1.5 SDK](https://github.com/cleveradssolutions/CAS-Android/releases)

## 0.0.2

### Dependencies
- [Android] Wraps [3.1.5 SDK](https://github.com/cleveradssolutions/CAS-Android/releases)

## 0.0.1

* Added android platform support
