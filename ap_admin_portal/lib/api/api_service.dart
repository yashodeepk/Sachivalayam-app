// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
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
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
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

  static Future getTaskCount() async {
    try {
      final response = await http.get(
        Uri.http(globals.serverUrl, globals.statusCountPath),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }

  static Future getBarGraphDataList(String encoded) async {
    try {
      final response =
          await http.post(Uri.http(globals.serverUrl, globals.barGraphDataPath),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
              },
              body: encoded);

      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }

  static Future getPieGraphDataList(String encoded) async {
    try {
      final response =
          await http.post(Uri.http(globals.serverUrl, globals.pieGraphDataPath),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
              },
              body: encoded);

      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }

  static Future getAllTaskData(String encoded) async {
    try {
      final response =
          await http.post(Uri.http(globals.serverUrl, globals.taskDataPath),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
              },
              body: encoded);

      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }

  static Future getAllZoneData() async {
    try {
      final response = await http.get(
        Uri.http(globals.serverUrl, globals.zoneDataPath),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );

      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }

  static Future getWorkerAttendanceData(String encoded) async {
    try {
      final response = await http.post(
          Uri.http(globals.serverUrl, globals.workerAttendanceDataPath),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: encoded);

      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }
}
