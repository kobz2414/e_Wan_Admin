import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class parkingSlot extends StatefulWidget {
  const parkingSlot({Key? key}) : super(key: key);

  @override
  State<parkingSlot> createState() => _parkingSlotState();
}

class _parkingSlotState extends State<parkingSlot> {

  final user = FirebaseAuth.instance.currentUser!;
  final databaseParking = FirebaseDatabase.instance.reference();

  var dbData1;
  var dbData2;
  int availableParkingSpaces = 0;
  int totalParkingSpaces = 0;
  Map args = {};

  @override
  Widget build(BuildContext context) {


    args = ModalRoute.of(context)!.settings.arguments as Map;
    var parkingLocationID = args["parkingLocationID"];

    return Scaffold(
      backgroundColor: Color(0xff262626),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
            child: StreamBuilder(
                stream: databaseParking.child("ParkingLocation").child(parkingLocationID).onValue,
                builder: (context, snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot1.hasError) {
                    return const Text("Something went wrong");
                  }else{
                    dbData1 = (snapshot1.data! as Event).snapshot.value;

                    return StreamBuilder(
                        stream: databaseParking.child("ParkingSlot").child(parkingLocationID).onValue,
                        builder: (context, snapshot2) {
                          if (snapshot2.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot2.hasError) {
                            return const Text("Something went wrong");
                          }else{

                            final DateTime now = DateTime.now();
                            var currDate = DateFormat('MM/dd/yyyy').format(now);
                            var currTime = DateFormat('hh:mm:ss a').format(now.subtract(const Duration( hours: 4)));

                            dbData2 = (snapshot2.data! as Event).snapshot.value;
                            var entryList2 = dbData2.entries.toList();

                            if(dbData2 != null){
                              totalParkingSpaces =  dbData2.length;
                            }

                            int occupied = 0;

                            for(int x = 0; x < totalParkingSpaces; x++ ){
                              if(entryList2[x].value["ArduinoStatus"] != "Vacant" ){
                                occupied += 1;
                              }
                            }

                            availableParkingSpaces = totalParkingSpaces - occupied;

                            //availableParkingSpaces = int.parse(data[args['parkingLocationID']]["ParkingLocationAvailable"].toString());

                            return Stack(
                                children: [
                                  Positioned(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        color: Colors.white,
                                      ),
                                      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                                      height: 130,
                                      child: Padding(
                                          padding: const EdgeInsets.only(top: 15, left: 20, right: 15), //apply padding to all four sides
                                          child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              child:
                                              Column(children: const [
                                                Text("CHOOSE A SPOT", style: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xff252525),
                                                ),),
                                              ],)
                                          )
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      child:
                                      Container(
                                        margin: const EdgeInsets.only(top: 50, left: 35, right: 20),
                                        child:
                                        Column(
                                          children: [
                                            const SizedBox(height: 25,),
                                            Row(
                                              children: const [
                                                Text("PARKING LOCATION", style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color: Color(0xff252525),
                                                ),),
                                              ],
                                            ),
                                            Row(
                                              children:[
                                                Text(parkingLocationID, style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 15,
                                                  color: Color(0xff252525),
                                                ),),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text("LAST UPDATED", style: const TextStyle(
                                                    color: Color(0xff252525),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10
                                                ),)
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(currDate + " " + currTime, style: const TextStyle(
                                                    color: Color(0xff252525),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10
                                                ),)
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                  Positioned(
                                      right: 80,
                                      child:
                                      Container(
                                        margin: const EdgeInsets.only(top: 50, left: 35, right: 5),
                                        child:
                                        Column(
                                          children: [
                                            const SizedBox(height: 25,),
                                            Row(
                                              children: const [
                                                Text("Occupied", style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color: Color(0xff252525),
                                                ),),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                (totalParkingSpaces > 0 && totalParkingSpaces < 20) ?
                                                Text(totalParkingSpaces.toString(), style: const TextStyle(
                                                  color: Color(0xff252525),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: -3,
                                                ),) :
                                                Text(totalParkingSpaces.toString(), style: const TextStyle(
                                                  color: Color(0xff252525),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0,
                                                ),),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                  Positioned(
                                      right: 20,
                                      child:
                                      Container(
                                        margin: const EdgeInsets.only(top: 50, left: 35, right: 10),
                                        child:
                                        Column(
                                          children: [
                                            const SizedBox(height: 25,),
                                            Row(
                                              children: const [
                                                Text("Available", style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color: Color(0xff252525),
                                                ),),
                                              ],
                                            ),
                                            Row(
                                              children:[

                                                (availableParkingSpaces > 0 && availableParkingSpaces < 20) ?
                                                Text(availableParkingSpaces.toString(), style: const TextStyle(
                                                  color: Color(0xff252525),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: -3,
                                                ),) :
                                                Text(availableParkingSpaces.toString(), style: const TextStyle(
                                                  color: Color(0xff252525),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                  letterSpacing: 0,
                                                ),),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                  Positioned(
                                      right: 80,
                                      child:
                                      Container(
                                        margin: const EdgeInsets.only(top: 85, left: 35, right: 5),
                                        child:
                                        Column(
                                          children: [
                                            const SizedBox(height: 25,),
                                            Row(
                                              children: [
                                                Text("PARKING TYPE", style: const TextStyle(
                                                    color: Color(0xff252525),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10
                                                ),)
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(dbData1["ParkingType"], style: const TextStyle(
                                                    color: Color(0xff252525),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10
                                                ),)
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                  ),
                                  // Labels Below
                                  Positioned(
                                    bottom: 20,
                                    left: 20,
                                    child:
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            const SizedBox(height: 3),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xfff6fbff),
                                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                                  ),
                                                  height: 10,
                                                  width: 10,
                                                ),
                                                const SizedBox(width: 3),
                                                const Text("VACANT", style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 8,
                                                    color: Colors.white
                                                ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(width: 12,),
                                        Column(
                                          children: [
                                            const SizedBox(height: 3),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xfff8d73a),
                                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                                  ),
                                                  height: 10,
                                                  width: 10,
                                                ),
                                                const SizedBox(width: 3),
                                                const Text("OCCUPIED", style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 8,
                                                    color: Colors.white
                                                ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(width: 12,),
                                        Column(
                                          children: [
                                            const SizedBox(height: 3),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xffFDB827),
                                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                                  ),
                                                  height: 10,
                                                  width: 10,
                                                ),
                                                const SizedBox(width: 3),
                                                const Text("RESERVED", style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8,
                                                  color: Colors.white,
                                                ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(width: 12,),
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
                                                const Text("NOT AVAILABLE", style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 8,
                                                  color: Colors.white,
                                                ),
                                                )
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),

                                  //Parking Slot Grp
                                  Positioned(
                                      child:
                                      Container(
                                        margin: const EdgeInsets.only(top: 170, left: 20, right: 20, bottom: 40),
                                        child: SingleChildScrollView(
                                            child: Container(
                                              height: MediaQuery.of(context).size.height + 100,
                                              width: MediaQuery.of(context).size.width,
                                              child:  Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  //LABEL ROAD
                                                  Positioned(
                                                    top: 0,
                                                    right: 50,
                                                    child: RotatedBox(
                                                      quarterTurns: 1,
                                                      child: SizedBox(
                                                        child: Text("ROAD", style: TextStyle(
                                                            color: Colors.grey[800],
                                                            fontSize: 50,
                                                            fontWeight: FontWeight.w900,
                                                            letterSpacing: 170
                                                        )),
                                                      ),
                                                    )
                                                  ),
                                                  //PARKING SLOTS 1-10
                                                  Positioned(
                                                    top: 0,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: dbData2["Ateneo de Davao University 1"]["ArduinoStatus"] == "Vacant" ?
                                                          Color(0xfff6fbff) : dbData2["Ateneo de Davao University 1"]["ArduinoStatus"] == "Occupied" ?
                                                          Color(0xfff8d73a) : Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 1',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 30,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: dbData2["Ateneo de Davao University 2"]["ArduinoStatus"] == "Vacant" ?
                                                          Color(0xfff6fbff) : dbData2["Ateneo de Davao University 2"]["ArduinoStatus"] == "Occupied" ?
                                                          Color(0xfff8d73a) : Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/parkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 2',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 60,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 3',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 90,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 4',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 120,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 5',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 150,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: dbData2["Ateneo de Davao University 6"]["ArduinoStatus"] == "Vacant" ?
                                                          Color(0xfff6fbff) : dbData2["Ateneo de Davao University 6"]["ArduinoStatus"] == "Occupied" ?
                                                          Color(0xfff8d73a) : dbData2["Ateneo de Davao University 6"]["ArduinoStatus"] == "Reserved" ?
                                                          Color(0xffFDB827) : Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushReplacementNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 6',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 180,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 7',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 210,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 8',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 240,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 9',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 270,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 10',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  //PARKING SLOTS 11-18
                                                  Positioned(
                                                    top: 330,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 11',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 360,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 12',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 390,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 13',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 420,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 14',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top:450,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 15',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 480,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 16',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 510,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 17',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 540,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 18',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  //PARKING SLOTS 19-26
                                                  Positioned(
                                                    top: 600,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 19',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 630,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 20',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 660,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 21',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 690,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 22',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top:720,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 23',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 750,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 24',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 780,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 25',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 810,
                                                    child: SizedBox(
                                                      width: 40,
                                                      height: 25,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                          primary: const Color(0xff5d6974),
                                                          onPrimary: const Color(0xff5d6974),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(3)
                                                          ),
                                                        ), onPressed: () {
                                                        Navigator.pushNamed(context, '/showParkingSlotDetails', arguments: {
                                                          'parkingSlotID': 'Ateneo de Davao University 26',
                                                          'parkingLocationID': parkingLocationID,
                                                          'parkingType': dbData1["ParkingType"]
                                                        });
                                                      },
                                                        child: Column(
                                                          children: [
                                                            Column(
                                                              children: const [
                                                                Text("", style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 10
                                                                ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                      )
                                  )
                                ]
                            );
                          }
                        }
                    );
                  }
                }
            ),
        ),
      ),
    );
  }
}

