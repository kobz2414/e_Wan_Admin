import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class paymentMethodAdd extends StatefulWidget {
  const paymentMethodAdd({Key? key}) : super(key: key);

  @override
  State<paymentMethodAdd> createState() => _paymentMethodAddState();
}

class _paymentMethodAddState extends State<paymentMethodAdd> {
  TextEditingController paymentMethodName = TextEditingController();
  TextEditingController paymentMethodAccountNumber = TextEditingController();
  TextEditingController paymentMethodAccountName = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;
  final databaseParking = FirebaseDatabase.instance.reference();
  var dbData;
  var parkingDetailsData;
  String parkingPrice = "", rentDuration = "", rentFrom = "", rentTo = "";

  Map args = {};

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    paymentMethodName.dispose();
    paymentMethodAccountNumber.dispose();
    paymentMethodAccountName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child:
              Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Row(
                      children: const [
                        Text("PAYMENT METHOD DETAILS", style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 23
                        ),),
                      ],
                    ),
                  ),
                  Row(
                    children: const [
                      Text("Please input the details below", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 10
                      ),),
                    ],
                  ),

                  // NAME
                  const SizedBox(
                    height: 40,
                  ),

                  TextField(
                    controller: paymentMethodName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Payment Method',
                      hintText: 'Enter Payment Method',
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: paymentMethodAccountName,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Account Name',
                      hintText: 'Enter Account Name',
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: paymentMethodAccountNumber,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Account Number',
                      hintText: 'Enter Account Number',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: (){
                              if(paymentMethodName.text == "" ||  paymentMethodAccountName.text == "" || paymentMethodAccountNumber.text == "" ){
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
                              }else {
                                addPaymentMethod(paymentMethodName.text,
                                    paymentMethodAccountName.text,
                                    paymentMethodAccountNumber.text);
                                Navigator.pop(context);
                              }
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
              ),
            ),
          ),
        ),
      ),
    );
  }


  void addPaymentMethod(String methodName, String methodAccountName, String methodAccountNumber) {
    databaseParking.child("PaymentMethods").child(methodName).set({
      "AccountName": methodAccountName,
      "AccountNumber": methodAccountNumber,
      "MethodName": methodName,
    });
  }
}
