package uz.go.pharm

import androidx.annotation.NonNull
import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

import com.facebook.FacebookSdk;
import com.facebook.LoggingBehavior
import com.facebook.appevents.AppEventsLogger;


class MainActivity : FlutterActivity() {

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
