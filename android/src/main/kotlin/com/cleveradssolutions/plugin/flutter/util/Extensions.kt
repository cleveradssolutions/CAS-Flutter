package com.cleveradssolutions.plugin.flutter.util

import android.content.Context

fun Number.pxToDp(context: Context): Float = toFloat() / context.resources.displayMetrics.density