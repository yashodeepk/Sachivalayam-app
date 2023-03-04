// import 'package:ap_admin_portal/app/shared-widgets/app_labelled_widget.dart';
// import 'package:ap_admin_portal/app/shared-widgets/button_widget.dart';
// import 'package:ap_admin_portal/gen/fonts.gen.dart';
// import 'package:ap_admin_portal/generated/l10n.dart';
// import 'package:ap_admin_portal/utils/constants/dimens.dart';
// import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
// import 'package:ap_admin_portal/utils/functions.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';

// class AddWorkingSlot extends StatefulWidget {
//   const AddWorkingSlot({Key? key}) : super(key: key);

//   @override
//   State<AddWorkingSlot> createState() => _AddWorkingSlotState();
// }

// class _AddWorkingSlotState extends State<AddWorkingSlot> {
//   List<String> fromOffset = [S.current.am, S.current.pm];
//   List<String> toOffset = [S.current.am, S.current.pm];
//   final hourList = List.generate(12, (index) => '${(index + 1)}');
//   final secondsList =
//       List.generate(60, (index) => index < 10 ? '0$index' : '${(index)}');

//   String _selectedFromHour = '8',
//       _selectedToHour = '5',
//       _selectedFromMin = '00',
//       _selectedToMin = '00';

