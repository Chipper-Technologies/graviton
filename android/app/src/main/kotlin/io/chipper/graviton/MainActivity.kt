package io.chipper.graviton

import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.play.core.integrity.IntegrityManagerFactory
import com.google.android.play.core.integrity.IntegrityTokenRequest
import com.google.android.gms.tasks.Task

class MainActivity : FlutterActivity() {
    private val CHANNEL = "io.chipper.graviton/play_integrity"
    
    override fun onCreate(savedInstanceState: Bundle?) {
        // Enable edge-to-edge display for Android 15+ (SDK 35) compatibility
        // This replaces the deprecated status/navigation bar color APIs
        // that Flutter's embedding layer uses internally
        if (Build.VERSION.SDK_INT >= 35) { // Android 15 (Vanilla Ice Cream)
            WindowCompat.setDecorFitsSystemWindows(window, false)
        }
        super.onCreate(savedInstanceState)
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestIntegrityToken" -> {
                    val nonce = call.argument<String>("nonce")
                    if (nonce == null) {
                        result.error("INVALID_ARGUMENT", "Nonce is required", null)
                        return@setMethodCallHandler
                    }
                    
                    requestIntegrityToken(nonce, result)
                }
                "checkAvailability" -> {
                    // Play Integrity API is available on this Android device
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun requestIntegrityToken(nonce: String, result: MethodChannel.Result) {
        try {
            val integrityManager = IntegrityManagerFactory.create(applicationContext)
            
            val integrityTokenRequest = IntegrityTokenRequest.builder()
                .setNonce(nonce)
                .build()
            
            integrityManager.requestIntegrityToken(integrityTokenRequest)
                .addOnSuccessListener { response ->
                    result.success(mapOf(
                        "token" to response.token()
                    ))
                }
                .addOnFailureListener { exception ->
                    result.error(
                        "INTEGRITY_ERROR",
                        exception.message ?: "Failed to request integrity token",
                        exception.toString()
                    )
                }
        } catch (e: Exception) {
            result.error(
                "INTEGRITY_ERROR",
                e.message ?: "Failed to initialize integrity manager",
                e.toString()
            )
        }
    }
}
