// import 'dart:io';
// import 'dart:typed_data';

// import 'package:ap_admin_portal/app/shared-widgets/app_snackbar.dart';
// import 'package:ap_admin_portal/app/shared-widgets/button_widget.dart';
// import 'package:ap_admin_portal/app/shared-widgets/image_capture.dart';
// import 'package:ap_admin_portal/gen/assets.gen.dart';
// import 'package:ap_admin_portal/generated/l10n.dart';
// import 'package:ap_admin_portal/utils/enums.dart';
// import 'package:dio/dio.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../../core/injections/locator.dart';
// import '../../../gen/fonts.gen.dart';
// import '../../../utils/constants/dimens.dart';
// import '../../../utils/constants/theme_colors.dart';
// import '../../../utils/functions.dart';
// import '../../view-models/task-vm/task-vm.dart';

// class CompleteTaskDialog extends StatefulWidget {
//   final String taskId;
//   const CompleteTaskDialog({Key? key, required this.taskId}) : super(key: key);

//   @override
//   State<CompleteTaskDialog> createState() => _CompleteTaskDialogState();
// }

// class _CompleteTaskDialogState extends State<CompleteTaskDialog> {
//   final List<File> imageFileList = [];
//   final List<String> _uploadImageFileNameList = [];
//   final List<Uint8List> _uploadImageToBytes = [];
//   final TaskVm _taskVm = sl<TaskVm>();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(sixteenDp),
//       margin: const EdgeInsets.symmetric(horizontal: twentyDp, vertical: fiftyDp),
//       decoration: BoxDecoration(color: ThemeColor.kWhite, borderRadius: BorderRadius.circular(tenDp)),
//       child: Material(
//         color: ThemeColor.kWhite,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Flexible(
//                           child: Text(
//                             S.current.completeTask,
//                             style: const TextStyle(
//                                 fontFamily: FontFamily.medium, color: ThemeColor.kLightBlack, fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                         IconButton(
//                             onPressed: () => pop(context),
//                             icon: const Icon(
//                               Icons.close,
//                               color: ThemeColor.kLightBlack,
//                             ))
//                       ],
//                     ),
//                     const SizedBox(height: sixteenDp),
//                     Text(S.current.afterImage,
//                         style: const TextStyle(color: ThemeColor.kLightBlack, fontWeight: FontWeight.w400)),
//                     const SizedBox(height: tenDp),
//                     GestureDetector(
//                       onTap: () => selectOption(),
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: sixDp),
//                         decoration: BoxDecoration(color: ThemeColor.kWhite, borderRadius: BorderRadius.circular(tenDp)),
//                         child: DottedBorder(
//                           strokeWidth: 0.9,
//                           borderType: BorderType.RRect,
//                           color: ThemeColor.kGray,
//                           dashPattern: const [9, 2],
//                           radius: const Radius.circular(tenDp),
//                           child: Container(
//                             alignment: Alignment.center,
//                             padding: const EdgeInsets.all(tenDp),
//                             width: MediaQuery.of(context).size.width,
//                             decoration: BoxDecoration(
//                                 color: ThemeColor.kGrayLight.withOpacity(0.4), borderRadius: BorderRadius.circular(tenDp)),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 SvgPicture.asset(Assets.svg.upload),
//                                 Text(
//                                   S.current.uploadAfterImageHere,
//                                   style: const TextStyle(
//                                       color: ThemeColor.kGray, fontWeight: FontWeight.w500, fontFamily: FontFamily.medium),
//                                 ),
//                                 const SizedBox(height: tenDp),
//                                 Text(
//                                   S.current.addImage,
//                                   style: const TextStyle(
//                                       decoration: TextDecoration.underline,
//                                       color: ThemeColor.kActive,
//                                       fontWeight: FontWeight.w500,
//                                       fontFamily: FontFamily.medium),
//                                 ),
//                                 const SizedBox(height: tenDp),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: tenDp),
//                     imageFileList.isEmpty ? Center(child: Text(S.current.noImageAdded)) : upLoadImages()
//                   ],
//                 ),
//               ),
//             ),

//             //submit button
//             Builder(builder: (context) {
//               return ButtonWidget(
//                   buttonName: S.current.submit,
//                   onButtonTapped: () async => await onSubmitTapped(context),
//                   width: MediaQuery.of(context).size.width,
//                   buttonColor: ThemeColor.kPrimaryGreen,
//                   edgeInsetsGeometry: const EdgeInsets.symmetric(horizontal: sixDp, vertical: tenDp),
//                   buttonTextColor: ThemeColor.kWhite);
//             })
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> onSubmitTapped(BuildContext context) async {
//     if (imageFileList.isNotEmpty) {
//       _uploadImageToBytes.clear();
//       _uploadImageFileNameList.clear();

//       for (int i = 0; i < imageFileList.length; i++) {
//         _uploadImageFileNameList.add(getFileNameAndExtension(file: imageFileList.elementAt(i)));
//         _uploadImageToBytes.add(await imageFileList.elementAt(i).readAsBytes());
//       }

//       final FormData formData = FormData.fromMap({
//         'task_status': taskStatusValues.reverse[TaskStatus.inReview],
//         'after_image': [..._uploadImageFileNameList],
//         'task_images': _uploadImageToBytes
//             .map((e) => MultipartFile.fromBytes(
//                   e.cast<int>(),
//                   filename: _uploadImageFileNameList[_uploadImageToBytes.indexOf(e)],
//                 ))
//             .toList(),
//       });

//       await _taskVm.updateTask(context: context, formData: formData, taskId: widget.taskId);
//     } else {
//       showAppSnackBar(message: S.current.pleaseAddAfterImages, context: context);
//     }
//   }

//   removeImageFromList(File e) {
//     setState(() {
//       imageFileList.remove(e);
//     });
//   }

//   void selectOption() async {
//     await showModalBottomSheet<void>(
//         enableDrag: true,
//         isScrollControlled: true,
//         isDismissible: true,
//         context: context,
//         builder: (BuildContext context) => ImageCaptureBottomSheet(
//             onCameraTapped: () => _onTap(AppImageSource.camera), onGalleryTapped: () => _onTap(AppImageSource.gallery)));
//   }

//   Widget upLoadImages() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(S.current.uploadedImages, style: const TextStyle(color: ThemeColor.kLightBlack, fontWeight: FontWeight.w400)),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           padding: EdgeInsets.zero,
//           child: Row(
//             //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: imageFileList
//                 .map((e) => Stack(
//                       alignment: Alignment.topRight,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(right: eightDp),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(tenDp),
//                             child: Image.file(
//                               e,
//                               height: oneFiftyDp,
//                               width: oneFiftyDp,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 2,
//                           right: tenDp,
//                           child: GestureDetector(
//                             onTap: () => removeImageFromList(e),
//                             child: Container(
//                               width: twentyFiveDp,
//                               height: twentyFiveDp,
//                               margin: const EdgeInsets.all(tenDp),
//                               decoration: const BoxDecoration(
//                                 color: ThemeColor.kErrorBorderColor,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Center(
//                                 child: Icon(
//                                   Icons.close,
//                                   color: ThemeColor.kWhite,
//                                   size: sixteenDp,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ))
//                 .toList(),
//           ),
//         )
//       ],
//     );
//   }

//   void _onTap(AppImageSource imageSource) async {
//     pop(context, route: false);
//     final file = await takePicture(imageSource);
//     if (file != null) {
//       final compressImageFile = await compressFile(file);
//       setState(() {
//         imageFileList.add(compressImageFile);
//       });
//     }
//   }
// }
