import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Apr';
        break;
      case 1:
        text = 'May';
        break;
      case 2:
        text = 'Jun';
        break;
      case 3:
        text = 'Jul';
        break;
      case 4:
        text = 'Aug';
        break;
      default:
        text = '';
        break;
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

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: 12,
            rodStackItems: [
              BarChartRodStackItem(0, 10, ThemeColor.kPrimaryGreen),
              BarChartRodStackItem(
                  10, 12, ThemeColor.kPrimaryGreen.withOpacity(0.5)),
            ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
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
              padding: const EdgeInsetsDirectional.fromSTEB(30, 30, 30, 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 30, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.22,
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
                                children: const [
                                  Padding(
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
                                  Padding(
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    child: AutoSizeText('065',
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        minFontSize: 25,
                                        maxFontSize: 30,
                                        style: TextStyle(
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
                                          'images/Ellipse_128_pink.svg',
                                          fit: BoxFit.fill,
                                        ),
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              0.07, -0.09),
                                          child: SvgPicture.asset(
                                            'images/archive-book.svg',
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
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 30, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.22,
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
                                children: const [
                                  Padding(
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
                                  Padding(
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    child: AutoSizeText('065',
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        minFontSize: 25,
                                        maxFontSize: 30,
                                        style: TextStyle(
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
                                          'images/Ellipse_128_blue.svg',
                                          fit: BoxFit.fill,
                                        ),
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              0.07, -0.09),
                                          child: SvgPicture.asset(
                                            'images/document-text.svg',
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
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 30, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.22,
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
                                children: const [
                                  Padding(
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
                                  Padding(
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 0),
                                    child: AutoSizeText('065',
                                        textAlign: TextAlign.left,
                                        maxLines: 2,
                                        minFontSize: 25,
                                        maxFontSize: 30,
                                        style: TextStyle(
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
                                          'images/Ellipse_128_green.svg',
                                          fit: BoxFit.fill,
                                        ),
                                        Align(
                                          alignment: const AlignmentDirectional(
                                              0.07, -0.09),
                                          child: SvgPicture.asset(
                                            'images/clipboard-tick.svg',
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
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
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
                            mainAxisSize: MainAxisSize.max,
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
                                width: 739,
                                height: 420,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Color(0x33000000),
                                      offset: Offset(0, 2),
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      33, 20, 41, 17),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 220,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFECF6FF),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5, 5, 5, 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: const [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: Color(0xFF202020),
                                                    size: 16,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                5, 0, 0, 0),
                                                    child: Text(
                                                        'June 1, 2022 - June 7, 2022',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text('Filter : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(10, 0, 10, 0),
                                                  //   child:
                                                  //       Dropdown<
                                                  //           String>(
                                                  //     options: [
                                                  //       'Option 1'
                                                  //     ],
                                                  //     onChanged: (val) =>
                                                  //         setState(() =>
                                                  //             _model.dropDownValue1 =
                                                  //                 val),
                                                  //     width: 77,
                                                  //     height: 30,
                                                  //     textStyle:
                                                  //         FlutterFlowTheme.of(
                                                  //                 context)
                                                  //             .bodyText1
                                                  //             .override(
                                                  //               fontFamily:
                                                  //                   'Poppins',
                                                  //               color: FlutterFlowTheme.of(
                                                  //                       context)
                                                  //                   .primaryText,
                                                  //               fontWeight:
                                                  //                   FontWeight
                                                  //                       .normal,
                                                  //             ),
                                                  //     hintText: 'Zone',
                                                  //     icon: Icon(
                                                  //       Icons
                                                  //           .keyboard_arrow_down_rounded,
                                                  //       size: 15,
                                                  //     ),
                                                  //     fillColor: Color(
                                                  //         0xFFECF6FF),
                                                  //     elevation: 2,
                                                  //     borderColor: Colors
                                                  //         .transparent,
                                                  //     borderWidth: 0,
                                                  //     borderRadius: 10,
                                                  //     margin:
                                                  //         EdgeInsetsDirectional
                                                  //             .fromSTEB(
                                                  //                 10,
                                                  //                 0,
                                                  //                 0,
                                                  //                 0),
                                                  //     hidesUnderline:
                                                  //         true,
                                                  //   ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 10, 0),
                                                  // child:
                                                  //     FlutterFlowDropDown<
                                                  //         String>(
                                                  //   options: [
                                                  //     'Option 1'
                                                  //   ],
                                                  //   onChanged: (val) =>
                                                  //       setState(() =>
                                                  //           _model.dropDownValue2 =
                                                  //               val),
                                                  //   width: 77,
                                                  //   height: 30,
                                                  //   textStyle:
                                                  //       FlutterFlowTheme.of(
                                                  //               context)
                                                  //           .bodyText1
                                                  //           .override(
                                                  //             fontFamily:
                                                  //                 'Poppins',
                                                  //             color: FlutterFlowTheme.of(
                                                  //                     context)
                                                  //                 .primaryText,
                                                  //             fontWeight:
                                                  //                 FontWeight
                                                  //                     .normal,
                                                  //           ),
                                                  //   hintText: 'Ward',
                                                  //   icon: Icon(
                                                  //     Icons
                                                  //         .keyboard_arrow_down_rounded,
                                                  //     size: 15,
                                                  //   ),
                                                  //   fillColor: Color(
                                                  //       0xFFECF6FF),
                                                  //   elevation: 2,
                                                  //   borderColor: Colors
                                                  //       .transparent,
                                                  //   borderWidth: 0,
                                                  //   borderRadius: 10,
                                                  //   margin:
                                                  //       EdgeInsetsDirectional
                                                  //           .fromSTEB(
                                                  //               10,
                                                  //               0,
                                                  //               0,
                                                  //               0),
                                                  //   hidesUnderline:
                                                  //       true,
                                                  // ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 10, 0),
                                                  // child:
                                                  //     FlutterFlowDropDown<
                                                  //         String>(
                                                  //   options: [
                                                  //     'Option 1'
                                                  //   ],
                                                  //   onChanged: (val) =>
                                                  //       setState(() =>
                                                  //           _model.dropDownValue3 =
                                                  //               val),
                                                  //   width: 134,
                                                  //   height: 30,
                                                  //   textStyle:
                                                  //       FlutterFlowTheme.of(
                                                  //               context)
                                                  //           .bodyText1
                                                  //           .override(
                                                  //             fontFamily:
                                                  //                 'Poppins',
                                                  //             color: FlutterFlowTheme.of(
                                                  //                     context)
                                                  //                 .primaryText,
                                                  //             fontWeight:
                                                  //                 FontWeight
                                                  //                     .normal,
                                                  //           ),
                                                  //   hintText:
                                                  //       'Swachlayam',
                                                  //   icon: Icon(
                                                  //     Icons
                                                  //         .keyboard_arrow_down_rounded,
                                                  //     size: 15,
                                                  //   ),
                                                  //   fillColor: Color(
                                                  //       0xFFECF6FF),
                                                  //   elevation: 2,
                                                  //   borderColor: Colors
                                                  //       .transparent,
                                                  //   borderWidth: 0,
                                                  //   borderRadius: 10,
                                                  //   margin:
                                                  //       EdgeInsetsDirectional
                                                  //           .fromSTEB(
                                                  //               10,
                                                  //               0,
                                                  //               0,
                                                  //               0),
                                                  //   hidesUnderline:
                                                  //       true,
                                                  // ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: LayoutBuilder(
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
                                                              .center,
                                                      barTouchData:
                                                          BarTouchData(
                                                        enabled: false,
                                                      ),
                                                      titlesData: FlTitlesData(
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
                                                        leftTitles: AxisTitles(
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
                                                        rightTitles: AxisTitles(
                                                          sideTitles:
                                                              SideTitles(
                                                                  showTitles:
                                                                      false),
                                                        ),
                                                      ),
                                                      gridData: FlGridData(
                                                        show: true,
                                                        checkToShowHorizontalLine:
                                                            (value) =>
                                                                value % 10 == 0,
                                                        getDrawingHorizontalLine:
                                                            (value) => FlLine(
                                                          // color: AppColors.borderColor.withOpacity(0.1),
                                                          strokeWidth: 1,
                                                        ),
                                                        drawVerticalLine: false,
                                                      ),
                                                      borderData: FlBorderData(
                                                        show: false,
                                                      ),
                                                      groupsSpace: barsSpace,
                                                      barGroups: getData(
                                                          barsWidth, barsSpace),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
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
                                                    color: Color(0xFFB4CBFF),
                                                  ),
                                                ),
                                              ),
                                              Padding(
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
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(5, 5, 5, 5),
                                                child: Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF3A6FE6),
                                                  ),
                                                ),
                                              ),
                                              Text('Assigned Task',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12)
                                                  // style:
                                                  //     FlutterFlowTheme.of(
                                                  //             context)
                                                  //         .bodyText1
                                                  //         .override(
                                                  //           fontFamily:
                                                  //               'Poppins',
                                                  //           fontSize: 12,
                                                  //           fontWeight:
                                                  //               FontWeight
                                                  //                   .normal,
                                                  //         ),
                                                  ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 30, 0, 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text('Area covered by workers',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12)
                                        // style:
                                        //     FlutterFlowTheme.of(context)
                                        //         .bodyText1
                                        //         .override(
                                        //           fontFamily: 'Poppins',
                                        //           fontSize: 20,
                                        //           fontWeight:
                                        //               FontWeight.w500,
                                        //         ),
                                        ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 741,
                                height: 331,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // FlutterFlowTheme.of(context)
                                  //     .secondaryBackground,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      33, 20, 41, 17),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 220,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFECF6FF),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5, 5, 5, 5),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: Color(0xFF202020),
                                                    size: 16,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                5, 0, 0, 0),
                                                    child: Text(
                                                        'June 1, 2022 - June 7, 2022',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        )
                                                        // style: FlutterFlowTheme
                                                        //         .of(context)
                                                        //     .bodyText1
                                                        //     .override(
                                                        //       fontFamily:
                                                        //           'Poppins',
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .normal,
                                                        //     ),
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text('Filter : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal)
                                                    // style: FlutterFlowTheme
                                                    //         .of(context)
                                                    //     .bodyText1
                                                    //     .override(
                                                    //       fontFamily:
                                                    //           'Poppins',
                                                    //       fontWeight:
                                                    //           FontWeight
                                                    //               .normal,
                                                    //     ),
                                                    ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(10, 0, 10, 0),
                                                  // child:
                                                  //     FlutterFlowDropDown<
                                                  //         String>(
                                                  //   options: [
                                                  //     'Option 1'
                                                  //   ],
                                                  //   onChanged: (val) =>
                                                  //       setState(() =>
                                                  //           _model.dropDownValue4 =
                                                  //               val),
                                                  //   width: 77,
                                                  //   height: 30,
                                                  //   textStyle:
                                                  //       FlutterFlowTheme.of(
                                                  //               context)
                                                  //           .bodyText1
                                                  //           .override(
                                                  //             fontFamily:
                                                  //                 'Poppins',
                                                  //             color: FlutterFlowTheme.of(
                                                  //                     context)
                                                  //                 .primaryText,
                                                  //             fontWeight:
                                                  //                 FontWeight
                                                  //                     .normal,
                                                  //           ),
                                                  //   hintText: 'Zone',
                                                  //   icon: Icon(
                                                  //     Icons
                                                  //         .keyboard_arrow_down_rounded,
                                                  //     size: 15,
                                                  //   ),
                                                  //   fillColor: Color(
                                                  //       0xFFECF6FF),
                                                  //   elevation: 2,
                                                  //   borderColor: Colors
                                                  //       .transparent,
                                                  //   borderWidth: 0,
                                                  //   borderRadius: 10,
                                                  //   margin:
                                                  //       EdgeInsetsDirectional
                                                  //           .fromSTEB(
                                                  //               10,
                                                  //               0,
                                                  //               0,
                                                  //               0),
                                                  //   hidesUnderline:
                                                  //       true,
                                                  // ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 10, 0),
                                                  // child:
                                                  //     FlutterFlowDropDown<
                                                  //         String>(
                                                  //   options: [
                                                  //     'Option 1'
                                                  //   ],
                                                  //   onChanged: (val) =>
                                                  //       setState(() =>
                                                  //           _model.dropDownValue5 =
                                                  //               val),
                                                  //   width: 77,
                                                  //   height: 30,
                                                  //   textStyle:
                                                  //       FlutterFlowTheme.of(
                                                  //               context)
                                                  //           .bodyText1
                                                  //           .override(
                                                  //             fontFamily:
                                                  //                 'Poppins',
                                                  //             color: FlutterFlowTheme.of(
                                                  //                     context)
                                                  //                 .primaryText,
                                                  //             fontWeight:
                                                  //                 FontWeight
                                                  //                     .normal,
                                                  //           ),
                                                  //   hintText: 'Ward',
                                                  //   icon: Icon(
                                                  //     Icons
                                                  //         .keyboard_arrow_down_rounded,
                                                  //     size: 15,
                                                  //   ),
                                                  //   fillColor: Color(
                                                  //       0xFFECF6FF),
                                                  //   elevation: 2,
                                                  //   borderColor: Colors
                                                  //       .transparent,
                                                  //   borderWidth: 0,
                                                  //   borderRadius: 10,
                                                  //   margin:
                                                  //       EdgeInsetsDirectional
                                                  //           .fromSTEB(
                                                  //               10,
                                                  //               0,
                                                  //               0,
                                                  //               0),
                                                  //   hidesUnderline:
                                                  //       true,
                                                  // ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 10, 0),
                                                  // child:
                                                  //     FlutterFlowDropDown<
                                                  //         String>(
                                                  //   options: [
                                                  //     'Option 1'
                                                  //   ],
                                                  //   onChanged: (val) =>
                                                  //       setState(() =>
                                                  //           _model.dropDownValue6 =
                                                  //               val),
                                                  //   width: 134,
                                                  //   height: 30,
                                                  //   textStyle:
                                                  //       FlutterFlowTheme.of(
                                                  //               context)
                                                  //           .bodyText1
                                                  //           .override(
                                                  //             fontFamily:
                                                  //                 'Poppins',
                                                  //             color: FlutterFlowTheme.of(
                                                  //                     context)
                                                  //                 .primaryText,
                                                  //             fontWeight:
                                                  //                 FontWeight
                                                  //                     .normal,
                                                  //           ),
                                                  //   hintText:
                                                  //       'Swachlayam',
                                                  //   icon: Icon(
                                                  //     Icons
                                                  //         .keyboard_arrow_down_rounded,
                                                  //     size: 15,
                                                  //   ),
                                                  //   fillColor: Color(
                                                  //       0xFFECF6FF),
                                                  //   elevation: 2,
                                                  //   borderColor: Colors
                                                  //       .transparent,
                                                  //   borderWidth: 0,
                                                  //   borderRadius: 10,
                                                  //   margin:
                                                  //       EdgeInsetsDirectional
                                                  //           .fromSTEB(
                                                  //               10,
                                                  //               0,
                                                  //               0,
                                                  //               0),
                                                  //   hidesUnderline:
                                                  //       true,
                                                  // ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                                                  Image.asset(
                                                    'images/Group_177882.png',
                                                    width: 128,
                                                    height: 128,
                                                    fit: BoxFit.cover,
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
                                                            Text('24',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF165083),
                                                                    fontSize:
                                                                        24)
                                                                // style: FlutterFlowTheme.of(
                                                                //         context)
                                                                //     .bodyText1
                                                                //     .override(
                                                                //       fontFamily:
                                                                //           'Poppins',
                                                                //       color:
                                                                //           Color(0xFF165083),
                                                                //       fontSize:
                                                                //           24,
                                                                //     ),
                                                                ),
                                                            Text(
                                                                'Total Workers',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)
                                                                // style: FlutterFlowTheme.of(
                                                                //         context)
                                                                //     .bodyText1
                                                                //     .override(
                                                                //       fontFamily:
                                                                //           'Poppins',
                                                                //       fontWeight:
                                                                //           FontWeight.normal,
                                                                //     ),
                                                                ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text('19',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF28AAE0),
                                                                    fontSize:
                                                                        24)
                                                                // style: FlutterFlowTheme.of(
                                                                //         context)
                                                                //     .bodyText1
                                                                //     .override(
                                                                //       fontFamily:
                                                                //           'Poppins',
                                                                //       color:
                                                                //           Color(0xFF28AAE0),
                                                                //       fontSize:
                                                                //           24,
                                                                //     ),
                                                                ),
                                                            Text(
                                                                'On duty Workers',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)
                                                                // style: FlutterFlowTheme.of(
                                                                //         context)
                                                                //     .bodyText1
                                                                //     .override(
                                                                //       fontFamily:
                                                                //           'Poppins',
                                                                //       fontWeight:
                                                                //           FontWeight.normal,
                                                                //     ),
                                                                ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Text('05',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFFFD6C4B),
                                                                    fontSize:
                                                                        24)
                                                                // style: FlutterFlowTheme.of(
                                                                //         context)
                                                                //     .bodyText1
                                                                //     .override(
                                                                //       fontFamily:
                                                                //           'Poppins',
                                                                //       color:
                                                                //           Color(0xFFFD6C4B),
                                                                //       fontSize:
                                                                //           24,
                                                                //     ),
                                                                ),
                                                            Text(
                                                                'Absent Workers',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)
                                                                // style: FlutterFlowTheme.of(
                                                                //         context)
                                                                //     .bodyText1
                                                                //     .override(
                                                                //       fontFamily:
                                                                //           'Poppins',
                                                                //       fontWeight:
                                                                //           FontWeight.normal,
                                                                //     ),
                                                                ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
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
                                                  Image.asset(
                                                    'images/Group_177873.png',
                                                    width: 128,
                                                    height: 128,
                                                    fit: BoxFit.cover,
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
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFFB6EEBD),
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
                                                                'Area covered',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF2D2D2D),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)
                                                                // style: FlutterFlowTheme.of(
                                                                //         context)
                                                                //     .bodyText1
                                                                //     .override(
                                                                //       fontFamily:
                                                                //           'Poppins',
                                                                //       color:
                                                                //           Color(0xFF2D2D2D),
                                                                //       fontWeight:
                                                                //           FontWeight.normal,
                                                                //     ),
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
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
                              children: [
                                Text('Recent Task Images',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    )
                                    // style: FlutterFlowTheme.of(context)
                                    //     .bodyText1
                                    //     .override(
                                    //       fontFamily: 'Poppins',
                                    //       fontSize: 20,
                                    //       fontWeight: FontWeight.w500,
                                    //     ),
                                    ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // FlutterFlowTheme.of(context)
                                //     .secondaryBackground,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        15, 15, 15, 15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        // FlutterFlowTheme.of(
                                        //         context)
                                        //     .secondaryBackground,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Color(0xFFE8E8E8),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 10, 10, 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.asset(
                                                            'images/Rectangle_5397.png',
                                                            width: 144,
                                                            height: 144,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, -0.56),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
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
                                                              color:
                                                                  Colors.white,
                                                              // FlutterFlowTheme.of(context)
                                                              //     .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                            ),
                                                            child: Text(
                                                                'Before',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal)
                                                                // style: FlutterFlowTheme.of(context)
                                                                //     .bodyText1
                                                                //     .override(
                                                                //       fontFamily: 'Poppins',
                                                                //       fontWeight: FontWeight.normal,
                                                                //     ),
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.asset(
                                                            'images/Rectangle_5630.png',
                                                            width: 144,
                                                            height: 144,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, -0.56),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
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
                                                              color:
                                                                  Colors.white,
                                                              // FlutterFlowTheme.of(context)
                                                              //     .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                            ),
                                                            child: Text(
                                                              'After',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              // style: FlutterFlowTheme.of(context)
                                                              //     .bodyText1
                                                              //     .override(
                                                              //       fontFamily: 'Poppins',
                                                              //       fontWeight: FontWeight.normal,
                                                              //     ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(10, 10, 10, 10),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      'Anantapur, East zone 515001',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 16,
                                                      )
                                                      // style: FlutterFlowTheme
                                                      //         .of(context)
                                                      //     .bodyText1
                                                      //     .override(
                                                      //       fontFamily:
                                                      //           'Poppins',
                                                      //       fontSize:
                                                      //           16,
                                                      //       fontWeight:
                                                      //           FontWeight
                                                      //               .normal,
                                                      //     ),
                                                      ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        15, 15, 15, 15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        // FlutterFlowTheme.of(
                                        //         context)
                                        //     .secondaryBackground,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Color(0xFFE8E8E8),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 10, 10, 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.asset(
                                                            'images/Rectangle_5397.png',
                                                            width: 144,
                                                            height: 144,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, -0.56),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
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
                                                              color:
                                                                  Colors.white,
                                                              // FlutterFlowTheme.of(context)
                                                              //     .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                            ),
                                                            child: Text(
                                                                'Before',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                )
                                                                // style: FlutterFlowTheme.of(context)
                                                                //     .bodyText1
                                                                //     .override(
                                                                //       fontFamily: 'Poppins',
                                                                //       fontWeight: FontWeight.normal,
                                                                //     ),
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, 0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.asset(
                                                            'images/Rectangle_5630.png',
                                                            width: 144,
                                                            height: 144,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0, -0.56),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
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
                                                              color:
                                                                  Colors.white,
                                                              // FlutterFlowTheme.of(context)
                                                              //     .secondaryBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25),
                                                            ),
                                                            child: Text('After',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                )
                                                                // style: FlutterFlowTheme.of(context)
                                                                //     .bodyText1
                                                                //     .override(
                                                                //       fontFamily: 'Poppins',
                                                                //       fontWeight: FontWeight.normal,
                                                                //     ),
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(10, 10, 10, 10),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      'Anantapur, East zone 515001',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 16,
                                                      )
                                                      // style: FlutterFlowTheme
                                                      //         .of(context)
                                                      //     .bodyText1
                                                      //     .override(
                                                      //       fontFamily:
                                                      //           'Poppins',
                                                      //       fontSize:
                                                      //           16,
                                                      //       fontWeight:
                                                      //           FontWeight
                                                      //               .normal,
                                                      //     ),
                                                      ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
