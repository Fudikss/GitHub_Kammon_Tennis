import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/login.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/home.dart';

class LogInWithSplash extends StatefulWidget {
  const LogInWithSplash({ Key? key }) : super(key: key);

  @override
  _LogInWithSplashState createState() => _LogInWithSplashState();
}

class _LogInWithSplashState extends State<LogInWithSplash> {

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 2000), () {
      UserAccountInfo userInfo = Provider.of<UserAccountInfo>(context, listen: false);
      var test = userInfo.nickname;
      print('user : $test');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Home()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: 
        SafeArea(
          child: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(0.0, 0.0),
                  child: SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 150,),
                ),
                Align(
                  alignment: Alignment(0.0, 0.0),
                  child: SizedBox(
                    width: 200,
                    height: 200,
                      child: CircularProgressIndicator(
                        strokeWidth: 10,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColorLight),
                    ) 
                  ),
                ),
              ],
            )
      ),)
    );
  }
}