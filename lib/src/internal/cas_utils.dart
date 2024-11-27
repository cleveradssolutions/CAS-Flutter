import '../ad_error.dart';

class CASUtils {
  static const String _errorNoConnection = 'No internet connection detected';
  static const String _errorNoFill = 'No Fill';
  static const String _errorConfig = 'Invalid configuration';
  static const String _errorNotReady = 'Ad are not ready';
  static const String _errorDisabled = 'Manager is disabled';
  static const String _errorReachedCap = 'Reached cap for user';
  static const String _errorInterval =
      'The interval between Ad impressions has not yet passed';
  static const String _errorAlreadyDisplayed = 'Ad already displayed';
  static const String _errorNotForeground = 'Application is paused';
  static const String _errorNoSpace = 'Not enough space to display ads';
  static const String _errorInternal = 'Internal error';

  static String getAdErrorMessage(int code) {
    switch (code) {
      case AdError.codeNoConnection:
        return _errorNoConnection;
      case AdError.codeNoFill:
        return _errorNoFill;
      case AdError.codeConfigurationError:
        return _errorConfig;
      case AdError.codeNotReady:
        return _errorNotReady;
      case AdError.codeManagerIsDisabled:
        return _errorDisabled;
      case AdError.codeReachedCap:
        return _errorReachedCap;
      case AdError.codeIntervalNotYetPassed:
        return _errorInterval;
      case AdError.codeAlreadyDisplayed:
        return _errorAlreadyDisplayed;
      case AdError.codeAppIsPaused:
        return _errorNotForeground;
      case AdError.codeNotEnoughSpace:
        return _errorNoSpace;
      default:
        return _errorInternal;
    }
  }

  static int getAdErrorCode(String message) {
    switch (message) {
      case _errorNoFill:
        return AdError.codeNoFill;
      case _errorInternal:
        return AdError.codeInternalError;
      case _errorNotReady:
        return AdError.codeNotReady;
      case _errorInterval:
        return AdError.codeIntervalNotYetPassed;
      case _errorNoConnection:
        return AdError.codeNoConnection;
      case _errorConfig:
        return AdError.codeConfigurationError;
      case _errorDisabled:
        return AdError.codeManagerIsDisabled;
      case _errorReachedCap:
        return AdError.codeReachedCap;
      case _errorAlreadyDisplayed:
        return AdError.codeAlreadyDisplayed;
      case _errorNotForeground:
        return AdError.codeAppIsPaused;
      case _errorNoSpace:
        return AdError.codeNotEnoughSpace;
      default:
        return AdError.codeInternalError;
    }
  }
}
