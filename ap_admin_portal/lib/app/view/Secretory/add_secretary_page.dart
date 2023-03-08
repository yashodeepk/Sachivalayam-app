import 'package:ap_admin_portal/app/shared-widgets/app_labelled_widget.dart';
import 'package:ap_admin_portal/app/shared-widgets/button_widget.dart';
import 'package:ap_admin_portal/app/shared-widgets/input_widget.dart';
import 'package:ap_admin_portal/app/view-models/user-vm.dart';
import 'package:ap_admin_portal/app/widgets/custom_dialog_box.dart';
import 'package:ap_admin_portal/core/data/services/user-service.dart';
import 'package:ap_admin_portal/core/injections/injections.dart';
import 'package:ap_admin_portal/gen/fonts.gen.dart';
import 'package:ap_admin_portal/generated/assets.dart';
import 'package:ap_admin_portal/generated/l10n.dart';
import 'package:ap_admin_portal/utils/constants/dimens.dart';
import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
import 'package:ap_admin_portal/utils/functions.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'bulk_upload_page.dart';

class AddSecretaryPage extends StatefulWidget {
  const AddSecretaryPage({Key? key}) : super(key: key);

  @override
  State<AddSecretaryPage> createState() => _AddSecretaryPageState();
}

class _AddSecretaryPageState extends State<AddSecretaryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _zoneController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _sachController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  int index = -1;

  final List<String> _genderList = [S.current.male, S.current.female];

  String? _selectedZone, _selectedWard, _selectedSach, _selectedGender;

  final UserService _authService = sl<UserService>();

  final UserVm _authVm = sl<UserVm>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> listOfZone = [];
  List<String> listOfWard = [];
  List<String> listOfSach = [];

  Widget genderSelector({required String gender, required bool isSelected}) {
    return Container(
      decoration: BoxDecoration(
          color: isSelected ? ThemeColor.kSeaBlue : Colors.transparent,
          borderRadius: gender == S.current.male
              ? const BorderRadius.only(topLeft: Radius.circular(tenDp), bottomLeft: Radius.circular(tenDp))
              : const BorderRadius.only(topRight: Radius.circular(tenDp), bottomRight: Radius.circular(tenDp))),
      padding: const EdgeInsets.all(twelveDp),
      child: Center(
        child: Text(gender),
      ),
    );
  }

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
          return Form(
            key: _formKey,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(sixteenDp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add New Secretary ',
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
                    Expanded(child: personalInfo()),
                    const VerticalDivider(endIndent: hundredDp),
                    //work area info
                    Expanded(child: workInfo())
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => onBulkUploadTapped(context),
                    child: Container(
                      width: oneFiftyDp,
                      margin: const EdgeInsets.only(left: thirtyDp),
                      padding: const EdgeInsets.all(tenDp),
                      decoration: BoxDecoration(
                          border: Border.all(color: ThemeColor.kPrimaryGreen),
                          borderRadius: BorderRadius.circular(tenDp),
                          color: ThemeColor.kWhite),
                      child: Row(
                        children: [
                          Text(
                            S.current.bulkUpload,
                            style: const TextStyle(color: ThemeColor.kPrimaryGreen),
                          ),
                          const SizedBox(width: tenDp),
                          const Icon(
                            Icons.arrow_right_alt_sharp,
                            color: ThemeColor.kPrimaryGreen,
                          )
                        ],
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: ButtonWidget(
                            buttonName: S.of(context).cancel,
                            onButtonTapped: () => pop(context),
                            width: oneFiftyDp,
                            buttonColor: ThemeColor.kWhite,
                            borderColor: ThemeColor.kWhite,
                            edgeInsetsGeometry: const EdgeInsets.all(sixteenDp),
                            buttonTextColor: ThemeColor.kPrimaryGreen),
                      ),
                      Flexible(
                        child: ButtonWidget(
                            buttonName: S.of(context).addSecretary,
                            onButtonTapped: () => pop(context),
                            width: oneFiftyDp,
                            buttonColor: ThemeColor.kPrimaryGreen,
                            edgeInsetsGeometry: const EdgeInsets.all(sixteenDp),
                            buttonTextColor: ThemeColor.kWhite),
                      ),
                    ],
                  ))
                ],
              ),
              const SizedBox(height: thirtyDp),
            ]),
          );
        }),
      ),
    );
  }

  Widget personalInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fortyDp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.personalInfo,
            style: const TextStyle(
                fontFamily: FontFamily.bold, color: ThemeColor.kBlack, fontWeight: FontWeight.w500, fontSize: twentyDp),
          ),
          const SizedBox(height: thirtyDp),

          ///worker name
          AppLabelledWidget(
            label: Text(
              S.current.workerName,
              style: const TextStyle(fontFamily: FontFamily.regular, color: ThemeColor.kLightBlack),
            ),
            edgeInsetsGeometry: const EdgeInsets.only(bottom: tenDp),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: sixDp),
              child: InputWidget(
                controller: _nameController,
                hint: S.current.enterSecretaryName,
                edgeInsetsGeometry: EdgeInsets.zero,
                onValidate: (value) => validateData(value!),
                onChange: (value) {
                  if (value != null) {
                    validateForm(_formKey);
                  }
                },
                inputType: TextInputType.name,
                textCapitalization: TextCapitalization.none,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {},
              ),
            ),
          ),

          ///contact number
          AppLabelledWidget(
              label: Text(
                S.current.contactNumber,
                style: const TextStyle(fontFamily: FontFamily.regular, color: ThemeColor.kLightBlack),
              ),
              edgeInsetsGeometry: const EdgeInsets.only(bottom: tenDp),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: sixDp),
                child: InputWidget(
                  controller: _contactNumberController,
                  inputFormatter: [numberFiltering()],
                  hint: S.current.enterContactNumber,
                  edgeInsetsGeometry: EdgeInsets.zero,
                  onValidate: (value) => validatePhoneNumber(value!),
                  onChange: (value) {
                    if (value != null) {
                      validateForm(_formKey);
                    }
                  },
                  inputType: TextInputType.phone,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {},
                ),
              )),

          ///gender
          AppLabelledWidget(
              label: Text(
                S.current.gender,
                style: const TextStyle(fontFamily: FontFamily.regular, color: ThemeColor.kLightBlack),
              ),
              edgeInsetsGeometry: const EdgeInsets.only(bottom: tenDp),
              child: Container(
                decoration: BoxDecoration(color: ThemeColor.kFillColor, borderRadius: BorderRadius.circular(tenDp)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _genderList
                      .map((gender) => Flexible(
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _selectedGender = gender;
                                index = _genderList.indexOf(gender);
                              }),
                              child: genderSelector(gender: gender, isSelected: index == _genderList.indexOf(gender)),
                            ),
                          ))
                      .toList(),
                ),
              )),
          const SizedBox(height: sixteenDp),

          ///age
          AppLabelledWidget(
              label: Text(
                S.current.age,
                style: const TextStyle(fontFamily: FontFamily.regular, color: ThemeColor.kLightBlack),
              ),
              edgeInsetsGeometry: const EdgeInsets.only(bottom: tenDp),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: sixDp),
                child: InputWidget(
                  controller: _ageController,
                  hint: S.current.enterSecretaryAge,
                  edgeInsetsGeometry: const EdgeInsets.symmetric(vertical: sixDp),
                  onValidate: (value) => validateAge(value!),
                  onChange: (value) {
                    if (value != null) {
                      validateForm(_formKey);
                    }
                  },
                  inputType: TextInputType.number,
                  inputFormatter: [numberFiltering()],
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (value) {},
                ),
              )),
        ],
      ),
    );
  }

  Widget workInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fortyDp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.workAreaInfo,
            style: const TextStyle(
                fontFamily: FontFamily.bold, color: ThemeColor.kBlack, fontWeight: FontWeight.w700, fontSize: twentyDp),
          ),
          const SizedBox(height: thirtyDp),

          ///zone
          AppLabelledWidget(
            label: Text(
              S.current.zone,
              style: const TextStyle(fontFamily: FontFamily.regular, color: ThemeColor.kLightBlack),
            ),
            edgeInsetsGeometry: const EdgeInsets.only(bottom: tenDp),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: sixDp),
              child: DropdownButtonFormField2(
                decoration: const InputDecoration(
                    fillColor: ThemeColor.kFillColor, border: InputBorder.none, contentPadding: EdgeInsets.zero),
                validator: (value) {
                  if (value == null) {
                    return '*required';
                  }
                  return null;
                },
                icon: dropdownIcon,
                isExpanded: true,
                hint: Text(
                  S.current.selectWorkZone,
                  style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: fourteenDp,
                      color: ThemeColor.kGray,
                      fontFamily: FontFamily.regular),
                ),
                value: _selectedZone,
                onChanged: (value) {
                  setState(() {
                    _selectedZone = value as String;
                  });
                  validateForm(_formKey);
                },
                items: addDividersAfterItems(items: listOfWard),
                customItemsHeights: getCustomItemsHeights(items: listOfWard),
                buttonHeight: fiftyDp,
                buttonWidth: double.infinity,
                buttonPadding: const EdgeInsets.symmetric(horizontal: sixteenDp),
                buttonDecoration: buttonDecoration(),
                itemHeight: fortyDp,
                dropdownMaxHeight: fourHundredDp,
                searchInnerWidgetHeight: 60,
                searchController: _zoneController,
                searchInnerWidget: Padding(
                  padding: searchPadding(),
                  child: searchForm(hintText: S.current.searchZone, controller: _zoneController),
                ),
                searchMatchFn: (item, searchValue) {
                  return (item.value.toString().contains(searchValue));
                },
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    _zoneController.clear();
                  }
                },
              ),
            ),
          ),

          ///ward
          AppLabelledWidget(
              label: Text(
                S.current.ward,
                style: const TextStyle(fontFamily: FontFamily.regular, color: ThemeColor.kLightBlack),
              ),
              edgeInsetsGeometry: const EdgeInsets.only(bottom: tenDp),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: sixDp),
                child: DropdownButtonFormField2(
                  decoration: const InputDecoration(
                      fillColor: ThemeColor.kFillColor, border: InputBorder.none, contentPadding: EdgeInsets.zero),
                  validator: (value) {
                    if (value == null) {
                      return '*required';
                    }
                    return null;
                  },
                  icon: dropdownIcon,
                  isExpanded: true,
                  hint: Text(
                    S.current.selectWorkWard,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: fourteenDp,
                        color: ThemeColor.kGray,
                        fontFamily: FontFamily.regular),
                  ),
                  items: addDividersAfterItems(items: listOfSach.map((e) => e).toList()),
                  customItemsHeights: getCustomItemsHeights(items: listOfSach.map((e) => e).toList()),
                  value: _selectedWard,
                  onChanged: (value) {
                    setState(() {
                      _selectedWard = value as String;
                    });
                    validateForm(_formKey);
                  },
                  buttonHeight: fiftyDp,
                  buttonWidth: double.infinity,
                  buttonPadding: buttonPadding,
                  buttonDecoration: buttonDecoration(),
                  itemHeight: fortyDp,
                  dropdownMaxHeight: fourHundredDp,
                  searchController: _wardController,
                  searchInnerWidgetHeight: 60,
                  searchInnerWidget: Padding(
                    padding: searchPadding(),
                    child: searchForm(hintText: S.current.searchWard, controller: _wardController),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                  //This to clear the search value when you close the menu
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      _wardController.clear();
                    }
                  },
                ),
              )),

          ///Swachlayam
          AppLabelledWidget(
              label: Text(
                S.current.sachivalayam,
                style: const TextStyle(fontFamily: FontFamily.regular, color: ThemeColor.kLightBlack),
              ),
              edgeInsetsGeometry: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: sixDp),
                child: DropdownButtonFormField2(
                  decoration: const InputDecoration(
                      fillColor: ThemeColor.kFillColor, border: InputBorder.none, contentPadding: EdgeInsets.zero),
                  validator: (value) {
                    if (value == null) {
                      return '*required';
                    }
                    return null;
                  },
                  icon: dropdownIcon,
                  isExpanded: true,
                  hint: Text(
                    S.current.selectWorkSwachlayam,
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: fourteenDp,
                        color: ThemeColor.kGray,
                        fontFamily: FontFamily.regular),
                  ),
                  items: addDividersAfterItems(items: listOfSach.map((e) => e).toList()),
                  customItemsHeights: getCustomItemsHeights(items: listOfSach.map((e) => e).toList()),
                  value: _selectedSach,
                  onChanged: (value) {
                    setState(() {
                      _selectedSach = value as String;
                    });
                    validateForm(_formKey);
                  },
                  buttonHeight: fiftyDp,
                  buttonWidth: double.infinity,
                  buttonPadding: buttonPadding,
                  buttonDecoration: buttonDecoration(),
                  itemHeight: fortyDp,
                  dropdownMaxHeight: fourHundredDp,
                  searchController: _sachController,
                  searchInnerWidgetHeight: 60,
                  searchInnerWidget: Padding(
                    padding: searchPadding(),
                    child: searchForm(hintText: S.current.selectWorkSwachlayam, controller: _sachController),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return (item.value.toString().contains(searchValue));
                  },
                  //This to clear the search value when you close the menu
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      _sachController.clear();
                    }
                  },
                ),
              )),
        ],
      ),
    );
  }

  searchForm({required String hintText, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: tenDp,
          vertical: eightDp,
        ),
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(tenDp),
          child: SvgPicture.asset(
            Assets.svgSearch,
            width: twentyDp,
            height: twentyDp,
          ),
        ),
        hintStyle: const TextStyle(fontSize: twelveDp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(eightDp),
        ),
      ),
    );
  }

  onBulkUploadTapped(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CustomDialogBox(
        sigmaX: 0,
        sigmaY: 0,
        child: BulkUploadPage(),
      ),
      barrierDismissible: false,
    );
  }
}
