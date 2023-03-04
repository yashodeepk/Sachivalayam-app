import 'dart:convert';

import 'package:ap_admin_portal/api/api_service.dart';
import 'package:ap_admin_portal/app/shared-widgets/app_labelled_widget.dart';
// import 'package:ap_admin_portal/app/view-models/user-vm.dart';
import 'package:ap_admin_portal/app/widgets/animated.column.dart';
import 'package:ap_admin_portal/main.dart';
import 'package:ap_admin_portal/utils/constants/dimens.dart';
import 'package:ap_admin_portal/utils/constants/theme_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ap_admin_portal/global/globals.dart' as globals;

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
    return Scaffold(
      backgroundColor: ThemeColor.kScaffoldBg,
      body: SafeArea(
        child: Center(
          child: Container(
            width: kIsWeb
                ? MediaQuery.of(context).size.width * 0.5
                : MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // color: Colors.white,
            child: CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //todo add logo
                    const Center(
                      child: Text('LOGO'),
                    ),
                    Expanded(
                      child: Form(
                        key: _loginFormKey,
                        child: Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.symmetric(horizontal: sixteenDp),
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 4),
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
                                            label: Text(
                                              "Password",
                                              style: const TextStyle(
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
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: InkWell(
                                            onTap: () {},
                                            // onForgotPasswordTapped(),
                                            child: Text("Forgot Password",
                                                style: const TextStyle(
                                                    fontFamily:
                                                        FontFamily.regular,
                                                    color: ThemeColor
                                                        .kLightBlack)),
                                          ),
                                        ),
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

  // onForgotPasswordTapped() =>
  //     switchScreen(context, ForgotPasswordScreen.routeName);

  Future<void> onLoginTapped(BuildContext context) async {
    if (validateForm(_loginFormKey)) {
      Map data = {
        "username": _emailController.text,
        "password": _passwordController.text
      };
      var res = await APIService.login(jsonEncode(data));
      print(res.statusCode);
      if (res.statusCode >= 200 && res.statusCode <= 300) {
        var resDecoded = jsonDecode(res.body);
        print(resDecoded['results']['data']);
        if (resDecoded['results'] != null) {
          if (resDecoded['results']['data'] != null) {
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
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MainApp()));
            }
          }
        }
      }
    }
  }
}
