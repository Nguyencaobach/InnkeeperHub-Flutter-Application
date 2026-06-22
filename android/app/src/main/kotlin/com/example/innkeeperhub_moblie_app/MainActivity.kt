package com.example.innkeeperhub_moblie_app

import android.os.Build
import android.os.Bundle
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Chỉ áp dụng cho Android 12+ (API 31+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Cài splash screen và dismiss ngay lập tức (không chờ)
            installSplashScreen().setKeepOnScreenCondition { false }
        }
        super.onCreate(savedInstanceState)
    }
}
