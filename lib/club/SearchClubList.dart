import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/Join_Club_Page_1_1.dart';

// import 'ClubMainPage_1_2.dart';

import 'Club_Main_Page.dart';

import 'Club_Join_Page.dart';

class ClubSimpleInfo {
  String club_uid = '';
  String club_name = '';
  int member_cnt = 0;

  ClubSimpleInfo(clubUid, clubName, memberCnt) {
    club_uid = clubUid;
    club_name = clubName;
    member_cnt = memberCnt;
  }
}

class SearchClubList extends StatefulWidget {
  final String name;

  const SearchClubList({Key? key, required this.name}) : super(key: key);

  @override
  _SearchClubListState createState() => _SearchClubListState(name);
}

class _SearchClubListState extends State<SearchClubList> {
  late UserAccountInfo user_account_info_;
  final String name;
  late bool check_user = false;
  User user = FirebaseAuth.instance.currentUser!;
  _SearchClubListState(this.name);

  Future _get_Member_List(String club_uid) async {
    List total_data = [];

    CollectionReference refMember_list = FirebaseFirestore.instance
        .collection("Club")
        .doc(club_uid)
        .collection("ClubMember");

    DocumentSnapshot snapshot_data =
        await refMember_list.doc("MemberList").get();

    if (snapshot_data["ClubMember"].length != 0) {
      for (int i = 0; i < snapshot_data["ClubMember"].length; i++) {
        total_data.add(snapshot_data["ClubMember"][i]["UserID"]);
      }

      for (int i = 0; i < total_data.length; i++) {
        if (user.uid == total_data[i]) {
          check_user = true;
          print(check_user);
        }
      }
    } else {
      check_user = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    user_account_info_ = Provider.of<UserAccountInfo>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        title: SvgPicture.asset(
          'assets/images/SVG/LOGO_KAMMON_small.svg',
          width: 110,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                //color: Theme.of(context).primaryColorLight,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      //color: Colors.blueGrey,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                              child: Container(
                                color: Color(0xfffbd6ce),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3)),
                                        border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 1)),
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(name,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'GSANSM',
                                              color: Colors.grey[500])),
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 20, 50, 5),
                                    child: Text('클럽명',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'GSANSM',
                                            color: Colors.grey[500])),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                                    child: Text('회원수',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'GSANSM',
                                            color: Colors.grey[500])),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Container(
                                  height: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ]),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          //color: Colors.amberAccent,
                          child: FutureBuilder<QuerySnapshot>(
                        future:
                            FirebaseFirestore.instance.collection('Club').get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            Center(child: Text('Something went wrong'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            List<DocumentSnapshot> clubList =
                                snapshot.data!.docs;
                            return ListView.builder(
                              itemBuilder: (BuildContext context, idx) {
                                return clubList[idx]['ClubName']
                                            .contains(name) ==
                                        true
                                    ? Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Container(
                                          child: GestureDetector(
                                            onTap: () {
                                              _get_Member_List(
                                                      clubList[idx]['ClubUID'])
                                                  .then((value) => {
                                                        if (check_user == true)
                                                          {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder:
                                                                    (BuildContext
                                                                        context) {
                                                              // return ClubMainPage(
                                                              //     club_uid: clubList[
                                                              //             idx][
                                                              //         'ClubUID'],
                                                              //     club_name: clubList[
                                                              //             idx][
                                                              //         'ClubName'],
                                                              //     image_url: clubList[
                                                              //             idx][
                                                              //         'ClubMainImage'],
                                                              //     club_intro:
                                                              //         clubList[
                                                              //                 idx]
                                                              //             [
                                                              //             'ClubIntro']);
                                                              return ClubJoinPage(
                                                                  club_uid: clubList[
                                                                          idx][
                                                                      'ClubUID'],
                                                                  club_name: clubList[
                                                                          idx][
                                                                      'ClubName'],
                                                                  image_url: clubList[
                                                                          idx][
                                                                      'ClubMainImage'],
                                                                  club_intro:
                                                                      clubList[
                                                                              idx]
                                                                          [
                                                                          'ClubIntro']);
                                                            }))
                                                          }
                                                        else
                                                          {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder:
                                                                    (BuildContext
                                                                        context) {
                                                              // return JoinClubPage(
                                                              //     club_uid: clubList[idx]['ClubUID'],
                                                              //     club_name: clubList[idx]['ClubName']);
                                                              return ClubJoinPage(
                                                                  club_uid: clubList[
                                                                          idx][
                                                                      'ClubUID'],
                                                                  club_name: clubList[
                                                                          idx][
                                                                      'ClubName'],
                                                                  image_url: clubList[
                                                                          idx][
                                                                      'ClubMainImage'],
                                                                  club_intro:
                                                                      clubList[
                                                                              idx]
                                                                          [
                                                                          'ClubIntro']);
                                                            }))
                                                          }
                                                      });
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 0, 20, 0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          clubList[idx]
                                                              ['ClubName'],
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[700],
                                                              fontFamily:
                                                                  'GSANSB'),
                                                        ),
                                                        Text(
                                                          clubList[idx][
                                                                  'MemberCount']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey[700],
                                                              fontFamily:
                                                                  'GSANSM'),
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 10, 0, 0),
                                                  child: Container(
                                                    height: 1,
                                                    color: Colors.grey[400],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ))
                                    : Container();
                              },
                              itemCount: clubList.length,
                            );
                          }
                        },
                      )),
                    ),
                  ],
                ),
              ))),
    );
  }
}









//1.0.0.+7
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:snstennis/club/Join_Club_Page_1_1.dart';
// import 'package:snstennis/hamburger.dart';

