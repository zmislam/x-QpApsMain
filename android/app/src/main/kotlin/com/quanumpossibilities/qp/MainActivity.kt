package com.quanumpossibilities.qp

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle

class MainActivity: FlutterFragmentActivity() {
    // For Using flutter_stripe dependency
    // Using FlutterFragmentActivity instead of FlutterActivity

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Register your plugin manually
        flutterEngine.plugins.add(WalletConnectV2Plugin())
    }

    // ? HANDEL DEEPLINK ------------------------------------------------
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleDeepLink(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleDeepLink(intent)
    }
//    ? CODE FOR USING SHARED PREFERENCE ------------------------- WE WILL USE GET STORAGE
//    private fun handleDeepLink(intent: Intent) {
//        val data: Uri? = intent.data
//        if (data != null) {
//            val shared = getSharedPreferences("deep_link_cache", Context.MODE_PRIVATE)
//            shared.edit().putString("last_deep_link", data.toString()).apply()
//        }
//    }

    private fun handleDeepLink(intent: Intent) {
        val data: Uri? = intent.data
        if (data != null) {
            val shared = getSharedPreferences("GetStorage", Context.MODE_PRIVATE)
            shared.edit().putString("last_deep_link", data.toString()).apply()
        }
    }
}
