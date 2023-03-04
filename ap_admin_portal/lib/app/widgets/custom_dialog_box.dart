import 'dart:ui';

import 'package:flutter/material.dart';

import '../../utils/constants/dimens.dart';

class CustomDialogBox extends StatefulWidget {
  final Widget child;
  final double? sigmaX, sigmaY;

  const CustomDialogBox({Key? key, required this.child, this.sigmaX, this.sigmaY}) : super(key: key);

  @override
  CustomDialogBoxState createState() => CustomDialogBoxState();
}

class CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: widget.sigmaX ?? tenDp, sigmaY: widget.sigmaY ?? tenDp),
      child: widget.child,
    );
  }
}
