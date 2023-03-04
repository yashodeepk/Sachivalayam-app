// import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../../../../../gen/fonts.gen.dart';
// import '../../../../../../utils/constants/dimens.dart';

// ///task status message
// class TaskStatusMessage extends StatelessWidget {
//   final String icon;
//   final String title;
//   final String description;
//   final Color bgColor;
//   const TaskStatusMessage({Key? key, required this.icon, required this.title, required this.description, required this.bgColor})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(top: sixteenDp, bottom: sixteenDp, left: fourteenDp, right: fourteenDp),
//       margin: const EdgeInsets.symmetric(horizontal: sixteenDp),
//       decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(tenDp)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SvgPicture.asset(icon),
//           const SizedBox(width: tenDp),
//           Expanded(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(color: ThemeColor.kBlack, fontFamily: FontFamily.bold),
//               ),
//               const SizedBox(height: tenDp),
//               Text(description, style: const TextStyle(color: ThemeColor.kBlack, fontFamily: FontFamily.regular)),
//             ],
//           ))
//         ],
//       ),
//     );
//   }
// }
