package com.cleveradssolutions.plugin.flutter.bridge

import android.location.Location
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleversolutions.ads.android.CAS
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/targeting_options"

class TargetingOptionsMethodHandler(
    binding: FlutterPluginBinding
) : MethodHandler(binding, CHANNEL_NAME) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getGender" -> getGender(result)
            "setGender" -> setGender(call, result)
            "getAge" -> getAge(result)
            "setAge" -> setAge(call, result)
            "getLocationLatitude" -> getLocationLatitude(result)
            "setLocationLatitude" -> setLocationLatitude(call, result)
            "getLocationLongitude" -> getLocationLongitude(result)
            "setLocationLongitude" -> setLocationLongitude(call, result)
            "isLocationCollectionEnabled" -> isLocationCollectionEnabled(result)
            "setLocationCollectionEnabled" -> setLocationCollectionEnabled(call, result)
            "getKeywords" -> getKeywords(result)
            "setKeywords" -> setKeywords(call, result)
            "getContentUrl" -> getContentUrl(result)
            "setContentUrl" -> setContentUrl(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun getGender(result: MethodChannel.Result) {
        result.success(CAS.targetingOptions.gender)
    }

    private fun setGender(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("gender", result) {
            CAS.targetingOptions.gender = it
        }
    }

    private fun getAge(result: MethodChannel.Result) {
        result.success(CAS.targetingOptions.age)
    }

    private fun setAge(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("age", result) {
            CAS.targetingOptions.age = it
        }
    }

    private fun getLocationLatitude(result: MethodChannel.Result) {
        result.success(CAS.targetingOptions.location?.latitude)
    }

    private fun setLocationLatitude(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Double>("latitude", result) {
            val location = CAS.targetingOptions.location ?: Location("").also {
                CAS.targetingOptions.location = it
            }
            location.latitude = it
        }
    }

    private fun getLocationLongitude(result: MethodChannel.Result) {
        result.success(CAS.targetingOptions.location?.longitude)
    }

    private fun setLocationLongitude(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Double>("longitude", result) {
            val location = CAS.targetingOptions.location ?: Location("").also {
                CAS.targetingOptions.location = it
            }
            location.longitude = it
        }
    }

    private fun isLocationCollectionEnabled(result: MethodChannel.Result) {
        result.success(CAS.targetingOptions.locationCollectionEnabled)
    }

    private fun setLocationCollectionEnabled(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Boolean>("isEnabled", result) {
            CAS.targetingOptions.locationCollectionEnabled = it
        }
    }

    private fun getKeywords(result: MethodChannel.Result) {
        result.success(CAS.targetingOptions.keywords?.toList())
    }

    private fun setKeywords(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<List<String>?>("keywords", result) {
            CAS.targetingOptions.keywords = it?.toSet()
        }
    }

    private fun getContentUrl(result: MethodChannel.Result) {
        result.success(CAS.targetingOptions.contentUrl)
    }

    private fun setContentUrl(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<String?>("contentUrl", result) {
            CAS.targetingOptions.contentUrl = it
        }
    }

}