# Preserve Home Widget Plugin & Related Classes
-keep class es.antonborri.home_widget.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.plugin.common.MethodChannel { *; }
-keep class io.flutter.plugin.common.MethodCall { *; }

# Keep Flutter & Kotlin Reflect Classes
-keep class kotlinx.** { *; }
-keep class kotlin.** { *; }

# Prevent Removal of XML & Resource Parsing Classes
-keep class org.xmlpull.** { *; }
-keep class org.kxml2.** { *; }
-keep class android.content.res.** { *; }
# Preserve resource classes
-keep class **.R$* {
    public static final int *;
}

-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class **.R$drawable { public static <fields>; }

-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
# Prevent ProGuard from Obfuscating Method Signatures
-keepattributes *Annotation*
-keepclassmembers class ** { @android.webkit.JavascriptInterface <methods>; }
