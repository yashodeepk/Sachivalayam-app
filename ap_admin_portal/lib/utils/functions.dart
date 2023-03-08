import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:ap_admin_portal/generated/assets.dart';
import 'package:ap_admin_portal/utils/regex.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/widgets/custom_dialog_box.dart';
// import '../core/data/services/user-service.dart';
// import '../core/injections/locator.dart';
import '../generated/l10n.dart';
import 'constants/dimens.dart';
import 'constants/theme_colors.dart';
import 'enums.dart';

var logger = Logger(printer: PrettyPrinter(lineLength: 500));

RegExp validPassword = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");

RegExp validUrl = RegExp(r"([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?");

Future<void> appLaunchUrl(url, {bool inAppLaunch = false}) async {
  try {
    if (inAppLaunch) {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } else {
      if (await canLaunch(url)) {
        await launch(url);
      }
    }
  } catch (e, stackTrace) {
    unawaited(FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: e.toString()));
    rethrow;
  }
}

/// [args] if arguments is need to another route
Widget backButton(BuildContext context,
        {dynamic args,
        void Function()? onPressed,
        Color iconColor = Colors.black,
        EdgeInsetsGeometry edgeInsetsGeometry = EdgeInsets.zero}) =>
    IconButton(
      tooltip: S.current.back,
      onPressed: () async {
        if (onPressed == null) {
          pop(context, args: args);
        } else {
          onPressed();
        }
      },
      icon: Padding(
        padding: edgeInsetsGeometry,
        child: Icon(
          Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
          color: iconColor,
        ),
      ),
    );

//image compress
Future<File> compressFile(File input) async {
  var targetPath = await getApplicationDocumentsDirectory();
  return (await FlutterImageCompress.compressAndGetFile(
          input.absolute.path, '${targetPath.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
          quality: 75, minWidth: 512, minHeight: 512)) ??
      input;
}

Future<String> cropImage({required String filePickedPath}) async {
  // to get the image size (MB)
  final cropImageFile = await ImageCropper().cropImage(
    sourcePath: filePickedPath,
    maxWidth: 512,
    maxHeight: 512,
    compressQuality: 100,
    compressFormat: ImageCompressFormat.jpg,
    aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ],
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Edit Image',
        toolbarColor: Colors.white,
        toolbarWidgetColor: Colors.black,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      IOSUiSettings(
        title: 'Edit Image',
      ),
    ],
  );

  final croppedImagePath = cropImageFile!.path;
  return croppedImagePath;
}

//date formatter
String dateFormatter({required String formatType, required DateTime dateTime}) {
  return DateFormat(formatType).format(dateTime);
}

//decimal filtering
FilteringTextInputFormatter decimalFiltering() => FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'));

/// Formats bytes and returns a string
String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) {
    return '0 B';
  }
  const List<String> suffixes = <String>[
    'B',
    'KB',
    'MB',
    'GB',
    'TB',
    'PB',
    'EB',
    'ZB',
    'YB',
  ];
  final int i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

//renames file names and appends extension
String getFileNameAndExtension({required File file}) {
  String fileName = path.basename(file.path).split('.').first;
  String extension = path.basename(file.path).split('.').last;
  fileName = fileName.replaceAll(fileName, 'IMG_${DateTime.now().microsecondsSinceEpoch}');
  return '$fileName.$extension';
}

//gets file size
String getFileSize({required File file}) => formatBytes(file.lengthSync(), 2);

String getFileSizeMb({required String filePickedPath}) =>
    "${((File(filePickedPath)).lengthSync() / 1024 / 1024).toStringAsFixed(2)}Mb";

Future loader({required BuildContext context}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Builder(builder: (context) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: fourDp, sigmaY: fourDp),
              child: Lottie.asset(Assets.lottiesLoader, width: twoHundredDp, height: twoHundredDp),
            );
          }),
        );
      });
}

//handles back
//number filtering
FilteringTextInputFormatter numberFiltering() => FilteringTextInputFormatter.allow(RegExp('[0-9]'));

onWidgetBindingComplete({required Duration duration, required Function() onComplete}) {
  WidgetsBinding.instance.addPostFrameCallback((_) => Timer(duration, onComplete));
}

///goes back
void pop(BuildContext context, {dynamic args, bool route = false}) {
  return Navigator.of(context, rootNavigator: route).pop(args);
}

popKeyBoard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

