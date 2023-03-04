// import 'package:dio/dio.dart';

// import '../functions.dart';

// class Logging extends Interceptor {
//   final contentType = 'application/json';

//   @override
//   Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
//     return super.onError(err, handler);
//   }

//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//     options.headers["Content-type"] = contentType;
//     options.headers["Accept"] = contentType;

//     logger.d(
//       ' => PATH: ${options.path}',
//     );
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) async {
//     logger.d(
//       'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
//     );

//     return super.onResponse(response, handler);
//   }
// }
