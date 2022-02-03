import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snstennis/account/log_in_splash.dart';
import 'package:snstennis/account/user_check.dart';

class App extends StatelessWidget {
  const App({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.hasError) {
          return Center(
            child: Text('Firebase connect Error!'),
          );
        }
        if(snapshot.connectionState == ConnectionState.done) {
          //return LogInWithSplash();
          return UserCheck();
        }
        return CircularProgressIndicator();
      }
    );
  }
}