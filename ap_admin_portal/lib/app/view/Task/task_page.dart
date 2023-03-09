import 'dart:convert';

import 'package:ap_admin_portal/api/api_service.dart';
import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();
  List taskDataFound = [];
  bool hasMore = false;
  int limit = 20;
  int pageNo = 0;
  final _scrollController = ScrollController();

  List<String> zoneItems = [];
  List<String> wardItems = [];
  List<String> swachlayamItems = [];
  List<String> statusItems = ['Ongoing', 'Completed', 'In-review'];
  List<String> selectedZone = [];
  List<String> selectedStatus = [];
  List<String> selectedWard = [];
  List<String> selectedSwachlayam = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    taskData();
    zoneData();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        fetch();
      }
    });
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  Future<void> taskData() async {
    Map data = {
      "limit": limit,
      "page": pageNo,
      "startDate": DateTime(
              selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0)
          .toString(),
      "endDate": DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, 23, 59, 59)
          .toString()
    };
    if (selectedZone.isNotEmpty) {
      data.addAll({
        "Zone": selectedZone,
      });
    }
    if (selectedStatus.isNotEmpty) {
      data.addAll({
        "Status": selectedStatus,
      });
    }
    if (selectedWard.isNotEmpty) {
      data.addAll({
        "Ward": selectedWard,
      });
    }
    if (selectedSwachlayam.isNotEmpty) {
      data.addAll({
        "Swachlayam": selectedSwachlayam,
      });
    }
    var res = await APIService.getAllTaskData(jsonEncode(data));
    if (res.statusCode >= 200 && res.statusCode <= 300) {
      var resDecoded = jsonDecode(res.body);
      // print(resDecoded);
      if (resDecoded['results'] != null) {
        if (resDecoded['results']['data'] != null) {
          List dataFound = resDecoded['results']['data'];
          taskDataFound.addAll(dataFound);
          setState(() {
            if (dataFound.length < limit) {
              hasMore = false;
            }
          });
        }
      }
    }
  }

  Future<void> zoneData() async {
    var res = await APIService.getAllZoneData();
    if (res.statusCode >= 200 && res.statusCode <= 300) {
      var resDecoded = jsonDecode(res.body);
      if (resDecoded['results'] != null) {
        if (resDecoded['results']['data'] != null) {
          if (resDecoded['results']['data'][0]['ward'] != null) {
            List w = resDecoded['results']['data'][0]['ward'];
            wardItems = w.map((e) => e.toString()).toList();
          }
          if (resDecoded['results']['data'][0]['zone'] != null) {
            List z = resDecoded['results']['data'][0]['zone'];
            zoneItems = z.map((e) => e.toString()).toList();
          }
          if (resDecoded['results']['data'][0]['sachivalyam'] != null) {
            List s = resDecoded['results']['data'][0]['sachivalyam'];
            swachlayamItems = s.map((e) => e.toString()).toList();
          }
          setState(() {});
        }
      }
    }
  }

  void fetch() {
    setState(() {
      pageNo = pageNo + 1;
    });
    taskData();
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Task',
                              style: TextStyle(
                                color: Color(0xFF2D2D2D),
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2015, 8),
                          lastDate: selectedDate,
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: ThemeColor.kPrimaryGreen,
                                  onPrimary: Colors.white,
                                  surface: ThemeColor.kPrimaryGreen,
                                  onSurface: Colors.black, // body text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: ThemeColor
                                        .kPrimaryGreen, // button text color
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                            taskDataFound = [];
                          });
                          taskData();
                        }
                      },
                      child: Container(
                        // width: 200,
                        height: 30,
                        decoration: BoxDecoration(
                          color: ThemeColor.kWhite,
                          border: Border.all(color: Color(0xffE8E8E8)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF202020),
                                size: 16,
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    5, 0, 0, 0),
                                child: AutoSizeText(
                                    DateFormat("MMM d, y").format(selectedDate),
                                    minFontSize: 12,
                                    maxFontSize: 16,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text('Filter :',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal)),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 0, 10, 0),
                              child: Container(
                                width: 77,
                                height: 30,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 5, 0),
                                decoration: BoxDecoration(
                                    color: ThemeColor.kWhite,
                                    border: Border.all(
                                        color: const Color(0xffE8E8E8)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                      isExpanded: true,
                                      hint: Align(
                                        alignment: AlignmentDirectional.center,
                                        child: Text(
                                          'Status',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                          width: 180,
                                          padding: null,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 0,
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                                MaterialStateProperty.all(6),
                                            thumbVisibility:
                                                MaterialStateProperty.all(true),
                                          )),
                                      items: statusItems.map((item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          //disable default onTap to avoid closing menu when selecting an item
                                          enabled: false,
                                          child: StatefulBuilder(
                                            builder: (context, menuSetState) {
                                              final _isSelected =
                                                  selectedStatus.contains(item);
                                              return InkWell(
                                                onTap: () {
                                                  _isSelected
                                                      ? selectedStatus
                                                          .remove(item)
                                                      : selectedStatus
                                                          .add(item);
                                                  //This rebuilds the StatefulWidget to update the button's text
                                                  setState(() {});
                                                  //This rebuilds the dropdownMenu Widget to update the check mark
                                                  menuSetState(() {});
                                                },
                                                child: Container(
                                                  height: double.infinity,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      _isSelected
                                                          ? const Icon(
                                                              Icons
                                                                  .check_box_outlined,
                                                              size: 20,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .check_box_outline_blank,
                                                              size: 20,
                                                            ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        item,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                      //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                                      value: selectedStatus.isEmpty
                                          ? null
                                          : selectedStatus.last,
                                      onChanged: (value) {},
                                      selectedItemBuilder: (context) {
                                        return statusItems.map(
                                          (item) {
                                            return Container(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Text(
                                                selectedStatus.join(', '),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                maxLines: 1,
                                              ),
                                            );
                                          },
                                        ).toList();
                                      },
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 30,
                                        padding: EdgeInsets.zero,
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                        ),
                                        iconSize: 15,
                                      )),
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 10, 0),
                              child: Container(
                                width: 77,
                                height: 30,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 5, 0),
                                decoration: BoxDecoration(
                                    color: ThemeColor.kWhite,
                                    border: Border.all(
                                        color: const Color(0xffE8E8E8)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                      isExpanded: true,
                                      hint: Align(
                                        alignment: AlignmentDirectional.center,
                                        child: Text(
                                          'Zone',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                          padding: null,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 0,
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                                MaterialStateProperty.all(6),
                                            thumbVisibility:
                                                MaterialStateProperty.all(true),
                                          )),
                                      items: zoneItems.map((item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          //disable default onTap to avoid closing menu when selecting an item
                                          enabled: false,
                                          child: StatefulBuilder(
                                            builder: (context, menuSetState) {
                                              final _isSelected =
                                                  selectedZone.contains(item);
                                              return InkWell(
                                                onTap: () {
                                                  _isSelected
                                                      ? selectedZone
                                                          .remove(item)
                                                      : selectedZone.add(item);
                                                  //This rebuilds the StatefulWidget to update the button's text
                                                  setState(() {});
                                                  //This rebuilds the dropdownMenu Widget to update the check mark
                                                  menuSetState(() {});
                                                },
                                                child: Container(
                                                  height: double.infinity,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      _isSelected
                                                          ? const Icon(
                                                              Icons
                                                                  .check_box_outlined,
                                                              size: 20,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .check_box_outline_blank,
                                                              size: 20,
                                                            ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        item,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                      //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                                      value: selectedZone.isEmpty
                                          ? null
                                          : selectedZone.last,
                                      onChanged: (value) {},
                                      selectedItemBuilder: (context) {
                                        return zoneItems.map(
                                          (item) {
                                            return Container(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Text(
                                                selectedZone.join(', '),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                maxLines: 1,
                                              ),
                                            );
                                          },
                                        ).toList();
                                      },
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 30,
                                        padding: EdgeInsets.zero,
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                        ),
                                        iconSize: 15,
                                      )),
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 10, 0),
                              child: Container(
                                width: 77,
                                height: 30,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 5, 0),
                                decoration: BoxDecoration(
                                    color: ThemeColor.kWhite,
                                    border: Border.all(
                                        color: const Color(0xffE8E8E8)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                      isExpanded: true,
                                      hint: Align(
                                        alignment: AlignmentDirectional.center,
                                        child: Text(
                                          'Ward',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                          padding: null,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 0,
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                                MaterialStateProperty.all(6),
                                            thumbVisibility:
                                                MaterialStateProperty.all(true),
                                          )),
                                      items: wardItems.map((item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          //disable default onTap to avoid closing menu when selecting an item
                                          enabled: false,
                                          child: StatefulBuilder(
                                            builder: (context, menuSetState) {
                                              final _isSelected =
                                                  selectedWard.contains(item);
                                              return InkWell(
                                                onTap: () {
                                                  _isSelected
                                                      ? selectedWard
                                                          .remove(item)
                                                      : selectedWard.add(item);
                                                  //This rebuilds the StatefulWidget to update the button's text
                                                  setState(() {});
                                                  //This rebuilds the dropdownMenu Widget to update the check mark
                                                  menuSetState(() {});
                                                },
                                                child: Container(
                                                  height: double.infinity,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      _isSelected
                                                          ? const Icon(
                                                              Icons
                                                                  .check_box_outlined,
                                                              size: 20,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .check_box_outline_blank,
                                                              size: 20,
                                                            ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        item,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                      //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                                      value: selectedWard.isEmpty
                                          ? null
                                          : selectedWard.last,
                                      onChanged: (value) {},
                                      selectedItemBuilder: (context) {
                                        return wardItems.map(
                                          (item) {
                                            return Container(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Text(
                                                selectedWard.join(', '),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                maxLines: 1,
                                              ),
                                            );
                                          },
                                        ).toList();
                                      },
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 30,
                                        padding: EdgeInsets.zero,
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                        ),
                                        iconSize: 15,
                                      )),
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 10, 0),
                              child: Container(
                                width: 134,
                                height: 30,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 5, 0),
                                decoration: BoxDecoration(
                                    color: ThemeColor.kWhite,
                                    border: Border.all(
                                        color: const Color(0xffE8E8E8)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                      isExpanded: true,
                                      hint: Align(
                                        alignment: AlignmentDirectional.center,
                                        child: Text(
                                          'Swachlayam',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context).hintColor,
                                          ),
                                        ),
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                          width: 200,
                                          padding: null,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 0,
                                          scrollbarTheme: ScrollbarThemeData(
                                            radius: const Radius.circular(40),
                                            thickness:
                                                MaterialStateProperty.all(6),
                                            thumbVisibility:
                                                MaterialStateProperty.all(true),
                                          )),
                                      items: swachlayamItems.map((item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          //disable default onTap to avoid closing menu when selecting an item
                                          enabled: false,
                                          child: StatefulBuilder(
                                            builder: (context, menuSetState) {
                                              final _isSelected =
                                                  selectedSwachlayam
                                                      .contains(item);
                                              return InkWell(
                                                onTap: () {
                                                  _isSelected
                                                      ? selectedSwachlayam
                                                          .remove(item)
                                                      : selectedSwachlayam
                                                          .add(item);
                                                  //This rebuilds the StatefulWidget to update the button's text
                                                  setState(() {});
                                                  //This rebuilds the dropdownMenu Widget to update the check mark
                                                  menuSetState(() {});
                                                },
                                                child: Container(
                                                  height: double.infinity,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          5, 0, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      _isSelected
                                                          ? const Icon(
                                                              Icons
                                                                  .check_box_outlined,
                                                              size: 20,
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .check_box_outline_blank,
                                                              size: 20,
                                                            ),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        item,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                      //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                                      value: selectedSwachlayam.isEmpty
                                          ? null
                                          : selectedSwachlayam.last,
                                      onChanged: (value) {},
                                      selectedItemBuilder: (context) {
                                        return swachlayamItems.map(
                                          (item) {
                                            return Container(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Text(
                                                selectedSwachlayam.join(', '),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                maxLines: 1,
                                              ),
                                            );
                                          },
                                        ).toList();
                                      },
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 30,
                                        padding: EdgeInsets.zero,
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                        ),
                                        iconSize: 15,
                                      )),
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 10, 0),
                              child: Tooltip(
                                message: "Apply filter",
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      taskDataFound = [];
                                    });
                                    taskData();
                                  },
                                  child: Container(
                                    height: 30,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            3, 0, 3, 0),
                                    decoration: const BoxDecoration(
                                        color: ThemeColor.kPrimaryGreen,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: const Center(
                                      child: Icon(Icons.done,
                                          color: ThemeColor.kWhite),
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 10, 0),
                              child: Tooltip(
                                message: "Remove filter",
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedZone = [];
                                      selectedStatus = [];
                                      selectedWard = [];
                                      selectedSwachlayam = [];
                                      taskDataFound = [];
                                    });
                                    taskData();
                                  },
                                  child: Container(
                                    height: 30,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            3, 0, 3, 0),
                                    decoration: const BoxDecoration(
                                        color: ThemeColor.kErrorBorderColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: const Center(
                                      child: Icon(Icons.delete_outline,
                                          color: ThemeColor.kWhite),
                                    ),
                                  ),
                                ),
                              )),
                        ],
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
                    columns: const [
                      DataColumn2(
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
                        label: Text(
                          'Task Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataColumn2(
                        label: Text(
                          'Work area',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataColumn2(
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
                      DataColumn2(
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
                      DataColumn2(
                        fixedWidth: 120,
                        label: Text(
                          'Swachlaym',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataColumn2(
                        fixedWidth: 70,
                        label: Text(
                          'Worker',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataColumn2(
                        fixedWidth: 120,
                        label: Text(
                          'Status',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // DataColumn2(
                      //   fixedWidth: 50,
                      //   label: Text(
                      //     '',
                      //   ),
                      // ),
                    ],
                    rows: [
                      for (int i = 0; i < taskDataFound.length + 1; i++)
                        if (i < taskDataFound.length)
                          DataRow(
                              // onSelectChanged: (value) {
                              //   AlertDialog alert = AlertDialog(
                              //     shape: const RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.all(
                              //             Radius.circular(15.0))),
                              //     title: Center(
                              //         child: Column(
                              //       mainAxisSize: MainAxisSize.min,
                              //       children: [
                              //         Padding(
                              //           padding: const EdgeInsets.all(10),
                              //           child: Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceBetween,
                              //             children: const [
                              //               Text("Task Details",
                              //                   style: TextStyle(
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.w500,
                              //                     color: Color(0xff2D2D2D),
                              //                   ),
                              //                   textAlign: TextAlign.center),
                              //               Icon(
                              //                 Icons.close,
                              //                 color: Color(0xff2D2D2D),
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //         const Padding(
                              //           padding:
                              //               EdgeInsets.fromLTRB(0, 0, 0, 10),
                              //           child: Divider(
                              //             color: Color(0xffD7D7D7),
                              //           ),
                              //         ),
                              //         Row(
                              //           children: [
                              //             Column(
                              //               children: [
                              //                 Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceBetween,
                              //                   children: [
                              //                     Text('Task Name',
                              //                         style: TextStyle(
                              //                           fontSize: 14,
                              //                           fontWeight:
                              //                               FontWeight.w500,
                              //                           color:
                              //                               Color(0xff2D2D2D),
                              //                         ),
                              //                         textAlign:
                              //                             TextAlign.center),
                              //                     Text(':',
                              //                         style: TextStyle(
                              //                           fontSize: 14,
                              //                           fontWeight:
                              //                               FontWeight.w500,
                              //                           color:
                              //                               Color(0xff2D2D2D),
                              //                         ),
                              //                         textAlign:
                              //                             TextAlign.center),
                              //                     Text(
                              //                         taskDataFound[i][
                              //                                     'task_name'] !=
                              //                                 null
                              //                             ? '${taskDataFound[i]['task_name']}'
                              //                             : '',
                              //                         style: TextStyle(
                              //                           fontSize: 14,
                              //                           fontWeight:
                              //                               FontWeight.w500,
                              //                           color:
                              //                               Color(0xff2D2D2D),
                              //                         ),
                              //                         textAlign:
                              //                             TextAlign.center),
                              //                   ],
                              //                 )
                              //               ],
                              //             ),
                              //             const Padding(
                              //               padding: EdgeInsets.fromLTRB(
                              //                   10, 0, 10, 0),
                              //               child: VerticalDivider(
                              //                 color: Color(0xffD7D7D7),
                              //               ),
                              //             ),
                              //             Column(
                              //               children: [],
                              //             ),
                              //           ],
                              //         )
                              //         // const Text("Something went wrong\n",
                              //         //     style: TextStyle(
                              //         //       fontSize: 16,
                              //         //       fontWeight: FontWeight.w500,
                              //         //       color: Colors.black,
                              //         //     ),
                              //         //     textAlign: TextAlign.center),
                              //         // Text("$message\n",
                              //         //     style: const TextStyle(
                              //         //       fontSize: 16,
                              //         //       fontWeight: FontWeight.w500,
                              //         //       color: Colors.black,
                              //         //     ),
                              //         //     textAlign: TextAlign.center),
                              //         // const Text("Please try again later",
                              //         //     style: TextStyle(
                              //         //       fontSize: 14,
                              //         //       fontWeight: FontWeight.w400,
                              //         //       color: Colors.grey,
                              //         //     ),
                              //         //     textAlign: TextAlign.center),
                              //       ],
                              //     )),
                              //     // actions: [closeButton, okButton],
                              //   );
                              //   showDialog(
                              //     barrierDismissible: true,
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return alert;
                              //     },
                              //   );
                              // },
                              cells: [
                                DataCell(Text(
                                  '0${i + 1}',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff202020),
                                  ),
                                )),
                                DataCell(Text(
                                  taskDataFound[i]['task_name'] != null
                                      ? '${taskDataFound[i]['task_name']}'
                                      : '',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff202020),
                                  ),
                                )),
                                DataCell(Text(
                                  taskDataFound[i]['from_work_area'] != null &&
                                          taskDataFound[i]['to_work_area'] !=
                                              null
                                      ? '${taskDataFound[i]['from_work_area']} to ${taskDataFound[i]['to_work_area']}'
                                      : '',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff202020),
                                  ),
                                )),
                                DataCell(Text(
                                  taskDataFound[i]['zone'] != null
                                      ? '${taskDataFound[i]['zone']}'
                                      : '',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff202020),
                                  ),
                                )),
                                DataCell(Text(
                                  taskDataFound[i]['ward'] != null
                                      ? '${taskDataFound[i]['ward']}'
                                      : '',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff202020),
                                  ),
                                )),
                                DataCell(Text(
                                  taskDataFound[i]['sachivalyam'] != null
                                      ? '${taskDataFound[i]['sachivalyam']}'
                                      : '',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff202020),
                                  ),
                                )),
                                DataCell(Text(
                                  taskDataFound[i]['assigned_worker'] != null
                                      ? '0${taskDataFound[i]['assigned_worker'].length}'
                                      : '',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xff202020),
                                  ),
                                )),
                                DataCell(Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffF2F2F2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: 100,
                                  height: 30,
                                  padding: EdgeInsets.all(3),
                                  child: taskDataFound[i]['task_status'] != null
                                      ? taskDataFound[i]['task_status'] ==
                                              'Completed'
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.fiber_manual_record,
                                                  color: Color(0xff117E22),
                                                  size: 10,
                                                ),
                                                Text(
                                                  'Completed',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff117E22),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : taskDataFound[i]['task_status'] ==
                                                  'Ongoing'
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(
                                                      Icons.fiber_manual_record,
                                                      color: Color(0xffEBA900),
                                                      size: 10,
                                                    ),
                                                    Text(
                                                      'Ongoing',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xffEBA900),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : taskDataFound[i]
                                                          ['task_status'] ==
                                                      'In-review'
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: const [
                                                        Icon(
                                                          Icons
                                                              .fiber_manual_record,
                                                          color:
                                                              Color(0xff006BFE),
                                                          size: 10,
                                                        ),
                                                        Text(
                                                          'In-review',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Color(
                                                                0xff006BFE),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : Container()
                                      : Container(),
                                )),
                                // DataCell(Container(
                                //   decoration: BoxDecoration(
                                //     color: Color(0xffF2F2F2),
                                //     borderRadius: BorderRadius.circular(10),
                                //   ),
                                //   width: 100,
                                //   height: 30,
                                //   padding: EdgeInsets.all(3),
                                //   child: Icon(
                                //     Icons.fiber_manual_record,
                                //     color: Color(0xff117E22),
                                //     size: 10,
                                //   ),
                                // )),
                              ])
                        else if (i == taskDataFound.length)
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