//   int fromIndex = 0;
//   int toIndex = 1;
//   late String fromAmPm = fromOffset[0];
//   late String toAmPm = toOffset[1];

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height / 2,
//       padding: const EdgeInsets.symmetric(
//           vertical: hundredDp, horizontal: sixteenDp),
//       child: Material(
//         borderRadius: BorderRadius.circular(tenDp),
//         child: Padding(
//           padding: const EdgeInsets.all(twelveDp),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(S.current.workingSlot,
//                             style: const TextStyle(
//                                 color: ThemeColor.kLightBlack,
//                                 fontFamily: FontFamily.medium)),
//                         IconButton(
//                             onPressed: () => pop(context),
//                             icon: const Icon(
//                               Icons.close,
//                               color: ThemeColor.kLightBlack,
//                             ))
//                       ],
//                     ),
//                     const SizedBox(height: tenDp),
//                     Text(
//                       S.current.from,
//                       style: const TextStyle(
//                           color: ThemeColor.kLightBlack,
//                           fontFamily: FontFamily.medium),
//                     ),
//                     const SizedBox(height: tenDp),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Flexible(
//                             child: AppLabelledWidget(
//                           label: Text(
//                             S.current.hour,
//                             style: const TextStyle(
//                                 fontFamily: FontFamily.regular,
//                                 color: ThemeColor.kGray),
//                           ),
//                           edgeInsetsGeometry:
//                               const EdgeInsets.only(bottom: tenDp),
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(vertical: sixDp),
//                             child: DropdownButtonFormField2(
//                               decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.zero),
//                               validator: (value) {
//                                 if (value == null) {
//                                   return '*required';
//                                 }
//                                 return null;
//                               },
//                               icon: const Icon(Icons.keyboard_arrow_down_sharp,
//                                   size: eighteenDp),
//                               isExpanded: true,
//                               hint: Text(
//                                 hourList.last,
//                                 style: const TextStyle(
//                                     overflow: TextOverflow.ellipsis,
//                                     fontSize: fourteenDp,
//                                     color: ThemeColor.kGray,
//                                     fontFamily: FontFamily.regular),
//                               ),
//                               value: _selectedFromHour,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _selectedFromHour = value as String;
//                                 });
//                               },
//                               buttonHeight: fiftyDp,
//                               items: addDividersAfterItems(items: hourList),
//                               customItemsHeights:
//                                   getCustomItemsHeights(items: hourList),
//                               buttonWidth: fiftyDp,
//                               buttonPadding: const EdgeInsets.symmetric(
//                                   horizontal: sixteenDp),
//                               buttonDecoration: buttonDecoration(),
//                               itemHeight: fortyDp,
//                               dropdownMaxHeight: fourHundredDp,
//                               //This to clear the search value when you close the menu
//                               onMenuStateChange: (isOpen) {
//                                 if (!isOpen) {
//                                   //_taskNameController.clear();
//                                 }
//                               },
//                             ),
//                           ),
//                         )),
//                         const SizedBox(width: fourteenDp),
//                         Flexible(
//                             child: AppLabelledWidget(
//                           label: Text(
//                             S.current.mins,
//                             style: const TextStyle(
//                                 fontFamily: FontFamily.regular,
//                                 color: ThemeColor.kGray),
//                           ),
//                           edgeInsetsGeometry:
//                               const EdgeInsets.only(bottom: tenDp),
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(vertical: sixDp),
//                             child: DropdownButtonFormField2(
//                               decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.zero),
//                               validator: (value) {
//                                 if (value == null) {
//                                   return '*required';
//                                 }
//                                 return null;
//                               },
//                               icon: const Icon(Icons.keyboard_arrow_down_sharp,
//                                   size: eighteenDp),
//                               isExpanded: true,
//                               hint: Text(
//                                 secondsList.last,
//                                 style: const TextStyle(
//                                     overflow: TextOverflow.ellipsis,
//                                     fontSize: fourteenDp,
//                                     color: ThemeColor.kGray,
//                                     fontFamily: FontFamily.regular),
//                               ),
//                               value: _selectedFromMin,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _selectedFromMin = value as String;
//                                 });
//                               },
//                               buttonHeight: fiftyDp,
//                               items: addDividersAfterItems(items: secondsList),
//                               customItemsHeights:
//                                   getCustomItemsHeights(items: secondsList),
//                               buttonWidth: fiftyDp,
//                               buttonPadding: const EdgeInsets.symmetric(
//                                   horizontal: sixteenDp),
//                               buttonDecoration: buttonDecoration(),
//                               itemHeight: fortyDp,
//                               dropdownMaxHeight: fourHundredDp,
//                               //This to clear the search value when you close the menu
//                               onMenuStateChange: (isOpen) {
//                                 if (!isOpen) {
//                                   //_taskNameController.clear();
//                                 }
//                               },
//                             ),
//                           ),
//                         )),
//                         const SizedBox(width: sixteenDp),
//                         Flexible(
//                           child: Row(
//                             children: fromOffset
//                                 .map((offset) => GestureDetector(
//                                     onTap: () => setState(() {
//                                           fromAmPm = offset;
//                                           fromIndex =
//                                               fromOffset.indexOf(offset);
//                                         }),
//                                     child: Padding(
//                                       padding:
//                                           const EdgeInsets.only(top: eightDp),
//                                       child: amPmSelector(
//                                           label: offset,
//                                           isSelected: fromIndex ==
//                                               fromOffset.indexOf(offset)),
//                                     )))
//                                 .toList(),
//                           ),
//                         )
//                       ],
//                     ),
//                     Text(
//                       S.current.to,
//                       style: const TextStyle(
//                           color: ThemeColor.kLightBlack,
//                           fontFamily: FontFamily.medium),
//                     ),
//                     const SizedBox(height: tenDp),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Flexible(
//                             child: AppLabelledWidget(
//                           label: Text(
//                             S.current.hour,
//                             style: const TextStyle(
//                                 fontFamily: FontFamily.regular,
//                                 color: ThemeColor.kGray),
//                           ),
//                           edgeInsetsGeometry:
//                               const EdgeInsets.only(bottom: tenDp),
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(vertical: sixDp),
//                             child: DropdownButtonFormField2(
//                               decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.zero),
//                               validator: (value) {
//                                 if (value == null) {
//                                   return '*required';
//                                 }
//                                 return null;
//                               },
//                               icon: const Icon(Icons.keyboard_arrow_down_sharp,
//                                   size: eighteenDp),
//                               isExpanded: true,
//                               hint: Text(
//                                 hourList.last,
//                                 style: const TextStyle(
//                                     overflow: TextOverflow.ellipsis,
//                                     fontSize: fourteenDp,
//                                     color: ThemeColor.kGray,
//                                     fontFamily: FontFamily.regular),
//                               ),
//                               value: _selectedToHour,
//                               onChanged: (value) {
//                                 setState(() {
//                                   _selectedToHour = value as String;
//                                 });
//                               },
//                               buttonHeight: fiftyDp,
//                               items: addDividersAfterItems(items: hourList),
//                               customItemsHeights:
//                                   getCustomItemsHeights(items: hourList),
//                               buttonWidth: fiftyDp,
//                               buttonPadding: const EdgeInsets.symmetric(
//                                   horizontal: sixteenDp),
//                               buttonDecoration: buttonDecoration(),
//                               itemHeight: fortyDp,
//                               dropdownMaxHeight: fourHundredDp,
//                               //This to clear the search value when you close the menu
//                               onMenuStateChange: (isOpen) {
//                                 if (!isOpen) {
//                                   //_taskNameController.clear();
//                                 }
//                               },
//                             ),
//                           ),
//                         )),
//                         const SizedBox(width: fourteenDp),
//                         Flexible(
//                             child: AppLabelledWidget(
//                           label: Text(
//                             S.current.hour,
//                             style: const TextStyle(
//                                 fontFamily: FontFamily.regular,
//                                 color: ThemeColor.kGray),
//                           ),
//                           edgeInsetsGeometry:
//                               const EdgeInsets.only(bottom: tenDp),
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(vertical: sixDp),
//                             child: DropdownButtonFormField2(
//                               decoration: const InputDecoration(
//                                   border: InputBorder.none,
//                                   contentPadding: EdgeInsets.zero),
//                               validator: (value) {
//                                 if (value == null) {
//                                   return '*required';
//                                 }
//                                 return null;
//                               },
//                               icon: const Icon(Icons.keyboard_arrow_down_sharp,
//                                   size: eighteenDp),
//                               isExpanded: true,
//                               hint: Text(
//                                 secondsList.last,
//                                 style: const TextStyle(
//                                     overflow: TextOverflow.ellipsis,
//                                     fontSize: fourteenDp,
//                                     color: ThemeColor.kGray,
//                                     fontFamily: FontFamily.regular),
//                               ),
//                               value: _selectedToMin,
//                               onChanged: (value) {
//                                 logger.w(value);
//                                 setState(() {
//                                   _selectedToMin = value as String;
//                                 });
//                               },
//                               buttonHeight: fiftyDp,
//                               items: addDividersAfterItems(items: secondsList),
//                               customItemsHeights:
//                                   getCustomItemsHeights(items: secondsList),
//                               buttonWidth: fiftyDp,
//                               buttonPadding: const EdgeInsets.symmetric(
//                                   horizontal: sixteenDp),
//                               buttonDecoration: buttonDecoration(),
//                               itemHeight: fortyDp,
//                               dropdownMaxHeight: fourHundredDp,
//                               //This to clear the search value when you close the menu
//                               onMenuStateChange: (isOpen) {
//                                 if (!isOpen) {
//                                   //_taskNameController.clear();
//                                 }
//                               },
//                             ),
//                           ),
//                         )),
//                         const SizedBox(width: sixteenDp),
//                         Flexible(
//                           child: Row(
//                             children: toOffset
//                                 .map((offset) => GestureDetector(
//                                     onTap: () => setState(() {
//                                           toAmPm = offset;
//                                           toIndex = toOffset.indexOf(offset);
//                                         }),
//                                     child: Padding(
//                                       padding:
//                                           const EdgeInsets.only(top: eightDp),
//                                       child: amPmSelector(
//                                           label: offset,
//                                           isSelected: toIndex ==
//                                               toOffset.indexOf(offset)),
//                                     )))
//                                 .toList(),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Builder(builder: (context) {
//                 return ButtonWidget(
//                     buttonName: S.current.addSlot,
//                     onButtonTapped: () => onAddSlotTap(context),
//                     width: MediaQuery.of(context).size.width,
//                     buttonColor: ThemeColor.kPrimaryGreen,
//                     buttonTextColor: ThemeColor.kWhite);
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget dropDownItem(
//       {required String label,
//       required List<String> slots,
//       required String selectedValue}) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         AppLabelledWidget(
//           label: Text(
//             label,
//             style: const TextStyle(
//                 fontFamily: FontFamily.regular, color: ThemeColor.kGray),
//           ),
//           edgeInsetsGeometry: const EdgeInsets.only(bottom: tenDp),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: sixDp),
//             child: DropdownButtonFormField2(
//               decoration: const InputDecoration(
//                   border: InputBorder.none, contentPadding: EdgeInsets.zero),
//               validator: (value) {
//                 if (value == null) {
//                   return '*required';
//                 }
//                 return null;
//               },
//               icon:
//                   const Icon(Icons.keyboard_arrow_down_sharp, size: eighteenDp),
//               isExpanded: true,
//               hint: Text(
//                 slots.last,
//                 style: const TextStyle(
//                     overflow: TextOverflow.ellipsis,
//                     fontSize: fourteenDp,
//                     color: ThemeColor.kGray,
//                     fontFamily: FontFamily.regular),
//               ),
//               value: selectedValue,
//               onChanged: (value) {
//                 logger.w(value);
//                 setState(() {
//                   selectedValue = value as String;
//                 });
//               },
//               buttonHeight: fiftyDp,
//               items: addDividersAfterItems(items: slots),
//               customItemsHeights: getCustomItemsHeights(items: slots),
//               buttonWidth: fiftyDp,
//               buttonPadding: const EdgeInsets.symmetric(horizontal: sixteenDp),
//               buttonDecoration: buttonDecoration(),
//               itemHeight: fortyDp,
//               dropdownMaxHeight: fourHundredDp,
//               //This to clear the search value when you close the menu
//               onMenuStateChange: (isOpen) {
//                 if (!isOpen) {
//                   //_taskNameController.clear();
//                 }
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget amPmSelector({required String label, required bool isSelected}) {
//     return Container(
//       height: fiftyDp,
//       decoration: BoxDecoration(
//           color: isSelected ? ThemeColor.kActive : ThemeColor.kGrayLight,
//           borderRadius: label == S.current.am
//               ? const BorderRadius.only(
//                   topLeft: Radius.circular(tenDp),
//                   bottomLeft: Radius.circular(tenDp))
//               : const BorderRadius.only(
//                   topRight: Radius.circular(tenDp),
//                   bottomRight: Radius.circular(tenDp))),
//       padding: const EdgeInsets.symmetric(horizontal: twelveDp),
//       child: Center(
//         child: Text(
//           label,
//           style: TextStyle(
//               color: isSelected ? ThemeColor.kWhite : ThemeColor.kLightBlack),
//         ),
//       ),
//     );
//   }

//   onAddSlotTap(BuildContext context) {
//     final fromTime = '$_selectedFromHour:$_selectedFromMin $fromAmPm';
//     final toTime = '$_selectedToHour:$_selectedToMin $toAmPm';

//     pop(context, args: '$fromTime - $toTime');
//   }
// }
