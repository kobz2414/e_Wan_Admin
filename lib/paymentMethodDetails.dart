import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class paymentMethodDetails extends StatefulWidget {
  const paymentMethodDetails({Key? key}) : super(key: key);

  @override
  State<paymentMethodDetails> createState() => _paymentMethodDetailsState();
}

class _paymentMethodDetailsState extends State<paymentMethodDetails> {
  TextEditingController paymentAccountName = TextEditingController();
  TextEditingController paymentAccountNumber = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;
  final database = FirebaseDatabase.instance.reference();

  Map args = {};

  @override
  Widget build(BuildContext context) {
    args = ModalRoute
        .of(context)!
        .settings
        .arguments as Map;

    return Scaffold(
      backgroundColor: Color(0xfff6fbff),
      body: SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 15,left: 20, right: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Column(
                      children: [
                        Text(args["paymentMethodName"], style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                          color: Colors.black87,
                        ),)
                      ],
                    ),
                    const SizedBox(height: 30,),
                    TextField(
                      controller: paymentAccountName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Account Name',
                        hintText: args["paymentMethodAccountName"],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: paymentAccountNumber,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Account Number',
                        hintText: args["paymentMethodAccountNumber"],
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    const SizedBox(
                      height: 30,
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
                                fontWeight: FontWeight.bold,
                                fontSize: 12
                            ),),
                            onPressed: (){
                              if(paymentAccountNumber.text == "" && paymentAccountName.text != ""){
                                savePaymentMethodDetails(args["paymentMethodName"], paymentAccountName.text, args["paymentMethodAccountNumber"]);
                                Navigator.pop(context);
                              }else if (paymentAccountName.text == "" && paymentAccountNumber.text != ""){
                                savePaymentMethodDetails(args["paymentMethodName"], args["paymentMethodAccountName"], paymentAccountNumber.text);
                                Navigator.pop(context);
                              }else if (paymentAccountName.text != "" && paymentAccountNumber.text != ""){
                                savePaymentMethodDetails(args["paymentMethodName"], paymentAccountName.text, paymentAccountNumber.text);
                                Navigator.pop(context);
                              } else if (paymentAccountName.text == "" && paymentAccountNumber.text == ""){
                                Navigator.pop(context);
                              }
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
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                                minimumSize: Size(MediaQuery.of(context).size.width-150, 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)
                                )
                            ),
                            child: const Text('DELETE', style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),),
                            onPressed: (){
                              deletePaymentMethod(args["paymentMethodName"]);
                              Navigator.pop(context);
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
                    ),
                  ],
                )
              ),
            )
        ),
      ),
    );
  }

  void deletePaymentMethod(String paymentMethodName) {
    database.child("PaymentMethods").child(paymentMethodName).remove();
  }

  void savePaymentMethodDetails(String paymentMethodName, String accountName, String accountNumber) {
    database.child("PaymentMethods").child(paymentMethodName).update({
      "AccountName" : accountName,
      "AccountNumber" : accountNumber,
    });
  }
}
