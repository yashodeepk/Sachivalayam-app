// import 'package:ap_admin_portal/core/data/services/user-service.dart';
// import 'package:ap_admin_portal/core/models/task/todays-task.dart';
// import 'package:ap_admin_portal/gen/fonts.gen.dart';
// import 'package:ap_admin_portal/utils/constants/dimens.dart';
// import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
// import 'package:ap_admin_portal/utils/enums.dart';
// import 'package:ap_admin_portal/utils/functions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../core/injections/locator.dart';
// import '../../core/models/user/user.dart';
// import '../../gen/assets.gen.dart';
// import '../../generated/l10n.dart';
// import '../view/secretary/main-page/tabs/task/task-details.dart';

// class NumberOfWorkersWidget extends StatelessWidget {
//   final String numberOfWorkers;
//   const NumberOfWorkersWidget({Key? key, required this.numberOfWorkers})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         SvgPicture.asset(Assets.svg.taskWorkers),
//         const SizedBox(width: fourDp),
//         Flexible(
//             child: Text(numberOfWorkers,
//                 style: const TextStyle(fontSize: thirteenDp))),
//         const SizedBox(width: fourDp),
//         Text(
//           S.current.workers,
//           style: const TextStyle(fontSize: thirteenDp),
//         ),
//         const SizedBox(width: fourDp),
//       ],
//     );
//   }
// }

// class TaskItemsWidget extends StatefulWidget {
//   final Tasks task;
//   const TaskItemsWidget({Key? key, required this.task}) : super(key: key);

//   @override
//   State<TaskItemsWidget> createState() => _TaskItemsWidgetState();
// }

// class _TaskItemsWidgetState extends State<TaskItemsWidget> {
//   final UserService _authService = sl<UserService>();
//   User? user;

//   getUser() async {
//     user = await _authService.getUser();
//     setState(() {});
//   }

//   @override
//   void initState() {
//     getUser();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => switchScreen(context, TaskDetailsScreen.routeName,
//           args: widget.task.id),
//       child: Container(
//         padding: const EdgeInsets.all(sixDp),
//         margin: const EdgeInsets.symmetric(vertical: tenDp),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(tenDp),
//             border: Border.all(color: ThemeColor.kGrayLight)),
//         child: ListTile(
//           minLeadingWidth: 0,
//           contentPadding: EdgeInsets.zero,
//           title: Column(
//             children: [
//               Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Flexible(
//                         child: Text(widget.task.taskName!,
//                             style: const TextStyle(fontSize: thirteenDp))),
//                     NumberOfWorkersWidget(
//                         numberOfWorkers:
//                             widget.task.assignedWorker!.length.toString())
//                   ]),
//               const SizedBox(height: tenDp),
//               Row(
//                 children: [
//                   Flexible(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         TaskLocationWidget(
//                             taskLocation:
//                                 '${widget.task.fromWorkArea!} to ${widget.task.toWorkArea!}',
//                             iconData: Assets.svg.routing),
//                         const SizedBox(height: tenDp),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Flexible(
//                                 child: TaskLocationWidget(
//                                     taskLocation: user?.sachivalyam ?? '',
//                                     iconData: Assets.svg.location)),
//                             //TaskStatusWidget(taskStatus: task.taskStatus!)
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   TaskStatusWidget(taskStatus: widget.task.taskStatus!)
//                 ],
//               ),
//               const SizedBox(height: tenDp),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class TaskLocationWidget extends StatelessWidget {
//   final String taskLocation;
//   final String iconData;
//   const TaskLocationWidget(
//       {Key? key, required this.taskLocation, required this.iconData})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         SvgPicture.asset(iconData),
//         const SizedBox(width: fourDp),
//         Flexible(
//           child: Text(
//             taskLocation,
//             style: const TextStyle(fontSize: twelveDp),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 2,
//           ),
//         )
//       ],
//     );
//   }
// }

// class TaskStatusWidget extends StatelessWidget {
//   final TaskStatus taskStatus;
//   const TaskStatusWidget({Key? key, required this.taskStatus})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final color = taskStatus == TaskStatus.ongoing
//         ? ThemeColor.kOngoingTaskCardColor
//         : taskStatus == TaskStatus.inReview
//             ? ThemeColor.kDeepBlue
//             : ThemeColor.kAccentGreen;

//     return Container(
//       padding: const EdgeInsets.all(eightDp),
//       decoration: BoxDecoration(
//           color: ThemeColor.kGrayLight,
//           borderRadius: BorderRadius.circular(sixteenDp)),
//       child: Row(
//         children: [
//           const SizedBox(width: tenDp),
//           Container(
//             width: tenDp,
//             height: tenDp,
//             decoration: BoxDecoration(shape: BoxShape.circle, color: color),
//           ),
//           const SizedBox(width: fourDp),
//           Text(
//             taskStatusValues.reverse[taskStatus]!,
//             style: TextStyle(
//                 fontFamily: FontFamily.medium,
//                 fontWeight: FontWeight.w500,
//                 fontSize: tenDp,
//                 color: color),
//           ),
//           const SizedBox(width: tenDp),
//         ],
//       ),
//     );
//   }
// }
