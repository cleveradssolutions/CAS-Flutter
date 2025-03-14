import 'package:clever_ads_solutions/clever_ads_solutions.dart';

class AdErrorFactory {
  static AdError fromArguments(dynamic arguments) {
    final Map<String, dynamic>? map = arguments['error'];
    if (map != null) {
      final int? code = map['code'];
      if (code != null) {
        final String? message = map['message'];
        return AdError(code, message);
      }
    }
    return AdError(AdError.codeInternalError);
  }
}
