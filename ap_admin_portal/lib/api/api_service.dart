import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ap_admin_portal/global/globals.dart' as globals;

class APIService {
  static dynamic message;
  static dynamic accessToken;

  static Future login(String payload) async {
    try {
      final response =
          await http.post(Uri.http(globals.serverUrl, globals.loginPath),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
              },
              body: payload);

      return response;
      // if (response.statusCode >= 200 && response.statusCode <= 300) {
      //   accessToken = json.decode(response.body)['token'];
      //   SharedPreferences prefs = await SharedPreferences.getInstance();

      //   return json.decode(response.body);
      // } else {
      //   R;
      // }
    } on Exception catch (err) {
      return {
        "body": "{'message': 'Oops! Something went wrong','error': '$err'}",
        "statusCode": 0
      };
    }
  }

  static Future<void> logout() async {
    try {
      globals.isLoggedIn = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } on Exception catch (_) {
      throw Exception("Something went wrong");
    }
  }
}
