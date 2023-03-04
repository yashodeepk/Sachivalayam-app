import 'package:flutter/material.dart';

class AppLabelledWidget extends StatefulWidget {
  final Widget label;
  final Widget child;
  final EdgeInsetsGeometry edgeInsetsGeometry;

  const AppLabelledWidget({Key? key, required this.label, required this.child, required this.edgeInsetsGeometry})
      : super(key: key);

  @override
  State<AppLabelledWidget> createState() => _AppLabelledWidgetState();
}

class _AppLabelledWidgetState extends State<AppLabelledWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.edgeInsetsGeometry,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        widget.label,
        // const SizedBox(height: eightDp),
        widget.child
      ]),
    );
  }
}
