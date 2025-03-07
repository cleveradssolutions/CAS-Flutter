import '../../internal/mapped_object.dart';
import '../ad_content_info.dart';
import '../ad_format.dart';
import '../ad_revenue_precision.dart';
import '../ad_source_id.dart';
import 'ad_format_extensions.dart';

class AdContentInfoImpl extends MappedObject implements AdContentInfo {
  AdContentInfoImpl() : super('cleveradssolutions/ad_content_info');

  @override
  Future<AdFormat> getFormat() async {
    final int? value = await invokeMethod<int>('getFormat');
    return AdFormatExtensions.fromValue(value);
  }

  @override
  Future<String> getSourceName() async {
    final String? sourceName = await invokeMethod<String>('getSourceName');
    return sourceName ?? '';
  }

  @override
  Future<AdSourceId> getSourceId() async {
    final int? value = await invokeMethod<int>('getSourceId');
    return AdSourceId.fromValue(value);
  }

  @override
  Future<String> getSourceUnitId() async {
    final String? sourceUnitId = await invokeMethod<String>('getSourceUnitId');
    return sourceUnitId ?? '';
  }

  @override
  Future<String> getCreativeId() async {
    final String? creativeId = await invokeMethod<String>('getCreativeId');
    return creativeId ?? '';
  }

  @override
  Future<double> getRevenue() async {
    final double? revenue = await invokeMethod<double>('getRevenue');
    return revenue ?? 0.0;
  }

  @override
  Future<AdRevenuePrecision> getRevenuePrecision() async {
    final int? value = await invokeMethod<int>('getRevenuePrecision');
    return AdRevenuePrecision.fromValue(value);
  }

  @override
  Future<int> getImpressionDepth() async {
    final int? impressionDepth = await invokeMethod<int>('getImpressionDepth');
    return impressionDepth ?? 0;
  }

  @override
  Future<double> getRevenueTotal() async {
    final double? revenueTotal = await invokeMethod<double>('getRevenueTotal');
    return revenueTotal ?? 0.0;
  }
}
