import 'dart:convert';

import 'package:ap_admin_portal/api/api_service.dart';
import 'package:ap_admin_portal/app/shared-widgets/app_labelled_widget.dart';
// import 'package:ap_admin_portal/app/view-models/user-vm.dart';
import 'package:ap_admin_portal/app/widgets/animated.column.dart';
import 'package:ap_admin_portal/main.dart';
import 'package:ap_admin_portal/utils/constants/dimens.dart';
import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
import 'package:ap_admin_portal/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ap_admin_portal/global/globals.dart' as globals;
import 'package:http/http.dart' as http;

// import '../../../../core/injections/locator.dart';
import '../../../../gen/fonts.gen.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/functions.dart';
import '../../../shared-widgets/button_widget.dart';
import '../../../shared-widgets/input_widget.dart';
import '../forgot-password/forgot-password-screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();

  bool _showPassword = false;

  // final UserVm _authVm = sl<UserVm>();

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 640;
    return Scaffold(
      backgroundColor: ThemeColor.kScaffoldBg,
      body: SafeArea(
        child: Center(
          child: Container(
            width: !isSmallScreen
                ? MediaQuery.of(context).size.width * 0.5
                : MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //todo add logo
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: Center(
                        child: Container(
                          width: 160,
                          height: 160,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Form(
                        key: _loginFormKey,
                        child: Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.symmetric(horizontal: sixteenDp),
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 20),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(thirtyDp),
                                  topRight: Radius.circular(thirtyDp)),
                              color: ThemeColor.kWhite,
                              border:
                                  Border.all(color: ThemeColor.kCardBorder)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: AnimatedColumnWidget(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: twentyDp),
                                        Text('Login',
                                            style: const TextStyle(
                                                fontFamily: FontFamily.medium,
                                                fontSize: twentyDp,
                                                color: ThemeColor.kLightBlack)),
                                        const SizedBox(height: twentyDp),

                                        ///email input
                                        AppLabelledWidget(
                                            label: Text(
                                              'Email',
                                              style: const TextStyle(
                                                  fontFamily:
                                                      FontFamily.regular,
                                                  color:
                                                      ThemeColor.kLightBlack),
                                            ),
                                            description:
                                                '', //todo handle if error
                                            edgeInsetsGeometry: EdgeInsets.zero,
                                            child: InputWidget(
                                              controller: _emailController,
                                              hint: "Enter email here",
                                              edgeInsetsGeometry:
                                                  const EdgeInsets.symmetric(
                                                      vertical: sixDp),
                                              onValidate: (value) =>
                                                  validateEmail(value!),
                                              onChange: (value) {
                                                // if (value != null) {
                                                //   validateForm(_loginFormKey);
                                                // }
                                              },
                                              inputType:
                                                  TextInputType.emailAddress,
                                              textCapitalization:
                                                  TextCapitalization.none,
                                              textInputAction:
                                                  TextInputAction.next,
                                              onFieldSubmitted: (value) {},
                                            )),

                                        ///password  input
                                        AppLabelledWidget(
                                            label: const Text(
                                              "Password",
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.regular,
                                                  color:
                                                      ThemeColor.kLightBlack),
                                            ),
                                            description: '',
                                            edgeInsetsGeometry: EdgeInsets.zero,
                                            child: InputWidget(
                                                controller: _passwordController,
                                                hint: "Enter password here",
                                                obscureText: !_showPassword,
                                                edgeInsetsGeometry:
                                                    const EdgeInsets.symmetric(
                                                        vertical: sixDp),
                                                onValidate: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Password Required";
                                                  }
                                                  return null;
                                                },
                                                // ,
                                                onChange: (value) {
                                                  // if (value != null) {
                                                  //   validateForm(_loginFormKey);
                                                  // }
                                                },
                                                inputType: TextInputType
                                                    .visiblePassword,
                                                textCapitalization:
                                                    TextCapitalization.none,
                                                textInputAction:
                                                    TextInputAction.done,
                                                onFieldSubmitted: (value) {
                                                  if (validateForm(
                                                      _loginFormKey)) {
                                                    onLoginTapped(context);
                                                  }
                                                  return null;
                                                },
                                                suffixIcon: IconButton(
                                                  tooltip: _showPassword
                                                      ? "hide password"
                                                      : "show password",
                                                  icon: Icon(_showPassword
                                                      ? Icons.visibility
                                                      : Icons.visibility_off),
                                                  color: ThemeColor.kGray,
                                                  onPressed: () => setState(
                                                      () => _showPassword =
                                                          !_showPassword),
                                                ))),
                                        // Align(
                                        //   alignment: Alignment.bottomRight,
                                        //   child: InkWell(
                                        //     onTap: () {
                                        //       Navigator.push(
                                        //           context,
                                        //           MaterialPageRoute(
                                        //               builder: (context) =>
                                        //                   const ForgotPasswordScreen()));
                                        //     },
                                        //     child: const Text("Forgot Password",
                                        //         style: TextStyle(
                                        //             fontFamily:
                                        //                 FontFamily.regular,
                                        //             color: ThemeColor
                                        //                 .kLightBlack)),
                                        //   ),
                                        // ),
                                      ]),
                                ),
                              ),
                              //login button
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Builder(builder: (context) {
                                  return ButtonWidget(
                                      buttonName: "Login",
                                      onButtonTapped: () =>
                                          onLoginTapped(context),
                                      width: MediaQuery.of(context).size.width,
                                      buttonColor: ThemeColor.kPrimaryGreen,
                                      buttonTextStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                      edgeInsetsGeometry:
                                          const EdgeInsets.symmetric(
                                              vertical: sixteenDp),
                                      buttonTextColor: ThemeColor.kWhite);
                                }),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onLoginTapped(BuildContext context) async {
    if (validateForm(_loginFormKey)) {
      showLoaderDialog(context);
      Map data = {
        "username": _emailController.text,
        "password": _passwordController.text
      };
      http.Response res = await APIService.login(jsonEncode(data));
      var resDecoded = jsonDecode(res.body);
      if (res.statusCode >= 200 && res.statusCode <= 300) {
        if (resDecoded['results'] != null) {
          if (resDecoded['results']['data'] != null) {
            if (resDecoded['results']['data']['roles'] != null &&
                resDecoded['results']['data']['roles'] == 'ROLE_ADMIN') {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('ap_admin_portal_access_token',
                  resDecoded['results']['data']["accessToken"]);
              prefs.setString('ap_admin_portal_user_id',
                  resDecoded['results']['data']['id'].toString());
              prefs.setString('ap_admin_portal_user_roles',
                  resDecoded['results']['data']['roles'].toString());
              prefs.setString('ap_admin_portal_user_age',
                  resDecoded['results']['data']['age'].toString());
              prefs.setString('ap_admin_portal_user_gender',
                  resDecoded['results']['data']['gender'].toString());
              prefs.setString('ap_admin_portal_user_email',
                  resDecoded['results']['data']['email'].toString());
              prefs.setString('ap_admin_portal_user_name',
                  resDecoded['results']['data']['name'].toString());
              prefs.setString('ap_admin_portal_user_phonenumber',
                  resDecoded['results']['data']['phone'].toString());
              prefs.setString('ap_admin_portal_user_zone',
                  resDecoded['results']['data']['zone'].toString());
              prefs.setString('ap_admin_portal_user_ward',
                  resDecoded['results']['data']['ward'].toString());
              prefs.setString('ap_admin_portal_user_sachivalyam',
                  resDecoded['results']['data']['sachivalyam'].toString());
              globals.isLoggedIn = true;
              if (mounted) {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const MainApp()));
              }
            } else {
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
                    const Text("Require Admin Role\n",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center),
                  ],
                )),
                // actions: [closeButton, okButton],
              );

              // show the dialog
              if (mounted) {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              }
            }
          } else {
            if (mounted) {
              Navigator.of(context).pop();
              showErrorDialog(context, "Login Failed!", false);
            }
          }
        }
      } else if (res.statusCode == 503) {
        if (mounted) {
          Navigator.of(context).pop();
          showErrorDialog(context, "Failed while connecting to server", true);
        }
      } else {
        if (mounted) {
          Navigator.of(context).pop();
          showErrorDialog(context, "${resDecoded['message']}", false);
        }
      }
    }
  }
}
