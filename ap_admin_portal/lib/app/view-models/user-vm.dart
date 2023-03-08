import 'package:ap_admin_portal/app/shared-widgets/app_snackbar.dart';
import 'package:ap_admin_portal/core/data/services/user-service.dart';
import 'package:ap_admin_portal/core/injections/injections.dart';
import 'package:ap_admin_portal/core/models/user/user.dart';
import 'package:ap_admin_portal/generated/assets.dart';
import 'package:ap_admin_portal/generated/l10n.dart';
import 'package:ap_admin_portal/utils/enums.dart';
import 'package:ap_admin_portal/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserVm extends ChangeNotifier {
  final UserService _userService = sl<UserService>();
  User? _user;
  User? get user => _user;
  //late final TaskVm _taskVm = sl<TaskVm>();

  BaseModelState getWorkersState = BaseModelState.initial;
  List<User>? listOfWorkers = List<User>.empty(growable: true);

  Future<void> getWorkers() async {
    getWorkersState = BaseModelState.loading;

    final results = await _userService.getWorkers();

    results.fold((error) {
      getWorkersState = BaseModelState.error;
    }, (data) {
      listOfWorkers = data;
      getWorkersState = BaseModelState.success;
    });

    notifyListeners();
  }

/*
  ///[payload] requires username , password
  Future<void> signIn({required payload, required BuildContext context, bool isSilentLogin = false}) async {
    loader(context: context);
    final results = await _userService.signIn(payload: payload);

    results.fold((errorMessage) {
      logger.w(errorMessage);
      if (isSilentLogin) {
        //todo very important step
        // if error message is no internet or server errors update ui to prevent getting unauthorised responses
      } else {
        pop(context, route: false);
        showAppSnackBar(context: context, message: errorMessage, lottieString: Assets.lotties.error);
      }
      notifyListeners();
    }, (user) async {
      _user = user;
      _userService.setCredentials(
          {'user': secureData.encryptAES(data: jsonEncode(user)), 'password': secureData.encryptAES(data: payload['password'])});

      if (isSilentLogin) {
        //do nothing to interrupt the UI

      } else {
        //use this to UPDATE UI
        pop(context);
        switchScreen(
            context, user!.userRole == UserRole.roleSecretary ? SecretaryMainPage.routeName : InspectorMainPage.routeName,
            args: PageSelector(mainPageIndex: 0, tabIndex: 0), replace: true);
      }

      notifyListeners();
    });
  }
*/

  Future<bool?> addOrUpdateWorker(
      {required User user, required BuildContext context, bool update = false, String? userId}) async {
    bool success = false;
    loader(context: context);

    final results = await _userService.addUpdateWorker(user: user, update: update, userId: userId ?? '');

    results.fold((errorMessage) {
      success = false;
      pop(context, route: false);
      showAppSnackBar(context: context, message: errorMessage, lottieString: Assets.lottiesError);
      notifyListeners();
    }, (statusCode) async {
      success = true;
      pop(context);
      showAppSnackBar(
          context: context,
          message: update ? S.current.detailsUpdated : S.current.workerAdded,
          description: update ? S.current.workerUpdatedSuccessfully : S.current.youHaveSuccessfullyAddedWorker,
          lottieString: Assets.lottiesSuccess,
          success: true);
      await getWorkers();
      // await _taskVm.getNewTaskDetails();
      notifyListeners();
    });

    notifyListeners();
    return success;
  }

  Future<void> deleteWorker({required String? workerId, required BuildContext context}) async {
    loader(context: context);
    final results = await _userService.deleteWorker(workerId: workerId!);

    results.fold((errorMessage) {
      pop(context, route: false);
      pop(context, route: false);
      logger.w(errorMessage);
      showAppSnackBar(context: context, message: errorMessage, lottieString: Assets.lottiesError);
    }, (statusCode) async {
      pop(context);
      pop(context);
      showAppSnackBar(
          context: context,
          message: S.current.workerDeleted,
          description: S.current.workerDeletedSuccessfully,
          lottieString: Assets.lottiesTrash,
          success: true);
      await getWorkers();
    });

    notifyListeners();
  }
}
