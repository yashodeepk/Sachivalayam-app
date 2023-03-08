import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'locale_provider.dart';

List<SingleChildWidget> listOfProvider(BuildContext ctx) {
  return [
    ChangeNotifierProvider(create: (ctx) => LocaleViewModel()),
  ];
}
