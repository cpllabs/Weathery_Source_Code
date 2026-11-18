# Preserve Home Widget Plugin & Related Classes
-keep class es.antonborri.home_widget.** { *; }
-keep class io.flutter.plugin.common.MethodChannel { *; }
-keep class io.flutter.plugin.common.MethodCall { *; }

# Note: kotlin/kotlinx/flutter-engine ship their own consumer rules; blanket
# keeps here disabled obfuscation for thousands of classes (Play "DEX code
# optimization" warning), so don't add them back.

# Preserve resource classes
-keep class **.R$* {
    public static final int *;
}

-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.CPLLabs.weathery.MainActivity { *; }
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

# Keep Facebook/Meta Audience Network classes safe from R8
-dontwarn com.facebook.infer.annotation.**
-dontwarn com.facebook.ads.internal.**
-keep class com.facebook.ads.** { *; }
-keep class com.facebook.infer.** { *; }

# OkHttp optional TLS providers (not bundled; OkHttp checks for them at runtime)
-dontwarn org.bouncycastle.jsse.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**

# Prevent ProGuard from Obfuscating Method Signatures
-keepattributes *Annotation*
-keepclassmembers class ** { @android.webkit.JavascriptInterface <methods>; }
