import '../ad_error.dart';

class AdErrorFactory {
  static AdError fromArguments(dynamic arguments) {
    final map = arguments['error'] as Map<dynamic, dynamic>?;
    if (map != null) {
      final int? code = map['code'] as int?;
      if (code != null) {
        return AdError(code, map['message'] as String);
      }
    }
    return AdError(AdError.codeInternalError, "Internal error");
  }
}
