import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery_app_admin/pages/base_page.dart';
import 'package:grocery_app_admin/pages/categories/categories_list.dart';
import 'package:grocery_app_admin/pages/homepage.dart';
import 'package:grocery_app_admin/pages/loginPage.dart';
import 'package:grocery_app_admin/providers/categories_provider.dart';
import 'package:grocery_app_admin/providers/loader_provider.dart';
import 'package:grocery_app_admin/providers/searchbar_provider.dart';
import 'package:grocery_app_admin/services/shared_services.dart';
import 'package:provider/provider.dart';

Widget _defaultHome = LoginPage();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  bool _result = await SharedService.isLogedIn();

  if (_result) {
    _defaultHome = HomePage();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoriesProvider(),
          child: CategoriesList(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchBarProvider(),
          child: BasePage(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
          child: BasePage(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: _defaultHome,
      ),
    );
  }
}
