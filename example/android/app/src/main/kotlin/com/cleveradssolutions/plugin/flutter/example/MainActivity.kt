package com.cleveradssolutions.plugin.flutter.example

import com.cleveradssolutions.plugin.flutter.CASMobileAdsPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register map of NativeAdFactory to CAS Plugin
        CASMobileAdsPlugin.nativeAdFactories = mapOf(
            "nativeFactoryIdExample" to NativeAdFactoryExample()
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

        // Unregister all NativeAdFactory
        CASMobileAdsPlugin.nativeAdFactories = null
    }
}
