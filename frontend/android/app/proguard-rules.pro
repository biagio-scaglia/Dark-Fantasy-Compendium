# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep application classes
-keep class com.example.dark_fantasy_compendium.** { *; }

# Keep data models (for JSON serialization)
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable implementations
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Optimization
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose

# Remove unused code
-dontwarn **
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*

# Preserve SVG assets and Flutter assets
-keep class **.R$* { *; }
-keep class **.R { *; }
-keepclassmembers class **.R$* {
    public static <fields>;
}

# Keep asset files (SVG, images, etc.)
-keep class flutter.** { *; }
-keep class io.flutter.** { *; }

# Preserve asset manifest
-keep class **.AssetManifest { *; }
-keep class **.AssetManifest$* { *; }

