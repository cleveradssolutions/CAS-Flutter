package com.cleveradssolutions.plugin.flutter

import android.content.Context
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.util.Log
import com.cleveradssolutions.sdk.nativead.CASNativeView
import com.cleveradssolutions.sdk.nativead.CASStarRatingView
import kotlin.math.roundToInt


internal class NativeTemplateStyle(
    val backgroundColor: Int,
    val primaryColor: Int,
    val callToActionTextColor: Int,
    val headlineTextColor: Int,
    val headlineFontStyle: Int,
    val secondaryTextColor: Int,
    val secondaryFontStyle: Int,
) {
    companion object {
        private const val FONT_UNDEFINED = -1
        private const val FONT_NORMAL = 0
        private const val FONT_BOLD = 1
        private const val FONT_ITALIC = 2
        private const val FONT_MONOSPACE = 3
    }

    fun applyToView(view: CASNativeView) {
        if (backgroundColor != Color.TRANSPARENT) {
            view.setBackgroundColor(backgroundColor)
        }

        if (primaryColor != Color.TRANSPARENT) {
            view.adLabelView?.let {
                it.background = createRoundedBorderDrawable(
                    view.context,
                    primaryColor
                )
                it.setTextColor(primaryColor)
            }
            val starRating = view.starRatingView as? CASStarRatingView
            starRating?.color = primaryColor
        }

        view.callToActionView?.let {
            if (primaryColor != Color.TRANSPARENT) {
                it.background = createRoundedButtonDrawable(
                    view.context,
                    primaryColor
                )
            }
            if (callToActionTextColor != Color.TRANSPARENT) {
                it.setTextColor(callToActionTextColor)
            }
        }

        view.headlineView?.let {
            if (headlineTextColor != Color.TRANSPARENT) {
                it.setTextColor(headlineTextColor)
            }
            if (headlineFontStyle > NativeTemplateStyle.FONT_UNDEFINED) {
                it.setTypeface(getTypeface(headlineFontStyle))
            }
        }

        if (secondaryTextColor != Color.TRANSPARENT) {
            view.bodyView?.setTextColor(secondaryTextColor)
            view.advertiserView?.setTextColor(secondaryTextColor)
            view.storeView?.setTextColor(secondaryTextColor)
            view.priceView?.setTextColor(secondaryTextColor)
            view.reviewCountView?.setTextColor(secondaryTextColor)
        }

        if (secondaryFontStyle > NativeTemplateStyle.FONT_UNDEFINED) {
            val typeface = getTypeface(secondaryFontStyle)
            view.bodyView?.setTypeface(typeface)
            view.advertiserView?.setTypeface(typeface)
            view.storeView?.setTypeface(typeface)
            view.priceView?.setTypeface(typeface)
            view.reviewCountView?.setTypeface(typeface)
        }

        view.invalidate()
        view.requestLayout()
    }

    private fun getTypeface(fontStyle: Int): Typeface = when (fontStyle) {
        FONT_NORMAL -> Typeface.DEFAULT
        FONT_BOLD -> Typeface.DEFAULT_BOLD
        FONT_ITALIC -> Typeface.defaultFromStyle(Typeface.ITALIC)
        FONT_MONOSPACE -> Typeface.MONOSPACE
        else -> Typeface.DEFAULT
    }

    private fun createRoundedButtonDrawable(context: Context, color: Int) =
        GradientDrawable().apply {
            shape = GradientDrawable.RECTANGLE
            setColor(color)
            cornerRadius = 20.0f * context.resources.displayMetrics.density
        }

    private fun createRoundedBorderDrawable(context: Context, color: Int) =
        GradientDrawable().apply {
            shape = GradientDrawable.RECTANGLE
            setColor(Color.TRANSPARENT)
            val density = context.resources.displayMetrics.density
            cornerRadius = 2.0f * density
            setStroke(density.roundToInt(), color)
        }
}