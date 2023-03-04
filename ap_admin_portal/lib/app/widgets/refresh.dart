import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../utils/constants/theme_colors.dart';

class Refresh extends StatefulWidget {
  final RefreshController controller;
  final bool enablePullUp, enablePullDown;
  final void Function()? onRefresh;
  final void Function()? onLoading;
  final Widget? header, footer, child;

  const Refresh({
    Key? key,
    required this.controller,
    this.enablePullUp = false,
    this.enablePullDown = true,
    this.onRefresh,
    this.onLoading,
    this.header = const WaterDropMaterialHeader(
      backgroundColor: ThemeColor.kPrimaryGreen,
    ),
    this.footer,
    this.child,
  }) : super(key: key);

  @override
  State<Refresh> createState() => _RefreshState();
}

class _RefreshState extends State<Refresh> {
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: widget.controller,
      enablePullDown: widget.enablePullDown,
      enablePullUp: widget.enablePullUp,
      onLoading: widget.onLoading,
      onRefresh: widget.onRefresh,
      header: widget.header,
      footer: widget.footer,
      child: widget.child,
    );
  }
}
