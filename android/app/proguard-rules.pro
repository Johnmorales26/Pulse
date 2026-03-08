# =============================================================================
# CONTEXTO IMPORTANTE: Flutter + ProGuard/R8
# =============================================================================
# El código Dart de Flutter se compila a bytecode nativo (ARM/x64) y NO pasa
# por R8. ProGuard SOLO afecta el código Java/Kotlin de los plugins nativos
# y los SDKs de terceros. Por eso, tus modelos Dart (PlaceLocation, etc.)
# están completamente a salvo — no necesitan reglas -keep en este archivo.
# =============================================================================


# =============================================================================
# FLUTTER ENGINE — Clases de embedding Java
# =============================================================================
# El motor de Flutter se comunica con Android a través de estas clases Java.
# Ofuscarlas rompería el arranque de la app completamente.
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-dontwarn io.flutter.**


# =============================================================================
# FIREBASE CORE & PLATFORM
# =============================================================================
# Los SDKs de Firebase incluyen sus propias reglas consumer, pero las
# declaramos explícitamente para garantizar compatibilidad con R8 en modo
# "full mode" (más agresivo que el modo compat).
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# FirebaseApp y sus providers internos usan reflexión para inicializar
# componentes — deben mantenerse con sus nombres originales.
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**


# =============================================================================
# FIREBASE AUTH
# =============================================================================
# El flujo de autenticación usa clases internas que R8 puede eliminar
# si las considera "no referenciadas" desde el código Dart.
-keep class com.google.firebase.auth.** { *; }
-keepnames class com.google.firebase.auth.** { *; }


# =============================================================================
# CLOUD FIRESTORE
# =============================================================================
# Firestore usa reflexión para mapear campos en sus operaciones internas de
# serialización de queries y listeners. Conservamos todos sus internals.
-keep class com.google.firebase.firestore.** { *; }
-keepnames class com.google.firebase.firestore.** { *; }
-dontwarn com.google.firebase.firestore.**


# =============================================================================
# FIREBASE STORAGE
# =============================================================================
-keep class com.google.firebase.storage.** { *; }
-dontwarn com.google.firebase.storage.**


# =============================================================================
# MAPBOX MAPS SDK
# =============================================================================
# El SDK de Mapbox tiene componentes nativos (C++) que se comunican con la
# capa Java a través de JNI. Las clases JNI deben conservar sus nombres exactos
# o la comunicación nativa falla en runtime con UnsatisfiedLinkError.
-keep class com.mapbox.** { *; }
-keepnames class com.mapbox.** { *; }
-dontwarn com.mapbox.**


# =============================================================================
# KOTLIN STANDARD LIBRARY
# =============================================================================
# Kotlin usa metadatos de reflexión en tiempo de ejecución para lambdas,
# coroutines y extensiones. R8 puede eliminar estos metadatos agresivamente.
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-dontwarn kotlin.**
-dontwarn kotlinx.**


# =============================================================================
# GEOLOCATOR (plugin de ubicación)
# =============================================================================
-keep class com.baseflow.geolocator.** { *; }
-dontwarn com.baseflow.geolocator.**


# =============================================================================
# IMAGE PICKER (subida de foto de perfil)
# =============================================================================
-keep class io.flutter.plugins.imagepicker.** { *; }
-dontwarn io.flutter.plugins.imagepicker.**


# =============================================================================
# REFLEXIÓN Y SERIALIZACIÓN GENERAL
# =============================================================================
# Conservar anotaciones en tiempo de ejecución — necesarias para cualquier
# librería que use reflexión internamente (Firebase, Kotlin coroutines, etc.)
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeInvisibleAnnotations
-keepattributes EnclosingMethod
-keepattributes InnerClasses


# =============================================================================
# CRASHLYTICS / DEOBFUSCACIÓN (ver sección mapping.txt abajo)
# =============================================================================
# Preservar números de línea en los stack traces para Firebase Crashlytics.
# Sin esto, los crashes en producción muestran líneas ofuscadas sin contexto.
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception


# =============================================================================
# MAP LAUNCHER
# =============================================================================
# map_launcher invoca apps externas de mapas (Google Maps, Waze, etc.) usando
# Intents implícitos. Su glue code Kotlin debe conservarse para que la
# resolución de Intents funcione en runtime.
-keep class com.map_launcher.** { *; }
-dontwarn com.map_launcher.**


# =============================================================================
# TOASTIFICATION
# =============================================================================
# Pure Dart en su mayoría, pero conservamos por si usa reflection interna.
-keep class com.toastification.** { *; }
-dontwarn com.toastification.**