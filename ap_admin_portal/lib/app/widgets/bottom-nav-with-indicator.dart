import 'package:ap_admin_portal/utils/constants/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/enums.dart';

class CustomBottomBarItems {
  final String icon;
  final String label;

  CustomBottomBarItems({
    required this.icon,
    required this.label,
  });
}

class CustomLineIndicatorBottomNavbar extends StatelessWidget {
  final Color? backgroundColor;
  final List<CustomBottomBarItems> customBottomBarItems;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final double unselectedFontSize;
  final Color? splashColor;
  final int currentIndex;
  final bool enableLineIndicator;
  final double lineIndicatorWidth;
  final IndicatorType indicatorType;
  final Function(int) onTap;
  final double selectedFontSize;
  final double selectedIconSize;
  final double unselectedIconSize;
  final LinearGradient? gradient;

  const CustomLineIndicatorBottomNavbar({
    super.key,
    this.backgroundColor,
    this.selectedColor,
    required this.customBottomBarItems,
    this.unSelectedColor,
    this.unselectedFontSize = 11,
    this.selectedFontSize = 12,
    this.selectedIconSize = 20,
    this.unselectedIconSize = 15,
    this.splashColor,
    this.currentIndex = 0,
    required this.onTap,
    this.enableLineIndicator = true,
    this.lineIndicatorWidth = 3,
    this.indicatorType = IndicatorType.top,
    this.gradient,
  });
  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarThemeData bottomTheme =
        BottomNavigationBarTheme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor ?? bottomTheme.backgroundColor,
        gradient: gradient,
      ),
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < customBottomBarItems.length; i++) ...[
              Expanded(
                child: CustomLineIndicatorBottomNavbarItems(
                  selectedColor: selectedColor,
                  unSelectedColor: unSelectedColor,
                  icon: customBottomBarItems[i].icon,
                  label: customBottomBarItems[i].label,
                  unSelectedFontSize: unselectedFontSize,
                  selectedFontSize: selectedFontSize,
                  unselectedIconSize: unselectedIconSize,
                  selectedIconSize: selectedIconSize,
                  splashColor: splashColor,
                  currentIndex: currentIndex,
                  enableLineIndicator: enableLineIndicator,
                  lineIndicatorWidth: lineIndicatorWidth,
                  indicatorType: indicatorType,
                  index: i,
                  onTap: onTap,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class CustomLineIndicatorBottomNavbarItems extends StatelessWidget {
  final String? icon;
  final String? label;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final double unSelectedFontSize;
  final double selectedIconSize;
  final double unselectedIconSize;

  final double selectedFontSize;
  final Color? splashColor;
  final int? currentIndex;
  final int index;
  final Function(int) onTap;
  final bool enableLineIndicator;
  final double lineIndicatorWidth;
  final IndicatorType indicatorType;

  const CustomLineIndicatorBottomNavbarItems({
    super.key,
    this.icon,
    this.label,
    this.selectedColor,
    this.unSelectedColor,
    this.unSelectedFontSize = twelveDp,
    this.selectedFontSize = fourteenDp,
    this.selectedIconSize = twentyDp,
    this.unselectedIconSize = fifteenDp,
    this.splashColor,
    this.currentIndex,
    required this.onTap,
    required this.index,
    this.enableLineIndicator = true,
    this.lineIndicatorWidth = 3,
    this.indicatorType = IndicatorType.top,
  });

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarThemeData bottomTheme =
        BottomNavigationBarTheme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(right: eightDp),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: splashColor ?? Theme.of(context).splashColor,
            onTap: () {
              onTap(index);
            },
            child: Container(
              decoration: BoxDecoration(
                border: enableLineIndicator
                    ? Border(
                        bottom: indicatorType == IndicatorType.bottom
                            ? BorderSide(
                                color: currentIndex == index
                                    ? selectedColor ??
                                        bottomTheme.selectedItemColor!
                                    : Colors.transparent,
                                width: lineIndicatorWidth,
                              )
                            : const BorderSide(color: Colors.transparent),
                        top: indicatorType == IndicatorType.top
                            ? BorderSide(
                                color: currentIndex == index
                                    ? selectedColor ??
                                        bottomTheme.selectedItemColor!
                                    : Colors.transparent,
                                width: lineIndicatorWidth,
                              )
                            : const BorderSide(color: Colors.transparent),
                      )
                    : null,
              ),
              padding: const EdgeInsets.symmetric(vertical: eightDp),
              // width: 70,
              // height: 60,
              child: Column(
                children: [
                  SvgPicture.asset(icon!,
                      width: currentIndex == index
                          ? selectedIconSize
                          : unselectedIconSize,
                      height: currentIndex == index
                          ? selectedIconSize
                          : unselectedIconSize,
                      color: currentIndex == index
                          ? selectedColor ?? bottomTheme.unselectedItemColor
                          : unSelectedColor),
                  const SizedBox(height: fiveDp),
                  Text(
                    '$label',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: currentIndex == index
                          ? selectedFontSize
                          : unSelectedFontSize,
                      color: currentIndex == index
                          ? selectedColor ?? bottomTheme.unselectedItemColor
                          : unSelectedColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
