import 'package:ap_admin_portal/gen/fonts.gen.dart';
import 'package:ap_admin_portal/generated/assets.dart';
import 'package:ap_admin_portal/generated/l10n.dart';
import 'package:ap_admin_portal/utils/constants/dimens.dart';
import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
import 'package:ap_admin_portal/utils/functions.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BulkUploadPage extends StatefulWidget {
  const BulkUploadPage({Key? key}) : super(key: key);

  @override
  State<BulkUploadPage> createState() => _BulkUploadPageState();
}

class _BulkUploadPageState extends State<BulkUploadPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(sixteenDp),
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height / 4, vertical: sixtyDp),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(tenDp)),
      child: Material(
        borderRadius: BorderRadius.circular(tenDp),
        color: ThemeColor.kWhite,
        child: Builder(builder: (context) {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.all(sixteenDp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.bulkUpload,
                    style: TextStyle(fontFamily: FontFamily.semiBold, fontSize: twentyDp),
                  ),
                  IconButton(
                    onPressed: () => pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: thirtyDp),
            Expanded(
              child: Row(
                children: [
                  //personal info
                  Expanded(child: downloadTemplate()),
                  const VerticalDivider(endIndent: hundredDp),
                  //work area info
                  Expanded(child: uploadTemplate())
                ],
              ),
            ),
          ]);
        }),
      ),
    );
  }

  Widget downloadTemplate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fortyDp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.template,
            style: const TextStyle(
                fontFamily: FontFamily.bold, color: ThemeColor.kBlack, fontWeight: FontWeight.w500, fontSize: twentyDp),
          ),
          Container(
            height: threeHundredDp,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(twentyDp),
            decoration: BoxDecoration(color: ThemeColor.kFillColor, borderRadius: BorderRadius.circular(tenDp)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.svgFile),
                const SizedBox(height: tenDp),
                Flexible(
                  child: Text(S.current.downloadBulkUploadTemplate,
                      style: const TextStyle(color: ThemeColor.kLightBlack, fontFamily: FontFamily.regular)),
                ),
                const SizedBox(height: tenDp),
                Flexible(
                  child: Text(
                    S.current.download,
                    style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: ThemeColor.kActive,
                        fontWeight: FontWeight.w500,
                        fontFamily: FontFamily.medium),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget uploadTemplate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fortyDp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.uploadedSecretaryList,
            style: const TextStyle(
                fontFamily: FontFamily.bold, color: ThemeColor.kBlack, fontWeight: FontWeight.w500, fontSize: twentyDp),
          ),
          Container(
            height: threeHundredDp,
            padding: const EdgeInsets.symmetric(vertical: sixDp),
            decoration: BoxDecoration(color: ThemeColor.kWhite, borderRadius: BorderRadius.circular(tenDp)),
            child: DottedBorder(
              strokeWidth: 0.9,
              borderType: BorderType.RRect,
              color: ThemeColor.kGray,
              dashPattern: const [9, 2],
              radius: const Radius.circular(tenDp),
              child: InkWell(
                onTap: () => pickFile(),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(tenDp),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: ThemeColor.kWhite, borderRadius: BorderRadius.circular(tenDp)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.svgFile),
                      Text(
                        S.current.uploadSecretaryListHere,
                        style: TextStyle(color: ThemeColor.kGray.withOpacity(0.5), fontFamily: FontFamily.regular),
                      ),
                      const SizedBox(height: tenDp),
                      InkWell(
                        child: Text(
                          S.current.uploadFile,
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: ThemeColor.kActive,
                              fontWeight: FontWeight.w500,
                              fontFamily: FontFamily.medium),
                        ),
                      ),
                      const SizedBox(height: tenDp),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickFile() async {}
}
