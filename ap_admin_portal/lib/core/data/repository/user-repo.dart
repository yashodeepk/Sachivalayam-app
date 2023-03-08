import 'dart:async';

import 'package:ap_admin_portal/core/data/data-source/user-ds.dart';
import 'package:ap_admin_portal/core/models/user/user.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../generated/l10n.dart';
import '../../errors/error.dart';

abstract class UserRepository {
  Future<Either<String, User?>> signIn({required Map<String, dynamic> payload});
  Future<Either<String, int?>> addUpdateWorker({required User user, bool update = false, String? userId});
  Future<Either<String, int?>> deleteWorker({required String workerId});
  Future<Either<String, List<User>?>> getWorkers();
}

@LazySingleton(as: UserRepository)
class UserRepositoryImpl extends UserRepository {
  UserDataSource userDataSource;
  String? message;
  UserRepositoryImpl(this.userDataSource);

  @override
  Future<Either<String, User?>> signIn({required Map<String, dynamic> payload}) async {
    try {
      final results = await userDataSource.signIn(payload: payload);

      return Right(results);
    } catch (e, stackTrace) {
      if (e is DioError) {
        if (e.response != null) {
          if (e.response!.statusCode == 401) {
            message = e.response!.data['message'].toString();
          } else if (e.response!.statusCode == 404) {
            message = 'Not found';
          }
        } else {
          message = ServerException.getErrorMessage(e);
        }
      } else if (e is NoInternetException) {
        message = S.current.couldNotConnectToInternet;
      } else {
        message = e.toString();
      }

      // unawaited(FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: message));
      return Left(message!);
    }
  }

  @override
  Future<Either<String, int?>> addUpdateWorker({required User user, bool update = false, String? userId}) async {
    try {
      final results = await userDataSource.addOrUpdateWorker(user: user, update: update, userId: userId);

      return Right(results);
    } catch (e, stackTrace) {
      if (e is DioError) {
        if (e.response != null) {
          if (e.response!.statusCode == 400) {
            message = e.response!.data['message'].toString();
          } else if (e.response!.statusCode == 404) {
            message = 'Not found';
          }
        } else {
          message = ServerException.getErrorMessage(e);
        }
      } else if (e is NoInternetException) {
        message = S.current.couldNotConnectToInternet;
      } else {
        message = e.toString();
      }

      // unawaited(FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: message));
      return Left(message!);
    }
  }

  @override
  Future<Either<String, int?>> deleteWorker({required String workerId}) async {
    try {
      final results = await userDataSource.deleteWorker(workerId: workerId);

      return Right(results);
    } catch (e, stackTrace) {
      if (e is DioError) {
        if (e.response != null) {
          if (e.response!.statusCode == 400) {
            message = e.response!.data['message'].toString();
          } else if (e.response!.statusCode == 404) {
            message = 'Not found';
          }
        } else {
          message = ServerException.getErrorMessage(e);
        }
      } else if (e is NoInternetException) {
        message = S.current.couldNotConnectToInternet;
      } else {
        message = e.toString();
      }

      // unawaited(FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: message));
      return Left(message!);
    }
  }

  @override
  Future<Either<String, List<User>?>> getWorkers() async {
    try {
      final results = await userDataSource.getWorkers();

      return Right(results);
    } catch (e, stackTrace) {
      if (e is DioError) {
        if (e.response != null) {
          if (e.response!.statusCode == 404) {
            message = 'Not found';
          }
        } else {
          message = ServerException.getErrorMessage(e);
        }
      } else if (e is NoInternetException) {
        message = S.current.couldNotConnectToInternet;
      } else {
        message = e.toString();
      }

      // unawaited(FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: message));
      return Left(message!);
    }
  }
}