///----ALERT DIALOG---------
showAlertDialog(
    {String title = '',
    required String content,
    required BuildContext context,
    required List<Widget> actions,
    bool barrierDismissible = false}) {
  var alertDialog = Platform.isAndroid
      ? AlertDialog(
          title: Text(title),
          content: Text(content),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(sixteenDp)),
          actions: actions)
      : CupertinoAlertDialog(title: Text(title), content: Text(content), actions: actions);

  if (Platform.isAndroid) {
    showDialog(
      context: context,
      builder: (context) => CustomDialogBox(child: alertDialog),
      barrierDismissible: barrierDismissible,
    );
  } else if (Platform.isIOS) {
    showCupertinoDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (context) {
          return CustomDialogBox(child: alertDialog);
        });
  }
}

showBtSheet(
    {required BuildContext context,
    required Widget widget,
    ShapeBorder? shapeBorder,
    bool isDismissible = false,
    bool enableDrag = false}) {
  showModalBottomSheet<void>(
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    context: context,
    shape: shapeBorder ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(fourteenDp),
        ),
    builder: (context) => widget,
  );
}

///Navigate to page
///[replace] determines whether to remove page from stack or to push
///[destination] is the route
///[args] Passes data to page
Future<dynamic> switchScreen(BuildContext context, String destination,
    {bool replace = false, bool popAndPush = false, dynamic args}) {
  return replace
      ? Navigator.of(context).pushNamedAndRemoveUntil(destination, (route) => false, arguments: args)
      : popAndPush
          ? Navigator.of(context).popAndPushNamed(destination, arguments: args)
          : Navigator.of(context).pushNamed(destination, arguments: args);
}

Future<dynamic> switchScreenWithConstructor(
  BuildContext context,
  Widget page, {
  bool replace = false,
}) {
  return replace
      ? Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => page), (route) => true)
      : Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

///take and return file for pictures
Future<File?> takePicture(AppImageSource imageSource) async {
  //get image from camera or gallery
  final filePicked = await ImagePicker()
      .pickImage(source: imageSource == AppImageSource.camera ? ImageSource.camera : ImageSource.gallery, imageQuality: 100);
  // final filePickedPath = filePicked!.path;

  //var imagePath = await cropImage(filePickedPath: filePickedPath);

  if (filePicked != null) {
    return File(filePicked.path);
  } else {
    return null;
  }
}

validateData(String? value) {
  if (value == null || value.isEmpty) {
    return "Required";
  }
  return null;
}

validateEmail(String? value) {
  if (value == null || value.isEmpty || !emailRegExp.hasMatch(value.trim())) {
    return "Enter valid email";
  }
  if (value.length > 100) {
    return "Email Too Long";
  }
  return null;
}

//form validator
bool validateForm(GlobalKey<FormState> formKey) {
  return formKey.currentState!.validate();
}

FilteringTextInputFormatter whiteSpaceFiltering() => FilteringTextInputFormatter.deny(RegExp(r'\s'));

Future<Map<String, String>> xTokenHeader() async {
  // final UserService authService = sl<UserService>();
  // final accessToken = await authService.getToken();
  return {'x-access-token': "accessToken!"};
}

List<DropdownMenuItem<String>> addDividersAfterItems({required List<String> items}) {
  List<DropdownMenuItem<String>> menuItems = [];
  for (var item in items) {
    menuItems.addAll(
      [
        DropdownMenuItem<String>(
          value: item,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ),
        //If it's last item, we will not add Divider after it.
        if (item != items.last)
          const DropdownMenuItem<String>(
            enabled: false,
            child: Divider(),
          ),
      ],
    );
  }
  return menuItems;
}

List<double> getCustomItemsHeights({required List<String> items}) {
  List<double> itemsHeights = [];
  for (var i = 0; i < (items.length * 2) - 1; i++) {
    if (i.isEven) {
      itemsHeights.add(fortyDp);
    }
    //Dividers indexes will be the odd indexes
    if (i.isOdd) {
      itemsHeights.add(fourDp);
    }
  }
  return itemsHeights;
}

const buttonPadding = EdgeInsets.symmetric(horizontal: sixteenDp);
const dropdownIcon = Icon(Icons.keyboard_arrow_down_sharp);

EdgeInsetsGeometry searchPadding() {
  return const EdgeInsets.only(
    top: eightDp,
    bottom: fourDp,
    right: eightDp,
    left: eightDp,
  );
}

BoxDecoration buttonDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(tenDp),
    color: ThemeColor.kGrayLight,
  );
}

String capitalizeFirstLetter(String value) => '${value[0].toUpperCase()}${value.substring(1).toLowerCase()}';
