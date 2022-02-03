import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserAccountInfo>(
          create: (BuildContext context) => UserAccountInfo()
        )
      ],
      child: MaterialApp(
        title: 'Kammon',
        theme: ThemeData(
          primaryColor: Color(0xffe83a4f),
          primaryColorLight: Color(0xfffde6e6),
          textTheme: TextTheme(
            headline1: TextStyle(fontFamily: 'GSANSB', fontSize: 24, color: Color(0xffe83a4f)),
            headline2: TextStyle(fontFamily: 'GSANSB', fontSize: 16, color: Color(0xff58585b)),
          )
        ),
        // home: Scaffold(
        //   body: WillPopScope(
        //     onWillPop: () {
        //       DateTime now = DateTime.now();
        //       if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        //         currentBackPressTime = now;
        //         //Fluttertoast.showToast(msg: 'exit_warning');
        //         return Future.value(false);
        //       }
        //       return Future.value(true);
        //     },
        //     child: App()
        //   ),
        // ),
        home: App()
      )
    );
  }
}