import 'dart:async';

import 'package:ap_admin_portal/core/models/api-response/api-response.dart';
import 'package:ap_admin_portal/utils/enums.dart';
import 'package:ap_admin_portal/utils/network/dio_client.dart';
import 'package:dio/dio.dart';

//Use if response returns ApiResponse
class ApiService<T> {
  static ApiService? _instance;

  static ApiService get instance {
    return _instance == null ? _instance = ApiService._() : _instance!;
  }

  ///In future when parameters change please update
  final Dio _dioClient = DioClient.instance.getDio;

  ApiService._();

  ///[payload] ==> payload , [endPoint] ==> path or uri
  ///[requestType] ==> get,post,put etc
  ///[payload] ==> data/object
  Future<ApiResponse> callService(
      {required RequestType requestType,
      required String endPoint,
      T? payload,
      Map<String, dynamic>? queryParams,
      Options? options}) async {
    late Response response;
    switch (requestType) {
      case RequestType.get:
        response = await _dioClient.get(endPoint, queryParameters: queryParams, options: options);
        break;
      case RequestType.post:
        response = await _dioClient.post(endPoint, data: payload, queryParameters: queryParams, options: options);
        break;
      case RequestType.put:
        response = await _dioClient.put(endPoint, data: payload, queryParameters: queryParams, options: options);
        break;
      case RequestType.patch:
        response = await _dioClient.patch(endPoint, data: payload, queryParameters: queryParams, options: options);
        break;
      case RequestType.delete:
        response = await _dioClient.delete(endPoint, data: payload, queryParameters: queryParams, options: options);
        break;
    }

    return apiResponseFromJson(response.toString());
  }
}
