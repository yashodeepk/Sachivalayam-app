// import 'package:ap_admin_portal/app/shared-widgets/app_sliver_header.dart';
// import 'package:ap_admin_portal/app/view-models/user-vm.dart';
// import 'package:ap_admin_portal/app/widgets/refresh.dart';
// import 'package:ap_admin_portal/core/models/task/todays-task.dart';
// import 'package:ap_admin_portal/core/view_helper/base_view.dart';
// import 'package:ap_admin_portal/utils/enums.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';

// import '../../core/injections/locator.dart';
// import '../../core/models/user/user.dart';
// import '../../gen/assets.gen.dart';
// import '../../generated/l10n.dart';
// import '../../utils/constants/dimens.dart';
// import '../view-models/task-vm/task-vm.dart';
// import '../widgets/loading-widget.dart';
// import '../widgets/no-data-widget.dart';
// import '../widgets/retry-page.dart';
// import '../widgets/task-widget.dart';
// import 'input_widget.dart';

// class TaskData extends StatefulWidget {
//   final TaskStatus taskStatus;
//   const TaskData({Key? key, required this.taskStatus}) : super(key: key);

//   @override
//   State<TaskData> createState() => _TaskDataState();
// }

// class _TaskDataState extends State<TaskData> {
//   late final TaskStatus taskStatus = widget.taskStatus;
//   final RefreshController _refreshController =
//       RefreshController(initialRefresh: false);
//   final TextEditingController _searchController = TextEditingController();
//   final UserVm _authVm = sl<UserVm>();
//   String? title;
//   late User? user = _authVm.user;

//   Future<void> onRefreshed(TaskVm vm) async {
//     _refreshController.refreshCompleted();
//     setState(() {
//       vm.getTaskStatus(taskStatus: taskStatus);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BaseView<TaskVm>(onModelReady: (vm) {
//       switch (taskStatus) {
//         case TaskStatus.all:
//           if (vm.getAllTaskState != BaseModelState.success) {
//             vm.getTaskStatus(taskStatus: taskStatus);
//           }
//           break;
//         case TaskStatus.ongoing:
//           if (vm.getOngoingTaskState != BaseModelState.success) {
//             vm.getTaskStatus(taskStatus: taskStatus);
//           }
//           break;
//         case TaskStatus.inReview:
//           if (vm.getInReviewTaskState != BaseModelState.success) {
//             vm.getTaskStatus(taskStatus: taskStatus);
//           }
//           break;
//         case TaskStatus.completed:
//           if (vm.getCompletedTaskState != BaseModelState.success) {
//             vm.getTaskStatus(taskStatus: taskStatus);
//           }
//           break;
//       }
//     }, builder: (context, taskVm, child) {
//       return Builder(builder: (context) {
//         BaseModelState? taskState;
//         List<Tasks>? taskList = [];
//         switch (taskStatus) {
//           case TaskStatus.all:
//             taskState = taskVm.getAllTaskState;
//             taskList = taskVm.listOfAllTask;
//             title = S.current.noTaskAvailable;
//             break;
//           case TaskStatus.ongoing:
//             taskState = taskVm.getOngoingTaskState;
//             taskList = taskVm.listOfOngoingTask;
//             title = S.current.noOngoingTaskAvailable;
//             break;
//           case TaskStatus.inReview:
//             taskState = taskVm.getInReviewTaskState;
//             taskList = taskVm.listOfInReviewTask;
//             title = S.current.noReviewTaskAvailable;
//             break;
//           case TaskStatus.completed:
//             taskState = taskVm.getCompletedTaskState;
//             taskList = taskVm.listOfCompletedTask;
//             title = user!.userRole == UserRole.roleSecretary
//                 ? S.current.noCompletedTaskAvailable
//                 : S.current.noApprovedTaskAvailable;
//             break;
//         }

//         return taskState == BaseModelState.loading
//             ? const LoadingWidget()
//             : taskVm.getTaskTodayState == BaseModelState.error
//                 ? RetryPage(
//                     onTap: () {
//                       setState(() {
//                         taskVm.getTaskStatus(taskStatus: taskStatus);
//                       });
//                     },
//                     isScaffold: false)
//                 : CustomScrollView(
//                     physics: const NeverScrollableScrollPhysics(),
//                     slivers: [
//                       const SliverPadding(
//                           padding: EdgeInsets.only(top: sixteenDp)),
//                       if (taskList!.isNotEmpty)
//                         AppSliverPersistentHeader(
//                           min: seventyDp,
//                           max: seventyDp,
//                           child: Form(
//                             child: InputWidget(
//                               controller: _searchController,
//                               hint: S.current.searchTask,
//                               edgeInsetsGeometry:
//                                   const EdgeInsets.symmetric(horizontal: tenDp),
//                               onValidate: (value) => null,
//                               onChange: (value) {
//                                 if (value != null) {
//                                   //todo handle
//                                 }
//                               },
//                               inputType: TextInputType.text,
//                               textCapitalization: TextCapitalization.none,
//                               textInputAction: TextInputAction.search,
//                               prefixIcon: Padding(
//                                 padding: const EdgeInsets.all(eightDp),
//                                 child: SvgPicture.asset(
//                                   Assets.svg.search,
//                                   width: twentyDp,
//                                   height: twentyDp,
//                                 ),
//                               ),
//                               onFieldSubmitted: (value) {},
//                             ),
//                           ),
//                         ),
//                       SliverFillRemaining(
//                         child: Column(
//                           crossAxisAlignment: taskList.isEmpty
//                               ? CrossAxisAlignment.center
//                               : CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Refresh(
//                                 controller: _refreshController,
//                                 enablePullDown: true,
//                                 enablePullUp: false,
//                                 onRefresh: () => onRefreshed(taskVm),
//                                 child: taskList.isEmpty
//                                     ? NoDataWidget(
//                                         title: title ?? '',
//                                         image: Assets.lotties.noTask)
//                                     : ListView.builder(
//                                         itemBuilder: (context, index) {
//                                           return TaskItemsWidget(
//                                               task: taskList![index]);
//                                         },
//                                         itemCount: taskList.length,
//                                         shrinkWrap: true,
//                                         padding: const EdgeInsets.only(
//                                             left: tenDp,
//                                             right: tenDp,
//                                             bottom: hundredDp),
//                                         primary: true,
//                                       ),
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     ],
//                   );
//       });
//     });
//   }
// }
