import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class parkingType extends StatefulWidget {
  const parkingType({Key? key}) : super(key: key);

  @override
  State<parkingType> createState() => _parkingTypeState();
}

class _parkingTypeState extends State<parkingType> {

  final List<String> parkingType = [
    'Paid',
    'Free',
  ];

  TextEditingController price = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.reference();
  var data;
  var dbParkingType;

  Map args = {};

  @override
  Widget build(BuildContext context) {

    args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: StreamBuilder(
                  stream: database.child("ParkingLocation").child("Ateneo de Davao University").onValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }else {

                      data = (snapshot.data! as Event).snapshot.value;

                      return Column(
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("PARKING TYPE", style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 30
                                ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Column(
                            children: const [
                              Text('Rent Time Start', style: TextStyle(
                                  color: Color(0xff5d6974),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),
                              )
                            ],
                          ),
                          /*const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(data["Email"].toString(), style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16
                            ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),*/
                          Column(
                            children: [
                              ElevatedButton(
                                  onPressed: data["ParkingType"] == "Free" ? null : (){
                                    DatePicker.showDateTimePicker(context, showTitleActions: true,
                                        onConfirm: (date) {
                                          database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                            "RentTimeFrom": DateFormat("EEE, MMM d - h:mm a").format(date),
                                            "RentTimeFromFormatted" : date.toString(),
                                          });
                                        },
                                        currentTime: DateTime.now());
                                  },
                                  child: Text(data["RentTimeFrom"], style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12
                                  ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                    minimumSize: Size(MediaQuery.of(context).size.width-200, 30),

                                  )
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: const [
                              Text('Rent Time End', style: TextStyle(
                                  color: Color(0xff5d6974),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                  onPressed: data["ParkingType"] == "Free" ? null : (){
                                    DatePicker.showDateTimePicker(context, showTitleActions: true,
                                        onConfirm: (date) {
                                          database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                            "RentTimeTo": DateFormat("EEE, MMM d - h:mm a").format(date),
                                            "RentTimeToFormatted" : date.toString(),
                                          });
                                        },
                                        currentTime: DateTime.now());
                                  },
                                  child: Text(data["RentTimeTo"], style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12
                                  ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                    minimumSize: Size(MediaQuery.of(context).size.width-250, 30),

                                  )
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            enabled: data["ParkingType"] == "Free" ? false : true,
                            controller: price,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: 'Parking Price*',
                              hintText: data["RentPrice"],
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (price){
                              database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                "RentPrice": price,
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          DropdownButtonFormField2(
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            isExpanded: true,
                            hint: Text(data["ParkingType"],
                              style: TextStyle(fontSize: 14),
                            ),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 20,
                            buttonHeight: 50,
                            buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            items: parkingType
                                .map((item) =>
                                DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                                .toList(),
                            onChanged: (value) {
                              database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                "ParkingType": value,
                              });
                            },
                          ),
                          const SizedBox(height: 30),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                    child: const Text("BACK", style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        onPrimary: Colors.black,
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
              ),

            ),
          ),
      ),
    );
  }
}
