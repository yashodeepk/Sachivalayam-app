import 'package:ap_admin_portal/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../utils/constants/dimens.dart';
import '../../../../utils/constants/theme_colors.dart';
import '../../../shared-widgets/app_sliver_appbar.dart';
import '../../../widgets/animated.column.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = 'forgot-password';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  Widget actionButtons({required String iconData, required String label}) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: fiftyDp,
            height: fiftyDp,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeColor.kGrayLight,
            ),
            child: Lottie.asset(iconData,
                animate: true, repeat: false, alignment: Alignment.center),
          ),
          const SizedBox(height: tenDp),
          Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.regular,
                color: ThemeColor.kLightBlack),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.kScaffoldBg,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          AppSliverAppBar(
              backgroundColor: ThemeColor.kScaffoldBg,
              automaticallyImplyLeading: true,
              title: Text(
                S.current.forgotPassword
                    .substring(0, S.current.forgotPassword.length - 1),
                style: const TextStyle(color: ThemeColor.kLightBlack),
              ),
              action: []),
          SliverFillRemaining(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Lottie.asset(Assets.lotties.forgotPassword,
                    animate: true, repeat: false, alignment: Alignment.center),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: sixteenDp),
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 12),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(thirtyDp),
                          topRight: Radius.circular(thirtyDp)),
                      color: ThemeColor.kWhite,
                      border: Border.all(color: ThemeColor.kCardBorder)),
                  child: SingleChildScrollView(
                    child: AnimatedColumnWidget(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: twentyDp),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: twentyDp),
                            child: Text(S.current.forgotPasswordDescription,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: FontFamily.regular,
                                    color: ThemeColor.kLightBlack)),
                          ),
                          const SizedBox(height: twentyDp),
                          actionButtons(
                              iconData: Assets.lotties.call,
                              label: '+91 98765 43210'),
                          const SizedBox(height: twentyDp),
                          actionButtons(
                              iconData: Assets.lotties.email,
                              label: 'admin@gmail.com'),
                        ]),
                  ),
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}
