import 'package:ap_admin_portal/gen/fonts.gen.dart';
import 'package:ap_admin_portal/utils/constants/dimens.dart';
import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String itemCount;
  final String label;
  final Color cardColor;
  const HomeCard(
      {Key? key,
      required this.itemCount,
      required this.label,
      required this.cardColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: hundredDp,
      width: MediaQuery.of(context).size.width / 3.5,
      padding: const EdgeInsets.all(tenDp),
      margin: const EdgeInsets.symmetric(horizontal: sixDp),
      decoration: BoxDecoration(
          color: cardColor, borderRadius: BorderRadius.circular(twelveDp)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: tenDp),
          Flexible(
            child: Text(
              itemCount,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: true,
              style: const TextStyle(
                  fontFamily: FontFamily.semiBold,
                  color: ThemeColor.kWhite,
                  fontSize: twentyDp,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                  fontFamily: FontFamily.medium,
                  color: ThemeColor.kWhite,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
