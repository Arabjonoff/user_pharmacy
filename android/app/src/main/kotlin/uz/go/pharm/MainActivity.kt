package uz.go.pharm

import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.util.Base64
import android.util.Log
import androidx.annotation.NonNull
import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException


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
