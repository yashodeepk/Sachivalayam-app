// import 'package:ap_admin_portal/app/view/auth/login/login-screen.dart';
// import 'package:ap_admin_portal/app/view/inspector/inspector-main-page.dart';
// import 'package:ap_admin_portal/app/view/secretary/main-page/secretary-main-page.dart';
// import 'package:ap_admin_portal/core/models/selector.dart';
// import 'package:flutter/material.dart';

// import '../../../../core/injections/locator.dart';
// import '../../../../utils/enums.dart';
// import '../../../view-models/user-vm.dart';
// import '../../../widgets/loading-widget.dart';

// class ConfigPage extends StatefulWidget {
//   static const String routeName = 'configPage';

//   const ConfigPage({Key? key}) : super(key: key);

//   @override
//   State<ConfigPage> createState() => _ConfigPageState();
// }

// class _ConfigPageState extends State<ConfigPage> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<AuthState>(
//           future: _authVm.verifyUserCredentials(context),
//           builder: (context, snapshot) {
//             if (snapshot.data == AuthState.initial) {
//               return const LoadingWidget();
//             }
//             if (snapshot.data == AuthState.notLoggedIn) {
//               return const LoginScreen();
//             }
//             if (snapshot.data == AuthState.loggedInWithValidJwt) {
//               return _authVm.user!.userRole == UserRole.roleSecretary
//                   ? SecretaryMainPage(
//                       selector: PageSelector(mainPageIndex: 0, tabIndex: 0))
//                   : InspectorMainPage(
//                       selector: PageSelector(mainPageIndex: 0, tabIndex: 0));
//             }
//             if (snapshot.data == AuthState.loggedInWithExpiredJwt) {
//               return const LoadingWidget();
//             } else {
//               return const LoadingWidget();
//             }
//           }),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//   }
// }
