# Keep javax.annotation classes
-keep class javax.annotation.** { *; }

# Keep error-prone annotations
-keep class com.google.errorprone.annotations.** { *; }
-dontwarn javax.annotation.Nullable
-dontwarn javax.annotation.concurrent.GuardedBy
-dontwarn javax.lang.model.element.Modifier
