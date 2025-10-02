import java.util.Properties
import java.io.FileInputStream


plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties().apply {
    val keystoreFile = rootProject.file("keystore.properties")
    if (keystoreFile.exists()) {
        load(FileInputStream(keystoreFile))
    }
}


android {
    namespace = "com.CPLLabs.weathery"
    compileSdk = flutter.compileSdkVersion.toInt()
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    signingConfigs {
        create("release") {
            storeFile = file("cpllabs_apps.jks")
            storePassword = keystoreProperties.getProperty("storePassword")
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("storePassword")
        }
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.CPLLabs.weathery"
        multiDexEnabled = true
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion

        targetSdk = 36
        versionCode = flutter.versionCode?.toInt()
        versionName = flutter.versionName
    }

    buildFeatures {
        compose=true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.9"
    }

    buildTypes {
        getByName("debug") {
//            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
        getByName("release") {
            isShrinkResources = false  // Instead of shrinkResources false
            isMinifyEnabled = true
            signingConfig = signingConfigs.getByName("release")
        }
    }

}

repositories {
    mavenCentral()
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.8.0")
    implementation("androidx.multidex:multidex:2.0.1")
//    implementation("com.github.antonborri.home_widget:home_widget:3.0.0")
//    implementation("androidx.compose.compiler:compiler:1.5.4")
    implementation("androidx.glance:glance-appwidget:LATEST-VERSION")

    // Play Services
    implementation("com.google.android.gms:play-services-appset:16.0.2")
    implementation("com.google.android.gms:play-services-ads-identifier:18.0.1")
    implementation("com.google.android.gms:play-services-basement:18.3.0")

    // Required when using custom native ad implementation
    implementation("com.unity3d.ads-mediation:mediation-sdk:8.6.1")
}
