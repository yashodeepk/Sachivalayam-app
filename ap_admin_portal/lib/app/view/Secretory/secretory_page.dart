import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:ap_admin_portal/api/api_service.dart';
import 'package:ap_admin_portal/app/widgets/toogle_button.dart';
import 'package:ap_admin_portal/generated/custom_icons_icons.dart';
import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
import 'package:ap_admin_portal/utils/dialog.dart';
import 'package:ap_admin_portal/utils/functions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SecretaryWidget extends StatefulWidget {
  const SecretaryWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SecretaryWidgetState createState() => _SecretaryWidgetState();
}

class _SecretaryWidgetState extends State<SecretaryWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  bool hasMore = true;
  int limit = 20;
  int pageNo = 0;
  int secretaryCount = 0;
  List secretaryFound = [];
  final _scrollController = ScrollController();
  bool showAddedNotification = false;
  bool showBulkUploadNotification = false;
  bool showUpdatedNotification = false;
  bool showDeleteNotification = false;
  Timer? _timer;
  TextEditingController nameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List zoneDataList = [];
  List zoneItems = [];
  String? selectedZone;
  List wardItems = [];
  String? selectedWard;
  List sachivalyamItems = [];
  String? selectedSachivalyam;
  String selectedGender = 'male';
  List<PlatformFile> _paths = [];

  String totalAddedSecretory = '0';
  String failedSecretory = '0';
  String addedSecretory = '0';

  final _formKey = GlobalKey<FormState>();
  final _checkKey = GlobalKey<FormState>();
  final _check2Key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    secretaryData();
    zoneData();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        fetch();
      }
    });
  }

  void fetch() {
    if (hasMore) {
      setState(() {
        pageNo = pageNo + 1;
      });
      secretaryData();
    }
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> secretaryData() async {
    Map data = {
      "limit": limit,
      "page": pageNo,
    };
    http.Response res = await APIService.getSecretaryData(jsonEncode(data));
    if (res.statusCode >= 200 && res.statusCode <= 300) {
      var resDecoded = jsonDecode(res.body);
      // print(resDecoded);
      if (resDecoded['results'] != null) {
        if (resDecoded['results']['data'] != null) {
          List dataFound = resDecoded['results']['data']['secretory'];
          secretaryFound.addAll(dataFound);
          secretaryCount = resDecoded['results']['data']['count'];
          setState(() {
            if (dataFound.length < limit) {
              hasMore = false;
            }
          });
        }
      }
    }
  }

  Future<void> _downloadFiles() async {
    showLoaderDialog(context);
    http.Response res = await APIService.getDownloadList();
    var resDecoded = jsonDecode(res.body);
    // print(resDecoded);
    if (res.statusCode >= 200 && res.statusCode <= 300) {
      if (resDecoded['results'] != null) {
        if (resDecoded['results']['data'] != null) {
          if (resDecoded['results']['data']['link'] != null) {
            try {
              AnchorElement anchorElement =
                  AnchorElement(href: resDecoded['results']['data']['link']);
              anchorElement.setAttribute(
                  'download', "${resDecoded['results']['data']['name']}.xlsx");
              anchorElement.click();
              anchorElement.remove();
              if (mounted) {
                Navigator.of(context).pop();
              }
            } catch (e) {
              if (mounted) {
                Navigator.of(context).pop();
                showErrorDialog(
                    context, "Failed while connecting to server", true);
              }
            }
          }
        }
      }
    } else if (res.statusCode == 503) {
      if (mounted) {
        Navigator.of(context).pop();
        showErrorDialog(context, "Failed while connecting to server", true);
      }
    } else {
      if (mounted) {
        Navigator.of(context).pop();
        showErrorDialog(
            context,
            resDecoded['message'] == null ? '' : "${resDecoded['message']}",
            false);
      }
    }
  }

  Future<void> addSecretary() async {
    showLoaderDialog(context);
    setState(() {
      showDeleteNotification = false;
      showAddedNotification = false;
      showBulkUploadNotification = false;
      showUpdatedNotification = false;
    });
    Map data = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "phone": contactNumberController.text.trim(),
      "ward": selectedWard,
      "zone": selectedZone,
      "sachivalyam": selectedSachivalyam,
      "gender": selectedGender,
      "age": ageController.text.trim(),
      "roles": "secretary",
      "workingSlots": []
    };
    http.Response res = await APIService.addUser(jsonEncode(data));
    // print(res.statusCode);
    var resDecoded = jsonDecode(res.body);
    if (res.statusCode >= 200 && res.statusCode <= 300) {
      // print(resDecoded);
      if (resDecoded['message'] != null) {
        if (resDecoded['message'] == 'success') {
          if (mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            setState(() {
              showAddedNotification = true;
              secretaryFound.add(resDecoded['results']['data']);
              secretaryCount = secretaryCount + 1;
            });
            _timer = Timer(const Duration(seconds: 5), () {
              setState(() {
                showDeleteNotification = false;
                showAddedNotification = false;
                showBulkUploadNotification = false;
                showUpdatedNotification = false;
              });
            });
          }
        } else {
          if (mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            setState(() {
              secretaryFound = [];
            });
            secretaryData();
          }
        }
      } else {
        if (mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          setState(() {
            secretaryFound = [];
          });
          secretaryData();
        }
      }
    } else if (res.statusCode == 503) {
      if (mounted) {
        Navigator.of(context).pop();
        showErrorDialog(context, "Failed while connecting to server", true);
      }
    } else {
      if (mounted) {
        Navigator.of(context).pop();
        showErrorDialog(
            context,
            resDecoded['message'] == null ? '' : "${resDecoded['message']}",
            false);
      }
    }
  }

  Future<void> bulkUploadSecretary() async {
    if (_paths.isNotEmpty) {
      showLoaderDialog(context);
      setState(() {
        showDeleteNotification = false;
        showAddedNotification = false;
        showBulkUploadNotification = false;
        showUpdatedNotification = false;
      });
      http.Response res = await APIService.bulkUploadUser(
          "secretory_template.xlsx", _paths[0].bytes!.cast());
      // print(res);
      var resDecoded = jsonDecode(res.body);
      // print(resDecoded);
      if (res.statusCode >= 200 && res.statusCode <= 300) {
        if (resDecoded['message'] != null) {
          if (resDecoded['message'] == 'success') {
            if (resDecoded['results'] != null) {
              if (resDecoded['results']['data'] != null) {
                if (resDecoded['results']['data']['totalCount'] != null) {
                  totalAddedSecretory =
                      resDecoded['results']['data']['totalCount'].toString();
                }
                if (resDecoded['results']['data']['addedCount'] != null) {
                  addedSecretory =
                      resDecoded['results']['data']['addedCount'].toString();
                }
                if (resDecoded['results']['data']['failedCount'] != null) {
                  failedSecretory =
                      resDecoded['results']['data']['failedCount'].toString();
                }
              }
            }
            if (mounted) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              setState(() {
                showBulkUploadNotification = true;
                secretaryFound = [];
              });
              secretaryData();
              _timer = Timer(const Duration(seconds: 10), () {
                setState(() {
                  showDeleteNotification = false;
                  showAddedNotification = false;
                  showBulkUploadNotification = false;
                  showUpdatedNotification = false;
                });
              });
            }
          } else {
            if (mounted) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              setState(() {
                secretaryFound = [];
              });
              secretaryData();
            }
          }
        } else {
          if (mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            setState(() {
              secretaryFound = [];
            });
            secretaryData();
          }
        }
      } else if (res.statusCode == 503) {
        if (mounted) {
          Navigator.of(context).pop();
          showErrorDialog(context, "Failed while connecting to server", true);
        }
      } else {
        if (mounted) {
          Navigator.of(context).pop();
          showErrorDialog(
              context,
              resDecoded['message'] == null ? '' : "${resDecoded['message']}",
              false);
        }
      }
    }
  }

  Future<void> updateSecretary(String id) async {
    showLoaderDialog(context);
    setState(() {
      showDeleteNotification = false;
      showAddedNotification = false;
      showBulkUploadNotification = false;
      showUpdatedNotification = false;
    });
    Map data = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": contactNumberController.text.trim(),
      "ward": selectedWard,
      "zone": selectedZone,
      "sachivalyam": selectedSachivalyam,
      "gender": selectedGender,
      "age": ageController.text.trim(),
      "workingSlots": []
    };
    if (passwordController.text.trim().isNotEmpty) {
      data.addAll({"password": passwordController.text.trim()});
    }
    http.Response res = await APIService.updateUser(jsonEncode(data), id);
    // print(res.statusCode);
    var resDecoded = jsonDecode(res.body);
    // print(resDecoded);
    if (res.statusCode >= 200 && res.statusCode <= 300) {
      if (resDecoded['message'] != null) {
        if (resDecoded['message'] == 'success') {
          if (mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            setState(() {
              showUpdatedNotification = true;
              secretaryFound = [];
            });
            secretaryData();
            _timer = Timer(const Duration(seconds: 5), () {
              setState(() {
                showDeleteNotification = false;
                showAddedNotification = false;
                showBulkUploadNotification = false;
                showUpdatedNotification = false;
              });
            });
          }
        } else {
          if (mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            setState(() {
              secretaryFound = [];
            });
            secretaryData();
          }
        }
      } else {
        if (mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          setState(() {
            secretaryFound = [];
          });
          secretaryData();
        }
      }
    } else if (res.statusCode == 503) {
      if (mounted) {
        Navigator.of(context).pop();
        showErrorDialog(context, "Failed while connecting to server", true);
      }
    } else {
      if (mounted) {
        Navigator.of(context).pop();
        showErrorDialog(
            context,
            resDecoded['message'] == null ? '' : "${resDecoded['message']}",
            false);
      }
    }
  }

  Future<void> deleteSecretary(String id, int dataIndex) async {
    setState(() {
      showDeleteNotification = false;
      showAddedNotification = false;
      showBulkUploadNotification = false;
      showUpdatedNotification = false;
    });
    http.Response res = await APIService.deleteSecretaryData(id);
    if (res.statusCode >= 200 && res.statusCode <= 300) {
      var resDecoded = jsonDecode(res.body);
      // print(resDecoded);
      if (resDecoded['message'] != null) {
        if (resDecoded['message'] == 'success') {
          if (mounted) {
            Navigator.of(context).pop();
            setState(() {
              showDeleteNotification = true;
              secretaryFound.removeAt(dataIndex);
              secretaryCount = secretaryCount - 1;
            });
            _timer = Timer(const Duration(seconds: 5), () {
              setState(() {
                showDeleteNotification = false;
                showAddedNotification = false;
                showBulkUploadNotification = false;
                showUpdatedNotification = false;
              });
            });
          }
        }
      }
    }
  }

  Future<void> zoneData() async {
    var res = await APIService.getAllZoneData();
    if (res.statusCode >= 200 && res.statusCode <= 300) {
      var resDecoded = jsonDecode(res.body);
      // print(resDecoded);
      if (resDecoded['results'] != null) {
        if (resDecoded['results']['data'] != null) {
          zoneItems = [];
          for (int i = 0; i < resDecoded['results']['data'].length; i++) {
            zoneItems.add(resDecoded['results']['data'][i]['name'].toString());
            zoneDataList.add(resDecoded['results']['data'][i]);
          }
          print(zoneItems);
          setState(() {});
        }
      }
    }
  }

  addUserDialog(bool edit, String? id) {
    AlertDialog alert = AlertDialog(
      key: _checkKey,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      titlePadding: EdgeInsets.zero,
      title: Container(
        width: MediaQuery.of(context).size.width * 0.59,
        height: MediaQuery.of(context).size.height * 0.89,
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(edit ? "Edit Secretary" : "Add New Secretary",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2D2D2D),
                          ),
                          textAlign: TextAlign.center),
                      InkWell(
                        onTap: () {
                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Icon(
                          Icons.close,
                          color: Color(0xff2D2D2D),
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Divider(
                    color: Color(0xffD7D7D7),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: Text(
                              "Personal Information",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: SizedBox(
                              width: 320,
                              // height: 38,
                              child: TextFormField(
                                controller: nameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Secretary name.';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter Secretary name here',
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                ),
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: SizedBox(
                              width: 320,
                              child: TextFormField(
                                controller: emailController,
                                validator: (value) => validateEmail(value),
                                decoration: InputDecoration(
                                  hintText: 'Enter Secretary email here',
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                ),
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: SizedBox(
                              width: 320,
                              // height: 38,
                              child: TextFormField(
                                controller: passwordController,
                                validator: (value) {
                                  if (!edit) {
                                    if (value!.isEmpty) {
                                      return 'Please Enter Secretary password.';
                                    }
                                    if (value.length < 9) {
                                      return 'Secretary password should be more that 8 character long.';
                                    }
                                  } else {
                                    if (value!.isNotEmpty) {
                                      if (value.length < 9) {
                                        return 'Secretary password should be more that 8 character long.';
                                      }
                                    }
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: edit
                                      ? 'Enter New Secretary password here'
                                      : 'Enter Secretary password here',
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                ),
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: SizedBox(
                              width: 320,
                              // height: 38,
                              child: TextFormField(
                                controller: contactNumberController,
                                maxLength: 10,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Contact number.';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Contact number needs to be a number.';
                                  }
                                  if (value.length != 10) {
                                    return 'Contact number needs to be 10 character long.';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter Contact number here',
                                  counterText: '',
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                ),
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: ToggleButton(
                              width: 320.0,
                              height: 38.0,
                              selected: true,
                              toggleBackgroundColor: const Color(0xffF8F8F8),
                              toggleBorderColor: Colors.transparent,
                              toggleColor: const Color(0xffEDF7FF),
                              activeTextColor: const Color(0xff165083),
                              inactiveTextColor: const Color(0xff6D6D6D),
                              leftDescription: 'Male',
                              rightDescription: 'Female',
                              onLeftToggleActive: () {
                                setState(() {
                                  selectedGender = 'female';
                                });
                              },
                              onRightToggleActive: () {
                                setState(() {
                                  selectedGender = 'male';
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: SizedBox(
                              width: 320,
                              // height: 38,
                              child: TextFormField(
                                controller: ageController,
                                maxLength: 3,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter age.';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Age needs to be a number.';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter Secretary Age here',
                                  counterText: '',
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.normal),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0x00000000),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF5F5F5),
                                ),
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: const VerticalDivider(
                          width: 1,
                          color: Color(0xffD7D7D7),
                        ),
                      ),
                    ),
                    Expanded(
                      child: StatefulBuilder(builder: (context, setModelState) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: Text(
                                "Work Area Information",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Text(
                              "Zone",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                              child: SizedBox(
                                width: 320,
                                child: DropdownButtonFormField2(
                                  decoration: InputDecoration(
                                    //Add isDense true and zero Padding.
                                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                    isDense: true,
                                    filled: true,
                                    fillColor: const Color(0xffF8F8F8),
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    //Add more decoration as you want here
                                    //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                  ),
                                  isExpanded: true,
                                  value: selectedZone,
                                  hint: const Text(
                                    'Select work zone',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  items: zoneItems
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null || value == '') {
                                      return 'Please select zone.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    //Do something when changing the item if you want.
                                    if (value != null && value != '') {
                                      List checkZone = zoneDataList
                                          .where((element) =>
                                              element['name'].toString() ==
                                              value.toString())
                                          .toList();
                                      print(checkZone);
                                      if (checkZone.isNotEmpty) {
                                        setState(() {
                                          selectedWard = null;
                                          selectedSachivalyam = null;
                                          selectedZone = value.toString();
                                          wardItems = [];
                                          sachivalyamItems = [];
                                          for (var i = 0;
                                              i < checkZone[0]['ward'].length;
                                              i++) {
                                            wardItems.add(checkZone[0]['ward']
                                                    [i]['name']
                                                .toString());
                                            // for (var j = 0;
                                            //     j <
                                            //         checkZone[0]['ward'][i]
                                            //                 ['sachivalyam']
                                            //             .length;
                                            //     j++) {
                                            //   sachivalyamItems.add(checkZone[0]
                                            //               ['ward'][i]
                                            //           ['sachivalyam'][j]['name']
                                            //       .toString());
                                            // }
                                          }
                                        });
                                        setModelState(() {});
                                      }
                                    }
                                  },
                                  onSaved: (value) {
                                    if (value != null && value != '') {
                                      List checkZone = zoneDataList
                                          .where((element) =>
                                              element['name'].toString() ==
                                              value.toString())
                                          .toList();
                                      print(checkZone);
                                      if (checkZone.isNotEmpty) {
                                        setState(() {
                                          selectedWard = null;
                                          selectedSachivalyam = null;
                                          selectedZone = value.toString();
                                          wardItems = [];
                                          sachivalyamItems = [];
                                          for (var i = 0;
                                              i < checkZone[0]['ward'].length;
                                              i++) {
                                            wardItems.add(checkZone[0]['ward']
                                                    [i]['name']
                                                .toString());
                                            // for (var j = 0;
                                            //     j <
                                            //         checkZone[0]['ward'][i]
                                            //                 ['sachivalyam']
                                            //             .length;
                                            //     j++) {
                                            //   sachivalyamItems.add(checkZone[0]
                                            //               ['ward'][i]
                                            //           ['sachivalyam'][j]['name']
                                            //       .toString());
                                            // }
                                          }
                                        });
                                        setModelState(() {});
                                      }
                                    }
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    height: 60,
                                    padding:
                                        EdgeInsets.only(left: 20, right: 10),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 30,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "Ward",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                              child: SizedBox(
                                width: 320,
                                child: DropdownButtonFormField2(
                                  decoration: InputDecoration(
                                    //Add isDense true and zero Padding.
                                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                    isDense: true,
                                    filled: true,
                                    fillColor: const Color(0xffF8F8F8),
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    //Add more decoration as you want here
                                    //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                  ),
                                  isExpanded: true,
                                  value: selectedWard,
                                  hint: const Text(
                                    'Select work ward',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  items: wardItems
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null || value == '') {
                                      return 'Please select ward.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    //Do something when changing the item if you want.
                                    if (value != null && value != '') {
                                      List checkZone = zoneDataList
                                          .where((element) =>
                                              element['name'].toString() ==
                                              selectedZone)
                                          .toList();
                                      List checkWard = checkZone[0]['ward']
                                          .where((element) =>
                                              element['name'].toString() ==
                                              value.toString())
                                          .toList();
                                      print(checkWard);
                                      if (checkWard.isNotEmpty) {
                                        setState(() {
                                          selectedWard = value.toString();
                                          selectedSachivalyam = null;
                                          sachivalyamItems = [];
                                          for (var i = 0;
                                              i <
                                                  checkWard[0]['sachivalyam']
                                                      .length;
                                              i++) {
                                            sachivalyamItems.add(checkWard[0]
                                                    ['sachivalyam'][i]['name']
                                                .toString());
                                          }
                                        });
                                        setModelState(() {});
                                      }
                                    }
                                  },
                                  onSaved: (value) {
                                    if (value != null && value != '') {
                                      setState(() {
                                        selectedWard = value.toString();
                                      });
                                      setModelState(() {});
                                    }
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    height: 60,
                                    padding:
                                        EdgeInsets.only(left: 20, right: 10),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 30,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "Sachivalyam",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                              child: SizedBox(
                                width: 320,
                                child: DropdownButtonFormField2(
                                  decoration: InputDecoration(
                                    //Add isDense true and zero Padding.
                                    //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                    isDense: true,
                                    filled: true,
                                    fillColor: const Color(0xffF8F8F8),
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    //Add more decoration as you want here
                                    //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                  ),
                                  isExpanded: true,
                                  value: selectedSachivalyam,
                                  hint: const Text(
                                    'Select work Sachivalyam',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  items: sachivalyamItems
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null || value == '') {
                                      return 'Please select Sachivalyam.';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    if (value != null && value != '') {
                                      setState(() {
                                        selectedSachivalyam = value.toString();
                                      });
                                      setModelState(() {});
                                    }
                                    //Do something when changing the item if you want.
                                  },
                                  onSaved: (value) {
                                    if (value != null && value != '') {
                                      setState(() {
                                        selectedSachivalyam = value.toString();
                                      });
                                      setModelState(() {});
                                    }
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    height: 60,
                                    padding:
                                        EdgeInsets.only(left: 20, right: 10),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 30,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    children: [
                      if (!edit)
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Future.delayed(Duration.zero, () {
                              bulkUploadUserDialog();
                            });
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              minimumSize: const Size(130, 50),
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: ThemeColor.kPrimaryGreen),
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            'Bulk Upload',
                            style: TextStyle(
                                color: ThemeColor.kPrimaryGreen,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      const Spacer(),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              minimumSize: const Size(130, 50),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                  color: ThemeColor.kPrimaryGreen,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (!edit) {
                                if (_formKey.currentState!.validate()) {
                                  addSecretary();
                                }
                              } else {
                                updateSecretary(id!);
                              }
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: const Color(0xff558F60),
                                minimumSize: const Size(130, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Text(
                              edit ? 'Save' : 'Add Secretary',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // actions: [closeButton, okButton],
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bulkUploadUserDialog() {
    AlertDialog alert = AlertDialog(
      key: _check2Key,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      titlePadding: EdgeInsets.zero,
      title: Container(
        width: MediaQuery.of(context).size.width * 0.59,
        height: MediaQuery.of(context).size.height * 0.85,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        if (mounted) {
                          Navigator.of(context).pop();
                          Future.delayed(Duration.zero, () {
                            addUserDialog(false, null);
                          });
                        }
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xff2D2D2D),
                      ),
                    ),
                    const Text(" Bulk Upload Secretary",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2D2D2D),
                        ),
                        textAlign: TextAlign.center),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(
                        Icons.close,
                        color: Color(0xff2D2D2D),
                      ),
                    )
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Divider(
                  color: Color(0xffD7D7D7),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: Text(
                              "Template",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            width: (MediaQuery.of(context).size.width * 0.59) *
                                0.45,
                            height:
                                (MediaQuery.of(context).size.height * 0.85) *
                                    0.6,
                            decoration: BoxDecoration(
                                color: const Color(0xffF8F8F8),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  CustomIcons.file,
                                  color: Color(0xffC7C7C7),
                                  size: 50,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      'Download Bulk secretary upload template',
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff6D6D6D),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                ),
                                InkWell(
                                  onTap: () {
                                    _downloadFiles();
                                  },
                                  child: const Text('Download',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Color(0xff165083),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: const VerticalDivider(
                          width: 1,
                          color: Color(0xffD7D7D7),
                        ),
                      ),
                    ),
                    Expanded(
                      child: StatefulBuilder(builder: (context, setModelState) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: Text(
                                "Upload Secretary List",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            DottedBorder(
                              dashPattern: [6, 6],
                              color: const Color(0xff6D6D6D),
                              radius: Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: Container(
                                width:
                                    (MediaQuery.of(context).size.width * 0.59) *
                                        0.45,
                                height: (MediaQuery.of(context).size.height *
                                        0.85) *
                                    0.6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      CustomIcons.file,
                                      color: Color(0xffC7C7C7),
                                      size: 50,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Upload secretary list here',
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xff6D6D6D),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        try {
                                          _paths = (await FilePicker.platform
                                                  .pickFiles(
                                                      type: FileType.custom,
                                                      allowMultiple: false,
                                                      onFileLoading:
                                                          (FilePickerStatus
                                                                  status) =>
                                                              print(status),
                                                      allowedExtensions: [
                                                "xls",
                                                "xlsx",
                                                "xlsb",
                                                "xltx",
                                                "xltm",
                                                "xls",
                                                "xlt",
                                                "xml",
                                                'csv'
                                              ]))!
                                              .files;
                                          // print(_paths);
                                          print(_paths[0].name);
                                        } on PlatformException catch (e) {
                                          print(e);
                                        } catch (e) {
                                          print(e);
                                        }
                                        if (mounted) {
                                          setState(() {});
                                          setModelState(() {});
                                        }
                                      },
                                      child: Container(
                                        width: 110,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: const Color(0xff165083),
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(40))),
                                        child: const Center(
                                          child: Text('Upload',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff165083),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ),
                                    ),
                                    if (_paths.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 50,
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: const BoxDecoration(
                                              color: Color(0xffEDF7FF),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(_paths[0].name,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      color: Color(0xff165083),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              InkWell(
                                                  onTap: () {
                                                    _paths.clear();
                                                    if (mounted) {
                                                      setState(() {});
                                                      setModelState(() {});
                                                    }
                                                  },
                                                  child: const Icon(
                                                      CustomIcons.cancel,
                                                      color: Color(0xffFF5151)))
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    const Spacer(),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            minimumSize: const Size(130, 50),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                                color: ThemeColor.kPrimaryGreen,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            bulkUploadSecretary();
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: const Color(0xff558F60),
                              minimumSize: const Size(130, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text(
                            'Add Secretary',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // actions: [closeButton, okButton],
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: !showAddedNotification
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff8FDA9B)),
                              color: const Color(0xffCCF0D2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: SvgPicture.asset(
                                    'assets/images/success.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    'Secretary added successfully',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Color(0xff1C6428)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showAddedNotification = false;
                                      });
                                    },
                                    child: const Icon(
                                      CustomIcons.cancel,
                                      size: 23,
                                      color: Color(0xffFF5151),
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: !showBulkUploadNotification
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff8FDA9B)),
                              color: const Color(0xffCCF0D2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: SvgPicture.asset(
                                    'assets/images/success.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Bulk Upload Completed, Total Secretory Found: $totalAddedSecretory, Added: $addedSecretory, Failed: $failedSecretory',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                        color: Color(0xff1C6428)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showBulkUploadNotification = false;
                                      });
                                    },
                                    child: const Icon(
                                      CustomIcons.cancel,
                                      size: 23,
                                      color: Color(0xffFF5151),
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: !showUpdatedNotification
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xff8FDA9B)),
                              color: const Color(0xffCCF0D2),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: SvgPicture.asset(
                                    'assets/images/success.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    'Secretary details updated successfully',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Color(0xff1C6428)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showUpdatedNotification = false;
                                      });
                                    },
                                    child: const Icon(
                                      CustomIcons.cancel,
                                      size: 23,
                                      color: Color(0xffFF5151),
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: !showDeleteNotification
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffFFE6E6),
                              border:
                                  Border.all(color: const Color(0xffD93434)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: SvgPicture.asset(
                                    'assets/images/deleted.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    'Secretary deleted successfully',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: Color(0xffD93434)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showDeleteNotification = false;
                                      });
                                    },
                                    child: const Icon(
                                      CustomIcons.cancel,
                                      size: 23,
                                      color: Color(0xffFF5151),
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Secretary',
                              style: TextStyle(
                                color: Color(0xFF2D2D2D),
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              )),
                          Text('Total : $secretaryCount',
                              style: const TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            nameController.text = '';
                            emailController.text = '';
                            passwordController.text = '';
                            contactNumberController.text = '';
                            ageController.text = '';
                            selectedGender = 'male';
                            selectedZone = null;
                            selectedWard = null;
                            selectedSachivalyam = null;
                          });
                          addUserDialog(false, null);
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: const Color(0xff558F60),
                            minimumSize: const Size(170, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: const Text(
                          'Add Secretary',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DataTable2(
                    scrollController: _scrollController,
                    columns: [
                      const DataColumn2(
                        fixedWidth: 70,
                        label: Text(
                          'Sr. no',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataColumn2(
                        fixedWidth: MediaQuery.of(context).size.width * 0.12,
                        label: const Text(
                          'Name',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataColumn2(
                        fixedWidth: MediaQuery.of(context).size.width * 0.12,
                        label: const Text(
                          'Email',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const DataColumn2(
                        label: Text(
                          'Contact no.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const DataColumn2(
                        label: Text(
                          'Gender',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const DataColumn2(
                        fixedWidth: 70,
                        label: Text(
                          'Age',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const DataColumn2(
                        fixedWidth: 70,
                        label: Text(
                          'Zone',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const DataColumn2(
                        fixedWidth: 70,
                        label: Text(
                          'Ward',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const DataColumn2(
                        label: Text(
                          'Sachivalyam',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const DataColumn2(
                        fixedWidth: 120,
                        label: Text(
                          '',
                        ),
                      ),
                    ],
                    rows: [
                      for (int i = 0; i < secretaryFound.length + 1; i++)
                        if (i < secretaryFound.length)
                          DataRow(cells: [
                            DataCell(Text(
                              '0${i + 1}',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff202020),
                              ),
                            )),
                            DataCell(Text(
                              secretaryFound[i]['name'] != null
                                  ? '${secretaryFound[i]['name']}'
                                  : '',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff202020),
                              ),
                            )),
                            DataCell(Text(
                              secretaryFound[i]['email'] != null
                                  ? '${secretaryFound[i]['email']}'
                                  : '',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff202020),
                              ),
                            )),
                            DataCell(Text(
                              secretaryFound[i]['phone'] != null
                                  ? '${secretaryFound[i]['phone']}'
                                  : '',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff202020),
                              ),
                            )),
                            DataCell(Text(
                              secretaryFound[i]['gender'] != null
                                  ? '${secretaryFound[i]['gender']}'
                                  : '',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff202020),
                              ),
                            )),
                            DataCell(Text(
                              secretaryFound[i]['age'] != null
                                  ? '${secretaryFound[i]['age']}'
                                  : '',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff202020),
                              ),
                            )),
                            DataCell(Text(
                              secretaryFound[i]['zone'] != null
                                  ? '${secretaryFound[i]['zone']}'
                                  : '',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff202020),
                              ),
                            )),
                            DataCell(Text(
                              secretaryFound[i]['ward'] != null
                                  ? '${secretaryFound[i]['ward']}'
                                  : '',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff202020),
                              ),
                            )),
                            DataCell(Text(
                              secretaryFound[i]['sachivalyam'] != null
                                  ? '${secretaryFound[i]['sachivalyam']}'
                                  : '',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff202020),
                              ),
                            )),
                            DataCell(Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (secretaryFound[i]['name'] != null) {
                                        nameController.text = secretaryFound[i]
                                                ['name']
                                            .toString();
                                      }
                                      if (secretaryFound[i]['phone'] != null) {
                                        contactNumberController.text =
                                            secretaryFound[i]['phone']
                                                .toString();
                                      }
                                      if (secretaryFound[i]['gender'] != null) {
                                        selectedGender = secretaryFound[i]
                                                ['gender']
                                            .toString();
                                      }
                                      if (secretaryFound[i]['age'] != null) {
                                        ageController.text =
                                            secretaryFound[i]['age'].toString();
                                      }
                                      if (secretaryFound[i]['email'] != null) {
                                        emailController.text = secretaryFound[i]
                                                ['email']
                                            .toString();
                                      }
                                      zoneItems = [];
                                      for (var element in zoneDataList) {
                                        zoneItems.add(element['name']);
                                      }
                                      List zoneCheck = zoneDataList
                                          .where((element) =>
                                              element['name'] ==
                                              secretaryFound[i]['zone']
                                                  .toString())
                                          .toList();
                                      if (zoneCheck.isNotEmpty) {
                                        if (secretaryFound[i]['zone'] != null) {
                                          selectedZone = secretaryFound[i]
                                                  ['zone']
                                              .toString();
                                        }
                                        wardItems = [];
                                        for (var element in zoneCheck[0]
                                            ['ward']) {
                                          wardItems.add(element['name']);
                                        }
                                        List wardCheck = zoneCheck[0]['ward']
                                            .where((element) =>
                                                element['name'] ==
                                                secretaryFound[i]['ward']
                                                    .toString())
                                            .toList();
                                        if (wardCheck.isNotEmpty) {
                                          if (secretaryFound[i]['ward'] !=
                                              null) {
                                            selectedWard = secretaryFound[i]
                                                    ['ward']
                                                .toString();
                                          }
                                          sachivalyamItems = [];
                                          for (var element in wardCheck[0]
                                              ['sachivalyam']) {
                                            sachivalyamItems
                                                .add(element['name']);
                                          }
                                          List sachivalyamCheck = wardCheck[0]
                                                  ['sachivalyam']
                                              .where((element) =>
                                                  element['name'] ==
                                                  secretaryFound[i]
                                                          ['sachivalyam']
                                                      .toString())
                                              .toList();
                                          if (sachivalyamCheck.isNotEmpty) {
                                            if (secretaryFound[i]
                                                    ['sachivalyam'] !=
                                                null) {
                                              selectedSachivalyam =
                                                  secretaryFound[i]
                                                          ['sachivalyam']
                                                      .toString();
                                            }
                                          }
                                        }
                                      }
                                    });
                                    addUserDialog(
                                        true, secretaryFound[i]['_id']);
                                  },
                                  child: const Icon(
                                    CustomIcons.edit,
                                    color: Color(0xff165083),
                                    size: 18,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    AlertDialog alert = AlertDialog(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0))),
                                      title: Container(
                                        // width: 400,
                                        // height: 400,
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/delete_check.svg',
                                              fit: BoxFit.fill,
                                            ),
                                            const Text(
                                                "Are you sure you want to\nremove secretary ?",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff2D2D2D),
                                                ),
                                                textAlign: TextAlign.center),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  secretaryFound[i]['name'] !=
                                                          null
                                                      ? '"${secretaryFound[i]['name']}"'
                                                      : '',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff808080),
                                                  ),
                                                  textAlign: TextAlign.center),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          ThemeColor.kWhite,
                                                      minimumSize:
                                                          const Size(130, 50),
                                                      shape: RoundedRectangleBorder(
                                                          side: const BorderSide(
                                                              color: ThemeColor
                                                                  .kPrimaryGreen),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10))),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff558F60),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await deleteSecretary(
                                                        secretaryFound[i]
                                                            ['_id'],
                                                        i);
                                                  },
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          ThemeColor
                                                              .kPrimaryGreen,
                                                      minimumSize: const Size(
                                                          130,
                                                          50),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10))),
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      'Remove',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      // actions: [closeButton, okButton],
                                    );
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    CustomIcons.trash,
                                    color: Color(0xffFF5151),
                                    size: 18,
                                  ),
                                )
                              ],
                            )),
                          ])
                        else if (i == secretaryFound.length)
                          if (hasMore)
                            DataRow(cells: [
                              const DataCell(Text(
                                '',
                              )),
                              const DataCell(Text(
                                '',
                              )),
                              const DataCell(Text(
                                '',
                              )),
                              const DataCell(Text(
                                '',
                              )),
                              DataCell(Container(
                                  width: 40,
                                  height: 40,
                                  padding: const EdgeInsets.all(3),
                                  child: const CircularProgressIndicator(
                                    color: ThemeColor.kPrimaryGreen,
                                  ))),
                              const DataCell(Text(
                                '',
                              )),
                              const DataCell(Text(
                                '',
                              )),
                              const DataCell(Text(
                                '',
                              )),
                              const DataCell(Text(
                                '',
                              )),
                              const DataCell(Text(
                                '',
                              )),
                            ])
                    ],
                    headingRowColor: MaterialStateProperty.all(
                      const Color(0xFFECF6FF),
                    ),
                    headingRowHeight: 60,
                    dataRowColor: MaterialStateProperty.all(
                      Colors.white,
                    ),
                    dataRowHeight: 64,
                    // border: TableBorder(
                    //   borderRadius: BorderRadius.circular(10),
                    // ),
                    dividerThickness: 1,
                    columnSpacing: 10,
                    showBottomBorder: true,
                    minWidth: 49,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
