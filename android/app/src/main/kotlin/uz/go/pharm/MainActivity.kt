package uz.go.pharm

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.facebook.FacebookSdk
import com.facebook.LoggingBehavior
import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*


class MainActivity : FlutterActivity() {


    lateinit var speechRecognizer: SpeechRecognizer
    var isInit: Boolean = false


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("c2270c63-ab7b-463b-b6d7-20821d098826");
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        FacebookSdk.setIsDebugEnabled(true)
        FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS)


        MethodChannel(flutterEngine.dartExecutor, "flutter/MethodChannelDemoExam").setMethodCallHandler { call, result ->

            if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
                checkPermission()
            }

            speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this)


            val speechRecognizerIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH)
            speechRecognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            speechRecognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, "ru_RU")


            Log.d("MRX", "MethodChannel")
            Log.d("MRX", Locale.getDefault().toLanguageTag())

            speechRecognizer.setRecognitionListener(object : RecognitionListener {
                override fun onReadyForSpeech(bundle: Bundle) {
                    Log.d("MRX", "onReadyForSpeech")
                }

                override fun onBeginningOfSpeech() {
                    Log.d("MRX", "onBeginningOfSpeech")
                }

                override fun onRmsChanged(v: Float) {
                    Log.d("MRX", "onRmsChanged")
                }

                override fun onBufferReceived(bytes: ByteArray) {
                    Log.d("MRX", "onBufferReceived")
                }

                override fun onEndOfSpeech() {
                    Log.d("MRX", "onEndOfSpeech")
                }

                override fun onError(i: Int) {
                    Log.d("MRX", "onError")
                }

                override fun onResults(bundle: Bundle) {
                    val data = bundle.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                    Log.d("MRX", "Result =>" + data!![0])
                    result.success(data!![0])
                }

                override fun onPartialResults(bundle: Bundle) {
                    Log.d("MRX", "onPartialResults")
                }

                override fun onEvent(i: Int, bundle: Bundle) {
                    Log.d("MRX", "onEvent")
                }
            })


            when (call.method) {
                "start" -> {
                    isInit = true
                    Log.d("MRX", "start")
                    speechRecognizer.startListening(speechRecognizerIntent)
                            ?: result.error("110", "nullErrorMessage", null)
                }
                "stop" -> {
                    isInit = true
                    speechRecognizer.stopListening()
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (isInit)
            speechRecognizer.destroy()
    }

    private fun checkPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.RECORD_AUDIO), 1)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String?>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 1 && grantResults.size > 0) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) Toast.makeText(this, "Permission Granted", Toast.LENGTH_SHORT).show()
        }
    }
}
