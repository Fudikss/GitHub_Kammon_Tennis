import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/Club_Member_Manage_1_0.dart';
import 'package:snstennis/club/Club_Settings.dart';

class ClubDrawer extends StatefulWidget {
  final String club_uid;
  final String club_name;
  const ClubDrawer({Key? key, required this.club_uid, required this.club_name})
      : super(key: key);

  @override
  _ClubDrawerState createState() => _ClubDrawerState(club_uid, club_name);
}

class _ClubDrawerState extends State<ClubDrawer> {
  String c_uid = "";
  String c_name = "";
  //UserAccountInfo userAccount = UserAccountInfo();

  _ClubDrawerState(this.c_uid, this.c_name);

  @override
  Widget build(BuildContext context) {
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);
    final auth = FirebaseAuth.instance;

    String grade = userAccount_.grade;

    print(grade);
    return Drawer(
        child: ListView(
      children: [
        Center(
          child: DrawerHeader(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: Text(
                c_name,
                style: TextStyle(
                    fontFamily: 'GSANSB',
                    fontSize: 24,
                    color: Color(0xffe83a4f)),
              ),
            ),
          ),
        ),
        Divider(thickness: 1.5, height: 1.5, color: Colors.grey[400]),
        // ListTile(
        //   leading: Icon(
        //     Icons.home,
        //     color: Colors.grey[850],
        //   ),
        //   title: Text(
        //     'HOME',
        //     style: TextStyle(
        //         fontFamily: 'GSANSB', fontSize: 14, color: Color(0xff58585b)),
        //   ),
        //   onTap: () {
        //     // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
        //     //     return ClubMainPage(club_uid: c_uid, club_name: c_name,);
        //     //   }));
        //   },
        // ),
        // ListTile(
        //   leading: Icon(
        //     Icons.chat,
        //     color: Colors.grey[850],
        //   ),
        //   title: Text('CHAT'),
        //   onTap: () {},
        // ),
        // ListTile(
        //   leading: Icon(
        //     Icons.sports_tennis,
        //     color: Colors.grey[850],
        //   ),
        //   title: Text('CLUB'),
        //   onTap: () {},
        // ),
        Divider(thickness: 1.5, height: 1.5, color: Colors.grey[400]),
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.grey[850],
          ),
          title: Text(
            'MEMBER',
            style: TextStyle(
                fontFamily: 'GSANSB', fontSize: 14, color: Color(0xff58585b)),
          ),
          onTap: () {
            ///
            /// 가입한 클럽안에서 권한 탐색 후 운영진이면 넘어가야한다.
            ///

            // if (user_grade == "NomalUser") {
            //   _showDialog_error(context);
            // } else {
            //   Navigator.push(context,
            //       MaterialPageRoute(builder: (BuildContext context) {
            //     return ClubMemberManage(
            //       club_name: c_uid,
            //     );
            //   }));
            // }

            if (grade == "Master" || grade == "SysOp") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return ClubMemberManage(
                  club_name: c_uid,
                  club_real_name: c_name,
                );
              }));
            } else {
              _showDialog_error(context);
            }
          },
        ),
        Divider(thickness: 1.5, height: 1.5, color: Colors.grey[400]),
        ListTile(
          leading: Icon(
            Icons.settings,
            color: Colors.grey[850],
          ),
          title: Text(
            'SETTINGS',
            style: TextStyle(
                fontFamily: 'GSANSB', fontSize: 14, color: Color(0xff58585b)),
          ),
          onTap: () {
            if (grade == "Master") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return ClubSettings(
                  club_name: c_uid,
                  club_uid: c_name,
                );
              }));
            } else {
              _showDialog_error(context);
            }
          },
        ),
        Divider(thickness: 1.5, height: 1.5, color: Colors.grey[400]),

        Padding(
          padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
          child: TextButton(
              onPressed: () {
                if (userAccount_.grade != "Master") {
                  _showDialog_secession(context, c_uid);
                } else {
                  _showDialog_secession_error(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  primary: Color(0xffe83a4f), elevation: 0),
              child: Text(
                "클럽탈퇴",
                style: TextStyle(
                    fontFamily: 'GSANSB', fontSize: 14, color: Colors.white),
              )),
        )
      ],
    ));
  }
}

