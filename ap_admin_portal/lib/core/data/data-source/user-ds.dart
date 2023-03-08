import 'package:ap_admin_portal/core/data/services/api-service.dart';
import 'package:ap_admin_portal/utils/functions.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../env/env.dart';
import '../../../utils/async-function.dart';
import '../../../utils/enums.dart';
import '../../injections/locator.dart';
import '../../models/user/user.dart';

///makes a network call and returns the response
abstract class UserDataSource {
  Future<User?> signIn({required Map<String, dynamic> payload});
  Future<int?> addOrUpdateWorker({required User user, required bool update, String? userId});
  Future<int?> deleteWorker({required String workerId});
  Future<List<User>?> getWorkers();
}

@LazySingleton(as: UserDataSource)
class UserDataSourceImpl extends UserDataSource {
  final ApiService _apiService = ApiService.instance;
  final AsyncFunctionWrapper _asyncFunctionWrapper = sl<AsyncFunctionWrapper>();

  @override
  Future<User?> signIn({required Map<String, dynamic> payload}) async {
    return await _asyncFunctionWrapper.handleAsyncNetworkCall(() async {
      final results =
          await _apiService.callService(requestType: RequestType.post, endPoint: Env.signInEndPoint, payload: payload);
      return User.fromJson((results).results);
    });
  }

  @override
  Future<int?> addOrUpdateWorker({required User user, required bool update, String? userId}) async {
    return await _asyncFunctionWrapper.handleAsyncNetworkCall(() async {
      final results = await _apiService.callService(
          requestType: update ? RequestType.put : RequestType.post,
          endPoint: update ? '${Env.userEndPoint}/$userId' : Env.signUpEndPoint,
          options: update ? Options(headers: await xTokenHeader()) : null,
          payload: update ? user.updateWorker() : user.toWorker());
      return (results.code);
    });
  }

  @override
  Future<int?> deleteWorker({required String workerId}) async {
    return await _asyncFunctionWrapper.handleAsyncNetworkCall(() async {
      final results = await _apiService.callService(
          requestType: RequestType.delete,
          endPoint: '${Env.userEndPoint}/$workerId',
          options: Options(headers: await xTokenHeader()));
      return (results.code);
    });
  }

  @override
  Future<List<User>?> getWorkers() async {
    return await _asyncFunctionWrapper.handleAsyncNetworkCall(() async {
      final results = await _apiService.callService(
          requestType: RequestType.get, endPoint: Env.getWorkersEndPoint, options: Options(headers: await xTokenHeader()));
      return (results.results as List).map((e) => User.fromWorker(e)).toList();
    });
  }
}
