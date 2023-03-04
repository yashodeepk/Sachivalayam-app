import 'dart:io';

import 'package:ap_admin_portal/gen/fonts.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../utils/constants/dimens.dart';
import '../../utils/constants/theme_colors.dart';

class ButtonWidget extends StatelessWidget {
  final String buttonName;
  final VoidCallback? onButtonTapped;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final Color? borderColor;
  final BorderRadiusGeometry borderRadiusGeometry;
  final double width;
  final double elevation;
  final EdgeInsetsGeometry edgeInsetsGeometry;
  final TextStyle? buttonTextStyle;
  final double? buttonHeight;

  const ButtonWidget({
    Key? key,
    required this.buttonName,
    required this.onButtonTapped,
    this.elevation = 0,
    this.buttonColor,
    this.buttonTextStyle,
    this.borderColor = Colors.transparent,
    required this.width,
    this.edgeInsetsGeometry = EdgeInsets.zero,
    this.borderRadiusGeometry =
        const BorderRadius.all(Radius.circular(twelveDp)),
    required this.buttonTextColor,
    this.buttonHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: width,
          height: buttonHeight ?? fiftyDp,
          margin: edgeInsetsGeometry,
          child: ElevatedButton(
            onPressed: onButtonTapped,
            style: ButtonStyle(
                side:
                    MaterialStateProperty.all(BorderSide(color: borderColor!)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(borderRadius: borderRadiusGeometry)),
                elevation: MaterialStateProperty.resolveWith<double>(
                    (states) => elevation),
                backgroundColor: MaterialStateProperty.all(
                    buttonColor ?? ThemeColor.kPrimaryGreen)),
            child: Text(buttonName,
                style: buttonTextStyle ??
                    TextStyle(
                        color: buttonTextColor ?? ThemeColor.kWhite,
                        fontFamily: FontFamily.medium)),
          ),
        );
      },
    );
  }
}

class DialogActionButton extends StatefulWidget {
  final Widget? child;
  final void Function()? onPressed;
  final Color? foregroundColor,
      backgroundColor; //used to control colors for android

  const DialogActionButton(
      {Key? key,
      this.child,
      required this.onPressed,
      this.foregroundColor,
      this.backgroundColor})
      : super(key: key);

  @override
  State<DialogActionButton> createState() => _DialogActionButtonState();
}

class _DialogActionButtonState extends State<DialogActionButton> {
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? TextButton(
            style: TextButton.styleFrom(
                foregroundColor: widget.foregroundColor ?? ThemeColor.kWhite,
                backgroundColor:
                    widget.backgroundColor ?? ThemeColor.kPrimaryGreen,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(eightDp)))),
            onPressed: widget.onPressed,
            child: widget.child ?? Text(S.current.okay))
        : CupertinoDialogAction(
            onPressed: widget.onPressed,
            child: widget.child ??
                Text(S.current.okay,
                    style: const TextStyle(color: ThemeColor.kActive)));
  }
}
