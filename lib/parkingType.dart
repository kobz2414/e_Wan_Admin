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

  final List<String> parkingTypes = [
    'Paid',
    'Free',
  ];

  TextEditingController price = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.reference();
  var data;
  var dbParkingType;
  bool enable = true;
  String parkingType = "", rentTimeFrom = "", rentTimeFromFormatted = "", rentTimeTo = "", rentTimeToFormatted = "", rentPrice = "", activeParkingType = "";
  // Initial Selected Value
  String dropdownvalue = 'Select Parking Type';

  // List of items in our dropdown menu
  var items = [
    'Paid',
    'Free',
  ];


  Map args = {};

  @override
  Widget build(BuildContext context) {

    args = ModalRoute.of(context)!.settings.arguments as Map;

/*    database.child("ParkingLocation").child("Ateneo de Davao University").child("ParkingType").once().then((DataSnapshot dataSnapshot){
      setState(() {
        activeParkingType = dataSnapshot.value.toString();
      });
      print(activeParkingType);
    });*/

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
                              Text('Current Parking Type', style: TextStyle(
                                  color: Color(0xff5d6974),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: [
                              Text(data["ParkingType"], style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: const [
                              Text('Current Parking Price', style: TextStyle(
                                  color: Color(0xff5d6974),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: [
                              Text(data["RentPrice"], style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: const [
                              Text('Current Rent Time Duration', style: TextStyle(
                                  color: Color(0xff5d6974),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: [
                              Text(data["RentTimeFrom"], style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Column(
                            children: [
                              Text(data["RentTimeTo"], style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 30,
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
                            hint: Text(activeParkingType,
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
                            items: parkingTypes
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
                              setState(() {
                                if(value == "Paid"){
                                  activeParkingType = "Paid";
                                  enable = true;
                                }else{
                                  activeParkingType = "Free";
                                  enable = false;
                                }
                              });

                              parkingType = value.toString();
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            enabled: enable ? true : false,
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
                              rentPrice = price;
                            },
                          ),
                          const SizedBox(
                            height: 30,
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
                          Column(
                            children: [
                              ElevatedButton(
                                  onPressed: !enable ? null : (){
                                    DatePicker.showDateTimePicker(context, showTitleActions: true,
                                        onConfirm: (date) {
                                          setState(() {
                                            rentTimeFrom = DateFormat("EEE, MMM d - h:mm a").format(date);
                                            rentTimeFromFormatted = date.toString();
                                          });
                                        },
                                        currentTime: DateTime.now());
                                  },
                                  child: Text(rentTimeFrom, style: const TextStyle(
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
                                  onPressed: !enable ? null : (){
                                    DatePicker.showDateTimePicker(context, showTitleActions: true,
                                        onConfirm: (date) {
                                          setState(() {
                                            rentTimeTo = DateFormat("EEE, MMM d - h:mm a").format(date);
                                            rentTimeToFormatted = date.toString();
                                          });
                                        },
                                        currentTime: DateTime.now());
                                  },
                                  child: Text(rentTimeTo, style: const TextStyle(
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

                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    onPressed:  (){
                                      if(data["ParkingType"] == "Free"){
                                        if(activeParkingType == ""){
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false, // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Incomplete Details'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: const <Widget>[
                                                      Text('Please select a Parking Type'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Close'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }else if(activeParkingType == "Paid"  && (rentTimeTo == "" || rentTimeFrom == "" || price == "")){
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false, // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Incomplete Details'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: const <Widget>[
                                                      Text('Please input all fields'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Close'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }else{
                                          database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                            "RentTimeFrom": rentTimeFrom,
                                            "RentTimeFromFormatted" : rentTimeFromFormatted,
                                          });

                                          database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                            "RentTimeTo": rentTimeTo,
                                            "RentTimeToFormatted" : rentTimeToFormatted,
                                          });

                                          database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                            "RentPrice": rentPrice,
                                          });

                                          database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                            "ParkingType": parkingType,
                                          });

                                          Navigator.pop(context);
                                        }
                                      }else if (data["ParkingType"] == "Paid"){
                                        if(activeParkingType == ""){
                                          showDialog<void>(
                                            context: context,
                                            barrierDismissible: false, // user must tap button!
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Incomplete Details'),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: const <Widget>[
                                                      Text('Please select a Parking Type'),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('Close'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }else if (activeParkingType == "Free"){
                                          database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                            "RentTimeFrom": "",
                                            "RentTimeFromFormatted" : "",
                                          });

                                          database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                            "RentTimeTo": "",
                                            "RentTimeToFormatted" : "",
                                          });

                                          database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                            "RentPrice": "",
                                          });

                                          database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                            "ParkingType": parkingType,
                                          });

                                          Navigator.pop(context);
                                        }else{

                                          if(price.text != ""){
                                            database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                              "RentPrice": rentPrice,
                                            });
                                          }

                                          if(rentTimeTo != ""){
                                            database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                              "RentTimeTo": rentTimeTo,
                                              "RentTimeToFormatted" : rentTimeToFormatted,
                                            });
                                          }

                                          if(rentTimeFrom != ""){
                                            database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                              "RentTimeFrom": rentTimeFrom,
                                              "RentTimeFromFormatted" : rentTimeFromFormatted,
                                            });
                                          }

                                          database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                            "ParkingType": parkingType,
                                          });

                                          Navigator.pop(context);
                                        }
                                      }


                                      /*if(activeParkingType == "Paid" && ((rentTimeTo == "" || rentTimeFrom == "" || price == "") || (data["RentPrice"] == "" || data["RentTimeTo"] == "" || data["RentTimeFrom"] == ""))){
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: false, // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Incomplete Details'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: const <Widget>[
                                                    Text('Please input all fields'),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Close'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }else{
                                        database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                          "RentTimeFrom": rentTimeFrom,
                                          "RentTimeFromFormatted" : rentTimeFromFormatted,
                                        });

                                        database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                          "RentTimeTo": rentTimeTo,
                                          "RentTimeToFormatted" : rentTimeFromFormatted,
                                        });

                                        database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                          "RentPrice": rentPrice,
                                        });

                                        database.child("ParkingLocation").child("Ateneo de Davao University").update({
                                          "ParkingType": parkingType,
                                        });

                                        Navigator.pop(context);
                                      }*/
                                    },
                                    child: const Text("SAVE", style: TextStyle(
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
                          ),
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
