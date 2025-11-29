package io.chipper.graviton

import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.play.core.integrity.IntegrityManagerFactory
import com.google.android.play.core.integrity.IntegrityTokenRequest
import com.google.android.gms.tasks.Task
import com.google.android.play.core.integrity.model.IntegrityErrorCode

class MainActivity : FlutterActivity() {
    private val CHANNEL = "io.chipper.graviton/play_integrity"
    private val TAG = "MainActivity"
    
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
                        result.error("INVALID_ARGUMENT", getString(R.string.integrity_invalid_argument), null)
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
                    handleIntegrityError(exception, "token_request", result)
                }
        } catch (e: SecurityException) {
            Log.e(TAG, "Security exception during integrity manager initialization", e)
            result.error(
                "SECURITY_ERROR",
                getString(R.string.integrity_security_error),
                mapOf("errorType" to "security")
            )
        } catch (e: IllegalStateException) {
            Log.e(TAG, "Illegal state exception during integrity manager initialization", e)
            result.error(
                "INITIALIZATION_ERROR",
                getString(R.string.integrity_initialization_error),
                mapOf("errorType" to "initialization")
            )
        } catch (e: Exception) {
            // Log full exception for debugging, but don't expose to client
            Log.e(TAG, "Unexpected error during integrity manager initialization", e)
            result.error(
                "UNKNOWN_ERROR",
                getString(R.string.integrity_unknown_error),
                mapOf("errorType" to "unknown")
            )
        }
    }
    
    /**
     * Handles Play Integrity API errors by logging full details server-side
     * and returning sanitized error codes to the client.
     */
    private fun handleIntegrityError(
        exception: Exception,
        operation: String,
        result: MethodChannel.Result
    ) {
        // Log full exception details for server-side debugging
        Log.e(TAG, "Play Integrity error during $operation: ${exception.javaClass.simpleName}", exception)
        
        // Extract error code if available from Play Integrity exceptions
        val errorMessage = exception.message ?: ""
        val sanitizedError = when {
            // Network-related errors
            errorMessage.contains("network", ignoreCase = true) ||
            errorMessage.contains("timeout", ignoreCase = true) ||
            errorMessage.contains("connection", ignoreCase = true) -> {
                Triple("NETWORK_ERROR", getString(R.string.integrity_network_error), "network")
            }
            
            // Device/app integrity errors
            errorMessage.contains("integrity", ignoreCase = true) ||
            errorMessage.contains("verdict", ignoreCase = true) -> {
                Triple("INTEGRITY_FAILED", getString(R.string.integrity_failed), "integrity")
            }
            
            // API not available or disabled
            errorMessage.contains("not available", ignoreCase = true) ||
            errorMessage.contains("disabled", ignoreCase = true) ||
            errorMessage.contains("unsupported", ignoreCase = true) -> {
                Triple("SERVICE_UNAVAILABLE", getString(R.string.integrity_service_unavailable), "unavailable")
            }
            
            // Rate limiting
            errorMessage.contains("quota", ignoreCase = true) ||
            errorMessage.contains("rate limit", ignoreCase = true) -> {
                Triple("RATE_LIMITED", getString(R.string.integrity_rate_limited), "rate_limit")
            }
            
            // Generic/unknown errors
            else -> {
                Triple("TOKEN_REQUEST_FAILED", getString(R.string.integrity_token_request_failed), "unknown")
            }
        }
        
        result.error(
            sanitizedError.first,
            sanitizedError.second,
            mapOf("errorType" to sanitizedError.third)
        )
    }
}
