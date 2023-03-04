import 'package:ap_admin_portal/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/constants/dimens.dart';
import '../../utils/constants/theme_colors.dart';

///shows a snackbar with  a  message
///[success] always remember to call success in a successful results
void showAppSnackBar(
    {required String message,
    String? description,
    String? lottieString,
    required BuildContext context,
    bool success = false}) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: tenDp),
            if (lottieString != null)
              Lottie.asset(lottieString, height: eightyDp),
            if (lottieString != null) const SizedBox(height: tenDp),
            Text(message,
                style: TextStyle(
                    color: success ? ThemeColor.kBlack : ThemeColor.kWhite,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.medium)),
            const SizedBox(height: tenDp),
            if (description != null)
              Text(description,
                  style: TextStyle(
                      color:
                          success ? ThemeColor.kLightBlack : ThemeColor.kWhite,
                      fontWeight: FontWeight.w400,
                      fontFamily: FontFamily.regular)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            success ? ThemeColor.kWhite : ThemeColor.kErrorBorderColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(twentyDp)),
      ),
    );
}
