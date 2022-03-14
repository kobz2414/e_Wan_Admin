import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class paymentMethod extends StatefulWidget {
  const paymentMethod({Key? key}) : super(key: key);

  @override
  State<paymentMethod> createState() => _transactionsState();
}

class _transactionsState extends State<paymentMethod> {

  final user = FirebaseAuth.instance.currentUser!;
  final databaseTransactions = FirebaseDatabase.instance.reference();
  var data;
  var dbTransactions;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10), //apply padding to all four sides
                  child: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 15, right: 15), //apply padding to all four sides
                      child: Column(
                        children: [
                          const SizedBox(height: 10,),
                          Column(
                            children: const [
                              Text("PAYMENT METHOD/S", style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 25,
                                color: Colors.black87,
                              ),)
                            ],
                          ),
                          Column(
                            children: const [
                              Text("Tap to edit payment method", style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10
                              ),),
                            ],
                          ),
                          const SizedBox(height: 30,),
                          Column(
                              children: [
                                Container(
                                  //width: MediaQuery.of(context).size.width - 80,
                                  //height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height - 500 : MediaQuery.of(context).size.height - 160,
                                  child: StreamBuilder(
                                      stream: databaseTransactions.child("PaymentMethods").onValue,
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
                                                    return Column(
                                                        children: [
                                                          ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                              primary: Colors.white,
                                                              /*minimumSize: Size(MediaQuery.of(context).size.width-20, 70),*/
                                                            ), onPressed: () {
                                                            Navigator.pushNamed(context, '/paymentMethodDetails', arguments: {
                                                              'paymentMethodName': entryList[index].value["MethodName"],
                                                              'paymentMethodAccountName': entryList[index].value["AccountName"],
                                                              'paymentMethodAccountNumber': entryList[index].value["AccountNumber"],
                                                            });
                                                          },
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 10,),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      entryList[index].value["MethodName"],
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
                                                                      entryList[index].value["AccountName"],
                                                                      style: const TextStyle(
                                                                          color: Color(
                                                                              0xff252626),
                                                                          fontSize: 12
                                                                      ),),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      entryList[index].value["AccountNumber"],
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff252626),
                                                                          fontSize: 12
                                                                      ),),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,)
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,)
                                                        ]
                                                    );
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
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          Navigator.pushNamed(context, '/paymentMethodAdd');
                        },
                        child: const Text("ADD", style: TextStyle(
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
                height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
