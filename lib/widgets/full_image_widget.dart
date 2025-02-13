import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullImageWidget extends StatelessWidget {
  static const String id = '/full_image';
  const FullImageWidget({super.key, required this.imagePath});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoView(
            imageProvider: CachedNetworkImageProvider(imagePath),
            tightMode: false,
          ),
          Positioned(
            top: 30,
            right: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close, color: kWhiteColor),
            ),
          ),
        ],
      ),
    );
  }
}
