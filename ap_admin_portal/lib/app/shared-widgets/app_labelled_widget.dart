import 'package:ap_admin_portal/utils/constants/dimens.dart';
import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
import 'package:flutter/material.dart';

class AppLabelledWidget extends StatefulWidget {
  final Widget label;
  final String? description; //used to show an extra such as error
  final Widget child;
  final EdgeInsetsGeometry? edgeInsetsGeometry;
  final TextStyle? descriptionTextStyle;
  final double? verticalSpacing;

  const AppLabelledWidget(
      {Key? key,
      required this.label,
      required this.child,
      this.edgeInsetsGeometry,
      this.descriptionTextStyle,
      this.verticalSpacing,
      this.description})
      : super(key: key);

  @override
  State<AppLabelledWidget> createState() => _AppLabelledWidgetState();
}

class _AppLabelledWidgetState extends State<AppLabelledWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.edgeInsetsGeometry ?? EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: widget.label),
            Flexible(
                child: Text(
              widget.description ?? '',
              style: widget.descriptionTextStyle ??
                  const TextStyle(
                      color: ThemeColor.kErrorBorderColor, fontSize: twelveDp),
            )),
          ],
        ),
        if (widget.verticalSpacing != null)
          SizedBox(height: widget.verticalSpacing),
        // const SizedBox(height: eightDp),
        widget.child
      ]),
    );
  }
}
