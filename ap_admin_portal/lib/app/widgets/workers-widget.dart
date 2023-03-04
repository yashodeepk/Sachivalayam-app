// import 'package:ap_admin_portal/app/shared-widgets/button_widget.dart';
// import 'package:ap_admin_portal/app/view-models/user-vm.dart';
// import 'package:ap_admin_portal/app/view/secretary/main-page/tabs/workers/add-or-edit-single-worker-page.dart';
// import 'package:ap_admin_portal/app/widgets/animated.column.dart';
// import 'package:ap_admin_portal/core/injections/injections.dart';
// import 'package:ap_admin_portal/gen/fonts.gen.dart';
// import 'package:ap_admin_portal/utils/constants/dimens.dart';
// import 'package:ap_admin_portal/utils/functions.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:lottie/lottie.dart';

// import '../../core/models/user/user.dart';
// import '../../gen/assets.gen.dart';
// import '../../generated/l10n.dart';
// import '../../utils/constants/theme_colors.dart';

// class WorkersWidget extends StatefulWidget {
//   final User worker;
//   const WorkersWidget({Key? key, required this.worker}) : super(key: key);

//   @override
//   State<WorkersWidget> createState() => _WorkersWidgetState();
// }

// class _WorkersWidgetState extends State<WorkersWidget> {
//   bool isHidden = true;
//   late final User worker = widget.worker;
//   late final UserVm _userVm = sl<UserVm>();

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           if (isHidden) {
//             isHidden = false;
//           } else {
//             isHidden = true;
//           }
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.all(sixteenDp),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(tenDp),
//             border: Border.all(color: ThemeColor.kGrayLight, width: 0.9)),
//         child: AnimatedColumnWidget(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(sixteenDp),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Flexible(
//                       child: Text(
//                     worker.name ?? '',
//                     style: const TextStyle(fontFamily: FontFamily.medium),
//                   )),
//                   Flexible(
//                       child: Text('${worker.age} yr old',
//                           style: const TextStyle(
//                               fontFamily: FontFamily.regular,
//                               color: ThemeColor.kLightBlack))),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: sixteenDp),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Flexible(
//                       child: Row(
//                     children: [
//                       SvgPicture.asset(Assets.svg.call),
//                       const SizedBox(width: tenDp),
//                       Flexible(
//                         child: Text(
//                           '${worker.phone}',
//                           style: const TextStyle(
//                               fontFamily: FontFamily.regular,
//                               fontWeight: FontWeight.w400,
//                               color: ThemeColor.kLightBlack),
//                         ),
//                       ),
//                     ],
//                   )),
//                   Flexible(
//                       child: Text(capitalizeFirstLetter(worker.gender ?? ''),
//                           style: const TextStyle(
//                               fontFamily: FontFamily.regular,
//                               color: ThemeColor.kLightBlack))),
//                 ],
//               ),
//             ),
//             if (isHidden) const SizedBox(height: twentyDp),
//             if (!isHidden) hiddenWidget()
//           ],
//         ),
//       ),
//     );
//   }

//   Widget hiddenWidget() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: sixteenDp),
//           child: Column(
//             children: [
//               const SizedBox(height: tenDp),
//               const Divider(),
//               Row(
//                 mainAxisSize: MainAxisSize.max,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Flexible(
//                       child: Text(
//                     S.current.workingHours,
//                     style: const TextStyle(
//                         fontFamily: FontFamily.regular,
//                         fontSize: twelveDp,
//                         color: ThemeColor.kLightBlack,
//                         fontWeight: FontWeight.w400),
//                   )),
//                   if (worker.workingSlots!.isNotEmpty)
//                     Flexible(
//                         child: Text(worker.workingSlots!.first,
//                             style: const TextStyle(
//                                 fontFamily: FontFamily.regular,
//                                 color: ThemeColor.kLightBlack))),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: tenDp),
//         Container(
//           decoration: const BoxDecoration(
//               color: ThemeColor.kSeaBlue,
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(tenDp),
//                 bottomRight: Radius.circular(tenDp),
//               )),
//           child: Row(
//             mainAxisSize: MainAxisSize.max,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Flexible(
//                   child: actionButton(
//                       iconData: Assets.svg.edit,
//                       label: S.current.edit,
//                       onPressed: () {
//                         switchScreen(
//                             context, AddOrEditSingleWorkerPage.routeName,
//                             args: worker);
//                       })),
//               Container(
//                 height: sixteenDp,
//                 width: .8,
//                 decoration:
//                     BoxDecoration(color: ThemeColor.kGray.withOpacity(.1)),
//               ),
//               Flexible(
//                   child: actionButton(
//                       iconData: Assets.svg.trash,
//                       label: S.current.remove,
//                       onPressed: () {
//                         showRemoveWorkerBtSheet(context);
//                       })),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   showRemoveWorkerBtSheet(BuildContext context) async {
//     showBtSheet(
//         context: context,
//         enableDrag: false,
//         widget: Builder(builder: (context) {
//           return Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(height: tenDp),
//               Lottie.asset(Assets.lotties.trash),
//               const SizedBox(height: tenDp),
//               Text(S.current.areYouSureYouWantToRemoveWorker,
//                   style: const TextStyle(
//                       color: ThemeColor.kBlack,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: FontFamily.medium)),
//               const SizedBox(height: tenDp),
//               Row(
//                 children: [
//                   Flexible(
//                       child: ButtonWidget(
//                           buttonName: S.current.cancel,
//                           onButtonTapped: () => pop(context),
//                           width: MediaQuery.of(context).size.width,
//                           buttonColor: ThemeColor.kWhite,
//                           edgeInsetsGeometry: const EdgeInsets.all(sixteenDp),
//                           buttonTextColor: ThemeColor.kPrimaryGreen)),
//                   Flexible(
//                       child: ButtonWidget(
//                           buttonName: S.current.remove,
//                           onButtonTapped: () => onRemoveWorkerTapped(context),
//                           width: MediaQuery.of(context).size.width,
//                           buttonColor: ThemeColor.kPrimaryGreen,
//                           edgeInsetsGeometry: const EdgeInsets.all(sixteenDp),
//                           buttonTextColor: ThemeColor.kWhite)),
//                 ],
//               )
//             ],
//           );
//         }));
//   }

//   Widget actionButton(
//       {required String iconData,
//       required String label,
//       void Function()? onPressed}) {
//     return TextButton.icon(
//         style: ButtonStyle(
//             minimumSize: MaterialStatePropertyAll(
//                 Size(MediaQuery.of(context).size.width / 2, 50))),
//         icon: SvgPicture.asset(iconData),
//         onPressed: onPressed,
//         label: Text(label));
//   }

//   Future<void> onRemoveWorkerTapped(BuildContext context) async =>
//       await _userVm.deleteWorker(workerId: worker.id!, context: context);
// }
