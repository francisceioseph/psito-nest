import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// The upload key, kept out of git: android/key.properties names the keystore
// and its passwords. Without it, a release is signed with the debug key and
// only good for trying on a device.
val keyProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}

android {
    namespace = "io.github.francisceioseph.psito.nest"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // The name of the game on the stores. It can never change once
        // published.
        applicationId = "io.github.francisceioseph.psito.nest"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // From the version in pubspec.yaml, which semantic-release raises:
        // 1.2.3 is 10203, always higher than the one before, as the stores
        // ask.
        versionName = flutter.versionName
        versionCode = flutter.versionName.split("-", "+")[0].split(".")
            .map { it.toInt() }
            .let { (major, minor, patch) -> major * 10000 + minor * 100 + patch }
    }

    signingConfigs {
        if (keyProperties.containsKey("storeFile")) {
            create("upload") {
                storeFile = file(keyProperties.getProperty("storeFile"))
                storePassword = keyProperties.getProperty("storePassword")
                keyAlias = keyProperties.getProperty("keyAlias")
                keyPassword = keyProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.findByName("upload")
                ?: signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
