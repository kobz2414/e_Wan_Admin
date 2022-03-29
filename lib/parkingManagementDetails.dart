import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class parkingManagementDetails extends StatefulWidget {
  const parkingManagementDetails({Key? key}) : super(key: key);

  @override
  State<parkingManagementDetails> createState() => _parkingManagementDetailsState();
}

class _parkingManagementDetailsState extends State<parkingManagementDetails> {
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
                          stream: db.child("Requests").child("ParkingPlace").child(args["requestID"]).onValue,
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
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Text("PARKING DETAILS", style: TextStyle(
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

                                    //parkingLocLng
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: const [
                                        Text('Parking Location Coordinates', style: TextStyle(
                                            color: Color(0xff5d6974),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12
                                        ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Latitude: " +   dbData["parkingLocLat"].toString(), style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16
                                        ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Longitude: " +   dbData["parkingLocLng"].toString(), style: const TextStyle(
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

                                    // BUTTONS

                                    const SizedBox(height: 30,),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                              onPressed: (){
                                                acceptParkingLocationRequest(dbData["parkingName"], dbData["parkingLocLat"], dbData["parkingLocLng"], dbData["uid"], int.parse(dbData["parkingSlotsNum"]));
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
                                                declineParkingLocationRequest();
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

  void declineParkingLocationRequest(){
    db.child("Requests").child("ParkingPlace").child(args["requestID"]).remove();
  }

  void acceptParkingLocationRequest(String parkingName, double parkingLat, double parkingLong, String uid, int parkingSize){
    db.child("ParkingLocation").child(parkingName).set({
      "ParkingType" : "Free",
      "RentPrice" : "",
      "RentTimeFrom" : "",
      "RentTimeFromFormatted" : "",
      "RentTimeTo" : "",
      "RentTimeToFormatted" : "",
      "markerID" : parkingName.replaceAll(' ', ''),
      "parkingLat" : parkingLat,
      "parkingLong" : parkingLong,
      "parkingName" : parkingName,
    });

    db.child("userData").child(uid).child("ParkingLocation").child(parkingName).set({
      "markerID" : parkingName.replaceAll(' ', ''),
      "parkingLat" : parkingLat,
      "parkingLong" : parkingLong,
      "parkingName" : parkingName,
    });

    for(int x = 1; x <= parkingSize; x++ ){
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

    db.child("Requests").child("ParkingPlace").child(args["requestID"]).remove();
  }
}
