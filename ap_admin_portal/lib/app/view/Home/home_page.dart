import 'dart:convert';

import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../api/api_service.dart';
import 'package:ap_admin_portal/global/globals.dart' as globals;

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String totalAssignedTask = '0';
  String inReview = '0';
  String ongoing = '0';
  String completed = '0';
  DateTime todaysDate = DateTime.now();
  List taskDataFound = [];
  List barGraphDataList = [];

  DateTime startDate = DateTime.now().subtract(const Duration(days: 6));
  DateTime endDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  final _scrollController = ScrollController();

  List<String> zoneItems = [];
  List<String> wardItems = [];
  List<String> swachlayamItems = [];
  List<String> selectedZone = [];
  List<String> selectedWard = [];
  List<String> selectedSwachlayam = [];

  List<String> selectedZone2 = [];
  List<String> selectedWard2 = [];
  List<String> selectedSwachlayam2 = [];

  int totalWorkers = 0;
  int presentWorkers = 0;
  double presentWorkerPercentage = 0.0;
  int absentWorkers = 0;
  double absentWorkersPercentage = 0.0;
  int touchedIndex = -1;

  double completedPresent = 0.0;
  double inCompletedPresent = 100.0;
  int touchedIndex2 = -1;

  int limit = 10;
  int pageNo = 0;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    taskCount();
    barGraphData();
    pieGraphData();
    workerAttendance();
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
    super.dispose();
  }

  List<PieChartSectionData> showingSections2() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex2;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 90.0 : 85.5;
      final widgetSize = isTouched ? 55.0 : 40.0;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(0xffB6EEBD),
            value: completedPresent,
            title: '$completedPresent%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xff007C10),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xffF3F4B4),
            value: inCompletedPresent,
            title: '$inCompletedPresent%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xff9A9C01),
            ),
          );
        default:
          throw Exception('Oh no');
      }
    });
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final radius = 10.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(0xffFF9177),
            value: absentWorkersPercentage,
            title: '',
            radius: radius,
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xffA1E1FB),
            value: presentWorkerPercentage,
            title: '',
            radius: radius,
          );
        default:
          throw Error();
      }
    });
  }

  Future<void> taskCount() async {
    var res = await APIService.getTaskCount();
    if (res.statusCode >= 200 && res.statusCode <= 300) {
      var resDecoded = jsonDecode(res.body);
      // print(resDecoded);
      if (resDecoded['results'] != null) {
        if (resDecoded['results']['data'] != null) {
          if (resDecoded['results']['data']['totalAssignedTask'] != null) {
            totalAssignedTask =
                resDecoded['results']['data']['totalAssignedTask'].toString();
          }
          if (resDecoded['results']['data']['inReview'] != null) {
            inReview = resDecoded['results']['data']['inReview'].toString();
          }
          if (resDecoded['results']['data']['ongoing'] != null) {
            ongoing = resDecoded['results']['data']['ongoing'].toString();
          }
          if (resDecoded['results']['data']['completed'] != null) {
            completed = resDecoded['results']['data']['completed'].toString();
          }
          setState(() {});
        }
      }
    }
  }

  Future<void> workerAttendance() async {
    Map data = {
      "startDate": DateTime(
              selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0)
          .toString(),
      "endDate": DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, 23, 59, 59)
          .toString()
    };
    if (selectedZone2.isNotEmpty) {
      data.addAll({
        "Zone": selectedZone2,
      });
    }
    if (selectedWard2.isNotEmpty) {
      data.addAll({
        "Ward": selectedWard2,
      });
    }
    if (selectedSwachlayam2.isNotEmpty) {
      data.addAll({
        "Swachlayam": selectedSwachlayam2,
      });
    }
    var res = await APIService.getWorkerAttendanceData(jsonEncode(data));
    if (res.statusCode >= 200 && res.statusCode <= 300) {
      var resDecoded = jsonDecode(res.body);
      if (resDecoded['results'] != null) {
        if (resDecoded['results']['data'] != null) {
          if (resDecoded['results']['data']['total'] != null) {
            totalWorkers = resDecoded['results']['data']['total'];
          }
          if (resDecoded['results']['data']['present'] != null) {
            presentWorkers = resDecoded['results']['data']['present'];
          }
          if (resDecoded['results']['data']['absent'] != null) {
            absentWorkers = resDecoded['results']['data']['absent'];
          }
          if (resDecoded['results']['data']['presentPercentage'] != null) {
            presentWorkerPercentage =
                resDecoded['results']['data']['presentPercentage'];
          }
          if (resDecoded['results']['data']['absentPercentage'] != null) {
            absentWorkersPercentage =
                resDecoded['results']['data']['absentPercentage'];
          }
          setState(() {});
        }
      }
    }
  }

  Future<void> taskData() async {
    Map data = {"limit": limit, "page": pageNo};
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

  void fetch() {
    setState(() {
      pageNo = pageNo + 1;
    });
    taskData();
  }

  Future<void> zoneData() async {
    var res = await APIService.getZoneData();
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

  Future<void> barGraphData() async {
    Map dataToEncode = {
      "startDate": DateTime(
              startDate.year, startDate.month, startDate.day, 0, 0, 0, 0, 0)
          .toString(),
      "endDate":
          DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 0, 0)
              .toString(),
    };
    if (selectedZone.isNotEmpty) {
      dataToEncode.addAll({
        "Zone": selectedZone,
      });
    }
    if (selectedWard.isNotEmpty) {
      dataToEncode.addAll({
        "Ward": selectedWard,
      });
    }
    if (selectedSwachlayam.isNotEmpty) {
      dataToEncode.addAll({
        "Swachlayam": selectedSwachlayam,
      });
    }
    var res = await APIService.getBarGraphDataList(jsonEncode(dataToEncode));
    if (res.statusCode >= 200 && res.statusCode <= 300) {
      var resDecoded = jsonDecode(res.body);
      if (resDecoded['results'] != null) {
        if (resDecoded['results']['data'] != null) {
          barGraphDataList = resDecoded['results']['data'];
          setState(() {});
        }
      }
    }
  }

  Future<void> pieGraphData() async {
    Map dataToEncode = {
      "startDate": DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, 0, 0, 0, 0, 0)
          .toString(),
      "endDate": DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, 23, 59, 59, 0, 0)
          .toString(),
    };
    if (selectedZone2.isNotEmpty) {
      dataToEncode.addAll({
        "Zone": selectedZone2,
      });
    }
    if (selectedWard2.isNotEmpty) {
      dataToEncode.addAll({
        "Ward": selectedWard2,
      });
    }
    if (selectedSwachlayam2.isNotEmpty) {
      dataToEncode.addAll({
        "Swachlayam": selectedSwachlayam2,
      });
    }
    var res = await APIService.getPieGraphDataList(jsonEncode(dataToEncode));
    if (res.statusCode >= 200 && res.statusCode <= 300) {
      var resDecoded = jsonDecode(res.body);
      if (resDecoded['results'] != null) {
        if (resDecoded['results']['data'] != null) {
          if (resDecoded['results']['data']['completedPercent'] != null) {
            completedPresent =
                resDecoded['results']['data']['completedPercent'];
            completedPresent =
                double.parse(completedPresent.toStringAsFixed(2));
            inCompletedPresent = 100 - completedPresent;
          }
          // barGraphDataList = resDecoded['results']['data'];
          setState(() {});
        }
      }
    }
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
        fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff808080));
    String text;
    if (barGraphDataList[value.toInt()] != null) {
      text = DateFormat("d MMM").format(DateTime.tryParse(
              barGraphDataList[value.toInt()]['date'].toString()) ??
          DateTime.now());
    } else {
      text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  List<BarChartGroupData> getData() {
    return [
      for (int i = 0; i < barGraphDataList.length; i++)
        BarChartGroupData(
          x: i,
          // barsSpace: barsSpace,
          barRods: [
            BarChartRodData(
              toY: barGraphDataList[i]['barGraphCount'][1],
              rodStackItems: [
                BarChartRodStackItem(0, barGraphDataList[i]['barGraphCount'][0],
                    ThemeColor.kCompletedTask),
                BarChartRodStackItem(
                    barGraphDataList[i]['barGraphCount'][0],
                    barGraphDataList[i]['barGraphCount'][1],
                    ThemeColor.kAssignedTask),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              width: barGraphDataList.length > 10 ? null : 20,
            ),
          ],
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 30, 0),
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.22,
                        height: (MediaQuery.of(context).size.width * 0.22) *
                            0.42, //35.31
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 10, 0, 0),
                                    child: AutoSizeText('Today',
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        minFontSize: 12,
                                        maxFontSize: 14,
                                        style: TextStyle(
                                            color: Color(0xFF00A91B),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    child: AutoSizeText('Total Assigned Task',
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        minFontSize: 12,
                                        maxFontSize: 16,
                                        style: TextStyle(
                                          // fontSize: 16,
                                          color: Color(0xFF2D2D2D),
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    child: AutoSizeText('0$totalAssignedTask',
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        minFontSize: 25,
                                        maxFontSize: 30,
                                        style: const TextStyle(
                                          color: Color(0xFF2D2D2D),
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: (MediaQuery.of(context).size.width *
                                            0.2) /
                                        2,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      alignment: AlignmentDirectional.centerEnd,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/Ellipse_128_pink.svg',
                                          fit: BoxFit.fill,
                                        ),
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              0.07, -0.09),
                                          child: SvgPicture.asset(
                                            'assets/images/archive-book.svg',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 30, 0),
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.22,
                        height: (MediaQuery.of(context).size.width * 0.22) *
                            0.42, //35.31
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 10, 0, 0),
                                    child: AutoSizeText('Today',
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        minFontSize: 12,
                                        maxFontSize: 14,
                                        style: TextStyle(
                                            color: Color(0xFF00A91B),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    child: AutoSizeText('Total Ongoing Task',
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        minFontSize: 12,
                                        maxFontSize: 16,
                                        style: TextStyle(
                                          // fontSize: 16,
                                          color: Color(0xFF2D2D2D),
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                    child: AutoSizeText('0$ongoing',
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        minFontSize: 25,
                                        maxFontSize: 30,
                                        style: const TextStyle(
                                          color: Color(0xFF2D2D2D),
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: (MediaQuery.of(context).size.width *
                                            0.2) /
                                        2,
                                    child: Stack(
                                      fit: StackFit.expand,
                                      alignment: AlignmentDirectional.centerEnd,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/Ellipse_128_blue.svg',
                                          fit: BoxFit.fill,
                                        ),
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              0.07, -0.09),
                                          child: SvgPicture.asset(
                                            'assets/images/document-text.svg',
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // width: MediaQuery.of(context).size.width * 0.22,
                      height: (MediaQuery.of(context).size.width * 0.22) *
                          0.42, //35.31
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 0, 0),
                                  child: AutoSizeText('Today',
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      minFontSize: 12,
                                      maxFontSize: 14,
                                      style: TextStyle(
                                          color: Color(0xFF00A91B),
                                          fontWeight: FontWeight.w500)),
                                ),
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  child: AutoSizeText('Total Completed Task',
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      minFontSize: 12,
                                      maxFontSize: 16,
                                      style: TextStyle(
                                        // fontSize: 16,
                                        color: Color(0xFF2D2D2D),
                                        fontWeight: FontWeight.w400,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
                                  child: AutoSizeText('0$completed',
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      minFontSize: 25,
                                      maxFontSize: 30,
                                      style: const TextStyle(
                                        color: Color(0xFF2D2D2D),
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width *
                                          0.2) /
                                      2,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    alignment: AlignmentDirectional.centerEnd,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/Ellipse_128_green.svg',
                                        fit: BoxFit.fill,
                                      ),
                                      Align(
                                        alignment: const AlignmentDirectional(
                                            0.07, -0.09),
                                        child: SvgPicture.asset(
                                          'assets/images/clipboard-tick.svg',
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: const [
                                    Text(
                                      'History Graph',
                                      style: TextStyle(
                                          color: Color(0xFF2D2D2D),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20, 20, 0, 17),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                final picked =
                                                    await showDateRangePicker(
                                                  context: context,
                                                  initialDateRange:
                                                      DateTimeRange(
                                                          start: startDate,
                                                          end: endDate),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime.now(),
                                                  builder: (context, child) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Center(
                                                          child: SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.8,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.5,
                                                            child: Theme(
                                                                data: Theme.of(
                                                                        context)
                                                                    .copyWith(
                                                                  colorScheme:
                                                                      const ColorScheme
                                                                          .light(
                                                                    primary:
                                                                        ThemeColor
                                                                            .kPrimaryGreen,
                                                                    onPrimary:
                                                                        Colors
                                                                            .white,
                                                                    surface:
                                                                        ThemeColor
                                                                            .kWhite,
                                                                    onSurface:
                                                                        Colors
                                                                            .black, // body text color
                                                                  ),
                                                                  textButtonTheme:
                                                                      TextButtonThemeData(
                                                                    style: TextButton
                                                                        .styleFrom(
                                                                      foregroundColor:
                                                                          ThemeColor
                                                                              .kPrimaryGreen, // button text color
                                                                    ),
                                                                  ),
                                                                ),
                                                                child: child!),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                if (picked != null) {
                                                  setState(() {
                                                    startDate = picked.start;
                                                    endDate = picked.end;
                                                  });
                                                  barGraphData();
                                                }
                                              },
                                              child: Container(
                                                // width: 200,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: ThemeColor.kSeaBlue,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(5, 5, 5, 5),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      const Icon(
                                                        Icons.calendar_today,
                                                        color:
                                                            Color(0xFF202020),
                                                        size: 16,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    5, 0, 0, 0),
                                                        child: AutoSizeText(
                                                            '${DateFormat("MMM d, y").format(startDate)} - ${DateFormat("MMM d, y").format(endDate)}',
                                                            minFontSize: 12,
                                                            maxFontSize: 16,
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 0, 0),
                                                    child: Text('Filter :',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal)),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              10, 0, 10, 0),
                                                      child: Container(
                                                        width: 77,
                                                        height: 30,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                10, 0, 5, 0),
                                                        decoration: const BoxDecoration(
                                                            color: ThemeColor
                                                                .kSeaBlue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButton2(
                                                                  isExpanded:
                                                                      true,
                                                                  hint: Align(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .center,
                                                                    child: Text(
                                                                      'Zone',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Theme.of(context)
                                                                            .hintColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  dropdownStyleData:
                                                                      DropdownStyleData(
                                                                          padding:
                                                                              null,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          elevation:
                                                                              0,
                                                                          scrollbarTheme:
                                                                              ScrollbarThemeData(
                                                                            radius:
                                                                                const Radius.circular(40),
                                                                            thickness:
                                                                                MaterialStateProperty.all(6),
                                                                            thumbVisibility:
                                                                                MaterialStateProperty.all(true),
                                                                          )),
                                                                  items: zoneItems
                                                                      .map(
                                                                          (item) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          item,
                                                                      //disable default onTap to avoid closing menu when selecting an item
                                                                      enabled:
                                                                          false,
                                                                      child:
                                                                          StatefulBuilder(
                                                                        builder:
                                                                            (context,
                                                                                menuSetState) {
                                                                          final _isSelected =
                                                                              selectedZone.contains(item);
                                                                          return InkWell(
                                                                            onTap:
                                                                                () {
                                                                              _isSelected ? selectedZone.remove(item) : selectedZone.add(item);
                                                                              //This rebuilds the StatefulWidget to update the button's text
                                                                              setState(() {});
                                                                              //This rebuilds the dropdownMenu Widget to update the check mark
                                                                              menuSetState(() {});
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: double.infinity,
                                                                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                              child: Row(
                                                                                children: [
                                                                                  _isSelected
                                                                                      ? const Icon(
                                                                                          Icons.check_box_outlined,
                                                                                          size: 20,
                                                                                        )
                                                                                      : const Icon(
                                                                                          Icons.check_box_outline_blank,
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
                                                                  value: selectedZone
                                                                          .isEmpty
                                                                      ? null
                                                                      : selectedZone
                                                                          .last,
                                                                  onChanged:
                                                                      (value) {},
                                                                  selectedItemBuilder:
                                                                      (context) {
                                                                    return zoneItems
                                                                        .map(
                                                                      (item) {
                                                                        return Container(
                                                                          alignment:
                                                                              AlignmentDirectional.center,
                                                                          child:
                                                                              Text(
                                                                            selectedZone.join(', '),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 14,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            maxLines:
                                                                                1,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).toList();
                                                                  },
                                                                  menuItemStyleData:
                                                                      const MenuItemStyleData(
                                                                    height: 30,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                  ),
                                                                  iconStyleData:
                                                                      const IconStyleData(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .keyboard_arrow_down_rounded,
                                                                    ),
                                                                    iconSize:
                                                                        15,
                                                                  )),
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              0, 0, 10, 0),
                                                      child: Container(
                                                        width: 77,
                                                        height: 30,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                10, 0, 5, 0),
                                                        decoration: const BoxDecoration(
                                                            color: ThemeColor
                                                                .kSeaBlue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButton2(
                                                                  isExpanded:
                                                                      true,
                                                                  hint: Align(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .center,
                                                                    child: Text(
                                                                      'Ward',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Theme.of(context)
                                                                            .hintColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  dropdownStyleData:
                                                                      DropdownStyleData(
                                                                          padding:
                                                                              null,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          elevation:
                                                                              0,
                                                                          scrollbarTheme:
                                                                              ScrollbarThemeData(
                                                                            radius:
                                                                                const Radius.circular(40),
                                                                            thickness:
                                                                                MaterialStateProperty.all(6),
                                                                            thumbVisibility:
                                                                                MaterialStateProperty.all(true),
                                                                          )),
                                                                  items: wardItems
                                                                      .map(
                                                                          (item) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          item,
                                                                      //disable default onTap to avoid closing menu when selecting an item
                                                                      enabled:
                                                                          false,
                                                                      child:
                                                                          StatefulBuilder(
                                                                        builder:
                                                                            (context,
                                                                                menuSetState) {
                                                                          final _isSelected =
                                                                              selectedWard.contains(item);
                                                                          return InkWell(
                                                                            onTap:
                                                                                () {
                                                                              _isSelected ? selectedWard.remove(item) : selectedWard.add(item);
                                                                              //This rebuilds the StatefulWidget to update the button's text
                                                                              setState(() {});
                                                                              //This rebuilds the dropdownMenu Widget to update the check mark
                                                                              menuSetState(() {});
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: double.infinity,
                                                                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                              child: Row(
                                                                                children: [
                                                                                  _isSelected
                                                                                      ? const Icon(
                                                                                          Icons.check_box_outlined,
                                                                                          size: 20,
                                                                                        )
                                                                                      : const Icon(
                                                                                          Icons.check_box_outline_blank,
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
                                                                  value: selectedWard
                                                                          .isEmpty
                                                                      ? null
                                                                      : selectedWard
                                                                          .last,
                                                                  onChanged:
                                                                      (value) {},
                                                                  selectedItemBuilder:
                                                                      (context) {
                                                                    return wardItems
                                                                        .map(
                                                                      (item) {
                                                                        return Container(
                                                                          alignment:
                                                                              AlignmentDirectional.center,
                                                                          child:
                                                                              Text(
                                                                            selectedWard.join(', '),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 14,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            maxLines:
                                                                                1,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).toList();
                                                                  },
                                                                  menuItemStyleData:
                                                                      const MenuItemStyleData(
                                                                    height: 30,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                  ),
                                                                  iconStyleData:
                                                                      const IconStyleData(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .keyboard_arrow_down_rounded,
                                                                    ),
                                                                    iconSize:
                                                                        15,
                                                                  )),
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              0, 0, 10, 0),
                                                      child: Container(
                                                        width: 134,
                                                        height: 30,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                10, 0, 5, 0),
                                                        decoration: const BoxDecoration(
                                                            color: ThemeColor
                                                                .kSeaBlue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButton2(
                                                                  isExpanded:
                                                                      true,
                                                                  hint: Align(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .center,
                                                                    child: Text(
                                                                      'Swachlayam',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Theme.of(context)
                                                                            .hintColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  dropdownStyleData:
                                                                      DropdownStyleData(
                                                                          width:
                                                                              200,
                                                                          padding:
                                                                              null,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          elevation:
                                                                              0,
                                                                          scrollbarTheme:
                                                                              ScrollbarThemeData(
                                                                            radius:
                                                                                const Radius.circular(40),
                                                                            thickness:
                                                                                MaterialStateProperty.all(6),
                                                                            thumbVisibility:
                                                                                MaterialStateProperty.all(true),
                                                                          )),
                                                                  items: swachlayamItems
                                                                      .map(
                                                                          (item) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          item,
                                                                      //disable default onTap to avoid closing menu when selecting an item
                                                                      enabled:
                                                                          false,
                                                                      child:
                                                                          StatefulBuilder(
                                                                        builder:
                                                                            (context,
                                                                                menuSetState) {
                                                                          final _isSelected =
                                                                              selectedSwachlayam.contains(item);
                                                                          return InkWell(
                                                                            onTap:
                                                                                () {
                                                                              _isSelected ? selectedSwachlayam.remove(item) : selectedSwachlayam.add(item);
                                                                              //This rebuilds the StatefulWidget to update the button's text
                                                                              setState(() {});
                                                                              //This rebuilds the dropdownMenu Widget to update the check mark
                                                                              menuSetState(() {});
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: double.infinity,
                                                                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                              child: Row(
                                                                                children: [
                                                                                  _isSelected
                                                                                      ? const Icon(
                                                                                          Icons.check_box_outlined,
                                                                                          size: 20,
                                                                                        )
                                                                                      : const Icon(
                                                                                          Icons.check_box_outline_blank,
                                                                                          size: 20,
                                                                                        ),
                                                                                  const SizedBox(width: 5),
                                                                                  Text(
                                                                                    item,
                                                                                    overflow: TextOverflow.ellipsis,
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
                                                                  value: selectedSwachlayam
                                                                          .isEmpty
                                                                      ? null
                                                                      : selectedSwachlayam
                                                                          .last,
                                                                  onChanged:
                                                                      (value) {},
                                                                  selectedItemBuilder:
                                                                      (context) {
                                                                    return swachlayamItems
                                                                        .map(
                                                                      (item) {
                                                                        return Container(
                                                                          alignment:
                                                                              AlignmentDirectional.center,
                                                                          child:
                                                                              Text(
                                                                            selectedSwachlayam.join(', '),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 14,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            maxLines:
                                                                                1,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).toList();
                                                                  },
                                                                  menuItemStyleData:
                                                                      const MenuItemStyleData(
                                                                    height: 30,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                  ),
                                                                  iconStyleData:
                                                                      const IconStyleData(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .keyboard_arrow_down_rounded,
                                                                    ),
                                                                    iconSize:
                                                                        15,
                                                                  )),
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              0, 0, 10, 0),
                                                      child: Tooltip(
                                                        message: "Apply filter",
                                                        child: InkWell(
                                                          onTap: () {
                                                            barGraphData();
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    3, 0, 3, 0),
                                                            decoration: const BoxDecoration(
                                                                color: ThemeColor
                                                                    .kPrimaryGreen,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                            child: const Center(
                                                              child: Icon(
                                                                  Icons.done,
                                                                  color: ThemeColor
                                                                      .kWhite),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              0, 0, 10, 0),
                                                      child: Tooltip(
                                                        message:
                                                            "Remove filter",
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedZone = [];
                                                              selectedWard = [];
                                                              selectedSwachlayam =
                                                                  [];
                                                            });
                                                            barGraphData();
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    3, 0, 3, 0),
                                                            decoration: const BoxDecoration(
                                                                color: ThemeColor
                                                                    .kErrorBorderColor,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                            child: const Center(
                                                              child: Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: ThemeColor
                                                                      .kWhite),
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
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: barGraphDataList.isNotEmpty
                                              ? LayoutBuilder(
                                                  builder:
                                                      (context, constraints) {
                                                    final barsSpace = 4.0 *
                                                        constraints.maxWidth /
                                                        400;
                                                    final barsWidth = 8.0 *
                                                        constraints.maxWidth /
                                                        400;
                                                    return BarChart(
                                                      BarChartData(
                                                        alignment:
                                                            BarChartAlignment
                                                                .spaceAround,
                                                        barTouchData:
                                                            BarTouchData(
                                                          enabled: true,
                                                          touchTooltipData:
                                                              BarTouchTooltipData(
                                                            tooltipBgColor:
                                                                Color(
                                                                    0xffF6F6F6),
                                                            tooltipRoundedRadius:
                                                                4.0,
                                                            fitInsideHorizontally:
                                                                true,
                                                            fitInsideVertically:
                                                                true,
                                                            tooltipMargin: 0,
                                                            getTooltipItem:
                                                                (group,
                                                                    groupIndex,
                                                                    rod,
                                                                    rodIndex) {
                                                              String text = '';
                                                              String assigned =
                                                                  '';
                                                              String completed =
                                                                  '';
                                                              if (barGraphDataList[
                                                                      group
                                                                          .x] !=
                                                                  null) {
                                                                text = DateFormat(
                                                                        "d MMM")
                                                                    .format(DateTime.tryParse(barGraphDataList[group.x]['date']
                                                                            .toString()) ??
                                                                        DateTime
                                                                            .now());
                                                                assigned = barGraphDataList[
                                                                            group.x]
                                                                        [
                                                                        'actualCount'][1]
                                                                    .toString();
                                                                completed = barGraphDataList[
                                                                            group.x]
                                                                        [
                                                                        'actualCount'][0]
                                                                    .toString();
                                                              }
                                                              return BarTooltipItem(
                                                                '$text\n',
                                                                const TextStyle(
                                                                  color: Color(
                                                                      0xff808080),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                ),
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        "Assigned: $assigned\n",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color(
                                                                          0xff808080),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text:
                                                                        "Completed: $completed",
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color(
                                                                          0xff808080),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        borderData:
                                                            FlBorderData(
                                                          show: true,
                                                          border: const Border(
                                                              bottom: BorderSide(
                                                                  color: Color(
                                                                      0xff37434d)),
                                                              left: BorderSide(
                                                                  color: Color(
                                                                      0xff37434d)),
                                                              top: BorderSide(
                                                                  color: Colors
                                                                      .transparent),
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .transparent)),
                                                        ),
                                                        titlesData:
                                                            FlTitlesData(
                                                          show: true,
                                                          bottomTitles:
                                                              AxisTitles(
                                                            sideTitles:
                                                                SideTitles(
                                                              showTitles: true,
                                                              reservedSize: 28,
                                                              getTitlesWidget:
                                                                  bottomTitles,
                                                            ),
                                                          ),
                                                          leftTitles:
                                                              AxisTitles(
                                                            sideTitles:
                                                                SideTitles(
                                                              showTitles: true,
                                                              reservedSize: 40,
                                                              getTitlesWidget:
                                                                  leftTitles,
                                                            ),
                                                          ),
                                                          topTitles: AxisTitles(
                                                            sideTitles:
                                                                SideTitles(
                                                                    showTitles:
                                                                        false),
                                                          ),
                                                          rightTitles:
                                                              AxisTitles(
                                                            sideTitles:
                                                                SideTitles(
                                                                    showTitles:
                                                                        false),
                                                          ),
                                                        ),
                                                        gridData: FlGridData(
                                                          show: false,
                                                          // checkToShowHorizontalLine:
                                                          //     (value) =>
                                                          //         value % 10 == 0,
                                                          // getDrawingHorizontalLine:
                                                          //     (value) => FlLine(
                                                          //   // color: AppColors.borderColor.withOpacity(0.1),
                                                          //   strokeWidth: 1,
                                                          // ),
                                                          drawVerticalLine:
                                                              false,
                                                        ),
                                                        // groupsSpace: barsSpace,
                                                        barGroups: getData(),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Center(
                                                  child: Text(
                                                      "No data available")),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(5, 5, 5, 5),
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: ThemeColor
                                                        .kCompletedTask,
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 15, 0),
                                                child: Text('Completed Task',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 12)),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(5, 5, 5, 5),
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: ThemeColor
                                                        .kAssignedTask,
                                                  ),
                                                ),
                                              ),
                                              const Text('Assigned Task',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 30, 0, 12),
                                child: Text('Area covered by workers',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20)),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20, 20, 0, 17),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                final DateTime? picked =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: selectedDate,
                                                  firstDate: DateTime(2023, 02),
                                                  lastDate: DateTime.now(),
                                                  builder:
                                                      (BuildContext context,
                                                          Widget? child) {
                                                    return Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        colorScheme:
                                                            const ColorScheme
                                                                .light(
                                                          primary: ThemeColor
                                                              .kPrimaryGreen,
                                                          onPrimary:
                                                              Colors.white,
                                                          surface: ThemeColor
                                                              .kPrimaryGreen,
                                                          onSurface: Colors
                                                              .black, // body text color
                                                        ),
                                                        textButtonTheme:
                                                            TextButtonThemeData(
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                ThemeColor
                                                                    .kPrimaryGreen, // button text color
                                                          ),
                                                        ),
                                                      ),
                                                      child: child!,
                                                    );
                                                  },
                                                );
                                                if (picked != null &&
                                                    picked != selectedDate) {
                                                  setState(() {
                                                    selectedDate = picked;
                                                  });
                                                  workerAttendance();
                                                  pieGraphData();
                                                }
                                              },
                                              child: Container(
                                                // width: 200,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: ThemeColor.kSeaBlue,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(5, 5, 5, 5),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      const Icon(
                                                        Icons.calendar_today,
                                                        color:
                                                            Color(0xFF202020),
                                                        size: 16,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                5, 0, 0, 0),
                                                        child: AutoSizeText(
                                                            DateFormat(
                                                                    "MMM d, y")
                                                                .format(
                                                                    selectedDate),
                                                            minFontSize: 12,
                                                            maxFontSize: 16,
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10, 0, 0, 0),
                                                    child: Text('Filter :',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal)),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              10, 0, 10, 0),
                                                      child: Container(
                                                        width: 77,
                                                        height: 30,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                10, 0, 5, 0),
                                                        decoration: const BoxDecoration(
                                                            color: ThemeColor
                                                                .kSeaBlue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButton2(
                                                                  isExpanded:
                                                                      true,
                                                                  hint: Align(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .center,
                                                                    child: Text(
                                                                      'Zone',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Theme.of(context)
                                                                            .hintColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  dropdownStyleData:
                                                                      DropdownStyleData(
                                                                          padding:
                                                                              null,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          elevation:
                                                                              0,
                                                                          scrollbarTheme:
                                                                              ScrollbarThemeData(
                                                                            radius:
                                                                                const Radius.circular(40),
                                                                            thickness:
                                                                                MaterialStateProperty.all(6),
                                                                            thumbVisibility:
                                                                                MaterialStateProperty.all(true),
                                                                          )),
                                                                  items: zoneItems
                                                                      .map(
                                                                          (item) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          item,
                                                                      //disable default onTap to avoid closing menu when selecting an item
                                                                      enabled:
                                                                          false,
                                                                      child:
                                                                          StatefulBuilder(
                                                                        builder:
                                                                            (context,
                                                                                menuSetState) {
                                                                          final _isSelected =
                                                                              selectedZone2.contains(item);
                                                                          return InkWell(
                                                                            onTap:
                                                                                () {
                                                                              _isSelected ? selectedZone2.remove(item) : selectedZone2.add(item);
                                                                              //This rebuilds the StatefulWidget to update the button's text
                                                                              setState(() {});
                                                                              //This rebuilds the dropdownMenu Widget to update the check mark
                                                                              menuSetState(() {});
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: double.infinity,
                                                                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                              child: Row(
                                                                                children: [
                                                                                  _isSelected
                                                                                      ? const Icon(
                                                                                          Icons.check_box_outlined,
                                                                                          size: 20,
                                                                                        )
                                                                                      : const Icon(
                                                                                          Icons.check_box_outline_blank,
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
                                                                  value: selectedZone2
                                                                          .isEmpty
                                                                      ? null
                                                                      : selectedZone2
                                                                          .last,
                                                                  onChanged:
                                                                      (value) {},
                                                                  selectedItemBuilder:
                                                                      (context) {
                                                                    return zoneItems
                                                                        .map(
                                                                      (item) {
                                                                        return Container(
                                                                          alignment:
                                                                              AlignmentDirectional.center,
                                                                          child:
                                                                              Text(
                                                                            selectedZone2.join(', '),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 14,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            maxLines:
                                                                                1,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).toList();
                                                                  },
                                                                  menuItemStyleData:
                                                                      const MenuItemStyleData(
                                                                    height: 30,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                  ),
                                                                  iconStyleData:
                                                                      const IconStyleData(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .keyboard_arrow_down_rounded,
                                                                    ),
                                                                    iconSize:
                                                                        15,
                                                                  )),
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              0, 0, 10, 0),
                                                      child: Container(
                                                        width: 77,
                                                        height: 30,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                10, 0, 5, 0),
                                                        decoration: const BoxDecoration(
                                                            color: ThemeColor
                                                                .kSeaBlue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButton2(
                                                                  isExpanded:
                                                                      true,
                                                                  hint: Align(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .center,
                                                                    child: Text(
                                                                      'Ward',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Theme.of(context)
                                                                            .hintColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  dropdownStyleData:
                                                                      DropdownStyleData(
                                                                          padding:
                                                                              null,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          elevation:
                                                                              0,
                                                                          scrollbarTheme:
                                                                              ScrollbarThemeData(
                                                                            radius:
                                                                                const Radius.circular(40),
                                                                            thickness:
                                                                                MaterialStateProperty.all(6),
                                                                            thumbVisibility:
                                                                                MaterialStateProperty.all(true),
                                                                          )),
                                                                  items: wardItems
                                                                      .map(
                                                                          (item) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          item,
                                                                      //disable default onTap to avoid closing menu when selecting an item
                                                                      enabled:
                                                                          false,
                                                                      child:
                                                                          StatefulBuilder(
                                                                        builder:
                                                                            (context,
                                                                                menuSetState) {
                                                                          final _isSelected =
                                                                              selectedWard2.contains(item);
                                                                          return InkWell(
                                                                            onTap:
                                                                                () {
                                                                              _isSelected ? selectedWard2.remove(item) : selectedWard2.add(item);
                                                                              //This rebuilds the StatefulWidget to update the button's text
                                                                              setState(() {});
                                                                              //This rebuilds the dropdownMenu Widget to update the check mark
                                                                              menuSetState(() {});
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: double.infinity,
                                                                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                              child: Row(
                                                                                children: [
                                                                                  _isSelected
                                                                                      ? const Icon(
                                                                                          Icons.check_box_outlined,
                                                                                          size: 20,
                                                                                        )
                                                                                      : const Icon(
                                                                                          Icons.check_box_outline_blank,
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
                                                                  value: selectedWard2
                                                                          .isEmpty
                                                                      ? null
                                                                      : selectedWard2
                                                                          .last,
                                                                  onChanged:
                                                                      (value) {},
                                                                  selectedItemBuilder:
                                                                      (context) {
                                                                    return wardItems
                                                                        .map(
                                                                      (item) {
                                                                        return Container(
                                                                          alignment:
                                                                              AlignmentDirectional.center,
                                                                          child:
                                                                              Text(
                                                                            selectedWard2.join(', '),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 14,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            maxLines:
                                                                                1,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).toList();
                                                                  },
                                                                  menuItemStyleData:
                                                                      const MenuItemStyleData(
                                                                    height: 30,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                  ),
                                                                  iconStyleData:
                                                                      const IconStyleData(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .keyboard_arrow_down_rounded,
                                                                    ),
                                                                    iconSize:
                                                                        15,
                                                                  )),
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              0, 0, 10, 0),
                                                      child: Container(
                                                        width: 134,
                                                        height: 30,
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                10, 0, 5, 0),
                                                        decoration: const BoxDecoration(
                                                            color: ThemeColor
                                                                .kSeaBlue,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButton2(
                                                                  isExpanded:
                                                                      true,
                                                                  hint: Align(
                                                                    alignment:
                                                                        AlignmentDirectional
                                                                            .center,
                                                                    child: Text(
                                                                      'Swachlayam',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Theme.of(context)
                                                                            .hintColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  dropdownStyleData:
                                                                      DropdownStyleData(
                                                                          width:
                                                                              200,
                                                                          padding:
                                                                              null,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          elevation:
                                                                              0,
                                                                          scrollbarTheme:
                                                                              ScrollbarThemeData(
                                                                            radius:
                                                                                const Radius.circular(40),
                                                                            thickness:
                                                                                MaterialStateProperty.all(6),
                                                                            thumbVisibility:
                                                                                MaterialStateProperty.all(true),
                                                                          )),
                                                                  items: swachlayamItems
                                                                      .map(
                                                                          (item) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          item,
                                                                      //disable default onTap to avoid closing menu when selecting an item
                                                                      enabled:
                                                                          false,
                                                                      child:
                                                                          StatefulBuilder(
                                                                        builder:
                                                                            (context,
                                                                                menuSetState) {
                                                                          final _isSelected =
                                                                              selectedSwachlayam2.contains(item);
                                                                          return InkWell(
                                                                            onTap:
                                                                                () {
                                                                              _isSelected ? selectedSwachlayam2.remove(item) : selectedSwachlayam2.add(item);
                                                                              //This rebuilds the StatefulWidget to update the button's text
                                                                              setState(() {});
                                                                              //This rebuilds the dropdownMenu Widget to update the check mark
                                                                              menuSetState(() {});
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              height: double.infinity,
                                                                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                                              child: Row(
                                                                                children: [
                                                                                  _isSelected
                                                                                      ? const Icon(
                                                                                          Icons.check_box_outlined,
                                                                                          size: 20,
                                                                                        )
                                                                                      : const Icon(
                                                                                          Icons.check_box_outline_blank,
                                                                                          size: 20,
                                                                                        ),
                                                                                  const SizedBox(width: 5),
                                                                                  Text(
                                                                                    item,
                                                                                    overflow: TextOverflow.ellipsis,
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
                                                                  value: selectedSwachlayam2
                                                                          .isEmpty
                                                                      ? null
                                                                      : selectedSwachlayam2
                                                                          .last,
                                                                  onChanged:
                                                                      (value) {},
                                                                  selectedItemBuilder:
                                                                      (context) {
                                                                    return swachlayamItems
                                                                        .map(
                                                                      (item) {
                                                                        return Container(
                                                                          alignment:
                                                                              AlignmentDirectional.center,
                                                                          child:
                                                                              Text(
                                                                            selectedSwachlayam2.join(', '),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 14,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                            maxLines:
                                                                                1,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).toList();
                                                                  },
                                                                  menuItemStyleData:
                                                                      const MenuItemStyleData(
                                                                    height: 30,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                  ),
                                                                  iconStyleData:
                                                                      const IconStyleData(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .keyboard_arrow_down_rounded,
                                                                    ),
                                                                    iconSize:
                                                                        15,
                                                                  )),
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              0, 0, 10, 0),
                                                      child: Tooltip(
                                                        message: "Apply filter",
                                                        child: InkWell(
                                                          onTap: () {
                                                            pieGraphData();
                                                            workerAttendance();
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    3, 0, 3, 0),
                                                            decoration: const BoxDecoration(
                                                                color: ThemeColor
                                                                    .kPrimaryGreen,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                            child: const Center(
                                                              child: Icon(
                                                                  Icons.done,
                                                                  color: ThemeColor
                                                                      .kWhite),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              0, 0, 10, 0),
                                                      child: Tooltip(
                                                        message:
                                                            "Remove filter",
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              selectedZone2 =
                                                                  [];
                                                              selectedWard2 =
                                                                  [];
                                                              selectedSwachlayam2 =
                                                                  [];
                                                            });
                                                            pieGraphData();
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    3, 0, 3, 0),
                                                            decoration: const BoxDecoration(
                                                                color: ThemeColor
                                                                    .kErrorBorderColor,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                            child: const Center(
                                                              child: Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: ThemeColor
                                                                      .kWhite),
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
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width: 128,
                                                    height: 128,
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        PieChart(
                                                          PieChartData(
                                                            pieTouchData:
                                                                PieTouchData(
                                                              touchCallback:
                                                                  (FlTouchEvent
                                                                          event,
                                                                      pieTouchResponse) {
                                                                // setState(() {
                                                                //   if (!event
                                                                //           .isInterestedForInteractions ||
                                                                //       pieTouchResponse ==
                                                                //           null ||
                                                                //       pieTouchResponse
                                                                //               .touchedSection ==
                                                                //           null) {
                                                                //     touchedIndex =
                                                                //         -1;
                                                                //     return;
                                                                //   }
                                                                //   touchedIndex =
                                                                //       pieTouchResponse
                                                                //           .touchedSection!
                                                                //           .touchedSectionIndex;
                                                                // });
                                                              },
                                                            ),
                                                            borderData:
                                                                FlBorderData(
                                                              show: false,
                                                            ),
                                                            sectionsSpace: 0,
                                                            centerSpaceRadius:
                                                                64,
                                                            sections:
                                                                showingSections(),
                                                          ),
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                                "${presentWorkerPercentage.toStringAsFixed(2)}%",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Color(
                                                                        0xff2D2D2D),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                            const Text(
                                                                "Present",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: Color(
                                                                      0xff808080),
                                                                )),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                                totalWorkers
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF165083),
                                                                    fontSize:
                                                                        24)),
                                                            const Text(
                                                                'Total Workers',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                                presentWorkers
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFF28AAE0),
                                                                    fontSize:
                                                                        24)),
                                                            const Text(
                                                                'On duty Workers',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text(
                                                                absentWorkers
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Color(
                                                                        0xFFFD6C4B),
                                                                    fontSize:
                                                                        24)),
                                                            const Text(
                                                                'Absent Workers',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 242,
                                              child: VerticalDivider(
                                                thickness: 2,
                                                color: Color(0xFFE8E8E8),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width: 128,
                                                    height: 128,
                                                    child: PieChart(
                                                      PieChartData(
                                                        pieTouchData:
                                                            PieTouchData(
                                                          touchCallback:
                                                              (FlTouchEvent
                                                                      event,
                                                                  pieTouchResponse) {
                                                            setState(() {
                                                              if (!event
                                                                      .isInterestedForInteractions ||
                                                                  pieTouchResponse ==
                                                                      null ||
                                                                  pieTouchResponse
                                                                          .touchedSection ==
                                                                      null) {
                                                                touchedIndex2 =
                                                                    -1;
                                                                return;
                                                              }
                                                              touchedIndex2 =
                                                                  pieTouchResponse
                                                                      .touchedSection!
                                                                      .touchedSectionIndex;
                                                            });
                                                          },
                                                        ),
                                                        borderData:
                                                            FlBorderData(
                                                          show: false,
                                                        ),
                                                        sectionsSpace: 0,
                                                        centerSpaceRadius: 0,
                                                        sections:
                                                            showingSections2(),
                                                      ),
                                                    ),
                                                  ),
                                                  Wrap(
                                                    alignment:
                                                        WrapAlignment.center,
                                                    runAlignment:
                                                        WrapAlignment.center,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    verticalDirection:
                                                        VerticalDirection.down,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: 15,
                                                            height: 15,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color(
                                                                  0xFFB6EEBD),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                                'Area covered',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF2D2D2D),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: 15,
                                                            height: 15,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFF3F4B4),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        8,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                                'Area not covered',
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF2D2D2D),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)
                                                                // style: FlutterFlowTheme.of(context)
                                                                //     .bodyText1
                                                                //     .override(
                                                                //       fontFamily: 'Poppins',
                                                                //       color: Color(0xFF2D2D2D),
                                                                //       fontWeight: FontWeight.normal,
                                                                //     ),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: const [
                                Text('Recent Task Images',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    )),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                  controller: _scrollController,
                                  padding: EdgeInsets.zero,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: taskDataFound.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String destination = '';
                                    if (index < taskDataFound.length) {
                                      // if (e['sachivalyam'] != null) {
                                      //   destination = destination +
                                      //       e['sachivalyam'].toString() +
                                      //       " : ";
                                      // }
                                      if (taskDataFound[index]
                                              ['from_work_area'] !=
                                          null) {
                                        destination =
                                            "$destination${taskDataFound[index]['from_work_area'].toString()}, ";
                                      }
                                      if (taskDataFound[index]
                                              ['to_work_area'] !=
                                          null) {
                                        destination =
                                            "$destination${taskDataFound[index]['to_work_area'].toString()}";
                                      }
                                      return Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(15, 15, 15, 15),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: const Color(0xFFE8E8E8),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(10, 10, 10, 10),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Stack(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .topCenter,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0, 0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: taskDataFound[index]
                                                                              [
                                                                              'before_image'] !=
                                                                          null &&
                                                                      taskDataFound[index]
                                                                              [
                                                                              'before_image']
                                                                          .isNotEmpty
                                                                  ? Image
                                                                      .network(
                                                                      taskDataFound[
                                                                              index]
                                                                          [
                                                                          'before_image'][0],
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.1,
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.1,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorBuilder: (BuildContext context,
                                                                          Object
                                                                              exception,
                                                                          StackTrace?
                                                                              stackTrace) {
                                                                        return SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.1,
                                                                          height:
                                                                              MediaQuery.of(context).size.width * 0.1,
                                                                          child:
                                                                              Center(child: const Text('Image Not Found')),
                                                                        );
                                                                      },
                                                                    )
                                                                  : SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.1,
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.1,
                                                                      child: const Center(
                                                                          child:
                                                                              Text("Image Not Found")),
                                                                    ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0, -0.56),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                      15,
                                                                      15,
                                                                      15,
                                                                      15),
                                                              child: Container(
                                                                width: 60,
                                                                height: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                ),
                                                                child: const Text(
                                                                    'Before',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal)),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Stack(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .topCenter,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0, 0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child: taskDataFound[index]
                                                                              [
                                                                              'after_image'] !=
                                                                          null &&
                                                                      taskDataFound[index]
                                                                              [
                                                                              'after_image']
                                                                          .isNotEmpty
                                                                  ? Image
                                                                      .network(
                                                                      taskDataFound[
                                                                              index]
                                                                          [
                                                                          'after_image'][0],
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.1,
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.1,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorBuilder: (BuildContext context,
                                                                          Object
                                                                              exception,
                                                                          StackTrace?
                                                                              stackTrace) {
                                                                        return SizedBox(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.1,
                                                                          height:
                                                                              MediaQuery.of(context).size.width * 0.1,
                                                                          child:
                                                                              Center(child: const Text('Image Not Found')),
                                                                        );
                                                                      },
                                                                    )
                                                                  : SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.1,
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.1,
                                                                      child: const Center(
                                                                          child:
                                                                              Text("Image Not Found")),
                                                                    ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0, -0.56),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                      15,
                                                                      15,
                                                                      15,
                                                                      15),
                                                              child: Container(
                                                                width: 60,
                                                                height: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              25),
                                                                ),
                                                                child: const Text(
                                                                    'After',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.normal)),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                          10, 10, 10, 10),
                                                  child: AutoSizeText(
                                                      toBeginningOfSentenceCase(
                                                              destination) ??
                                                          "",
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 16,
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 32),
                                        child: Center(
                                            child: hasMore
                                                ? const CircularProgressIndicator(
                                                    color: ThemeColor
                                                        .kPrimaryGreen,
                                                  )
                                                : Container()),
                                      );
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
