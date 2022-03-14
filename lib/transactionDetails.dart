import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class transactionDetails extends StatefulWidget {
  const transactionDetails({Key? key}) : super(key: key);

  @override
  _transactionDetailsState createState() => _transactionDetailsState();
}

class _transactionDetailsState extends State<transactionDetails> {
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
                                  Text("TRANSACTION DETAILS", style: TextStyle(
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

                            //DATE
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

                            //REQUEST STATUS
                            const SizedBox(
                              height: 10,
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
                            Row(
                              children: [
                                Text(data["RequestStatus"].toString(), style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16
                                ),
                                )
                              ],
                            ),

                            //PAYMENT DETAILS
                            const SizedBox(
                              height: 30,
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

                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: (){
                                        Navigator.pushReplacementNamed(context, '/transactions', arguments: {
                                          'parkingLocationID': args["parkingLocationID"]
                                        });
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
