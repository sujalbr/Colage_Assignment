plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.bibha.w_appapp"
    compileSdk = 35
    ndkVersion = "27.0.12077973" // Optional: match your Flutter installation

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.bibha.w_appapp"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
     getByName("release") {
        isMinifyEnabled = true
        // REMOVE or COMMENT this if it exists:
        // isShrinkResources = true
        signingConfig = signingConfigs.getByName("debug")
     }
    } 

}

flutter {
    source = "../.."
}
dependencies {
    implementation 'com.google.android.gms:play-services-auth:20.7.0' // use latest
}
classpath 'com.google.gms:google-services:4.4.0' // or latest
apply plugin: 'com.google.gms.google-services'
