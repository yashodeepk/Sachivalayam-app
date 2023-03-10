// import 'package:dio/dio.dart';
// import 'package:retry/retry.dart';

// import '../../env/env.dart';

// class DioClient {
//   static DioClient? _instance;

//   static DioClient get instance => _instance == null ? _instance = DioClient._() : _instance!;

//   final RetryOptions _retry = const RetryOptions(maxAttempts: 5);

//   DioClient._();

//   Dio get getDio => _dio(initDio());

//   RetryOptions get retry => _retry;

//   Dio _dio(BaseOptions? baseOptions) {
//     return Dio(baseOptions);
//     /*..interceptors.add(
//         Logging(),
//       );*/
//   }

//   static BaseOptions initDio() {
//     return BaseOptions(
//         baseUrl: Env.baseurl,
//         connectTimeout: 30000,
//         receiveTimeout: 45000,
//         sendTimeout: 200000,
//         responseType: ResponseType.json,
//         headers: {'Content-Type': 'application/json;charset=UTF-8', 'Charset': 'utf-8'});
//   }
// }
