import 'package:ap_admin_portal/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../gen/assets.gen.dart';
import '../../generated/l10n.dart';
import '../../utils/constants/dimens.dart';
import '../../utils/constants/theme_colors.dart';
import '../shared-widgets/button_widget.dart';
import 'animated.column.dart';

class RetryPage extends StatefulWidget {
  final Function() onTap;
  final bool isScaffold;
  const RetryPage({Key? key, required this.onTap, this.isScaffold = true})
      : super(key: key);

  @override
  State<RetryPage> createState() => _RetryPageState();
}

class _RetryPageState extends State<RetryPage> {
  body() {
    return Container(
      alignment: Alignment.center,
      child: AnimatedColumnWidget(children: [
        Lottie.asset(Assets.lotties.error,
            width: MediaQuery.of(context).size.width / 1.2),
        Text(
          S.of(context).somethingWentWrong,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: FontFamily.medium, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: tenDp),
        Text(
          S.of(context).pleaseTryAgainLater,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: FontFamily.medium, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: thirtyDp),
        ButtonWidget(
            buttonName: S.of(context).refresh,
            onButtonTapped: widget.onTap,
            buttonColor: ThemeColor.kPrimaryGreen,
            width: MediaQuery.of(context).size.width / 1.8,
            borderRadiusGeometry: BorderRadius.circular(tenDp),
            buttonTextColor: ThemeColor.kWhite)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isScaffold
        ? Scaffold(
            backgroundColor: Colors.white,
            body: body(),
          )
        : body();
  }
}
