import 'package:e_wan_admin/signIn/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageAdminState();
}

class _homePageAdminState extends State<homePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final databaseParking = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
                children: [
                  //LOGOUT AND ACCOUNT
                  Positioned(
                      top: 20,
                      left: 20,
                      child: Row(
                        children: [
                          Text(user.email!, style:
                          const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Colors.black
                          ),
                          ),
                        ],
                      )
                  ),
                  Positioned(
                    right: 20,
                    child: Container(
                      width: MediaQuery.of(context).size.width-220,
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextButton(
                              onPressed: () async {
                                await authService.signOut();
                              },
                              child:
                              const Text('Logout', style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: Colors.grey
                              ),)
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            child: Image.asset('images/Logo.png'),
                          )
                        ],
                      ),
                    )
                  ),
                  // USER MANAGEMENT
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 240),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xff262626),
                                onPrimary: Colors.white,
                                minimumSize: Size(MediaQuery.of(context).size.width-43, 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)
                                )
                            ),
                            child: const Text('USER MANAGEMENT', style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),),
                            onPressed: (){
                              Navigator.pushNamed(context, '/userManagement');
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  // PARKING MANAGEMENT
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 288),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xff262626),
                                onPrimary: Colors.white,
                                minimumSize: Size(MediaQuery.of(context).size.width-43, 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)
                                )
                            ),
                            child: const Text('PARKING MANAGEMENT', style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),),
                            onPressed: (){
                              Navigator.pushNamed(context, '/parkingManagement',);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  // PARKING RECORDS
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 336),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xff262626),
                                onPrimary: Colors.white,
                                minimumSize: Size(MediaQuery.of(context).size.width-43, 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)
                                )
                            ),
                            child: const Text('PARKING RECORD', style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),),
                            onPressed: (){
                              Navigator.pushNamed(context, '/parkingRecord');
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ]
            )
        ),
      )
    ));
  }
}