// import 'package:course_management_project/config/constants/colors/colors.dart';
// import 'package:course_management_project/config/constants/images_paths.dart';
// import 'package:flutter/material.dart';

// class UserProfileBox extends StatelessWidget {
//   const UserProfileBox({
//     super.key
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         color: kBlueCustomColor,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 65,
//                   height: 65,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: AssetImage(ImagesPaths.profileDemoJpeg),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Flexible(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Flexible(
//                         child: Text(
//                           'کاربر عزیز',
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleLarge!
//                               .copyWith(color: kWhiteColor, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                       Text(
//                         'به برنامه خوش آمدید',
//                         style: Theme.of(context)
//                             .textTheme
//                             .titleMedium!
//                             .copyWith(color: kWhiteColor, fontWeight: FontWeight.bold),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 10),
//           Container(
//             padding: const EdgeInsets.all(3),
//             decoration: BoxDecoration(
//               color: kTransparentColor,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.asset(ImagesPaths.tawanaWhiteLogoJpg, fit: BoxFit.cover, height: 50),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
