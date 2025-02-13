import 'package:course_management_project/config/constants/colors/colors.dart';
import 'package:course_management_project/config/constants/images_paths.dart';
import 'package:course_management_project/utils/app_theme.dart';
import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key, required this.onImageTap});

  final VoidCallback onImageTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onImageTap,
                child: Container(
                  width: sizeConstants.avatarSmallMed,
                  height: sizeConstants.avatarSmallMed,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(ImagesPaths.profileDemoJpeg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        'کاربر عزیز',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: kWhiteColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'به برنامه خوش آمدید',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: kWhiteColor, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: kTransparentColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(ImagesPaths.tawanaWhiteLogoJpg, fit: BoxFit.cover, height: sizeConstants.avatarSmall),
          ),
        ),
      ],
    );
  }
}
