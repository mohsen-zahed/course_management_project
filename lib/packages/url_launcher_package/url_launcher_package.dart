import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherPackage {
  static void launchWhatsApp(String url) async {
    try {
      // Check if the URL can be launched
      if (await canLaunchUrl(Uri.parse(url))) {
        // Launch WhatsApp
        await launchUrl(Uri.parse(url));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
