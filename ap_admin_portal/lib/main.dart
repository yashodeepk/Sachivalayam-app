import 'package:ap_admin_portal/app/view/Secretory/secretory_page.dart';
import 'package:ap_admin_portal/app/view/Home/home_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

import 'package:ap_admin_portal/global/globals.dart' as globals;
import 'app/view/auth/login/login-screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var accessToken = prefs.getString('ap_admin_portal_access_token');

  accessToken?.isEmpty ?? true
      ? globals.isLoggedIn = false
      : globals.isLoggedIn = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ap Gov Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff558F60),
        secondaryHeaderColor: const Color(0xff165083),
        textTheme: GoogleFonts.poppinsTextTheme().apply(),
      ),
      home: globals.isLoggedIn ? const MainApp() : const LoginScreen(),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => const AppRoot();
}

class AppRoot extends StatefulWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.setExtended(true);
  }

  var pages = [const HomePageWidget(), const SecretaryWidget()];

  String _getTitleByIndex(int index) {
    switch (index) {
      case 0:
        return 'Home';
      default:
        return 'Page Title Not found';
    }
  }

  Widget showDrawer() {
    return SidebarX(
      animationDuration: const Duration(milliseconds: 150),
      controller: _controller,
      theme: const SidebarXTheme(
        // margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: Colors.transparent,
        textStyle: TextStyle(color: Color(0xff808080)),
        selectedTextStyle: TextStyle(color: Color(0xff165083)),
        itemTextPadding: EdgeInsets.only(left: 18),
        selectedItemTextPadding: EdgeInsets.only(left: 18),
        itemDecoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            // border: Border.all(color: darkColorScheme.background),
            ),
        selectedItemDecoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Color(0xff165083),
              width: 1.0,
            ),
            // color: const Color(0xFF5F5FA7).withOpacity(0.6).withOpacity(0.37),
          ),
          color: Color(0xffECF6FF),
        ),
        iconTheme: IconThemeData(
          color: Color(0xff808080),
          size: 20,
        ),
        selectedIconTheme: IconThemeData(
          color: Color(0xff165083),
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 220,
        decoration: BoxDecoration(color: Colors.white
            // darkColorScheme.background,
            ),
      ),
      footerDivider: Divider(color: Colors.white.withOpacity(0.3), height: 1),
      headerBuilder: (context, extended) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: const [
                    AutoSizeText(
                      "Logo",
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Icons.home,
          label: 'Home',
          onTap: () {
            _onItemTapped(0);
          },
        ),
        SidebarXItem(
          icon: Icons.people,
          label: 'Secretary',
          onTap: () {
            _onItemTapped(1);
          },
        ),
        SidebarXItem(
          icon: Icons.file_present_rounded,
          label: 'Tasks',
          onTap: () {
            // _onItemTapped(2);
          },
        ),
        SidebarXItem(
          icon: Icons.my_location,
          label: 'Zone',
          onTap: () {
            // _onItemTapped(3);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final isSmallScreen = MediaQuery.of(context).size.width < 640;
      return Scaffold(
        key: _scaffoldKey,
        drawer: showDrawer(),
        body: Row(
          children: [
            if (!isSmallScreen) showDrawer(),
            Expanded(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isSmallScreen)
                          IconButton(
                              icon: const Icon(Icons.menu_rounded),
                              onPressed: () {
                                _scaffoldKey.currentState?.openDrawer();
                              }),
                        Padding(
                          padding: !isSmallScreen
                              ? EdgeInsetsDirectional.fromSTEB(30, 10, 0, 10)
                              : EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                          child: Container(
                            width: 320,
                            child: TextFormField(
                              controller: searchController,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.normal),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF5F5F5),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 18,
                                ),
                              ),
                              style: TextStyle(fontWeight: FontWeight.normal),
                              // FlutterFlowTheme.of(context)
                              //     .bodyText1
                              //     .override(
                              //       fontFamily: 'Poppins',
                              //       fontWeight: FontWeight.normal,
                              //     ),
                              // validator: _model.textControllerValidator
                              // .asValidator(context),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  // borderColor: Colors.transparent,
                                  // borderRadius: 30,
                                  // borderWidth: 1,
                                  // buttonSize: 40,
                                  color: Colors.transparent,
                                  icon: FaIcon(
                                    FontAwesomeIcons.bell,
                                    color: Color(0xff101213),
                                    // FlutterFlowTheme.of(context)
                                    // .primaryText,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    print('IconButton pressed ...');
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: !isSmallScreen
                                  ? EdgeInsetsDirectional.fromSTEB(
                                      30, 20, 20, 20)
                                  : EdgeInsetsDirectional.fromSTEB(
                                      10, 20, 20, 20),
                              child: Container(
                                width: 40,
                                height: 40,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'images/Ellipse_123.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isSmallScreen) pages[_selectedIndex],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
