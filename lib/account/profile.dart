import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/login.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/account/edit_profile.dart';
import 'package:snstennis/home.dart';
import 'package:snstennis/privacy_policy.dart';
import 'package:snstennis/terms_use.dart';

class Profile extends StatefulWidget {
  const Profile({ Key? key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late UserAccountInfo userAccount;
  final auth = FirebaseAuth.instance;
  void logOut() {      
    userAccount.logOut();
    auth.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    userAccount = Provider.of<UserAccountInfo>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        title: 
          SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
        actions: [],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => Home(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: 
                Text('나의 정보', style: TextStyle(color: Theme.of(context).primaryColor, fontFamily: 'GSANSB', fontSize: 20,),textAlign: TextAlign.start,)
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                child: Column(
                  children: [
                    userAccount.profile_image == '' ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child:
                        SvgPicture.asset('assets/images/SVG/profile_pink.svg', width: 120,)
                        //Image.network('https://www.edmundsgovtech.com/wp-content/uploads/2020/01/default-picture_0_0.png', fit: BoxFit.cover,),
                    ) :
                    CircleAvatar(
                      backgroundColor: Colors.white,
                        radius: 60,
                        backgroundImage: NetworkImage(userAccount.profile_image)
                    ),
                    //SvgPicture.asset('assets/images/SVG/profile_pink.svg', width: 120,),
                    SizedBox(height: 10,),
                    Column(
                      children: [
                        Text(userAccount.nickname, style: Theme.of(context).textTheme.headline2),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => EditProfile())
                            );
                          }, 
                          child: Text('수정하기')
                        )
                      ],
                    )
                    
                  ],
                )
              ) 
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => TermsUse()));
                      },
                      child: Text(
                        "이용약관",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      // style: OutlinedButton.styleFrom(
                      //     primary: Colors.white,
                      //     backgroundColor: Colors.white,
                      //     side: BorderSide(
                      //         color: Theme.of(context).primaryColor, width: 1),
                      //     elevation: 2),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => PrivacyPolicy()));
                      },
                      child: Text(
                        "개인정보처리방침",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      // style: OutlinedButton.styleFrom(
                      //     primary: Colors.white,
                      //     backgroundColor: Colors.white,
                      //     side: BorderSide(
                      //         color: Theme.of(context).primaryColor, width: 1),
                      //     elevation: 2),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        logOut();
                      },
                      child: Text(
                        "로그아웃",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      // style: OutlinedButton.styleFrom(
                      //     primary: Colors.white,
                      //     backgroundColor: Colors.white,
                      //     side: BorderSide(
                      //         color: Theme.of(context).primaryColor, width: 1),
                      //     elevation: 2),
                    ),
                  )
                ],
              ),
            )
          ],
        )
        )
      ),
    );
  }
}