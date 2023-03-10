import 'dart:convert';

import 'package:ap_admin_portal/api/api_service.dart';
import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ZoneWidget extends StatefulWidget {
  const ZoneWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ZoneWidgetState createState() => _ZoneWidgetState();
}

class _ZoneWidgetState extends State<ZoneWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  List zoneDataList = [];

  @override
  void initState() {
    super.initState();
    zoneData();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
  }

  Future<void> zoneData() async {
    http.Response res = await APIService.getAllZoneData();
    if (res.statusCode >= 200 && res.statusCode <= 300) {
      var resDecoded = jsonDecode(res.body);
      // print(resDecoded);
      if (resDecoded['results'] != null) {
        if (resDecoded['results']['data'] != null) {
          zoneDataList = resDecoded['results']['data'];
          setState(() {});
        }
      }
    }
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
            // mainAxisSize: MainAxisSize.min,
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
                          Text('Zone',
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
              Expanded(
                child: ListView.builder(
                    // controller: _scrollController,
                    // padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    // shrinkWrap: true,
                    itemCount: zoneDataList.length,
                    itemBuilder: (BuildContext context, int i) {
                      bool expansionCheck = false;
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          width: double.infinity,
                          // height: 60,
                          decoration: const BoxDecoration(
                              color: ThemeColor.kWhite,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Theme(
                            data: ThemeData()
                                .copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              // tilePadding: EdgeInsets.all(0),
                              onExpansionChanged: (value) {
                                setState(() {
                                  expansionCheck = value;
                                });
                              },
                              // trailing: const SizedBox.shrink(),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text(
                                      'Zone - ${zoneDataList[i]['name']}',
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff165083),
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                              children: [
                                // const Divider(
                                //   color: Color(0xff165083),
                                // ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: zoneDataList[i]['ward'].length,
                                    itemBuilder: (BuildContext context, int j) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Color(0xffD7D7D7)))),
                                        child: ExpansionTile(
                                          // trailing: const SizedBox.shrink(),
                                          backgroundColor: Color(0xffECF6FF),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                                child: Text(
                                                  'Ward No - ${zoneDataList[i]['ward'][j]['name']}',
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xff165083),
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),
                                          children: [
                                            const Divider(
                                              color: Color(0xff165083),
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: zoneDataList[i]
                                                            ['ward'][j]
                                                        ['sachivalyam']
                                                    .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int k) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        border: k !=
                                                                zoneDataList[i]['ward'][j]
                                                                            [
                                                                            'sachivalyam']
                                                                        .length -
                                                                    1
                                                            ? const Border(
                                                                bottom: BorderSide(
                                                                    color: Color(
                                                                        0xffD7D7D7)))
                                                            : null),
                                                    child: ExpansionTile(
                                                      initiallyExpanded: false,
                                                      trailing: const SizedBox
                                                          .shrink(),
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0,
                                                                    0,
                                                                    20,
                                                                    0),
                                                            child: SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1,
                                                              child: Text(
                                                                '${zoneDataList[i]['ward'][j]['sachivalyam'][k]['sachivalyam_no'].toString()}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Color(
                                                                        0xff165083),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 0, 0, 0),
                                                            child: Text(
                                                              '${zoneDataList[i]['ward'][j]['sachivalyam'][k]['name']}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: const TextStyle(
                                                                  fontSize: 16,
                                                                  color: Color(
                                                                      0xff165083),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                })
                                          ],
                                        ),
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
