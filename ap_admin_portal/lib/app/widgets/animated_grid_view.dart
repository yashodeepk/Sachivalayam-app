import 'package:flutter/material.dart';

class AppGridView extends StatefulWidget {
  final crossAxisSpacing, mainAxisSpacing, childAspectRatio, crossAxisCount;
  final List list;

  const AppGridView(
      {Key? key,
      this.crossAxisSpacing = 0.0,
      this.mainAxisSpacing = 0.0,
      this.childAspectRatio = 1.0,
      required this.crossAxisCount,
      required this.list})
      : super(key: key);

  @override
  State<AppGridView> createState() => _AppGridViewState();
}

class _AppGridViewState extends State<AppGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: widget.crossAxisSpacing,
      mainAxisSpacing: widget.mainAxisSpacing,
      childAspectRatio: widget.childAspectRatio,
      crossAxisCount: widget.crossAxisCount,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: <Widget>[...widget.list],
    );
  }
}
