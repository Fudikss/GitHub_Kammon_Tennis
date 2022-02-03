import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/profile.dart';
import 'package:snstennis/account/user_account_info.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({ Key? key }) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String text = '';
  bool state = false;

  @override
  void initState() {
    super.initState();

    final data = loadAsset(context);
    data.then((value) => {
      text = value
    });

    Timer(Duration(milliseconds: 500), () {
      setState(() {
        state = true;
      });
    });
  }

  Future<String> loadAsset(BuildContext context) async {
    return await DefaultAssetBundle.of(context).loadString('assets/privacy_policy.txt');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    UserAccountInfo userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
    
    

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        title: 
          SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
        actions: [],
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => Profile(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60,),
                    Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text('KAMMON 개인정보처리방침', style: Theme.of(context).textTheme.headline2),
                    ),
                    SizedBox(height: 20,),
                    Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Container(
                        child: state == true ? Text(text) : Container(),
                      )
                    )
                  ],
                ),
              )
            ),
          ),
        )
      ),
    );
  }
}