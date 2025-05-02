import '../ad_format.dart';

class AdFormatFactory {
  static AdFormat fromValue(int? index) {
    if (index == null) {
      return AdFormat.banner;
    } else {
      return AdFormat.values[index];
    }
  }

  static AdFormat fromArguments(dynamic arguments) {
    final int? index = arguments['format'];
    return fromValue(index);
  }
}
