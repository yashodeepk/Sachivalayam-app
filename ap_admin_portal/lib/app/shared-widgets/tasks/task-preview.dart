// import 'package:ap_admin_portal/app/shared-widgets/button_widget.dart';
// import 'package:ap_admin_portal/app/shared-widgets/tasks/task-complete-dialog.dart';
// import 'package:ap_admin_portal/app/shared-widgets/tasks/task-status-message.dart';
// import 'package:ap_admin_portal/app/view-models/user-vm.dart';
// import 'package:ap_admin_portal/app/widgets/animated.column.dart';
// import 'package:ap_admin_portal/app/widgets/custom_dialog_box.dart';
// import 'package:ap_admin_portal/core/injections/injections.dart';
// import 'package:ap_admin_portal/core/models/task/todays-task.dart';
// import 'package:ap_admin_portal/core/models/user/user.dart';
// import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// import '../../../../../../gen/assets.gen.dart';
// import '../../../../../../gen/fonts.gen.dart';
// import '../../../../../../generated/l10n.dart';
// import '../../../../../../utils/constants/dimens.dart';
// import '../../../../../../utils/enums.dart';
// import '../../../../../../utils/functions.dart';
// import '../../view-models/task-vm/task-vm.dart';

// ///task preview
// class TaskPreview extends StatefulWidget {
//   final Tasks task;
//   const TaskPreview({Key? key, required this.task}) : super(key: key);

//   @override
//   State<TaskPreview> createState() => _TaskPreviewState();
// }

// class _TaskPreviewState extends State<TaskPreview> {
//   late Tasks getTask = widget.task;
//   late final listOfWorkers = getTask.assignedWorker;
//   final UserVm _authVm = sl<UserVm>();
//   late final User? _user = _authVm.user;
//   final TaskVm _taskVm = sl<TaskVm>();

//   Widget assignedWorkers({required List<String> workers}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 0),
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(tenDp), color: ThemeColor.kFillColor),
//       child: ListView.separated(
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(sixDp),
//             child: Text(
//               workers[index],
//               style: const TextStyle(color: ThemeColor.kActive),
//             ),
//           );
//         },
//         separatorBuilder: (context, index) {
//           return const Divider();
//         },
//         itemCount: workers.length,
//         padding: const EdgeInsets.symmetric(horizontal: tenDp),
//         shrinkWrap: true,
//         primary: false,
//       ),
//     );
//   }

//   Widget beforeOrAfterImage({required String label, required DateTime dateTime, required List<String>? images}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               label,
//               style: const TextStyle(color: ThemeColor.kLightBlack, fontWeight: FontWeight.w400),
//             ),
//             Text(
//               dateFormatter(formatType: 'dd/MM/yyy', dateTime: dateTime),
//               style: const TextStyle(color: ThemeColor.kGray, fontWeight: FontWeight.w400, fontSize: twelveDp),
//             ),
//           ],
//         ),
//         const SizedBox(height: tenDp),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           padding: EdgeInsets.zero,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: images!
//                 .map((imageUrl) => Padding(
//                       padding: const EdgeInsets.only(right: tenDp),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(tenDp),
//                         child: CachedNetworkImage(
//                           imageUrl: imageUrl,
//                           height: oneFiftyDp,
//                           width: oneFiftyDp,
//                           fit: BoxFit.cover,
//                           errorWidget: (context, url, error) => const Center(
//                             child: Text('Image could not be downloaded'),
//                           ),
//                           placeholder: (context, url) => const Center(
//                               child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation(ThemeColor.kPrimaryGreen),
//                           )),
//                         ),
//                       ),
//                     ))
//                 .toList(),
//           ),
//         )
//       ],
//     );
//   }

//   Widget itemRow({required String title, String? description, List? data, bool isList = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: eightDp),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Text(title,
//                 style:
//                     const TextStyle(fontFamily: FontFamily.regular, fontWeight: FontWeight.w400, color: ThemeColor.kLightBlack)),
//           ),
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(':'),
//                 const SizedBox(width: tenDp),
//                 isList
//                     ? Flexible(
//                         child: ListView.builder(
//                         itemBuilder: (context, index) {
//                           final length = index;
//                           final count = ++index;

