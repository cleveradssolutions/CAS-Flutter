import 'package:flutter/foundation.dart';

void logDebug(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
