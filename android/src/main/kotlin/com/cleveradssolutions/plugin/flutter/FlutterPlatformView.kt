package com.cleveradssolutions.plugin.flutter

import android.view.View
import io.flutter.plugin.platform.PlatformView

/** A simple PlatformView that wraps a View and sets its reference to null on dispose(). */
class FlutterPlatformView(
    private var view: View?
) : PlatformView {
    override fun getView(): View? = view

    override fun dispose() {
        view = null
    }
}