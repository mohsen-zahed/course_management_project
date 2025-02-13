import 'dart:math';

import 'package:flutter/material.dart';

List<Map<String, Color>> getMatchingColors(int totalColors) {
  assert(totalColors > 0, "totalColors must be greater than 0");

  List<Map<String, Color>> colorPairs = [];

  for (int index = 0; index < totalColors; index++) {
    // Generate a base hue
    double hue = (index * 360 / totalColors) % 360;

    // Lightness for bright, smooth backgrounds (values between 0.7 and 0.9)
    double baseLightness = 0.85 + Random().nextDouble() * 0.05;
    double saturation = 0.5 + Random().nextDouble() * 0.3; // Moderate saturation for vibrancy

    // Generate background color
    Color backgroundColor = HSLColor.fromAHSL(1.0, hue, saturation, baseLightness).toColor();

    // Generate foreground color (either dark or light based on the background)
    // If the background is light, use a dark foreground color; if dark, use a light foreground
    Color foregroundColor = HSLColor.fromAHSL(1.0, hue, 0.6, 0.5).toColor();

    // Add the color pair to the list
    colorPairs.add({
      'background': backgroundColor,
      'foreground': foregroundColor,
    });
  }

  return colorPairs;
}
