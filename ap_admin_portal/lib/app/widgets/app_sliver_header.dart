import 'package:flutter/material.dart';

class AppSliverPersistentHeader extends StatelessWidget {
  final Widget child;
  final bool pinned;

  final double max, min;

  const AppSliverPersistentHeader({
    Key? key,
    required this.child,
    required this.min,
    required this.max,
    this.pinned = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      delegate: PersistentHeader(child: child, max: max, min: min),
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double max, min;

  PersistentHeader({Key? key, required this.child, required this.min, required this.max});

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
