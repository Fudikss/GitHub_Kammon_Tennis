import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/add_member_info.dart';
import 'package:snstennis/account/log_in_splash.dart';
import 'package:snstennis/account/login.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/home.dart';

class UserCheck extends StatefulWidget {
  const UserCheck({ Key? key }) : super(key: key);

  @override
  _UserCheckState createState() => _UserCheckState();
}

class _UserCheckState extends State<UserCheck> {
  bool isMember = false;
  User? curUser;
  UserAccountInfo userAccount = UserAccountInfo();

  @override
  void initState() {
    super.initState();
  }

  Future<Map<dynamic, dynamic>> _getMarketChat(String userId) async {
    var data;
    
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
    DocumentSnapshot snapshot = await ref.doc(userId).collection('TotalMarketChat').doc('MarketChat').get();

    data = snapshot.data();
    return data;
  }

  Future<Map<dynamic, dynamic>> _getData(String userId) async {
    var data1;
    var data2;
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
    DocumentSnapshot snapshot1 = await ref.doc(userId).get();
    DocumentSnapshot snapshot2 = await ref.doc(userId).collection('TotalMarketChat').doc('MarketChat').get();
    
    data1 = snapshot1.data();
    data2 = snapshot2.data();

    var data = {
      'nickname' : data1['nickname'].toString(),
      'gender' : data1['gender'].toString(),
      'fcmToken' : data1['fcm_token'].toString(),
      'reg_data' : data1['reg_date'].toString(),
      'profile_image' : data1['profile_image'].toString(),
      'marketChatItem' : data2['ItemID'],
      'reportCount' : data1['reportCount']
    };
    print(data);
    return data;
  }

  Future _setUserProvider(String userId, UserAccountInfo _userAccount) async{
    print('set user data');
    final data = _getData(userId);
    data.then((value) => {
      _userAccount.logIn(
        userId, 
        value['nickname'],
        value['gender'],
        value['fcm_token'].toString(),
        value['reg_date'].toString(),
        value['profile_image'].toString(),
        value['marketChatItem'],
        value['reportCount']
      ),      
    });
  }

  Future _checkUserData() async{
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('Users').get();
    final List<DocumentSnapshot> documents = result.docs;
    isMember = false;
    Iterator doc_iter = documents.iterator;
    User? curUser = FirebaseAuth.instance.currentUser;
    while(doc_iter.moveNext()) {
      if( doc_iter.current.id == curUser!.uid) {
        isMember = true;
        break;
      } 
    }

    if(isMember) {
      userAccount = Provider.of<UserAccountInfo>(context, listen: false);
      final isUser = _setUserProvider(curUser!.uid, userAccount);
      isUser.then((value) => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => LogInWithSplash(),
          ),
        )
      });
    }
    else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => AddMemberInfo(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> user) {
        if(user.hasData) {
          User? curUser = FirebaseAuth.instance.currentUser;
          final data = _checkUserData();
          return Container(
            color: Colors.white,
            child: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(0.0, 0.0),
                  child: SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 150,),
                ),
              ],
            ))
          );
        } else {
          return Login();
        }
      }
    );
  }
}




// class UserCheck extends StatefulWidget {
//   const UserCheck({ Key? key }) : super(key: key);

//   @override
//   _UserCheckState createState() => _UserCheckState();
// }

// class _UserCheckState extends State<UserCheck> {
//   bool isMember = false;
//   User? curUser;
//   UserAccountInfo userAccount = UserAccountInfo();

//   @override
//   void initState() {
//     super.initState();
//     curUser = FirebaseAuth.instance.currentUser;
//   }

//   Future<Map<dynamic, dynamic>> _getData(String userId) async {
//     var data;
//     CollectionReference ref = FirebaseFirestore.instance.collection('Users');
//     DocumentSnapshot snapshot = await ref.doc(userId).get();
//     data = snapshot.data();
//     return data;
//   }

//   Future<Map<dynamic, dynamic>> _getMarketChat(String userId) async {
//     var data;
    
//     CollectionReference ref = FirebaseFirestore.instance.collection('Users');
//     DocumentSnapshot snapshot = await ref.doc(userId).collection('TotalMarketChat').doc('MarketChat').get();

//     data = snapshot.data();
//     return data;
//   }

//   void _setUserProvider(String userId, UserAccountInfo _userAccount) {
//     String nickname_ = '';
//     String gender_ = '';
//     String fcmToken_ = '';
//     String regDate_ = '';
    
