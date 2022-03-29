import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class userManagement extends StatefulWidget {
  const userManagement({Key? key}) : super(key: key);

  @override
  State<userManagement> createState() => _userManagementState();
}

class _userManagementState extends State<userManagement> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseDatabase.instance.reference();
  var dbData;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("USERS", style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 30
                              ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      height: 10,
                                      width: 10,
                                    ),
                                    const SizedBox(width: 3),
                                    const Text("UNRESTRICTED", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                        color: Colors.black
                                    ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(width: 10,),
                            Column(
                              children: [
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xff5d6974),
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      height: 10,
                                      width: 10,
                                    ),
                                    const SizedBox(width: 3),
                                    const Text("RESTRICTED", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 8,
                                        color: Colors.black
                                    ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        StreamBuilder(
                          stream: db.child("userData").onValue,
                          builder: (context, snapshot){
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }else if (snapshot.hasError) {
                              return const Text("Something went wrong");
                            }else{
                              dbData = (snapshot.data! as Event).snapshot.value;

                              if(dbData != null){
                                var entryList = dbData.entries.toList();
                                return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: dbData.length,
                                    itemBuilder: (context, index){
                                      return Column(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: entryList[index].value["userRestricted"] == "False" ? Colors.black : Color(0xff5d6974),
                                              onPrimary: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                              minimumSize: Size(MediaQuery.of(context).size.width-40, 70),
                                            ),onPressed: (){
                                            Navigator.pushNamed(context, '/userManagementDetails', arguments: {
                                              'userID': entryList[index].key
                                            });
                                          },
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 15,),
                                                Column(
                                                  children: [
                                                    Text(entryList[index].value["userName"], style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20
                                                    ),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    Text(entryList[index].value["userEmail"], style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12
                                                    ),
                                                    ),
                                                    Text(entryList[index].value["userRole"], style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12
                                                    ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 15,),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                        ],
                                      );
                                    });
                              }else{
                                return SizedBox();
                              }
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
