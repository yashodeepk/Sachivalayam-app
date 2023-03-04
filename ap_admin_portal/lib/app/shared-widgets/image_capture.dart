// import 'package:flutter/material.dart';

// import '../../generated/l10n.dart';
// import '../../utils/constants/dimens.dart';
// import '../../utils/constants/theme_colors.dart';
// import '../../utils/enums.dart';
// import '../widgets/animated.column.dart';

// class ImageCaptureBottomSheet extends StatefulWidget {
//   final Function() onCameraTapped, onGalleryTapped;

//   const ImageCaptureBottomSheet({Key? key, required this.onCameraTapped, required this.onGalleryTapped}) : super(key: key);

//   @override
//   State<ImageCaptureBottomSheet> createState() => _ImageCaptureBottomSheetState();
// }

// class _ImageCaptureBottomSheetState extends State<ImageCaptureBottomSheet> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height / 4,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: twentyDp, vertical: tenDp),
//             child: Text(
//               S.current.selectOption,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: sixteenDp),
//             ),
//           ),
//           const SizedBox(height: twentyDp),
//           Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//             item(title: S.current.camera, iconData: Icons.camera, onTap: widget.onCameraTapped),
//             item(title: S.current.gallery, iconData: Icons.photo_album, onTap: widget.onGalleryTapped),
//           ]),
//         ],
//       ),
//     );
//   }

//   Widget item({required String title, required IconData iconData, required Function() onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedColumnWidget(
//         animateType: AnimateType.slideUp,
//         children: [
//           GestureDetector(
//             onTap: onTap,
//             child: Container(
//                 width: fiftyDp,
//                 height: fiftyDp,
//                 decoration: const BoxDecoration(color: ThemeColor.kActive, shape: BoxShape.circle),
//                 child: Icon(
//                   iconData,
//                   color: ThemeColor.kWhite,
//                 )),
//           ),
//           const SizedBox(height: tenDp),
//           Text(title)
//         ],
//       ),
//     );
//   }
// }
