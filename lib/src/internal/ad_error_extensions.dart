import 'package:clever_ads_solutions/clever_ads_solutions.dart';

extension AdErrorExtensions on AdError {
  static AdError fromArguments(dynamic arguments) {
    final Map<String, dynamic>? map = arguments['error'];
    if (map == null) {
      return AdError.fromMessage(message)
    }
  }
}