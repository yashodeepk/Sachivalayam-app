import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../gen/assets.gen.dart';
import '../../gen/fonts.gen.dart';
import '../../generated/l10n.dart';
import '../../utils/constants/dimens.dart';
import '../../utils/constants/theme_colors.dart';

class AddImageWidget extends StatelessWidget {
  final String label;
  final void Function()? onTap;
  const AddImageWidget({Key? key, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: sixDp),
        decoration: BoxDecoration(color: ThemeColor.kWhite, borderRadius: BorderRadius.circular(tenDp)),
        child: DottedBorder(
          strokeWidth: 0.9,
          borderType: BorderType.RRect,
          color: ThemeColor.kGray,
          dashPattern: const [9, 2],
          radius: const Radius.circular(tenDp),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(tenDp),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: ThemeColor.kGrayLight.withOpacity(0.4), borderRadius: BorderRadius.circular(tenDp)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.svg.upload),
                Text(
                  label,
                  style: const TextStyle(color: ThemeColor.kGray, fontWeight: FontWeight.w500, fontFamily: FontFamily.medium),
                ),
                const SizedBox(height: tenDp),
                Text(
                  S.current.addImage,
                  style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: ThemeColor.kActive,
                      fontWeight: FontWeight.w500,
                      fontFamily: FontFamily.medium),
                ),
                const SizedBox(height: tenDp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
