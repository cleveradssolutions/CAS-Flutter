package com.cleveradssolutions.plugin.flutter

import android.location.Location
import com.cleversolutions.ads.android.CAS
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class TargetingOptionsMethodHandler : MethodHandler {

    override fun onMethodCall(call: MethodCall, result: Result): Boolean {
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
            else -> return false
        }
        return true
    }

    private fun getGender(result: Result) {
        result.success(CAS.targetingOptions.gender)
    }

    private fun setGender(call: MethodCall, result: Result) {
        tryGetArgSetValue<Int>("gender", call, result) { CAS.targetingOptions.gender = it }
    }

    private fun getAge(result: Result) {
        result.success(CAS.targetingOptions.age)
    }

    private fun setAge(call: MethodCall, result: Result) {
        tryGetArgSetValue<Int>("age", call, result) { CAS.targetingOptions.age = it }
    }

    private fun getLocationLatitude(result: Result) {
        result.success(CAS.targetingOptions.location?.latitude)
    }

    private fun setLocationLatitude(call: MethodCall, result: Result) {
        tryGetArgSetValue<Double>("latitude", call, result) {
            val location = CAS.targetingOptions.location ?: Location("").also {
                CAS.targetingOptions.location = it
            }
            location.latitude = it
        }
    }

    private fun getLocationLongitude(result: Result) {
        result.success(CAS.targetingOptions.location?.longitude)
    }

    private fun setLocationLongitude(call: MethodCall, result: Result) {
        tryGetArgSetValue<Double>("longitude", call, result) {
            val location = CAS.targetingOptions.location ?: Location("").also {
                CAS.targetingOptions.location = it
            }
            location.longitude = it
        }
    }

    private fun isLocationCollectionEnabled(result: Result) {
        result.success(CAS.targetingOptions.locationCollectionEnabled)
    }

    private fun setLocationCollectionEnabled(call: MethodCall, result: Result) {
        tryGetArgSetValue<Boolean>("isEnabled", call, result) {
            CAS.targetingOptions.locationCollectionEnabled = it
        }
    }

    private fun getKeywords(result: Result) {
        result.success(CAS.targetingOptions.keywords)
    }

    private fun setKeywords(call: MethodCall, result: Result) {
        tryGetArgSetValue<Set<String>?>("keywords", call, result) {
            CAS.targetingOptions.keywords = it
        }
    }

    private fun getContentUrl(result: Result) {
        result.success(CAS.targetingOptions.contentUrl)
    }

    private fun setContentUrl(call: MethodCall, result: Result) {
        tryGetArgSetValue<String?>("contentUrl", call, result) {
            CAS.targetingOptions.contentUrl = it
        }
    }

}