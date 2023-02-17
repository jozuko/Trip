## general
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeInvisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepattributes RuntimeInvisibleParameterAnnotations
-keepattributes EnclosingMethod
-dontnote com.google.**
-dontnote com.android.**
-dontnote android.net.http.**
-keep class sun.misc.Unsafe { *; }

## androidx
-keep class androidx.** { *; }
-keep interface androidx.** { *; }
-dontwarn androidx.**

## material
-keep class com.google.android.material.** { *; }
-dontwarn com.google.android.material.**
-dontnote com.google.android.material.**

## GMS
-keep class com.google.android.gms.** { *; }
-keep class com.google.firebase.** { *; }
-keep class com.google.gson.** { *; }
-keepnames class * extends java.util.ListResourceBundle { protected java.lang.Object[][] getContents(); }
-keepnames public class com.google.android.gms.common.internal.safeparcel.SafeParcelable { public static final *** NULL; }
-keepnames @com.google.android.gms.common.annotation.KeepName class *
-keepnames class * implements android.os.Parcelable { public static final ** CREATOR; }
-keepclassmembernames class * { @com.google.android.gms.common.annotation.KeepName *; }

# Firestore
-keep class io.grpc.** { *; }

# QR
-keep class com.google.zxing.** { *; }

## kotlin
-dontwarn kotlin.**
-keep class kotlin.** { *; }
-keepclassmembernames class kotlinx.** { volatile <fields>; }

# remove log
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
}
-assumenosideeffects class timber.log.Timber {
    public static *** v(...);
    public static *** d(...);
}

-dontwarn com.google.errorprone.annotations.DoNotMock