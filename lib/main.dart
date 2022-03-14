import 'package:e_wan_admin/GoogleFiles/google_sign_in.dart';
import 'package:e_wan_admin/homePage.dart';
import 'package:e_wan_admin/homePageController.dart';
import 'package:e_wan_admin/parkingLocation.dart';
import 'package:e_wan_admin/parkingSlot.dart';
import 'package:e_wan_admin/parkingSlotDetails.dart';
import 'package:e_wan_admin/parkingType.dart';
import 'package:e_wan_admin/paymentMethodAdd.dart';
import 'package:e_wan_admin/paymentMethodDetails.dart';
import 'package:e_wan_admin/paymentMethod.dart';
import 'package:e_wan_admin/requestDetails.dart';
import 'package:e_wan_admin/startPage.dart';
import 'package:e_wan_admin/transactionDetails.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'transactions.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(homeScreen());
}

class homeScreen extends StatelessWidget {
  static const String title = "Home Page";

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: title,

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Metropolis',
        ),
        home: homePageController(),
        routes: {
          '/parkingLocation': (context) => parkingLocation(),
          '/startPage': (context) => startPage(),
          '/homePageController': (context) => homePageController(),
          '/homePage': (context) => homePage(),
          '/transactionDetails' : (context) => transactionDetails(),
          '/parkingSlot' : (context) => parkingSlot(),
          '/parkingType' : (context) => parkingType(),
          '/requestDetails' : (context) => requestDetails(),
          '/transactions' : (context) => transactions(),
          '/paymentMethod' : (context) => paymentMethod(),
          '/paymentMethodDetails' : (context) => paymentMethodDetails(),
          '/paymentMethodAdd' : (context) => paymentMethodAdd(),
          '/parkingSlotDetails' : (context) => parkingSlotDetails()
        },
      )
  );
}



