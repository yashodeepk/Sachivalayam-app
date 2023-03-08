// To parse this JSON data, do
//
//     final apiResponse = apiResponseFromJson(jsonString);

import 'dart:convert';

ApiResponse apiResponseFromJson(String str) => ApiResponse.fromJson(json.decode(str));

String apiResponseToJson(ApiResponse data) => json.encode(data.toJson());

class ApiResponse {
  final dynamic results;

  final String? message;
  final int? code;
  ApiResponse({
    this.results,
    this.message,
    this.code,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        results: json["results"]["data"],
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "results": results,
        "message": message,
        "code": code,
      };
}