void _showDialog_error(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "권한 탐색",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "접근할 수 있는 권한이 없습니다",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              "나가기",
              style: TextStyle(
                  fontFamily: 'GSANSM', fontSize: 14, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
                fixedSize: Size(80, 20),
                primary: Colors.white,
                side:
                    BorderSide(width: 1, color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _showDialog_secession_error(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "탈퇴 실패",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "창설자는 탈퇴할 수 없습니다",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              "나가기",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontFamily: 'GSANSM'),
            ),
            style: ElevatedButton.styleFrom(
                fixedSize: Size(80, 20),
                primary: Colors.white,
                side:
                    BorderSide(width: 1, color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _showDialog_secession(BuildContext context, String club_uid) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "클럽 탈퇴",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "해당 클럽에서 탈퇴하시겠습니까?",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(
                  "탈퇴",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontFamily: 'GSANSM'),
                ),
                onPressed: () {
                  UserAccountInfo userAccount_ =
                      Provider.of(context, listen: false);

                  FirebaseFirestore.instance
                      .collection("Club")
                      .doc(club_uid)
                      .collection("ClubMember")
                      .doc("MemberList")
                      .update({
                    "ClubMember": FieldValue.arrayRemove([
                      {
                        "Grade": userAccount_.grade,
                        "UserID": user.uid,
                        "NickName": userAccount_.nickname
                      }
                    ])
                  });

                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(user.uid)
                      .update({
                    "JoinClub": FieldValue.arrayRemove([club_uid])
                  });

                  FirebaseFirestore.instance
                      .collection('Club')
                      .doc(club_uid)
                      .update({
                    'MemberCount': FieldValue.increment(-1),
                  }).then((value) => print('ok'));

                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              SizedBox(
                width: 40,
              ),
              ElevatedButton(
                child: Text(
                  "취소",
                  style: TextStyle(
                      fontFamily: 'GSANSM', fontSize: 14, color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(80, 20),
                    primary: Colors.white,
                    side: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ],
          )
        ],
      );
    },
  );
}





//1.0.0.+7
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/club/Club_Member_Manage_1_0.dart';
// import 'package:snstennis/club/Club_Settings.dart';


// class ClubDrawer extends StatefulWidget {
//   final String club_uid;
//   final String club_name;
//   const ClubDrawer({Key? key, required this.club_uid, required this.club_name})
//       : super(key: key);

//   @override
//   _ClubDrawerState createState() => _ClubDrawerState(club_uid, club_name);
// }

// class _ClubDrawerState extends State<ClubDrawer> {
//   String c_uid = "";
//   String c_name = "";
//   //UserAccountInfo userAccount = UserAccountInfo();

//   _ClubDrawerState(this.c_uid, this.c_name);

//   @override
//   Widget build(BuildContext context) {
//     UserAccountInfo userAccount_ =
//         Provider.of<UserAccountInfo>(context, listen: false);
//     final auth = FirebaseAuth.instance;

//     String grade = userAccount_.grade;

//     return Drawer(
//         child: ListView(
//       children: [
//         Center(
//           child: DrawerHeader(
//             child: Padding(
//               padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
//               child: Text(
//                 c_name,
//                 style: TextStyle(
//                     fontFamily: 'GSANSB',
//                     fontSize: 24,
//                     color: Color(0xffe83a4f)),
//               ),
//             ),
//           ),
//         ),
//         Divider(thickness: 1.5, height: 1.5, color: Colors.grey[400]),
//         ListTile(
//           leading: Icon(
//             Icons.home,
//             color: Colors.grey[850],
//           ),
//           title: Text(
//             'HOME',
//             style: TextStyle(
//                 fontFamily: 'GSANSB', fontSize: 14, color: Color(0xff58585b)),
//           ),
//           onTap: () {
//             // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
//             //     return ClubMainPage(club_uid: c_uid, club_name: c_name,);
//             //   }));
//           },
//         ),
//         // ListTile(
//         //   leading: Icon(
//         //     Icons.chat,
//         //     color: Colors.grey[850],
//         //   ),
//         //   title: Text('CHAT'),
//         //   onTap: () {},
//         // ),
//         // ListTile(
//         //   leading: Icon(
//         //     Icons.sports_tennis,
//         //     color: Colors.grey[850],
//         //   ),
//         //   title: Text('CLUB'),
//         //   onTap: () {},
//         // ),
//         Divider(thickness: 1.5, height: 1.5, color: Colors.grey[400]),
//         ListTile(
//           leading: Icon(
//             Icons.person,
//             color: Colors.grey[850],
//           ),
//           title: Text(
//             'MEMBER',
//             style: TextStyle(
//                 fontFamily: 'GSANSB', fontSize: 14, color: Color(0xff58585b)),
//           ),
//           onTap: () {
//             ///
//             /// 가입한 클럽안에서 권한 탐색 후 운영진이면 넘어가야한다.
//             ///

