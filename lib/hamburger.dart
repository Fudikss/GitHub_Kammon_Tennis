import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/login.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/account/edit_profile.dart';
import 'package:snstennis/home.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserAccountInfo userAccount = Provider.of<UserAccountInfo>(context);
    final auth = FirebaseAuth.instance;
    void logOut() {      
      userAccount.logOut();
      auth.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Login()));
    }
    return SafeArea(
      child: Expanded(
        child: SingleChildScrollView(
          child: Container(
          child: 
            Column(
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
                            radius: 120,
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
                              child: Text('변경하기')
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
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Home()));
                          },
                          child: Text(
                            "이용약관",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor, width: 1),
                              elevation: 2),
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
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Home()));
                          },
                          child: Text(
                            "개인정보처리방침",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor, width: 1),
                              elevation: 2),
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
                        child: OutlinedButton(
                          onPressed: () {
                            logOut();
                          },
                          child: Text(
                            "로그아웃",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor, width: 1),
                              elevation: 2),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
        ),
      )
    );
  }
}