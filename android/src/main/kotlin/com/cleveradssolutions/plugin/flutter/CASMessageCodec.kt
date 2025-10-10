package com.cleveradssolutions.plugin.flutter

import android.content.Context
import android.graphics.Color
import android.util.Size
import com.cleveradssolutions.sdk.AdContentInfo
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdSize
import com.cleversolutions.ads.InitialConfiguration
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private const val VALUE_INIT_STATUS = 128
private const val VALUE_AD_SIZE = 129.toByte()
private const val VALUE_SIZE = 130
private const val VALUE_AD_ERROR = 131
private const val VALUE_TEMPLATE_STYLE = 132.toByte()
private const val VALUE_COLOR = 133.toByte()
private const val VALUE_AD_CONTENT_INFO = 134

internal class CASMessageCodec(var context: Context) : StandardMessageCodec() {

    override fun writeValue(stream: ByteArrayOutputStream, value: Any?) {
        when (value) {
            is InitialConfiguration -> {
                stream.write(VALUE_INIT_STATUS)
                writeValue(stream, value.error)
                writeValue(stream, value.countryCode)
                writeValue(stream, value.isConsentRequired)
                writeValue(stream, value.consentFlowStatus)
            }

            is Size -> {
                stream.write(VALUE_SIZE)
                writeValue(stream, value.width)
                writeValue(stream, value.height)
            }

            is AdError -> {
                stream.write(VALUE_AD_ERROR)
                writeValue(stream, value.code)
                writeValue(stream, value.message)
            }

            is AdContentInfo -> {
                stream.write(VALUE_AD_CONTENT_INFO)
                writeValue(stream, value.format.value)
                writeValue(stream, value.sourceName)
                writeValue(stream, value.sourceUnitId)
                writeValue(stream, value.creativeId)
                writeValue(stream, value.revenue)
                writeValue(stream, value.revenuePrecision)
                writeValue(stream, value.revenueTotal)
                writeValue(stream, value.impressionDepth)
            }

            else -> super.writeValue(stream, value)
        }
    }

    override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? =
        when (type) {
            VALUE_AD_SIZE -> {
                val mode = readValueOfType(buffer.get(), buffer) as Int
                val width = readValueOfType(buffer.get(), buffer) as Int
                val height = readValueOfType(buffer.get(), buffer) as Int
                when (mode) {
                    1 -> if (width <= 0) AdSize.getAdaptiveBannerInScreen(context)
                    else AdSize.getAdaptiveBanner(context, width)

                    2 -> AdSize.getInlineBanner(width, height)

                    else -> when {
                        height >= 250 -> AdSize.MEDIUM_RECTANGLE
                        height >= 90 -> AdSize.LEADERBOARD
                        else -> AdSize.BANNER
                    }
                }
            }

            VALUE_TEMPLATE_STYLE -> NativeTemplateStyle(
                backgroundColor = readValueOfType(buffer.get(), buffer) as? Int ?: Color.TRANSPARENT,
                primaryColor = readValueOfType(buffer.get(), buffer) as? Int ?: Color.TRANSPARENT,
                callToActionTextColor = readValueOfType(buffer.get(), buffer) as? Int ?: Color.TRANSPARENT,
                headlineTextColor = readValueOfType(buffer.get(), buffer) as? Int ?: Color.TRANSPARENT,
                headlineFontStyle = readValueOfType(buffer.get(), buffer) as? Int ?: -1,
                secondaryTextColor = readValueOfType(buffer.get(), buffer) as? Int ?: Color.TRANSPARENT,
                secondaryFontStyle = readValueOfType(buffer.get(), buffer) as? Int ?: -1
            )

            VALUE_COLOR -> Color.argb(
                /* alpha = */ readValueOfType(buffer.get(), buffer) as Int,
                /* red = */ readValueOfType(buffer.get(), buffer) as Int,
                /* green = */ readValueOfType(buffer.get(), buffer) as Int,
                /* blue = */ readValueOfType(buffer.get(), buffer) as Int
            )

            else -> super.readValueOfType(type, buffer)
        }
}