//             // if (user_grade == "NomalUser") {
//             //   _showDialog_error(context);
//             // } else {
//             //   Navigator.push(context,
//             //       MaterialPageRoute(builder: (BuildContext context) {
//             //     return ClubMemberManage(
//             //       club_name: c_uid,
//             //     );
//             //   }));
//             // }

//             if (grade == "Master" || grade == "SysOp") {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (BuildContext context) {
//                 return ClubMemberManage(
//                   club_name: c_uid,
//                   club_real_name: c_name,
//                 );
//               }));
//             } else {
//               _showDialog_error(context);
//             }
//           },
//         ),
//         Divider(thickness: 1.5, height: 1.5, color: Colors.grey[400]),
//         ListTile(
//           leading: Icon(
//             Icons.settings,
//             color: Colors.grey[850],
//           ),
//           title: Text(
//             'SETTINGS',
//             style: TextStyle(
//                 fontFamily: 'GSANSB', fontSize: 14, color: Color(0xff58585b)),
//           ),
//           onTap: () {
//             if (grade == "Master") {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (BuildContext context) {
//                 return ClubSettings(
//                   club_name: c_uid,
//                   club_uid: c_name,
//                 );
//               }));
//             } else {
//               _showDialog_error(context);
//             }
//           },
//         ),
//         Divider(thickness: 1.5, height: 1.5, color: Colors.grey[400]),

//         Padding(
//           padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
//           child: TextButton(
//               onPressed: () {
//                 if (userAccount_.grade != "Master") {
//                   _showDialog_secession(context, c_uid);
//                 } else {
//                   _showDialog_secession_error(context);
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                   primary: Color(0xffe83a4f), elevation: 0),
//               child: Text(
//                 "클럽탈퇴",
//                 style: TextStyle(
//                     fontFamily: 'GSANSB', fontSize: 14, color: Colors.white),
//               )),
//         )
//       ],
//     ));
//   }
// }

// void _showDialog_error(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("권한 탐색"),
//         content: Text("접근할 수 있는 권한이 없습니다"),
//         actions: <Widget>[
//           ElevatedButton(
//             child: Text(
//               "나가기",
//               style: TextStyle(
//                   fontFamily: 'GSANSM', fontSize: 14, color: Colors.white),
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

// void _showDialog_secession_error(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("탈퇴 실패"),
//         content: Text(
//           "창설자는 탈퇴할 수 없습니다",
//           style: TextStyle(fontFamily: "GSANSM"),
//         ),
//         actions: <Widget>[
//           ElevatedButton(
//             child: Text(
//               "나가기",
//               style: TextStyle(
//                   fontFamily: 'GSANSM', fontSize: 14, color: Colors.white),
//             ),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