// import 'ClubMainPage_1_2.dart';

// class SearchClubList extends StatefulWidget {
//   final String name;

//   const SearchClubList({Key? key, required this.name}) : super(key: key);

//   @override
//   _SearchClubListState createState() => _SearchClubListState(name);
// }

// class _SearchClubListState extends State<SearchClubList> {
//   String name = "";
//   User user = FirebaseAuth.instance.currentUser!;
//   late bool check_user = false;

//   _SearchClubListState(this.name);

//   void _showDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("검색 결과"),
//           content: Text("찾는 클럽이 없습니다."),
//           actions: <Widget>[
//             ElevatedButton(
//               child: Text("OK"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   List<DataRow> _getDataRows() {
//     List<DataRow> data = [];
//     List<Map<String, dynamic>> data_temp = [];

//     return data;
//   }

//   Future _get_Member_List(String club_uid) async {
//     print("실행");
//     List total_data = [];

//     CollectionReference refMember_list = FirebaseFirestore.instance
//         .collection("Club")
//         .doc(club_uid)
//         .collection("ClubMember");

//     DocumentSnapshot snapshot_data =
//         await refMember_list.doc("MemberList").get();

//     if (snapshot_data["ClubMember"].length != 0) {
//       for (int i = 0; i < snapshot_data["ClubMember"].length; i++) {
//         total_data.add(snapshot_data["ClubMember"][i]["UserID"]);
//       }

//       for (int i = 0; i < total_data.length; i++) {
//         if (user.uid == total_data[i]) {
//           check_user = true;
//           print(check_user);
//         }
//       }
//     } else {
//       check_user = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       endDrawer: Drawer(child: HamburgerMenu()),
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFFFFFF),
//         iconTheme: IconThemeData(color: Colors.grey),
//         automaticallyImplyLeading: false,
//         title: 
//           SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: Icon(Icons.arrow_back_ios),
//         ),
//         actions: [],
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Container(
//             width: MediaQuery.of(context).size.width,
//             //height: MediaQuery.of(context).size.height,
//             color: Color(0xFFFFFFFF),
//             //color: Colors.amberAccent,
//             child:
//                 //Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//                 Padding(
//               padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 40,
//                   ),
//                   Container(
//                     color: Color(0xfffbd6ce),
//                     width: MediaQuery.of(context).size.width,
//                     height: 50,
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.all(Radius.circular(3)),
//                             border: Border.all(
//                                 color: Colors.grey.shade400, width: 1)),
//                         child: Container(
//                           margin: EdgeInsets.only(left: 10),
//                           alignment: Alignment.centerLeft,
//                           child: Text(name,
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   fontFamily: 'GSANSM',
//                                   color: Colors.grey[500])),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     child: Column(children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(20, 20, 50, 5),
//                             child: Text('클럽명',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontFamily: 'GSANSM',
//                                     color: Colors.grey[500])),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
//                             child: Text('회원수',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontFamily: 'GSANSM',
//                                     color: Colors.grey[500])),
//                           )
//                         ],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                         child: Container(
//                           height: 1,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ]),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                     child: StreamBuilder<QuerySnapshot>(
//                         stream: FirebaseFirestore.instance.collection('Club').where('ClubName', isEqualTo: name).snapshots(),
//                         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                           if (snapshot.hasError) {
//                             Center(child: Text('Something went wrong'));
//                           }
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return Center(child: CircularProgressIndicator());
//                           } else {
//                             if (snapshot.data!.docs.length == 0) {
//                               return Padding(
//                                 padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
//                                 child: Center(child:Text('검색결과가 없습니다.',
//                                   style: TextStyle(
//                                       fontSize: 22,
//                                       fontFamily: 'GSANSM',
//                                       color: Colors.grey[500]))));
//                             } else {
//                               String club_uid = "";
//                               return ListView.separated(
//                                   itemBuilder: (BuildContext context, idx) {
//                                     DocumentSnapshot data = snapshot.data!.docs[idx];
//                                     club_uid = data["ClubUID"];
//                                     _get_Member_List(club_uid);
//                                     return GestureDetector(
//                                       onTap: () {
//                                         ///
//                                         /// 이쪽에서 조건문 걸어서 가입된 회원이면 해당 클럽 페이지로 이동
//                                         ///
//                                         if (check_user == true) {
//                                           Navigator.push(context,
//                                               MaterialPageRoute(builder:
//                                                   (BuildContext context) {
//                                             return ClubMainPage(
//                                                 club_uid: data.id,
//                                                 club_name: name,
//                                                 image_url: '',);
//                                           }));
//                                         } else {
//                                           Navigator.push(context,
//                                               MaterialPageRoute(builder:
//                                                   (BuildContext context) {
//                                             return JoinClubPage(
//                                                 club_uid: data.id,
//                                                 club_name: name);
//                                           }));
//                                         }
//                                       },
//                                       child: Container(
//                                           padding: EdgeInsets.fromLTRB(20, 10,
//                                               0, 10), //color: Colors.grey,
//                                           child: Text(data['ClubName'],
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontFamily: 'GSANSB',
//                                                   color: Colors.grey[700]))),
//                                     );
//                                   },
//                                   separatorBuilder:
//                                       (BuildContext context, idx) {
//                                     return Padding(
//                                       padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                       child: Container(
//                                         height: 1,
//                                         color: Colors.grey[500],
//                                       ),
//                                     );
//                                     //return Container(height: 1, color: Colors.red[300],);
//                                   },
//                                   itemCount: snapshot.data!.docs.length);
//                             }
//                           }
//                         }),
//                   )
//                 ],
//               ),
//             )),
//       )),
//     );
//   }
// }
