import 'package:e_wan_admin/homePage.dart';
import 'package:e_wan_admin/signIn.dart';
import 'package:e_wan_admin/signIn/AuthService.dart';
import 'package:e_wan_admin/signIn/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class homePageController extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot){
        if (snapshot.connectionState == ConnectionState.active){
          final User? user = snapshot.data;
          return user == null ? signIn() : homePage();
        }else{
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  /*=> Scaffold(
    body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }else if (snapshot.hasData){
          return startPage();
        }else if (snapshot.hasError){
          return Center(child: Text('Something went wrong!'));
        }else{
          return signIn();
        }
      },
    ),
  )*/
}