// void _showDialog_secession(BuildContext context, String club_uid) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("클럽 탈퇴"),
//         content: Text(
//           "해당 클럽에서 탈퇴하시겠습니까?",
//           style: TextStyle(fontFamily: "GSANSM"),
//         ),
//         actions: <Widget>[
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 child: Text(
//                   "탈퇴",
//                   style: TextStyle(
//                       fontFamily: 'GSANSM', fontSize: 14, color: Colors.white),
//                 ),
//                 onPressed: () {
//                   UserAccountInfo userAccount_ = Provider.of(context, listen: false);

//                   FirebaseFirestore.instance
//                       .collection("Club")
//                       .doc(club_uid)
//                       .collection("ClubMember")
//                       .doc("MemberList")
//                       .update({
//                     "ClubMember": FieldValue.arrayRemove([
//                       {
//                         "Grade": userAccount_.grade,
//                         "UserID": user.uid,
//                         "NickName": userAccount_.nickname
//                       }
//                     ])
//                   });

//                   FirebaseFirestore.instance
//                       .collection("Users")
//                       .doc(user.uid)
//                       .update({
//                     "JoinClub": FieldValue.arrayRemove([club_uid])
//                   });

//                   FirebaseFirestore.instance.collection('Club').doc(club_uid).update({
//                       'MemberCount': FieldValue.increment(-1),
//                     }).then((value) => print('ok'));

//                   Navigator.of(context).popUntil((route) => route.isFirst); 
//                 },
//               ),
//               SizedBox(
//                 width: 40,
//               ),
//               ElevatedButton(
//                 child: Text(
//                   "취소",
//                   style: TextStyle(
//                       fontFamily: 'GSANSM', fontSize: 14, color: Colors.white),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           )
//         ],
//       );
//     },
//   );
// }



// //1.0.0+7
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:snstennis/account/user_account_info.dart';
// // import 'package:snstennis/club/Club_Member_Manage_1_0.dart';
// // import 'package:snstennis/club/Club_Settings.dart';

// // // class ClubDrawer extends StatelessWidget {
// // //   final String club_uid;
// // //   const ClubDrawer({Key? key, required this.club_uid}) : super(key: key);

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     UserAccountInfo userAccount = UserAccountInfo();
// // //     final auth = FirebaseAuth.instance;
// // //     userAccount = Provider.of<UserAccountInfo>(context);
// // //     return Drawer(
// // //         child: ListView(
// // //       children: [
// // //         Center(
// // //           child: DrawerHeader(
// // //             child: Text(
// // //               'CLUB MENU',
// // //               style: TextStyle(
// // //                   fontSize: 50.0,
// // //                   fontWeight: FontWeight.w600,
// // //                   color: Colors.grey[400]),
// // //             ),
// // //             decoration: BoxDecoration(
// // //               color: Colors.red[200],
// // //             ),
// // //           ),
// // //         ),
// // //         ListTile(
// // //           leading: Icon(
// // //             Icons.home,
// // //             color: Colors.grey[850],
// // //           ),
// // //           title: Text('HOME'),
// // //           onTap: () {},
// // //         ),
// // //         ListTile(
// // //           leading: Icon(
// // //             Icons.chat,
// // //             color: Colors.grey[850],
// // //           ),
// // //           title: Text('CHAT'),
// // //           onTap: () {},
// // //         ),
// // //         ListTile(
// // //           leading: Icon(
// // //             Icons.sports_tennis,
// // //             color: Colors.grey[850],
// // //           ),
// // //           title: Text('CLUB'),
// // //           onTap: () {},
// // //         ),
// // //         ListTile(
// // //           leading: Icon(
// // //             Icons.person,
// // //             color: Colors.grey[850],
// // //           ),
// // //           title: Text('MEMBER'),
// // //           onTap: () {
// // //             ///
// // //             /// 가입한 클럽안에서 권한 탐색 후 운영진이면 넘어가야한다.
// // //             ///
// // //             Navigator.push(context,
// // //                 MaterialPageRoute(builder: (BuildContext context) {
// // //               return ClubMemberManage(club_name: ,);
// // //             }));
// // //           },
// // //         ),
// // //         ListTile(
// // //           leading: Icon(
// // //             Icons.settings,
// // //             color: Colors.grey[850],
// // //           ),
// // //           title: Text('SETTINGS'),
// // //           onTap: () {},
// // //         ),
// // //         Padding(
// // //           padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
// // //           child: ElevatedButton(
// // //               onPressed: () {
// // //                 // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
// // //                 //   return ClubSettings(club_name: "에핀마스터");
// // //                 // }));
// // //               },
// // //               style: ElevatedButton.styleFrom(
// // //                 primary: Colors.red[200],
// // //               ),
// // //               child: Text("로그아웃")),
// // //         )
// // //       ],
// // //     ));
// // //   }
// // // }

// // class ClubDrawer extends StatefulWidget {
// //   final String club_uid;
// //   final String club_name;
// //   const ClubDrawer({Key? key, required this.club_uid, required this.club_name})
// //       : super(key: key);

// //   @override
// //   _ClubDrawerState createState() => _ClubDrawerState(club_uid, club_name);
// // }

// // class _ClubDrawerState extends State<ClubDrawer> {
// //   String c_uid = "";
// //   String c_name = "";
// //   //UserAccountInfo userAccount = UserAccountInfo();

// //   _ClubDrawerState(this.c_uid, this.c_name);

// //   @override
// //   Widget build(BuildContext context) {
// //     UserAccountInfo userAccount_ =
// //         Provider.of<UserAccountInfo>(context, listen: false);
// //     final auth = FirebaseAuth.instance;

// //     String grade = userAccount_.grade;

// //     return Drawer(
// //         child: ListView(
// //       children: [
// //         Center(
// //           child: DrawerHeader(
// //             child: Padding(
// //               padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
// //               child: Text(
// //                 c_name,
// //                 style: TextStyle(
// //                     fontFamily: 'GSANSB',
// //                     fontSize: 24,
// //                     color: Color(0xffe83a4f)),
// //               ),
// //             ),
// //           ),
// //         ),
// //         Divider(thickness: 1.5, height: 1.5, color: Colors.grey[400]),
// //         ListTile(
// //           leading: Icon(
// //             Icons.home,
// //             color: Colors.grey[850],
// //           ),
// //           title: Text(
// //             'HOME',
// //             style: TextStyle(
// //                 fontFamily: 'GSANSB', fontSize: 14, color: Color(0xff58585b)),
// //           ),
// //           onTap: () {
// //             // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
// //             //     return ClubMainPage(club_uid: c_uid, club_name: c_name,);
// //             //   }));
// //           },
// //         ),
// //         // ListTile(
// //         //   leading: Icon(
// //         //     Icons.chat,
// //         //     color: Colors.grey[850],
// //         //   ),
// //         //   title: Text('CHAT'),
// //         //   onTap: () {},
// //         // ),
// //         // ListTile(
// //         //   leading: Icon(
// //         //     Icons.sports_tennis,
// //         //     color: Colors.grey[850],
// //         //   ),
// //         //   title: Text('CLUB'),
// //         //   onTap: () {},
// //         // ),
// //         Divider(thickness: 1.5, height: 1.5, color: Colors.grey[400]),
// //         ListTile(
// //           leading: Icon(
// //             Icons.person,
// //             color: Colors.grey[850],
// //           ),
// //           title: Text(
// //             'MEMBER',
// //             style: TextStyle(
// //                 fontFamily: 'GSANSB', fontSize: 14, color: Color(0xff58585b)),
// //           ),
// //           onTap: () {
// //             ///
// //             /// 가입한 클럽안에서 권한 탐색 후 운영진이면 넘어가야한다.
// //             ///

// //             // if (user_grade == "NomalUser") {
// //             //   _showDialog_error(context);
// //             // } else {
// //             //   Navigator.push(context,
// //             //       MaterialPageRoute(builder: (BuildContext context) {
// //             //     return ClubMemberManage(
// //             //       club_name: c_uid,
// //             //     );
// //             //   }));
// //             // }

// //             if (grade == "Master" || grade == "SysOp") {
// //               Navigator.push(context,
// //                   MaterialPageRoute(builder: (BuildContext context) {
// //                 return ClubMemberManage(
// //                   club_name: c_uid,
// //                   club_real_name: c_name,
// //                 );
// //               }));
// //             } else {
// //               _showDialog_error(context);
// //             }
// //           },
// //         ),
// //         Divider(thickness: 1.5, height: 1.5, color: Colors.grey[400]),
// //         ListTile(
// //           leading: Icon(
// //             Icons.settings,
// //             color: Colors.grey[850],
// //           ),
// //           title: Text(
// //             'SETTINGS',
// //             style: TextStyle(
// //                 fontFamily: 'GSANSB', fontSize: 14, color: Color(0xff58585b)),
// //           ),
// //           onTap: () {
// //             if (grade == "Master") {
// //               Navigator.push(context,
// //                   MaterialPageRoute(builder: (BuildContext context) {
// //                 return ClubSettings(
// //                   club_name: c_uid,
// //                   club_uid: c_name,
// //                 );
// //               }));
// //             } else {
// //               _showDialog_error(context);
// //             }
// //           },
// //         ),
// //         Divider(thickness: 1.5, height: 1.5, color: Colors.grey[400]),
// //         // Padding(
// //         //   padding: EdgeInsets.fromLTRB(30, 50, 30, 0),
// //         //   child: ElevatedButton(
// //         //       onPressed: () {
// //         //         // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
// //         //         //   return ClubSettings(club_name: "에핀마스터");
// //         //         // }));
// //         //       },
// //         //       style: ElevatedButton.styleFrom(
// //         //           primary: Color(0xffe83a4f), elevation: 0),
// //         //       child: Text(
// //         //         "로그아웃",
// //         //         style: TextStyle(
// //         //             fontFamily: 'GSANSB', fontSize: 14, color: Colors.white),
// //         //       )),
// //         // )
// //       ],
// //     ));
// //   }
// // }

// // void _showDialog_error(BuildContext context) {
// //   showDialog(
// //     context: context,
// //     builder: (BuildContext context) {
// //       return AlertDialog(
// //         title: Text("권한 탐색"),
// //         content: Text("접근할 수 있는 권한이 없습니다"),
// //         actions: <Widget>[
// //           ElevatedButton(
// //             child: Text(
// //               "나가기",
// //               style: TextStyle(
// //                   fontFamily: 'GSANSM', fontSize: 14, color: Colors.white),
// //             ),
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //             },
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }
