import 'package:snstennis/account/login.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPage extends StatefulWidget {
  MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  UserAccountInfo userAccount = UserAccountInfo();

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    void logOut() {
      auth.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Login()));
    }
    //userAccount = Provider.of<UserAccountInfo>(context, );
    userAccount = Provider.of<UserAccountInfo>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          iconTheme: IconThemeData(color: Colors.grey),
          automaticallyImplyLeading: false,
          title: Text(
            'COMON',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              onPressed: () {}, 
              icon: 
                Icon(Icons.menu)
            )
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1,            
            child:
            Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child:
              Column(mainAxisSize: MainAxisSize.max,
              children: [
                // Padding(
                //   padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                //   child:
                //     Column(
                //       mainAxisSize: MainAxisSize.max,
                //       children: [
                //         Container(
                //           width: 100,
                //           height: 100,
                //           clipBehavior: Clip.antiAlias,
                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //           ),
                //           child: Image.network(
                //             'https://picsum.photos/seed/68/600',
                //           ),
                //         ),
                //         Container(
                //           child: Center(),
                //         )
                //       ],
                //     ),
                // ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
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
                ),
              ],),
            ),
          ),
        ));
  }
}
