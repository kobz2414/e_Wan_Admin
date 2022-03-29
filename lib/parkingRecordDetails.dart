import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class parkingRecordDetails extends StatefulWidget {
  const parkingRecordDetails({Key? key}) : super(key: key);

  @override
  State<parkingRecordDetails> createState() => _parkingRecordDetailsState();
}

class _parkingRecordDetailsState extends State<parkingRecordDetails> {
  final user = FirebaseAuth.instance.currentUser!;
  final db = FirebaseDatabase.instance.reference();
  var dbData;
  var dbData2;
  int totalParkingSpaces = 0;

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
                          stream: db.child("Requests").child("AdditionalSlots").child(args["requestID"]).onValue,
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

                              if(dbData != null){
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text("SLOT REQ. DETAILS", style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 30
                                          ),
                                          )
                                        ],
                                      ),
                                    ),

                                    //parkingName
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
                                        Text(dbData["parkingName"].toString(), style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16
                                        ),
                                        )
                                      ],
                                    ),

                                    //parkingSlotsNum
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: const [
                                        Text('# of Parking Slots', style: TextStyle(
                                            color: Color(0xff5d6974),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12
                                        ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(dbData["parkingSlotsNum"].toString(), style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16
                                        ),
                                        )
                                      ],
                                    ),

                                    //requestedBy
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: const [
                                        Text('Requested By', style: TextStyle(
                                            color: Color(0xff5d6974),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12
                                        ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(dbData["requestedBy"].toString(), style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16
                                        ),
                                        )
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: const [
                                        Text('Requested By (Email)', style: TextStyle(
                                            color: Color(0xff5d6974),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12
                                        ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(dbData["requestedByEmail"].toString(), style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16
                                        ),
                                        )
                                      ],
                                    ),

                                    StreamBuilder(
                                      stream: db.child("ParkingSlot").child(dbData["parkingName"]).onValue,
                                      builder: (context, snapshot){
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return const Text("Something went wrong");
                                        }else{

                                          dbData2 = (snapshot.data! as Event).snapshot.value;

                                          if(dbData2 != null){
                                            totalParkingSpaces =  dbData2.length;
                                          }

                                          return SizedBox();
                                          }
                                      },
                                    ),

                                    // BUTTONS

                                    const SizedBox(height: 30,),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                              onPressed: (){
                                                acceptParkingSlotRequest(dbData["parkingName"], dbData["parkingLocLat"], dbData["parkingLocLng"], int.parse(dbData["parkingSlotsNum"]));
                                                Navigator.pop(context);
                                              },
                                              child: const Text("APPROVE", style: TextStyle(
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
                                                declineParkingSlotRequest();
                                                Navigator.pop(context);
                                              },
                                              child: const Text("DECLINE", style: TextStyle(
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

  void declineParkingSlotRequest(){
    db.child("Requests").child("AdditionalSlots").child(args["requestID"]).remove();
  }

  void acceptParkingSlotRequest(String parkingName, double parkingLat, double parkingLong , int parkingSize){

    int x = totalParkingSpaces;

    for(x; x <= totalParkingSpaces + parkingSize; x++ ){
      db.child("ParkingSlot").child(parkingName).child(parkingName + " " + x.toString()).set({
        "ArduinoLastUpdateDate" : "",
        "ArduinoLastUpdateDateAndTime" : "",
        "ArduinoLastUpdateTime" : "",
        "ArduinoStatus" : "Not Available",

        "ParkingAvailability" : "Unavailable",
        "ParkingSlotLocationLat" : parkingLat,
        "ParkingSlotLocationLong" : parkingLong,
        "ReservationTransactionID" : "",

        "ReservationUserID" : "",
        "Reserved" : "False",
        "ReservedFrom" : "",
        "ReservedTo" : "",
      });
    }

    db.child("Requests").child("AdditionalSlots").child(args["requestID"]).remove();
  }
}
