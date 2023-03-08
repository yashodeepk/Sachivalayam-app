import 'package:dio/dio.dart';

import '../../generated/l10n.dart';

class CacheException implements Exception {}

class NoInternetException implements Exception {
  @override
  String toString() => 'No Internet';
}

class NullException implements Exception {
  @override
  String toString() => 'null ';
}

class ServerException implements Exception {
  final String message;

  const ServerException({required this.message});

  static String? getErrorMessage(DioError e) {
    String? message;
    if (e.type == DioErrorType.connectionError) {
      message = S.current.somethingWentWrong;
    } else if (e.type == DioErrorType.connectionTimeout) {
      message = S.current.requestTimeout;
    } else if (e.type == DioErrorType.receiveTimeout) {
      message = S.current.serverTimeout;
    } else if (e.type == DioErrorType.receiveTimeout) {
      message = S.current.requestTimeout;
    } else if (e.response != null && e.response!.statusCode! >= 500 || e.response!.statusCode! <= 599) {
      message = S.current.serverError;
    } else if (e.response != null && e.response!.statusCode! == 404) {
      message = S.current.serverCouldNotBeReached;
    } else if (e.type == DioErrorType.badResponse) {
      message = S.current.serviceUnavailable;
    }
    return message!;
  }
}
