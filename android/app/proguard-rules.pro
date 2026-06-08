## Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

## UCrop (image_cropper)
-keep class com.yalantis.ucrop.** { *; }
-dontwarn com.yalantis.ucrop.**

## Google Fonts
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

## Rive
-keep class app.rive.** { *; }
-dontwarn app.rive.**

## Lottie
-keep class com.airbnb.lottie.** { *; }
-dontwarn com.airbnb.lottie.**

## SharedPreferences
-keep class androidx.datastore.** { *; }

## General
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
