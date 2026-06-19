import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  static void success(BuildContext context, String title) {
    toastification.show(
      context: context,
      title: Text(title),
      type: ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 7),
    );
  }

  static void error(BuildContext context, String title) {
    toastification.show(
      context: context,
      title: Text(title),
      type: ToastificationType.error,
      autoCloseDuration: const Duration(seconds: 7),
    );
  }

  static void warning(BuildContext context, String title) {
    toastification.show(
      context: context,
      title: Text(title),
      type: ToastificationType.warning,
      autoCloseDuration: const Duration(seconds: 7),
    );
  }

  static void info(BuildContext context, String title) {
    toastification.show(
      context: context,
      title: Text(title),
      type: ToastificationType.info,
      autoCloseDuration: const Duration(seconds: 7),
    );
  }
}
