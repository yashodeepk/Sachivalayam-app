import 'package:ap_admin_portal/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/constants/dimens.dart';
import '../../utils/constants/theme_colors.dart';
import '../../utils/enums.dart';
import '../../utils/functions.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String hint, helperText;
  String? prefixText;
  final EdgeInsetsGeometry edgeInsetsGeometry;
  Widget? prefixIcon;
  final String? Function(String?) onChange;
  final String? Function(String?) onValidate;
  final String? Function(String?) onFieldSubmitted;
  final AppTextFieldType textFieldType;
  final Function()? onPrefixIconTapped;
  final Function()? onSuffixIconTapped;
  final Widget suffixIcon, suffix;
  final bool autoFocus, obscureText;
  final TextInputType inputType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> inputFormatter;
  final bool readOnly, isDropDown;
  final Color focusAndEnableColor, filledColor;
  final int maxLines;
  final int maxLength;
  final double width;
  final TextAlign textAlign;
  final Function()? onTap;
  final double borderRadius;
  bool hasBorder;

  InputWidget(
      {Key? key,
      this.onTap,
      required this.controller,
      required this.hint,
      this.helperText = '',
      required this.edgeInsetsGeometry,
      required this.onValidate,
      this.autoFocus = false,
      this.obscureText = false,
      this.prefixIcon,
      this.readOnly = false,
      this.isDropDown = false,
      this.maxLines = 1,
      this.maxLength = 6,
      this.borderRadius = twelveDp,
      this.focusAndEnableColor = Colors.transparent,
      this.filledColor = ThemeColor.kWhite,
      this.inputType = TextInputType.text,
      this.inputFormatter = const [],
      this.textFieldType = AppTextFieldType.regular,
      this.textAlign = TextAlign.start,
      this.width = double.infinity,
      this.suffixIcon = const SizedBox(),
      this.suffix = const SizedBox(),
      this.onPrefixIconTapped,
      this.onSuffixIconTapped,
      this.textInputAction = TextInputAction.next,
      this.textCapitalization = TextCapitalization.none,
      required this.onChange,
      required this.onFieldSubmitted,
      this.hasBorder = false,
      this.prefixText})
      : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  final double borderWidth = 3;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        switch (widget.textFieldType) {
          case AppTextFieldType.form:
            return _regularFormField();

          case AppTextFieldType.phone:
            return _phoneTextField();

          case AppTextFieldType.multiline:
            return _multiLineField();

          default:
            return _regularFormField();
        }
      },
    );
  }

  //multi line
  Widget _multiLineField() {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: widget.edgeInsetsGeometry,
        child: TextFormField(
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          autofocus: widget.autoFocus,
          cursorColor: Colors.black,
          maxLines: widget.maxLines,
          keyboardType: widget.inputType,
          inputFormatters: widget.inputFormatter,
          textAlign: widget.textAlign,
          style: const TextStyle(
              color: Colors.black, fontFamily: FontFamily.regular),
          controller: widget.controller,
          validator: widget.onValidate,
          onChanged: widget.onChange,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: ThemeColor.kFillColor,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(eightDp),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: twelveDp, vertical: eightDp),
              filled: true,
              fillColor: ThemeColor.kFillColor,
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: ThemeColor.kFillColor),
                  borderRadius: BorderRadius.all(Radius.circular(eightDp))),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ThemeColor.kFillColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(eightDp))),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                color: ThemeColor.kErrorBorderColor,
              )),
              suffix: widget.suffixIcon,
              hintText: widget.hint,
              helperStyle: const TextStyle(fontSize: tenDp),
              hintStyle: const TextStyle(
                  color: ThemeColor.kGray, fontFamily: FontFamily.regular),
              focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(sixDp)),
                  borderSide: BorderSide(
                    color: ThemeColor.kErrorBorderColor,
                  ))
              // disabledBorder: InputBorder.none,
              ),
        ));
  }

  Widget _phoneTextField() {
    return Container(
        width: widget.width,
        margin: widget.edgeInsetsGeometry,
        child: TextFormField(
          autofocus: widget.autoFocus,
          cursorColor: Colors.black,
          keyboardType: TextInputType.phone,
          readOnly: widget.readOnly,
          maxLength: widget.maxLength,
          // inputFormatters: [numberFiltering()],
          style: const TextStyle(
              color: Colors.black, fontFamily: FontFamily.regular),
          controller: widget.controller,
          validator: widget.onValidate,
          onChanged: widget.onChange,
          onTap: widget.onTap,
          onFieldSubmitted: widget.onFieldSubmitted,
          textInputAction: widget.textInputAction,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            contentPadding: const EdgeInsets.all(tenDp),
            /*    label: Text(widget.hint,
                style: const TextStyle(
                  color: Colors.black45,
                )),*/
            labelStyle: const TextStyle(
                color: ThemeColor.kBlack, fontFamily: FontFamily.regular),
            filled: true,
            hintText: widget.hint,
            fillColor: widget.filledColor,
            helperStyle: const TextStyle(fontSize: tenDp),
            //hintStyle: const TextStyle(inherit: true, color:  Colors.black45),
            enabledBorder: widget.hasBorder
                ? OutlineInputBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(widget.borderRadius)),
                    borderSide: BorderSide(color: widget.focusAndEnableColor))
                : InputBorder.none,
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.focusAndEnableColor),
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.borderRadius))),
            focusColor: ThemeColor.kFillColor,
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ThemeColor.kErrorBorderColor)),
            focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ThemeColor.kErrorBorderColor)),
            // disabledBorder: InputBorder.none,
          ),
        ));
  }

  Widget _regularFormField() {
    return Container(
      margin: widget.edgeInsetsGeometry,
      child: TextFormField(
        autofocus: widget.autoFocus,
        cursorColor: Colors.black,
        maxLines: widget.maxLines,
        keyboardType: widget.inputType,
        inputFormatters: widget.inputFormatter,
        textAlign: widget.textAlign,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        obscuringCharacter: '*',
        style: const TextStyle(
            color: ThemeColor.kGray, fontFamily: FontFamily.regular),
        controller: widget.controller,
        validator: widget.onValidate,
        onChanged: widget.onChange,
        onFieldSubmitted: widget.onFieldSubmitted,
        textInputAction: widget.textInputAction,
        onTap: widget.onTap,
        textCapitalization: widget.textCapitalization,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(sixteenDp),
            helperText: widget.helperText,
            filled: true,
            fillColor: ThemeColor.kFillColor,
            prefixIcon: widget.prefixIcon ??
                const SizedBox(width: tenDp, height: twentyDp),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: fifteenDp),
            suffixIcon: widget.isDropDown
                ? const Icon(Icons.arrow_drop_down,
                    color: ThemeColor.kLightBlack)
                : GestureDetector(
                    onTap: widget.onSuffixIconTapped, child: widget.suffixIcon),
            hintText: widget.hint,
            helperStyle: const TextStyle(fontSize: tenDp),
            hintStyle: const TextStyle(
                color: ThemeColor.kGray, fontFamily: FontFamily.regular),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.focusAndEnableColor),
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.focusAndEnableColor),
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius),
              ),
            ),
            //  focusColor: ThemeColor.kFocusedColor,
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ThemeColor.kErrorBorderColor),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ThemeColor.kErrorBorderColor),
            )
            // disabledBorder: InputBorder.none,
            ),
      ),
    );
  }
}
