# Flutter-related rules
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Firebase (if used)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Gson (if used)
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# Retrofit (if used)
-keep class retrofit2.** { *; }
-dontwarn retrofit2.**

# AndroidX (common)
-keep class androidx.** { *; }
-dontwarn androidx.**


# flutter_stripe (dependency)
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider