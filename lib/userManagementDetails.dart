import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class userManagementDetails extends StatefulWidget {
  const userManagementDetails({Key? key}) : super(key: key);

  @override
  State<userManagementDetails> createState() => _userManagementDetailsState();
}

class _userManagementDetailsState extends State<userManagementDetails> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseDatabase.instance.reference();
  var dbData;

  Map args = {};

  @override
  Widget build(BuildContext context) {

    args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: db.child("userData").child(args["userID"]).onValue,
                          builder: (context, snapshot){
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }else if (snapshot.hasError) {
                              return const Text("Something went wrong");
                            }else{
                              dbData = (snapshot.data! as Event).snapshot.value;

                              print(dbData);

                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text("USER DETAILS", style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 30
                                        ),
                                        )
                                      ],
                                    ),
                                  ),

                                  //NAME
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    children: const [
                                      Text('Name', style: TextStyle(
                                          color: Color(0xff5d6974),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(dbData["userName"].toString(), style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16
                                      ),
                                      )
                                    ],
                                  ),

                                  //EMAIL
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: const [
                                      Text('Email', style: TextStyle(
                                          color: Color(0xff5d6974),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(dbData["userEmail"].toString(), style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16
                                      ),
                                      )
                                    ],
                                  ),

                                  //USER TYPE
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: const [
                                      Text('User Type', style: TextStyle(
                                          color: Color(0xff5d6974),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(dbData["userRole"].toString(), style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16
                                      ),
                                      )
                                    ],
                                  ),

                                  //RESTRICTION
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: const [
                                      Text('Restricted', style: TextStyle(
                                          color: Color(0xff5d6974),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12
                                      ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(dbData["userRestricted"].toString(), style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16
                                      ),
                                      )
                                    ],
                                  ),

                                  // BUTTONS

                                  const SizedBox(height: 30,),
                                  dbData["userRestricted"] == "True"  ?
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: (){
                                              db.child("userData").child(args["userID"]).update({
                                                "userRestricted": "False",
                                              });
                                            },
                                            child: const Text("UNRESTRICT", style: TextStyle(
                                                fontWeight: FontWeight.bold
                                            ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                primary: Color(0xff262626),
                                                onPrimary: Colors.white,
                                                minimumSize: Size(MediaQuery.of(context).size.width-150, 40),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30.0)
                                                )

                                            )
                                        )
                                      ],
                                    ),
                                  ): Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: (){
                                              db.child("userData").child(args["userID"]).update({
                                                "userRestricted": "True",
                                              });
                                            },
                                            child: const Text("RESTRICT", style: TextStyle(
                                                fontWeight: FontWeight.bold
                                            ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                primary: Color(0xff262626),
                                                onPrimary: Colors.white,
                                                minimumSize: Size(MediaQuery.of(context).size.width-150, 40),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30.0)
                                                )
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                            child: const Text("CANCEL", style: TextStyle(
                                                fontWeight: FontWeight.bold
                                            ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                primary: Color(0xff262626),
                                                onPrimary: Colors.white,
                                                minimumSize: Size(MediaQuery.of(context).size.width-150, 40),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30.0)
                                                )
                                            )
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }
                          },
                        )
                      ],
                    ),
                  )
              ),
            )
        ));
  }

}