//     final data = _getData(userId);
//     final market = _getMarketChat(userId);

//     data.then(
//       (value) => {
//         nickname_ = value['nickname'].toString(),
//         gender_ = value['gender'].toString(),
//         fcmToken_ = value['fcm_token'].toString(),
//         regDate_ = value['reg_date'].toString(),
//         market.then((value1) => {
//           _userAccount.logIn(
//             userId,
//             nickname_,
//             gender_,
//             fcmToken_,
//             regDate_,
//             value1['ItemID']
//           ),
//         }),        
//       }
//     );
//   }

//   // Future _checkUserData() async{
//   //   final QuerySnapshot result = await FirebaseFirestore.instance.collection('Users').get();
//   //   final List<DocumentSnapshot> documents = result.docs;
//   //   isMember = false;
//   //   Iterator doc_iter = documents.iterator;
//   //   User? curUser = FirebaseAuth.instance.currentUser;
//   //   while(doc_iter.moveNext()) {
//   //     if( doc_iter.current.id == curUser!.uid) {
//   //       isMember = true;
//   //       break;
//   //     } 
//   //   }
//   // }

//   Future _checkUserData(String userId) async{
//     CollectionReference ref = FirebaseFirestore.instance.collection('Users');
//     DocumentSnapshot snapshot = await ref.doc(userId).get();

//     isMember = snapshot.exists;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if( curUser == null ) {
//       return Login();
//     } else {
//       final isUserData = _checkUserData(curUser!.uid);
//       isUserData.then((value) => {
//         if(isMember) {
//           userAccount = Provider.of<UserAccountInfo>(context, listen: false),
//           _setUserProvider(curUser!.uid, userAccount),

//         //   Navigator.of(context).push(
//         //     MaterialPageRoute(
//         //       builder: (BuildContext context) => LogInWithSplash(),
//         //     ),
//         //   )
//         // } else {
//         //   Navigator.of(context).push(
//         //     MaterialPageRoute(
//         //       builder: (BuildContext context) => AddMemberInfo(),
//         //     ),
//         //   )
//         }
//       });
//       return StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (BuildContext context, AsyncSnapshot<User?> user) {
//           if(user.hasData) {
//             if(isMember) {
//               // Navigator.of(context).push(
//               //   MaterialPageRoute(
//               //     builder: (BuildContext context) => LogInWithSplash(),
//               //   ),
//               // );
//               return LogInWithSplash();
//             } else {
//               // Navigator.of(context).push(
//               //   MaterialPageRoute(
//               //     builder: (BuildContext context) => AddMemberInfo(),
//               //   ),
//               // );
//               return AddMemberInfo();
//             }
//           } else {
//             return Scaffold(
//               backgroundColor: Colors.white,
//               body: 
//                 SafeArea(
//                   child: Center(
//                     child: Stack(
//                       children: [
//                         Align(
//                           alignment: Alignment(0.0, 0.0),
//                           child: SvgPicture.asset('assets/images/SVG/LOGO_horizontal.svg', width: 150,),
//                         ),
//                         Align(
//                           alignment: Alignment(0.0, 0.0),
//                           child: SizedBox(
//                             width: 200,
//                             height: 200,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 10,
//                                 valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColorLight),
//                             ) 
//                           ),
//                         ),
//                       ],
//                     )
//               ),)
//             );
//           }
//         }
//       );
//     }


//     // return StreamBuilder(
//     //   stream: FirebaseAuth.instance.authStateChanges(),
//     //   builder: (BuildContext context, AsyncSnapshot<User?> user) {
//     //     if(user.hasData) {
//     //       User? curUser = FirebaseAuth.instance.currentUser;
//     //       final data = _checkUserData();
//     //       data.then((value) => {
//     //         if(isMember) {
//     //           userAccount = Provider.of<UserAccountInfo>(context, listen: false),
//     //           _setUserProvider(curUser!.uid, userAccount),

//     //           Navigator.of(context).push(
//     //             MaterialPageRoute(
//     //               builder: (BuildContext context) => LogInWithSplash(),
//     //             ),
//     //           )
//     //         } else {
//     //           Navigator.of(context).push(
//     //             MaterialPageRoute(
//     //               builder: (BuildContext context) => AddMemberInfo(),
//     //             ),
//     //           )
//     //         }
//     //       });
//     //       return Container();
//     //     } else {
//     //       return Login();
//     //     }
//     //   }
//     // );
//   }
// }