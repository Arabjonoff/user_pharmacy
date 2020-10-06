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


class MainActivity : FlutterActivity() {


    private var speechRecognizer: SpeechRecognizer? = null

//    private fun resourceToUriString(context: Context, resId: Int): String? {
//        return (ContentResolver.SCHEME_ANDROID_RESOURCE
//                + "://"
//                + context.resources.getResourcePackageName(resId)
//                + "/"
//                + context.resources.getResourceTypeName(resId)
//                + "/"
//                + context.resources.getResourceEntryName(resId))
//    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("c2270c63-ab7b-463b-b6d7-20821d098826");
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        FacebookSdk.setIsDebugEnabled(true)
        FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS)
        SpeechRecognizer.createSpeechRecognizer(this@MainActivity)





        MethodChannel(flutterEngine.dartExecutor, "flutter/MethodChannelDemoExam").setMethodCallHandler { call, result ->
            val recognizerIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
            recognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
            recognizerIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, "ru_RU")
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.RECORD_AUDIO), 1)
                }
            }

            Log.d("MRX", "MethodChannel")

            speechRecognizer?.setRecognitionListener(object : RecognitionListener {
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
                    Log.d("MRX", "start")
                    speechRecognizer?.startListening(recognizerIntent)
                            ?: result.error("418", "nullErrorMessage", null)
                }
                "stop" -> speechRecognizer?.stopListening()
                        ?: result.error("418", "nullErrorMessage", null);
                else -> result.notImplemented()
            }
        }

//        MethodChannel(flutterEngine.dartExecutor, "crossingthestreams.io/resourceResolver").setMethodCallHandler { call, result ->
//            if ("drawableToUri" == call.method) {
//                val resourceId: Int = this@MainActivity.resources.getIdentifier(call.arguments as String, "drawable", this@MainActivity.packageName)
//                result.success(resourceToUriString(this@MainActivity.applicationContext, resourceId))
//            }
//            if ("getAlarmUri" == call.method) {
//                result.success(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM).toString())
//            }
//        }
    }
}
