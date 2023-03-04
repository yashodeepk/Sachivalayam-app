import 'package:flutter/material.dart';

import '../../utils/constants/dimens.dart';
import '../../utils/constants/theme_colors.dart';

class AppSliverAppBar extends StatelessWidget {
  final Widget? leading, title, flexibleSpace;
  final List<Widget>? action;
  final bool centerTitle, automaticallyImplyLeading;

  ///increase leading width should there be any
  final double? leadingWidth, expandedHeight;

  final Color? backgroundColor;

  const AppSliverAppBar(
      {Key? key,
      this.leading,
      this.title,
      this.action,
      this.automaticallyImplyLeading = false,
      this.leadingWidth = fiftyFiveDp,
      this.centerTitle = true,
      this.flexibleSpace,
      this.backgroundColor = Colors.white,
      //  this.toolbarHeight,
      this.expandedHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      iconTheme: const IconThemeData(color: ThemeColor.kGray),
      pinned: true,
      elevation: 0,
      backgroundColor: backgroundColor,
      centerTitle: centerTitle,
      floating: false,
      snap: false,
      leading: leading,
      leadingWidth: leadingWidth,
      title: title ?? const SizedBox(),
      actions: action ?? [],
      flexibleSpace: flexibleSpace,
      expandedHeight: expandedHeight,
      //toolbarHeight: toolbarHeight!,
    );
  }
}
