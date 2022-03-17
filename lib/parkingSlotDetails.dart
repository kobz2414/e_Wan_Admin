import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class parkingSlotDetails extends StatefulWidget {
  const parkingSlotDetails({Key? key}) : super(key: key);

  @override
  _showParkingSlotDetailsState createState() => _showParkingSlotDetailsState();
}

class _showParkingSlotDetailsState extends State<parkingSlotDetails> {
  final user = FirebaseAuth.instance.currentUser!;
  final databaseParking = FirebaseDatabase.instance.reference();
  var dbData;

  Map args = {};

  @override
  Widget build(BuildContext context) {

    args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
        backgroundColor: Color(0xff262626),
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox(height: 800,),
                  Container(
                      padding: const EdgeInsets.only(
                          top: 50,
                          bottom: 16,
                          left: 16,
                          right: 16
                      ),
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10.0,
                                offset: Offset(0.0, 10.0)
                            )
                          ]
                      ),
                      child: StreamBuilder(
                          stream: databaseParking.child("ParkingSlot").child(args["parkingLocationID"]).child(args["parkingSlotID"]).onValue,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return const Text("Something went wrong");
                            }else{

                              dbData = (snapshot.data! as Event).snapshot.value;

                              print(dbData);

                              return  Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(args["parkingLocationID"],
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xff5d6974)
                                    ),
                                  ),
                                  const SizedBox(height: 1,),
                                  Text(args["parkingSlotID"], style: const
                                  TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  ),
                                  const SizedBox(height: 20,),
                                  const Text("Status", style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xff5d6974)
                                  ),
                                  ),
                                  const SizedBox(height: 1,),
                                  Text(dbData["ArduinoStatus"], style: const
                                  TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  ),
                                  const SizedBox(height: 20,),
                                  const Text("Marked as", style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xff5d6974)
                                  ),
                                  ),
                                  const SizedBox(height: 1,),
                                  Text(dbData["ParkingAvailability"], style: const
                                  TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Text("LAST UPDATED: " + dbData["ArduinoLastUpdateDateAndTime"].toUpperCase(), style: const
                                  TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xff5d6974)
                                  ),
                                  ),
                                  const SizedBox(height: 30,),
                                  dbData["ParkingAvailability"] == "Available"  ?
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: dbData["ParkingAvailability"] == "Available" && (dbData["ArduinoStatus"] == "Occupied" || dbData["ArduinoStatus"] == "Reserved") ? null : (){
                                              databaseParking.child("ParkingSlot").child(args["parkingLocationID"]).child(args["parkingSlotID"]).update({
                                                "ParkingAvailability": "Unavailable",
                                              });
                                            },
                                            child: const Text("MARK AS UNAVAILABLE", style: TextStyle(
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
                                              databaseParking.child("ParkingSlot").child(args["parkingLocationID"]).child(args["parkingSlotID"]).update({
                                                "ParkingAvailability": "Available",
                                              });
                                            },
                                            child: const Text("MARK AS AVAILABLE", style: TextStyle(
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
                                              Navigator.pushReplacementNamed(context, '/parkingSlot', arguments: {
                                                'parkingLocationID': args["parkingLocationID"]
                                              });
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
                          }
                      )
                  ),
                ],
              ),
            )
        )
    );



    /*Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox(height: 800,),
        Container(
          padding: const EdgeInsets.only(
              top: 50,
              bottom: 16,
              left: 16,
              right: 16
          ),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(40),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0)
                )
              ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("SM ECOLAND",
                style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff5d6974)
                ),
              ),
              const SizedBox(height: 1,),
              Text("SME-001", style: const
              TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
              ),
              ),
              const SizedBox(height: 20,),
              Text("STATUS", style: const
              TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff5d6974)
              ),
              ),
              const SizedBox(height: 1,),
              Text("VACANT", style: const
              TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
              ),
              ),
              const SizedBox(height: 1,),
              Text("LAST UPDATED: AUGUST 5, 2020 5:30 PM", style: const
              TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff5d6974)
              ),
              ),
              const SizedBox(
                height: 15,
                width: 1080,
              ),
            ],
          ),
        ),
      ],
    )*/
  }
}