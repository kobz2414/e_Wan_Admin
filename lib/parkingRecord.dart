import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class parkingRecord extends StatefulWidget {
  const parkingRecord({Key? key}) : super(key: key);

  @override
  State<parkingRecord> createState() => _parkingRecordState();
}

class _parkingRecordState extends State<parkingRecord> {
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
                              Text("PARKING SLOT REQ.", style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 30
                              ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                        StreamBuilder(
                          stream: db.child("Requests").child("AdditionalSlots").onValue,
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
                                              primary: Colors.black,
                                              onPrimary: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20)
                                              ),
                                              minimumSize: Size(MediaQuery.of(context).size.width-40, 70),
                                            ),onPressed: (){
                                            Navigator.pushNamed(context, '/parkingRecordDetails', arguments: {
                                              'requestID': entryList[index].key
                                            });
                                          },
                                            child: Column(
                                              children: [
                                                const SizedBox(height: 15,),
                                                Column(
                                                  children: [
                                                    Text(entryList[index].value["parkingName"], style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20
                                                    ),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    Text("Requested by " + entryList[index].value["requestedBy"], style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12
                                                    ),
                                                    ),
                                                    const SizedBox(height: 5,),
                                                    Text("Slots: " + entryList[index].value["parkingSlotsNum"], style: const TextStyle(
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