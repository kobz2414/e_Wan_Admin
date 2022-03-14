import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class requestDetails extends StatefulWidget {
  const requestDetails({Key? key}) : super(key: key);

  @override
  State<requestDetails> createState() => _requestDetailsState();
}

class _requestDetailsState extends State<requestDetails> {

  final List<String> requestStatus = [
    'Pending',
    'Approved',
    'Declined',
  ];

  String requestCurrentStatus = "";

  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.reference();
  var data;
  var dbTransactions;

  Map args = {};

  @override
  Widget build(BuildContext context) {

    args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      backgroundColor: Color(0xfff6fbff),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: StreamBuilder(
                    stream: database.child("Transactions").child(args["parkingLocationID"]).child(args["transactionNumber"]).onValue,
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
                                  Text("REQUEST DETAILS", style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20
                                  ),
                                  )
                                ],
                              ),
                            ),

                            //TRANSACTION ID
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              children: const [
                                Text('TRANSACTION ID', style: TextStyle(
                                    color: Color(0xff5d6974),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(args["transactionNumber"].toString(), style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                                )
                              ],
                            ),

                            //NAME
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text('NAME', style: TextStyle(
                                    color: Color(0xff5d6974),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(data["Name"].toString(), style: const TextStyle(
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
                                Text('EMAIL', style: TextStyle(
                                    color: Color(0xff5d6974),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                                )
                              ],
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

                            //MOBILE
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text('Mobile Number', style: TextStyle(
                                    color: Color(0xff5d6974),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(data["MobileNumber"].toString(), style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                                )
                              ],
                            ),

                            //PARKING LOCATION
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text('Parking Location', style: TextStyle(
                                    color: Color(0xff5d6974),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(data["ParkingLocationName"].toString(), style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                                )
                              ],
                            ),

                            //PARKING SLOT
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text('Parking Slot', style: TextStyle(
                                    color: Color(0xff5d6974),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(data["ParkingSlotID"].toString(), style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                                )
                              ],
                            ),

                            //PLATE NUMBER
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text('Plate Number', style: TextStyle(
                                    color: Color(0xff5d6974),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(data["PlateNumber"].toString(), style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                                )
                              ],
                            ),

                            //Reservation Date
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text('Reservation Date', style: TextStyle(
                                    color: Color(0xff5d6974),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(data["RentDuration"].toString(), style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14
                                ),
                                )
                              ],
                            ),

                            //Total Due
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: const [
                                Text('Total Due', style: TextStyle(
                                    color: Color(0xff5d6974),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(data["TotalCost"].toString(), style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                                )
                              ],
                            ),

                            //PAYMENT DETAILS
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: Color(0xff5d6974),
                              ),
                              height: 260,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 15, left: 20, right: 15), //apply padding to all four sides
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: const [
                                          Text("PAYMENT DETAILS", style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),)
                                        ],
                                      ),
                                      Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width - 80,
                                              //height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height - 500 : MediaQuery.of(context).size.height - 160,
                                              child: StreamBuilder(
                                                  stream: database.child("PaymentDetails").child(args["transactionNumber"]).onValue,
                                                  builder: (context, snapshot) {
                                                    if(snapshot.hasData){
                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                        return const Center(
                                                          child: CircularProgressIndicator(),
                                                        );
                                                      } else if (snapshot.hasError) {
                                                        return const Text("Something went wrong");
                                                      }else{
                                                        dbTransactions = (snapshot.data! as Event).snapshot.value;

                                                        if(dbTransactions != null){

                                                          print(dbTransactions);

                                                          return Column(
                                                            children: [
                                                              const SizedBox(height: 18,),
                                                              Row(
                                                                children: const [
                                                                  Text("Payment Method", style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 12
                                                                  ),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(dbTransactions["PaymentMethod"], style: const TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 16
                                                                  ),
                                                                  )
                                                                ],
                                                              ),

                                                              const SizedBox(height: 18,),
                                                              Row(
                                                                children: const [
                                                                  Text("Reference Number", style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 12
                                                                  ),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(dbTransactions["ReferenceNumber"], style: const TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 16
                                                                  ),
                                                                  )
                                                                ],
                                                              ),

                                                              const SizedBox(height: 18,),
                                                              Row(
                                                                children: const [
                                                                  Text("Sender\s Name", style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 12
                                                                  ),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(dbTransactions["Name"], style: const TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 16
                                                                  ),
                                                                  )
                                                                ],
                                                              ),

                                                              const SizedBox(height: 18,),
                                                              Row(
                                                                children: const [
                                                                  Text("Amount Paid", style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 12
                                                                  ),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(dbTransactions["Amount"], style: const TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 16
                                                                  ),
                                                                  )
                                                                ],
                                                              ),

                                                              const SizedBox(height: 18,),

                                                            ],
                                                          );
                                                        }else{
                                                          return Column(
                                                            children: [
                                                              const SizedBox(height: 18,),
                                                              Row(
                                                                children: const [
                                                                  Text("Payment Method", style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 12
                                                                  ),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: const [
                                                                  Text("-", style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 16
                                                                  ),
                                                                  )
                                                                ],
                                                              ),

                                                              const SizedBox(height: 18,),
                                                              Row(
                                                                children: const [
                                                                  Text("Reference Number", style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 12
                                                                  ),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: const [
                                                                  Text("-", style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 16
                                                                  ),
                                                                  )
                                                                ],
                                                              ),

                                                              const SizedBox(height: 18,),
                                                              Row(
                                                                children: const [
                                                                  Text("Sender\s Name", style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 12
                                                                  ),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: const [
                                                                  Text("-", style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 16
                                                                  ),
                                                                  )
                                                                ],
                                                              ),

                                                              const SizedBox(height: 18,),
                                                              Row(
                                                                children: const [
                                                                  Text("Amount Paid", style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 12
                                                                  ),
                                                                  )
                                                                ],
                                                              ),
                                                              Row(
                                                                children: const [
                                                                  Text("-", style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 16
                                                                  ),
                                                                  )
                                                                ],
                                                              ),

                                                              const SizedBox(height: 18,),

                                                            ],
                                                          );
                                                        }
                                                      }
                                                    }else{
                                                      return const Text("");
                                                    }
                                                  }
                                              ),
                                            )
                                          ]
                                      )
                                    ],
                                  )
                              ),
                            ),


                            //REQUEST STATUS
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: const [
                                Text('Request Status', style: TextStyle(
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
                            DropdownButtonFormField2(
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              isExpanded: true,
                              hint: Text(data["RequestStatus"],
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
                              items: requestStatus
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
                              onChanged: (value){
                                requestCurrentStatus = value.toString();
                              },
                            ),

                            const SizedBox(
                              height: 50,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        onPrimary: Colors.black,
                                        minimumSize: Size(MediaQuery.of(context).size.width-150, 40),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0)
                                        )
                                    ),
                                    child: const Text('SAVE', style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),),
                                    onPressed: (){
                                      if(requestCurrentStatus == "Declined"){
                                        database.child("Transactions").child(args["parkingLocationID"]).child(args["transactionNumber"]).update({
                                          "TransactionStatus": "Past",
                                        });

                                        database.child("UserData").child(data["userID"].toString()).child("Transactions").child(args["transactionNumber"]).update({
                                          "TransactionStatus": "Past",
                                        });
                                      }else{
                                        database.child("Transactions").child(args["parkingLocationID"]).child(args["transactionNumber"]).update({
                                          "RequestStatus": requestCurrentStatus,
                                        });

                                        database.child("UserData").child(data["userID"].toString()).child("Transactions").child(args["transactionNumber"]).update({
                                          "RequestStatus": requestCurrentStatus,
                                        });

                                        database.child("ParkingSlot").child(data["ParkingLocationName"].toString()).child(data["ParkingSlotID"].toString()).update({
                                          "Reserved": "True",
                                          "ReservedFrom": data["RentTimeFromFormatted"],
                                          "ReservedTo": data["RentTimeToFormatted"],
                                          "ReservationTransactionID": args["transactionNumber"],
                                          "ReservationUserID": user.uid
                                        });

                                        /*database.child("UserData").child(data["userID"].toString()).child("Transactions").child(args["transactionNumber"]).get({
                                          "RequestStatus": requestCurrentStatus,
                                        });*/
                                      }

                                      Navigator.pushReplacementNamed(context, '/homePage', arguments: {
                                        'parkingLocationID': args["parkingLocationID"]
                                      });
                                    },
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
                                        Navigator.pushReplacementNamed(context, '/homePage', arguments: {
                                          'parkingLocationID': args["parkingLocationID"]
                                        });
                                      },
                                      child: const Text("CANCEL", style: TextStyle(
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
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      }
                    }
                ),
              ),
            )
        ),
      ),
    );
  }
}
