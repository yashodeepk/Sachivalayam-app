import 'package:auto_size_text/auto_size_text.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SecretaryWidget extends StatefulWidget {
  const SecretaryWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SecretaryWidgetState createState() => _SecretaryWidgetState();
}

class _SecretaryWidgetState extends State<SecretaryWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _unfocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _unfocusNode.dispose();
    super.dispose();
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
                          Text('Secretary',
                              style: TextStyle(
                                color: Color(0xFF2D2D2D),
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              )),
                          Text('Total : 87',
                              style: TextStyle(
                                color: Color(0xFF808080),
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(40, 0, 0, 0),
                      child: TextButton(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        child: Text(
                          'Add Secretary',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xff558F60),
                            minimumSize: Size(170, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
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
                    columns: [
                      DataColumn2(
                        size: ColumnSize.S,
                        label: DefaultTextStyle.merge(
                          softWrap: true,
                          child: const AutoSizeText('Sr. no',
                              maxFontSize: 16,
                              style: TextStyle(
                                // fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                      DataColumn2(
                        label: DefaultTextStyle.merge(
                          softWrap: true,
                          child: const AutoSizeText(
                            'Name',
                            maxFontSize: 16,
                            style: TextStyle(
                              // fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      DataColumn2(
                        label: DefaultTextStyle.merge(
                          softWrap: true,
                          child: AutoSizeText(
                            'Contact no.',
                            maxFontSize: 16,
                            style: TextStyle(
                              // fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      DataColumn2(
                        size: ColumnSize.S,
                        label: DefaultTextStyle.merge(
                          softWrap: true,
                          child: AutoSizeText(
                            'Gender',
                            maxFontSize: 16,
                            style: TextStyle(
                              // fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      DataColumn2(
                        size: ColumnSize.S,
                        label: DefaultTextStyle.merge(
                          softWrap: true,
                          child: AutoSizeText(
                            'Age',
                            maxFontSize: 16,
                            style: TextStyle(
                              // fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      DataColumn2(
                        size: ColumnSize.S,
                        label: DefaultTextStyle.merge(
                          softWrap: true,
                          child: AutoSizeText(
                            'Zone',
                            maxFontSize: 16,
                            style: TextStyle(
                              // fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      DataColumn2(
                        label: DefaultTextStyle.merge(
                          softWrap: true,
                          child: AutoSizeText(
                            'Ward',
                            maxFontSize: 16,
                            style: TextStyle(
                              // fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      DataColumn2(
                        label: DefaultTextStyle.merge(
                          softWrap: true,
                          child: AutoSizeText(
                            'Swachlaym',
                            maxFontSize: 16,
                            style: TextStyle(
                              // fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      DataColumn2(
                        label: DefaultTextStyle.merge(
                          softWrap: true,
                          child: AutoSizeText(
                            '',
                            maxFontSize: 16,
                          ),
                        ),
                      ),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(Text(
                          '01',
                        )),
                        DataCell(
                          Text(
                            'Tirumala Tirupathi',
                          ),
                        ),
                        DataCell(
                          Text(
                            '98765 98765',
                          ),
                        ),
                        DataCell(
                          Text(
                            'Male',
                          ),
                        ),
                        DataCell(
                          Text(
                            '38',
                          ),
                        ),
                        DataCell(
                          Text(
                            'East zone',
                          ),
                        ),
                        DataCell(
                          Text(
                            'Vijayawada',
                          ),
                        ),
                        DataCell(
                          Text(
                            'Santhapeta',
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                // borderColor: Colors.transparent,
                                // borderRadius: 30,
                                // buttonSize: 40,
                                icon: Icon(
                                  Icons.edit,
                                  color: Color(0xFF165083),
                                  size: 24,
                                ),
                                onPressed: () {
                                  print('IconButton pressed ...');
                                },
                              ),
                              IconButton(
                                // borderColor: Colors.transparent,
                                // borderRadius: 30,
                                // buttonSize: 40,
                                icon: FaIcon(
                                  FontAwesomeIcons.trashAlt,
                                  color: Color(0xFFFF5151),
                                  size: 24,
                                ),
                                onPressed: () {
                                  print('IconButton pressed ...');
                                },
                              ),
                            ],
                          ),
                        ),
                      ])
                    ],
                    headingRowColor: MaterialStateProperty.all(
                      Color(0xFFECF6FF),
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
                    columnSpacing: 0,
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
