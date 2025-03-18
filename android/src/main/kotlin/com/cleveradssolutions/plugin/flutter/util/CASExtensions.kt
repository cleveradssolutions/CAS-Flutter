package com.cleveradssolutions.plugin.flutter.util

import com.cleveradssolutions.sdk.AdContentInfo
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdImpression

fun AdError.toMap(): Map<String, Any?> {
    return mapOf(
        "code" to code,
        "message" to message
    )
}

fun AdContentInfo.toMap(): Map<String, Any?> {
    return mapOf(
        "format" to format.value,
        "sourceName" to sourceName,
        "sourceId" to sourceId,
        "sourceUnitId" to sourceUnitId,
        "creativeId" to creativeId,
        "revenue" to revenue,
        "revenuePrecision" to revenuePrecision,
        "impressionDepth" to impressionDepth,
        "revenueTotal" to revenueTotal
    )
}

fun AdImpression.toMap(): Map<String, Any?> {
    return mapOf(
        "cpm" to this.cpm,
        "priceAccuracy" to this.priceAccuracy,
        "adType" to this.adType.ordinal,
        "networkName" to this.network,
        "versionInfo" to this.versionInfo,
        "identifier" to this.identifier,
        "impressionDepth" to this.impressionDepth,
        "lifetimeRevenue" to this.lifetimeRevenue,
        "creativeIdentifier" to this.creativeIdentifier
    )
}
