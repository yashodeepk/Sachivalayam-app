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

  static Future addUser(String payload) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String accessToken = pref.getString('ap_admin_portal_access_token') ?? '';
      final response =
          await http.post(Uri.http(globals.serverUrl, globals.signupDataPath),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'x-access-token': accessToken
              },
              body: payload);

      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }

  static Future bulkUploadUser(String fileName, List<int> bytes) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String accessToken = pref.getString('ap_admin_portal_access_token') ?? '';
      final request = http.MultipartRequest(
        'POST',
        Uri.http(globals.serverUrl, globals.bulUploadSecretoryDataPath),
      );
      request.headers.addAll({
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'x-access-token': accessToken
      });
      request.files.add(http.MultipartFile.fromBytes('worker_excel', bytes,
          filename: fileName));
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }

  static Future updateUser(String payload, String id) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String accessToken = pref.getString('ap_admin_portal_access_token') ?? '';
      final response = await http.put(
          Uri.http(globals.serverUrl, "${globals.userDataPath}/$id"),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'x-access-token': accessToken
          },
          body: payload);

      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }

  static Future getDownloadList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String accessToken = pref.getString('ap_admin_portal_access_token') ?? '';
      final response = await http.get(
        Uri.http(globals.serverUrl, globals.getDownloadDataPath,
            {'filename': globals.secretoryTemplateName}),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'x-access-token': accessToken
        },
      );

      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }

  static Future getTaskCount() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String accessToken = pref.getString('ap_admin_portal_access_token') ?? '';
      final response = await http.get(
        Uri.http(globals.serverUrl, globals.statusCountPath),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'x-access-token': accessToken
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
      SharedPreferences pref = await SharedPreferences.getInstance();
      String accessToken = pref.getString('ap_admin_portal_access_token') ?? '';
      final response =
          await http.post(Uri.http(globals.serverUrl, globals.barGraphDataPath),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'x-access-token': accessToken
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
      SharedPreferences pref = await SharedPreferences.getInstance();
      String accessToken = pref.getString('ap_admin_portal_access_token') ?? '';
      final response =
          await http.post(Uri.http(globals.serverUrl, globals.pieGraphDataPath),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'x-access-token': accessToken
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
      SharedPreferences pref = await SharedPreferences.getInstance();
      String accessToken = pref.getString('ap_admin_portal_access_token') ?? '';
      final response =
          await http.post(Uri.http(globals.serverUrl, globals.taskDataPath),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                'x-access-token': accessToken
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
      SharedPreferences pref = await SharedPreferences.getInstance();
      String accessToken = pref.getString('ap_admin_portal_access_token') ?? '';
      final response = await http.get(
        Uri.http(globals.serverUrl, globals.allZoneDataPath),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'x-access-token': accessToken
        },
      );

      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }

  static Future getZoneData() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String accessToken = pref.getString('ap_admin_portal_access_token') ?? '';
      final response = await http.get(
        Uri.http(globals.serverUrl, globals.zoneDataPath),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'x-access-token': accessToken
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
      SharedPreferences pref = await SharedPreferences.getInstance();
      String accessToken = pref.getString('ap_admin_portal_access_token') ?? '';
      final response = await http.post(
          Uri.http(globals.serverUrl, globals.workerAttendanceDataPath),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'x-access-token': accessToken
          },
          body: encoded);

      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }

  static Future getSecretaryData(String encoded) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String accessToken = pref.getString('ap_admin_portal_access_token') ?? '';
      final response = await http.post(
          Uri.http(globals.serverUrl, globals.secretaryDataPath),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'x-access-token': accessToken
          },
          body: encoded);

      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }

  static Future deleteSecretaryData(String id) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String accessToken = pref.getString('ap_admin_portal_access_token') ?? '';
      final response = await http.delete(
        Uri.http(globals.serverUrl, '${globals.userDataPath}/$id'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'x-access-token': accessToken
        },
      );

      return response;
    } on Exception catch (err) {
      return http.Response(
          "{'message': 'Oops! Something went wrong','error': '$err'}", 503);
    }
  }
}
