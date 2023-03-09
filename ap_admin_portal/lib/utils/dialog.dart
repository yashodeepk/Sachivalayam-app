import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

showErrorDialog(BuildContext context, String message) {
  AlertDialog alert = AlertDialog(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0))),
    title: Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Oops!",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff165083),
            ),
            textAlign: TextAlign.center),
        SvgPicture.asset(
          'assets/images/error.svg',
          fit: BoxFit.fill,
        ),
        const Text("Something went wrong\n",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.center),
        Text("$message\n",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.center),
        const Text("Please try again later",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center),
      ],
    )),
    // actions: [closeButton, okButton],
  );
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showSuccessDialog(BuildContext context, String message) {
  AlertDialog alert = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.add_task_outlined,
          color: Colors.green,
          size: 72,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
            margin: const EdgeInsets.only(left: 7),
            child: Text(
              message.toString(),
              style: const TextStyle(color: Color(0xFF000000)),
            )),
      ],
    ),
  );
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    elevation: 0,
    shadowColor: null,
    backgroundColor: Colors.transparent,
    content: Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.05,
        height: MediaQuery.of(context).size.width * 0.05,
        child: const CircularProgressIndicator(
          color: ThemeColor.kPrimaryGreen,
          strokeWidth: 5,
        ),
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
