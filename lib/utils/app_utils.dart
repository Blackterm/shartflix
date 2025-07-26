import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_colors.dart';
import 'snackbar_status_enum.dart';
import 'constants.dart';

class AppUtils {
  static void showSnackBar(BuildContext context, String message, {MessageStatus status = MessageStatus.normal}) {
    Color backgroundColor;
    switch (status) {
      case MessageStatus.success:
        backgroundColor = ThemeColor.green;
        break;
      case MessageStatus.error:
        backgroundColor = ThemeColor.red;
        break;
      case MessageStatus.warning:
        backgroundColor = ThemeColor.orange;
        break;
      case MessageStatus.normal:
        backgroundColor = ThemeColor.black;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static List<Color> generateRandomColors(int n) {
    final random = Random();
    List<Color> bgColors = [];

    for (int i = 0; i < n; i++) {
      Color color = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1.0,
      );
      bgColors.add(color);
    }

    return bgColors;
  }

  static Future<void> openUrl(BuildContext context, String url, {String? errorMessage}) async {
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          AppUtils.showSnackBar(
            context,
            errorMessage ?? 'Bağlantı açılamadı: $url',
            status: MessageStatus.error,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppUtils.showSnackBar(
          context,
          'Bir hata oluştu: $e',
          status: MessageStatus.error,
        );
      }
    }
  }

  static Future<void> openTermsOfService(BuildContext context) async {
    await openUrl(
      context,
      AppConstants.termsOfServiceUrl,
      errorMessage: 'Kullanıcı sözleşmesi açılamadı',
    );
  }
}
