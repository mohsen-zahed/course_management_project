import 'package:flutter/material.dart';

double getMediaQueryWidth(BuildContext context, [double? width]) {
  return MediaQuery.of(context).size.width * (width ?? 1);
}

double getMediaQueryHeight(BuildContext context, [double? height]) {
  return MediaQuery.of(context).size.height * (height ?? 1);
}

double getScreenArea(BuildContext context, [num? area]) {
  return (getMediaQueryWidth(context) * getMediaQueryHeight(context)) * (area ?? 1);
}
