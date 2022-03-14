import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class transactions extends StatefulWidget {
  const transactions({Key? key}) : super(key: key);

  @override
  State<transactions> createState() => _transactionsState();
}

class _transactionsState extends State<transactions> {

  final user = FirebaseAuth.instance.currentUser!;
  final databaseTransactions = FirebaseDatabase.instance.reference();
  var data;
  var dbTransactions;

  Map args = {};

  @override
  Widget build(BuildContext context) {

    args = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(

                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10), //apply padding to all four sides
                  child: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 15, right: 15), //apply padding to all four sides
                      child: Column(
                        children: [
                          const SizedBox(height: 10,),
                          Column(
                            children: const [
                              Text("TRANSACTIONS", style: TextStyle(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                                fontSize: 25,
                                color: Colors.black87,
                              ),)
                            ],
                          ),
                          const SizedBox(height: 30,),
                          Column(
                              children: [
                                Container(
                                  //width: MediaQuery.of(context).size.width - 80,
                                  //height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height - 500 : MediaQuery.of(context).size.height - 160,
                                  child: StreamBuilder(
                                      stream: databaseTransactions.child("Transactions").child(args["parkingLocationID"]).onValue,
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
                                              var entryList = dbTransactions.entries.toList();

                                              return ListView.builder(
                                                  scrollDirection: Axis.vertical,
                                                  shrinkWrap: true,
                                                  itemCount: dbTransactions.length,
                                                  itemBuilder: (context, index) {

                                                    return  entryList[index].value["RequestStatus"] == "Approved" ||  entryList[index].value["RequestStatus"] == "Declined" ? Column(
                                                        children: [
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              primary: Colors.white,
                                                              /*minimumSize: Size(MediaQuery.of(context).size.width-20, 70),*/
                                                            ), onPressed: () {
                                                            Navigator.pushReplacementNamed(context, '/transactionDetails', arguments: {
                                                              'transactionNumber': entryList[index].key,
                                                              'parkingLocationID': args["parkingLocationID"]
                                                            });
                                                          },
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 10,),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      entryList[index]
                                                                          .value["ParkingLocationName"],
                                                                      style: const TextStyle(
                                                                          color: Color(
                                                                              0xff252626),
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize: 18
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      entryList[index]
                                                                          .value["Date"],
                                                                      style: const TextStyle(
                                                                          color: Color(0xff252626),
                                                                          fontSize: 12
                                                                      ),),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      entryList[index]
                                                                          .value["Time"],
                                                                      style: const TextStyle(
                                                                          color: Color(0xff252626),
                                                                          fontSize: 12
                                                                      ),),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,)
                                                              ],
                                                            ),
                                                          ) ,
                                                          const SizedBox(
                                                            height: 10,)
                                                        ]
                                                    ) : const SizedBox();
                                                  });
                                            }else{
                                              return Text("");
                                            }
                                          }
                                        }else{
                                          return Text("");
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
              ),
              const SizedBox(
                height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