//                           return Text('$count.${data[length]}',
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.w400, fontFamily: FontFamily.medium, color: ThemeColor.kActive));
//                         },
//                         itemCount: data!.length,
//                         shrinkWrap: true,
//                         padding: EdgeInsets.zero,
//                       ))
//                     : Flexible(
//                         child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           description ?? '',
//                           style: const TextStyle(
//                               fontWeight: FontWeight.w400, fontFamily: FontFamily.medium, color: ThemeColor.kActive),
//                         ),
//                       )),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Future onCompleteTaskTapped(BuildContext context) async {
//     showDialog(
//       context: context,
//       builder: (context) => CustomDialogBox(
//         sigmaX: 0,
//         sigmaY: 0,
//         child: CompleteTaskDialog(taskId: getTask.id!),
//       ),
//       barrierDismissible: false,
//     );
//   }

//   onApproveTapped(BuildContext context) async {
//     if (_user!.userRole == UserRole.roleSanitaryInspector) {
//       final FormData formData = FormData.fromMap({
//         'task_status': taskStatusValues.reverse[TaskStatus.completed],
//       });

//       await _taskVm.updateTask(context: context, formData: formData, taskId: getTask.id!);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         if (_user!.userRole != UserRole.roleSanitaryInspector) ...{
//           if (getTask.taskStatus == TaskStatus.inReview) ...{
//             TaskStatusMessage(
//                 icon: Assets.svg.ongoing,
//                 title: S.current.taskInReview,
//                 description: S.current.taskInReviewDescription,
//                 bgColor: ThemeColor.kInReviewMessage)
//           } else if (getTask.taskStatus == TaskStatus.completed) ...{
//             TaskStatusMessage(
//                 icon: Assets.svg.approved,
//                 title: S.current.taskApproved,
//                 description: S.current.taskApprovedDescription,
//                 bgColor: ThemeColor.kApprovedMessage)
//           }
//         },
//         Expanded(
//           child: SingleChildScrollView(
//             child: Builder(builder: (context) {
//               return Container(
//                 padding: const EdgeInsets.symmetric(horizontal: sixteenDp),
//                 child: AnimatedColumnWidget(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   const SizedBox(height: tenDp),
//                   Container(
//                     padding: const EdgeInsets.all(fourteenDp),
//                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(tenDp), color: ThemeColor.kFillColor),
//                     child: AnimatedColumnWidget(
//                       children: [
//                         itemRow(title: S.current.taskName, description: getTask.taskName),
//                         itemRow(title: S.current.fromWorkArea, description: getTask.fromWorkArea),
//                         itemRow(title: S.current.toWorkArea, description: getTask.toWorkArea),
//                         itemRow(title: S.current.assignWorker, data: listOfWorkers, isList: true),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: sixteenDp),
//                   beforeOrAfterImage(label: S.current.beforeImage, dateTime: getTask.createdAt!, images: getTask.beforeImage),
//                   const SizedBox(height: sixteenDp),
//                   if (getTask.afterImage!.isNotEmpty)
//                     beforeOrAfterImage(label: S.current.afterImage, dateTime: getTask.updatedAt!, images: getTask.afterImage!),
//                 ]),
//               );
//             }),
//           ),
//         ),
//         if (_user!.userRole != UserRole.roleSanitaryInspector) ...{
//           if (getTask.taskStatus == TaskStatus.ongoing)
//             ButtonWidget(
//                 buttonName: S.current.completeTask,
//                 onButtonTapped: () => onCompleteTaskTapped(context),
//                 width: MediaQuery.of(context).size.width,
//                 buttonColor: ThemeColor.kPrimaryGreen,
//                 edgeInsetsGeometry: const EdgeInsets.all(sixteenDp),
//                 buttonTextColor: ThemeColor.kWhite)
//         } else ...{
//           if (getTask.taskStatus == TaskStatus.inReview)
//             ButtonWidget(
//                 buttonName: S.current.approved.substring(0, S.current.approved.length - 1),
//                 onButtonTapped: () => onApproveTapped(context),
//                 width: MediaQuery.of(context).size.width,
//                 buttonColor: ThemeColor.kPrimaryGreen,
//                 edgeInsetsGeometry: const EdgeInsets.all(sixteenDp),
//                 buttonTextColor: ThemeColor.kWhite)
//         }
//       ],
//     );
//   }
// }
