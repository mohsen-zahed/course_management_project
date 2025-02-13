
import 'package:flutter/material.dart';

bool isThemeLight(BuildContext context) {
  if (context.mounted) {
    return Theme.of(context).brightness == Brightness.light;
  }
  return true;
}
