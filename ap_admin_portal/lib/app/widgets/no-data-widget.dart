import 'package:ap_admin_portal/app/widgets/animated.column.dart';
import 'package:ap_admin_portal/gen/fonts.gen.dart';
import 'package:ap_admin_portal/utils/constants/dimens.dart';
import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoDataWidget extends StatelessWidget {
  final String title;
  final String? description;
  final String image;
  const NoDataWidget(
      {Key? key, required this.title, this.description, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedColumnWidget(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: fiftyDp),
          Lottie.asset(image, repeat: false),
          const SizedBox(height: tenDp),
          Text(title,
              style: const TextStyle(
                  fontFamily: FontFamily.regular,
                  fontSize: twelveDp,
                  color: ThemeColor.kBlack)),
          const SizedBox(height: tenDp),
          if (description != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: thirtyDp),
              child: Text(description!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: FontFamily.regular,
                      fontWeight: FontWeight.w400,
                      color: ThemeColor.kLightBlack)),
            )
        ]);
  }
}
