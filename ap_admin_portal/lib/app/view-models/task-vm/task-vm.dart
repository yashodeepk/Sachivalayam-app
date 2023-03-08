/*
import 'package:ap_gov_app/app/shared-widgets/app_snackbar.dart';
import 'package:ap_gov_app/app/view-models/user-vm.dart';
import 'package:ap_gov_app/app/view/secretary/main-page/secretary-main-page.dart';
import 'package:ap_gov_app/core/models/task/download-link.dart';
import 'package:ap_gov_app/core/models/task/new-task-details.dart';
import 'package:ap_gov_app/core/models/task/todays-task.dart';
import 'package:ap_gov_app/core/models/user/user.dart';
import 'package:ap_gov_app/utils/functions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../../core/data/services/task-service.dart';
import '../../../core/injections/locator.dart';
import '../../../core/models/selector.dart';
import '../../../gen/assets.gen.dart';
import '../../../generated/l10n.dart';
import '../../../utils/enums.dart';

@lazySingleton
class TaskVm extends ChangeNotifier {
  final UserVm _userVm = sl<UserVm>();
  User? user;
  final TaskService _taskService = sl<TaskService>();

  BaseModelState getTaskTodayState = BaseModelState.initial;
  BaseModelState getAllTaskState = BaseModelState.initial;
  BaseModelState getOngoingTaskState = BaseModelState.initial;
  BaseModelState getInReviewTaskState = BaseModelState.initial;
  BaseModelState getCompletedTaskState = BaseModelState.initial;
  BaseModelState getTaskByIdState = BaseModelState.initial;
  BaseModelState getDownloadState = BaseModelState.initial;

  List<Tasks>? listOfAllTask = List<Tasks>.empty(growable: true);
  List<Tasks>? listOfInReviewTask = List<Tasks>.empty(growable: true);
  List<Tasks>? listOfOngoingTask = List<Tasks>.empty(growable: true);
  List<Tasks>? listOfCompletedTask = List<Tasks>.empty(growable: true);

  TaskToday? _taskToday;
  TaskToday? get taskToday => _taskToday;

  Tasks? _tasks;
  Tasks? get tasks => _tasks;

  BaseModelState getNewTaskDetailsState = BaseModelState.initial;
  NewTaskDetails? _newTaskDetails;
  NewTaskDetails? get newTaskDetails => _newTaskDetails;

  DownloadLink? _downloadLink;
  DownloadLink? get downloadLink => _downloadLink;

  Future<void> getTaskToday() async {
    getTaskTodayState = BaseModelState.loading;
    user = _userVm.user;

    if (user != null) {
      final results = await _taskService.getTaskToday(uid: user!.id!);

      results.fold((error) {
        getTaskTodayState = BaseModelState.error;
      }, (taskData) {
        _taskToday = taskData;
        getTaskTodayState = BaseModelState.success;
      });
    } else {
      getTaskTodayState = BaseModelState.error;
    }
    notifyListeners();
  }

  Future<void> getNewTaskDetails() async {
    getNewTaskDetailsState = BaseModelState.loading;

    final results = await _taskService.getNewTaskDetails();

    results.fold((error) {
      getNewTaskDetailsState = BaseModelState.error;
    }, (data) async {
      _newTaskDetails = data;
      getNewTaskDetailsState = BaseModelState.success;
      await getTaskStatus(taskStatus: TaskStatus.inReview);
    });

    notifyListeners();
  }

  Future<void> addNewTask({required BuildContext context, required FormData formData}) async {
    loader(context: context);
    final results = await _taskService.addNewTask(formData: formData);

    results.fold((failed) {
      pop(context, route: false);
      showAppSnackBar(message: failed, lottieString: Assets.lotties.error, context: context);
    }, (successful) async {
      pop(context, route: false);
      showAppSnackBar(
          message: S.current.created,
          description: S.current.youHaveSuccessfullyCreatedTask,
          lottieString: Assets.lotties.success,
          context: context,
          success: true);

      switchScreen(context, SecretaryMainPage.routeName, args: PageSelector(mainPageIndex: 1, tabIndex: 2), replace: true);
      await getTaskToday();
    });
  }

  Future<Tasks?> updateTask({required BuildContext context, required FormData formData, required String taskId}) async {
    loader(context: context);
    final results = await _taskService.updateTask(formData: formData, taskId: taskId);

    results.fold((failed) {
      pop(context, route: false);
      showAppSnackBar(message: failed, lottieString: Assets.lotties.error, context: context);
    }, (taskData) async {
      pop(context, route: false);
      pop(context, route: false);
      showAppSnackBar(
          message: S.current.submitted,
          description: S.current.youHaveSuccessfullySubmittedTask,
          lottieString: Assets.lotties.success,
          context: context,
          success: true);

      await getTaskToday();
      await getTaskStatus(taskStatus: TaskStatus.inReview);
      await getTaskStatus(taskStatus: TaskStatus.ongoing);
      await getTaskStatus(taskStatus: TaskStatus.all);
      await getTaskById(taskId: taskId);
    });

    notifyListeners();

    return tasks;
  }

  Future<void> getTaskStatus({required TaskStatus taskStatus}) async {
    switch (taskStatus) {
      case TaskStatus.all:
        getAllTaskState = BaseModelState.loading;
        break;
      case TaskStatus.ongoing:
        getOngoingTaskState = BaseModelState.loading;
        break;
      case TaskStatus.inReview:
        getInReviewTaskState = BaseModelState.loading;
        break;
      case TaskStatus.completed:
        getCompletedTaskState = BaseModelState.loading;
        break;
    }

    final results = await _taskService.getTaskStatus(taskStatus: taskStatusValues.reverse[taskStatus]!);

    results.fold((failure) {
      switch (taskStatus) {
        case TaskStatus.all:
          getAllTaskState = BaseModelState.error;
          break;
        case TaskStatus.ongoing:
          getOngoingTaskState = BaseModelState.error;
          break;
        case TaskStatus.inReview:
          getInReviewTaskState = BaseModelState.error;
          break;
        case TaskStatus.completed:
          getCompletedTaskState = BaseModelState.error;
          break;
      }
    }, (data) {
      switch (taskStatus) {
        case TaskStatus.all:
          listOfAllTask = data;
          getAllTaskState = BaseModelState.success;

          break;
        case TaskStatus.ongoing:
          listOfOngoingTask = data;
          getOngoingTaskState = BaseModelState.success;

          break;
        case TaskStatus.inReview:
          listOfInReviewTask = data;
          getInReviewTaskState = BaseModelState.success;

          break;
        case TaskStatus.completed:
          listOfCompletedTask = data;
          getCompletedTaskState = BaseModelState.success;

          break;
      }
    });

    notifyListeners();
  }

  Future<void> getTaskById({required String taskId}) async {
    getTaskByIdState = BaseModelState.loading;
    final results = await _taskService.getTaskById(taskId: taskId);

    results.fold((error) {
      getTaskByIdState = BaseModelState.error;
    }, (data) {
      _tasks = data;
      getTaskByIdState = BaseModelState.success;
    });

    notifyListeners();
  }

  Future<void> getDownloadLink() async {
    getDownloadState = BaseModelState.loading;
    final results = await _taskService.getDownloadLink();

    results.fold((error) {
      getDownloadState = BaseModelState.error;
    }, (data) async {
      _downloadLink = data;
      getDownloadState = BaseModelState.success;
    });

    notifyListeners();
  }

  Future<void> uploadBulkWorker({required BuildContext context, required FormData formData}) async {
    loader(context: context);
    final results = await _taskService.updateBulkWorkers(formData: formData);

    results.fold((failed) {
      pop(context, route: false);
      showAppSnackBar(message: failed, lottieString: Assets.lotties.error, context: context);
    }, (successful) async {
      pop(context, route: false);
      showAppSnackBar(
          message: S.current.workerAdded,
          description: S.current.youHaveSuccessfullyAddedWorker,
          lottieString: Assets.lotties.success,
          context: context,
          success: true);

      await _userVm.getWorkers();
      await getNewTaskDetails();
    });
  }

  clearTaskDuringLogout() {
    getTaskTodayState = BaseModelState.initial;
    getAllTaskState = BaseModelState.initial;
    getOngoingTaskState = BaseModelState.initial;
    getInReviewTaskState = BaseModelState.initial;
    getCompletedTaskState = BaseModelState.initial;
    getNewTaskDetailsState = BaseModelState.initial;
    notifyListeners();
  }
}
*/
