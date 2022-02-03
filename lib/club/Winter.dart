import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/app.dart';
import 'Winter2.dart';

class Winter extends StatefulWidget {
  const Winter({Key? key}) : super(key: key);

  @override
  _WinterState createState() => _WinterState();
}

class _WinterState extends State<Winter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "동계현장실습",
          style: TextStyle(color: Color(0xFFF6F4F0), fontSize: 25.0),
        ),
        actions: [],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFFF0CDB4),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("assets/images/GIF/winter_image.gif"),
            ),
            SignInButton(Buttons.Google, onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return WinterJoinUser();
              }));
            })
          ],
        ),
      ),
    );
  }
}
