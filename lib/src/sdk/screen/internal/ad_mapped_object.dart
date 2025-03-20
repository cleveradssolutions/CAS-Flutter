import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../internal/mapped_object.dart';
import '../../ad_content_info.dart';
import '../../internal/ad_content_info_impl.dart';

mixin AdMappedObject on MappedObjectImpl {

  AdContentInfo? _contentInfo;
  String? _contentInfoId;

  Future<AdContentInfo?> getContentInfo() async {
    AdContentInfo? contentInfo = _contentInfo;
    if (contentInfo != null) {
      return contentInfo;
    } else {
      return _getContentInfo(await invokeMethod('getContentInfo'));
    }
  }

  @protected
  AdContentInfo getContentInfoFromCall(MethodCall call) {
    return _getContentInfo(call.arguments['contentInfoId']);
  }

  AdContentInfo _getContentInfo(String? contentInfoId) {
    final String id = contentInfoId ?? '';
    AdContentInfo? contentInfo = _contentInfo;
    if (contentInfo == null || id != _contentInfoId) {
      contentInfo = AdContentInfoImpl(id);
      _contentInfo = contentInfo;
      _contentInfoId = id;
    }
    return contentInfo;
  }

  void destroy() {
    _contentInfo = null;
    _contentInfoId = null;
  }
}
