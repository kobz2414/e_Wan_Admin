import 'package:e_wan_admin/homePage.dart';
import 'package:e_wan_admin/homePageController.dart';
import 'package:e_wan_admin/parkingManagement.dart';
import 'package:e_wan_admin/parkingManagementDetails.dart';
import 'package:e_wan_admin/parkingRecord.dart';
import 'package:e_wan_admin/parkingRecordDetails.dart';
import 'package:e_wan_admin/signIn/AuthService.dart';
import 'package:e_wan_admin/startPage.dart';
import 'package:e_wan_admin/userManagementDetails.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'userManagement.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(homeScreen());
}

class homeScreen extends StatelessWidget {
  static const String title = "Home Page";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService(),)
      ],
      child: MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Metropolis',
        ),
        home: homePageController(),
        routes: {
          '/startPage': (context) => startPage(),
          '/homePageController': (context) => homePageController(),
          '/homePage': (context) => homePage(),
          '/userManagement': (context) => userManagement(),
          '/userManagementDetails': (context) => userManagementDetails(),
          '/parkingManagement': (context) => parkingManagement(),
          '/parkingManagementDetails': (context) => parkingManagementDetails(),
          '/parkingRecord': (context) => parkingRecord(),
          '/parkingRecordDetails': (context) => parkingRecordDetails()
        },
      ),
    );
  }
}



