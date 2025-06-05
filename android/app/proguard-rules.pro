# Keep Razorpay SDK classes
-keep class com.razorpay.** { *; }
-keep class * extends com.razorpay.BaseRazorpay { *; }

# Keep Google Pay API classes
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }

# Keep annotations to prevent removal
-keep @interface proguard.annotation.Keep
-keep @interface proguard.annotation.KeepClassMembers

# Don't warn about missing Google Pay classes
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.PaymentsClient
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.Wallet
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.WalletUtils
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers
