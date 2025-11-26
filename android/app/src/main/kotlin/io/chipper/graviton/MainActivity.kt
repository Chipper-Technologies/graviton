package io.chipper.graviton

import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Enable edge-to-edge display for Android 15+ (SDK 35) compatibility
        // This replaces the deprecated status/navigation bar color APIs
        // that Flutter's embedding layer uses internally
        if (Build.VERSION.SDK_INT >= 35) { // Android 15 (Vanilla Ice Cream)
            WindowCompat.setDecorFitsSystemWindows(window, false)
        }
        super.onCreate(savedInstanceState)
    }
}
