package com.example.parkinson_com_v2

import android.os.Bundle
import android.telephony.TelephonyManager
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    private val CHANNEL = "sim_info_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "isSimPresent") {
                val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
                val simState = telephonyManager.simState

                when (simState) {
                    TelephonyManager.SIM_STATE_ABSENT -> {
                        // No SIM card is available
                        result.success(false)
                    }
                    TelephonyManager.SIM_STATE_READY -> {
                        // SIM card is available and ready
                        result.success(true)
                    }
                    TelephonyManager.SIM_STATE_UNKNOWN -> {
                        // SIM card state is unknown
                        result.success(false)
                    }
                    else -> {
                        // Handle other SIM states as absent for safety
                        result.success(false)
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }
}

