import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snstennis/club/club_drawer_1_0.dart';

class ClubMemberJoinList extends StatefulWidget {
  final String club_uid;
  final String club_name;
  const ClubMemberJoinList(
      {Key? key, required this.club_uid, required this.club_name})
      : super(key: key);

  @override
  _ClubMemberJoinListState createState() =>
      _ClubMemberJoinListState(club_uid, club_name);
}

class _ClubMemberJoinListState extends State<ClubMemberJoinList> {
  String c_uid = "";
  String c_name = "";

  bool selected = false;
  List bol_member = [];

  List success_member_name = [];
  List success_member_datetime = [];
  List success_member_user_uid = [];

  List total_wait_join_member_name = [];
  List total_wait_join_member_datetime = [];
  List total_wait_join_member_user_uid = [];

  List selected_index = [];

  _ClubMemberJoinListState(this.c_uid, this.c_name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        title:
            // Image.asset(
            //   'assets/images/PNG/logo2.png',
            //   width: 110,
            // ),
            SvgPicture.asset(
          'assets/images/SVG/LOGO_KAMMON_small.svg',
          width: 110,
        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      endDrawer: Drawer(
        child: ClubDrawer(
          club_uid: c_uid,
          club_name: c_name,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 20, 10),
                    child: ElevatedButton(
                        onPressed: () async {
                          var add_member_list = [];

                          List select_user_id = [];

                          if (success_member_name.length == 0) {
                            _showDialog(context);
                          } else {
                            for (int i = 0;
                                i < success_member_name.length;
                                i++) {
                              add_member_list.add([
                                {
                                  "UserID": success_member_user_uid[i],
                                  "Grade": "NomalUser",
                                  "NickName": success_member_name[i],
                                }
                              ]);
                            }

                            for (int i = 0; i < add_member_list.length; i++) {
                              FirebaseFirestore.instance
                                  .collection("Club")
                                  .doc(c_uid)
                                  .collection("ClubMember")
                                  .doc("MemberList")
                                  .update({
                                "ClubMember":
                                    FieldValue.arrayUnion(add_member_list[i])
                              });
                            }

                            ///
                            /// 이 부분은 선택한 데이터 저장하는 부분
                            ///
                            // for (int i = 0; i < add_member_list.length; i++) {
                            //   if (total_wait_join_member_user_uid[i] ==
                            //       success_member_user_uid[i]) {
                            //     select_user_id.add(success_member_user_uid[i]);
                            //   }
                            // }

                            ///
                            /// 이 부분은 선택한 데이터 삭제 부분
                            ///
                            for (int i = 0;
                                i < total_wait_join_member_name.length;
                                i++) {
                              for (int j = 0;
                                  j < success_member_name.length;
                                  j++) {
                                if (total_wait_join_member_name[i] ==
                                    success_member_name[j]) {
                                  total_wait_join_member_name.removeAt(i);
                                }
                              }
                            }

                            for (int i = 0;
                                i < total_wait_join_member_datetime.length;
                                i++) {
                              for (int j = 0;
                                  j < success_member_datetime.length;
                                  j++) {
                                if (total_wait_join_member_datetime[i] ==
                                    success_member_datetime[j]) {
                                  total_wait_join_member_datetime.removeAt(i);
                                }
                              }
                            }

                            for (int i = 0;
                                i < total_wait_join_member_user_uid.length;
                                i++) {
                              for (int j = 0;
                                  j < success_member_user_uid.length;
                                  j++) {
                                if (total_wait_join_member_user_uid[i] ==
                                    success_member_user_uid[j]) {
                                  select_user_id
                                      .add(total_wait_join_member_user_uid[i]);
                                  total_wait_join_member_user_uid.removeAt(i);
                                }
                              }
                            }

                            List wait_total = [];

                            for (int i = 0;
                                i < total_wait_join_member_name.length;
                                i++) {
                              wait_total.add({
                                "WaitUserName": total_wait_join_member_name[i],
                                "DateTime": total_wait_join_member_datetime[i],
                                "UserID": total_wait_join_member_user_uid[i]
                              });
                            }

                            print(select_user_id);

                            List club_id = [];

                            club_id.add(c_uid);

                            for (int i = 0; i < select_user_id.length; i++) {
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(select_user_id[i])
                                  .update({
                                "JoinClub": FieldValue.arrayUnion(club_id),
                              });
                            }

                            /// UTbUVagErvXldjofM7GAB2WXj9L2
                            FirebaseFirestore.instance
                                .collection("Club")
                                .doc(c_uid)
                                .collection("ClubMember")
                                .doc("WaitJoinClub")
                                .update({"WaitJoinClub": wait_total});

                            wait_total.clear();

                            FirebaseFirestore.instance
                                .collection('Club')
                                .doc(c_uid)
                                .update({
                              'MemberCount': FieldValue.increment(1),
                            }).then((value) => print('ok'));
                            Navigator.of(context).pop();
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xffFFFFFF)),
                            elevation: MaterialStateProperty.all<double>(0.0)),
                        child: Text(
                          "수락하기",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'GSANSB',
                              fontSize: 15.0),
                        ))),
              ],
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Club")
                    .doc(c_uid)
                    .collection("ClubMember")
                    .doc("WaitJoinClub")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error!");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    List a = [];
                    List b = [];
                    List c = [];

                    total_wait_join_member_name.clear();
                    total_wait_join_member_datetime.clear();

                    if (data["WaitJoinClub"] == null) {
                      return Center(child: Text("가입 신청자가 없습니다."));
                    } else {
                      for (int i = 0; i < data["WaitJoinClub"].length; i++) {
                        a.add(data["WaitJoinClub"][i]["WaitUserName"]);
                        b.add(data["WaitJoinClub"][i]["DateTime"]);
                        c.add(data["WaitJoinClub"][i]["UserUID"]);
                        total_wait_join_member_name
                            .add(data["WaitJoinClub"][i]["WaitUserName"]);
                        total_wait_join_member_datetime
                            .add(data["WaitJoinClub"][i]["DateTime"]);
                        total_wait_join_member_user_uid
                            .add(data["WaitJoinClub"][i]["UserUID"]);
                        bol_member.add(false);
                      }
                    }

                    //_imageToStorage(data);

                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          child: Container(
                            height: MediaQuery.of(context).size.height - 200,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.separated(
                              itemCount: a.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: ListTile(
                                    /*leading: CircleAvatar(
                                      backgroundColor: Colors.black,
                                    ),*/
                                    title: Text(a[index]),
                                    subtitle: Text(b[index]),
                                    trailing: Checkbox(
                                      onChanged: (bool? val) {
                                        setState(() {
                                          bol_member[index] = val!;
                                          if (bol_member[index] == true) {
                                            success_member_name.add(a[index]);
                                            success_member_datetime
                                                .add(b[index]);
                                            success_member_user_uid
                                                .add(c[index]);
                                            selected_index.add(index);
                                            print(
                                                "success_member_name의 true 값" +
                                                    success_member_name
                                                        .toString());
                                            print("success_member_uid의 true 값" +
                                                success_member_user_uid
                                                    .toString());

                                            print("selected_index의 true 값" +
                                                selected_index.toString());
                                          } else if (bol_member[index] ==
                                              false) {
                                            success_member_name
                                                .remove(a[index]);
                                            success_member_datetime
                                                .remove(b[index]);
                                            success_member_user_uid
                                                .remove(c[index]);
                                            selected_index.remove(index);
                                            print(
                                                "success_member_name의 false 값" +
                                                    success_member_name
                                                        .toString());
                                            print(
                                                "success_member_uid의 false 값" +
                                                    success_member_user_uid
                                                        .toString());

                                            print("selected_index의 false 값" +
                                                selected_index.toString());
                                          }
                                        });
                                        //success_member.clear();
                                      },
                                      value: bol_member[index],

                                      ///
                                      /// White로
                                      ///
                                      checkColor: Color(0xffFFFFFF),
                                      fillColor: MaterialStateProperty.all(
                                          Color(0xffe9394f)),
                                    ),
                                    onTap: () {},
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Container(
                                  height: 1,
                                  color: Colors.grey[500],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "가입 승인 오류",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "선택한 유저가 없습니다",
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








//1.0.0.+7
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:snstennis/club/club_drawer_1_0.dart';

// class ClubMemberJoinList extends StatefulWidget {
//   final String club_uid;
//   final String club_name;
//   const ClubMemberJoinList(
//       {Key? key, required this.club_uid, required this.club_name})
//       : super(key: key);

//   @override
//   _ClubMemberJoinListState createState() =>
//       _ClubMemberJoinListState(club_uid, club_name);
// }

// class _ClubMemberJoinListState extends State<ClubMemberJoinList> {
//   String c_uid = "";
//   String c_name = "";

//   bool selected = false;
//   List bol_member = [];

//   List success_member_name = [];
//   List success_member_datetime = [];
//   List success_member_user_uid = [];

//   List total_wait_join_member_name = [];
//   List total_wait_join_member_datetime = [];
//   List total_wait_join_member_user_uid = [];

//   List selected_index = [];

//   _ClubMemberJoinListState(this.c_uid, this.c_name);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFFFFFF),
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFFFFFF),
//         iconTheme: IconThemeData(color: Colors.grey),
//         automaticallyImplyLeading: false,
//         title: 
//         // Image.asset(
//         //   'assets/images/PNG/logo2.png',
//         //   width: 110,
//         // ),
//         SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
//         actions: [],
//         centerTitle: true,
//         elevation: 0,
//       ),
//       endDrawer: Drawer(
//         child: ClubDrawer(
//           club_uid: c_uid,
//           club_name: c_name,
//         ),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Padding(
//                     padding: EdgeInsets.fromLTRB(0, 20, 20, 10),
//                     child: ElevatedButton(
//                         onPressed: () async {
//                           var add_member_list = [];

//                           List select_user_id = [];

//                           if (success_member_name.length == 0) {
//                             _showDialog(context);
//                           } else {
//                             for (int i = 0;
//                                 i < success_member_name.length;
//                                 i++) {
//                               add_member_list.add([
//                                 {
//                                   "UserID": success_member_user_uid[i],
//                                   "Grade": "NomalUser",
//                                   "NickName": success_member_name[i],
//                                 }
//                               ]);
//                             }

//                             for (int i = 0; i < add_member_list.length; i++) {
//                               FirebaseFirestore.instance
//                                   .collection("Club")
//                                   .doc(c_uid)
//                                   .collection("ClubMember")
//                                   .doc("MemberList")
//                                   .update({
//                                 "ClubMember":
//                                     FieldValue.arrayUnion(add_member_list[i])
//                               });
//                             }

//                             ///
//                             /// 이 부분은 선택한 데이터 저장하는 부분
//                             ///
//                             // for (int i = 0; i < add_member_list.length; i++) {
//                             //   if (total_wait_join_member_user_uid[i] ==
//                             //       success_member_user_uid[i]) {
//                             //     select_user_id.add(success_member_user_uid[i]);
//                             //   }
//                             // }

//                             ///
//                             /// 이 부분은 선택한 데이터 삭제 부분
//                             ///
//                             for (int i = 0;
//                                 i < total_wait_join_member_name.length;
//                                 i++) {
//                               for (int j = 0;
//                                   j < success_member_name.length;
//                                   j++) {
//                                 if (total_wait_join_member_name[i] ==
//                                     success_member_name[j]) {
//                                   total_wait_join_member_name.removeAt(i);
//                                 }
//                               }
//                             }

//                             for (int i = 0;
//                                 i < total_wait_join_member_datetime.length;
//                                 i++) {
//                               for (int j = 0;
//                                   j < success_member_datetime.length;
//                                   j++) {
//                                 if (total_wait_join_member_datetime[i] ==
//                                     success_member_datetime[j]) {
//                                   total_wait_join_member_datetime.removeAt(i);
//                                 }
//                               }
//                             }

//                             for (int i = 0;
//                                 i < total_wait_join_member_user_uid.length;
//                                 i++) {
//                               for (int j = 0;
//                                   j < success_member_user_uid.length;
//                                   j++) {
//                                 if (total_wait_join_member_user_uid[i] ==
//                                     success_member_user_uid[j]) {
//                                   select_user_id
//                                       .add(total_wait_join_member_user_uid[i]);
//                                   total_wait_join_member_user_uid.removeAt(i);
//                                 }
//                               }
//                             }

//                             List wait_total = [];

//                             for (int i = 0;
//                                 i < total_wait_join_member_name.length;
//                                 i++) {
//                               wait_total.add({
//                                 "WaitUserName": total_wait_join_member_name[i],
//                                 "DateTime": total_wait_join_member_datetime[i],
//                                 "UserID": total_wait_join_member_user_uid[i]
//                               });
//                             }

//                             print(select_user_id);

//                             List club_id = [];

//                             club_id.add(c_uid);

//                             for (int i = 0; i < select_user_id.length; i++) {
//                               await FirebaseFirestore.instance
//                                   .collection("Users")
//                                   .doc(select_user_id[i])
//                                   .update({
//                                 "JoinClub": FieldValue.arrayUnion(club_id),
//                               });
//                             }

//                             FirebaseFirestore.instance
//                                 .collection("Club")
//                                 .doc(c_uid)
//                                 .collection("ClubMember")
//                                 .doc("WaitJoinClub")
//                                 .update({"WaitJoinClub": wait_total});

//                             wait_total.clear();
//                           }
//                         },
//                         style: ButtonStyle(
//                             backgroundColor:
//                                 MaterialStateProperty.all(Color(0xffFFFFFF)),
//                             elevation: MaterialStateProperty.all<double>(0.0)),
//                         child: Text(
//                           "완료",
//                           style: TextStyle(
//                               color: Colors.black,
//                               fontFamily: 'GSANSB',
//                               fontSize: 15.0),
//                         ))),
//               ],
//             ),
//             StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("Club")
//                     .doc(c_uid)
//                     .collection("ClubMember")
//                     .doc("WaitJoinClub")
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<DocumentSnapshot> snapshot) {
//                   if (snapshot.hasError) {
//                     return Text("Error!");
//                   } else if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   } else {
//                     Map<String, dynamic> data =
//                         snapshot.data!.data() as Map<String, dynamic>;
//                     List a = [];
//                     List b = [];
//                     List c = [];

//                     total_wait_join_member_name.clear();
//                     total_wait_join_member_datetime.clear();

//                     if (data["WaitJoinClub"] == null) {
//                       return Center(child: Text("가입 신청자가 없습니다."));
//                     } else {
//                       for (int i = 0; i < data["WaitJoinClub"].length; i++) {
//                         a.add(data["WaitJoinClub"][i]["WaitUserName"]);
//                         b.add(data["WaitJoinClub"][i]["DateTime"]);
//                         c.add(data["WaitJoinClub"][i]["UserUID"]);
//                         total_wait_join_member_name
//                             .add(data["WaitJoinClub"][i]["WaitUserName"]);
//                         total_wait_join_member_datetime
//                             .add(data["WaitJoinClub"][i]["DateTime"]);
//                         total_wait_join_member_user_uid
//                             .add(data["WaitJoinClub"][i]["UserUID"]);
//                         bol_member.add(false);
//                       }
//                     }

//                     //_imageToStorage(data);

//                     return Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//                           child: Container(
//                             height: MediaQuery.of(context).size.height - 200,
//                             width: MediaQuery.of(context).size.width,
//                             child: ListView.separated(
//                               itemCount: a.length,
//                               scrollDirection: Axis.vertical,
//                               shrinkWrap: true,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(5)),
//                                   child: ListTile(
//                                     /*leading: CircleAvatar(
//                                       backgroundColor: Colors.black,
//                                     ),*/
//                                     title: Text(a[index]),
//                                     subtitle: Text(b[index]),
//                                     trailing: Checkbox(
//                                       onChanged: (bool? val) {
//                                         setState(() {
//                                           bol_member[index] = val!;
//                                           if (bol_member[index] == true) {
//                                             success_member_name.add(a[index]);
//                                             success_member_datetime
//                                                 .add(b[index]);
//                                             success_member_user_uid
//                                                 .add(c[index]);
//                                             selected_index.add(index);
//                                             print(
//                                                 "success_member_name의 true 값" +
//                                                     success_member_name
//                                                         .toString());
//                                             print("success_member_uid의 true 값" +
//                                                 success_member_user_uid
//                                                     .toString());

//                                             print("selected_index의 true 값" +
//                                                 selected_index.toString());
//                                           } else if (bol_member[index] ==
//                                               false) {
//                                             success_member_name
//                                                 .remove(a[index]);
//                                             success_member_datetime
//                                                 .remove(b[index]);
//                                             success_member_user_uid
//                                                 .remove(c[index]);
//                                             selected_index.remove(index);
//                                             print(
//                                                 "success_member_name의 false 값" +
//                                                     success_member_name
//                                                         .toString());
//                                             print(
//                                                 "success_member_uid의 false 값" +
//                                                     success_member_user_uid
//                                                         .toString());

//                                             print("selected_index의 false 값" +
//                                                 selected_index.toString());
//                                           }
//                                         });
//                                         //success_member.clear();
//                                       },
//                                       value: bol_member[index],

//                                       ///
//                                       /// White로
//                                       ///
//                                       checkColor: Color(0xffFFFFFF),
//                                       fillColor: MaterialStateProperty.all(
//                                           Color(0xffe9394f)),
//                                     ),
//                                     onTap: () {},
//                                   ),
//                                 );
//                               },
//                               separatorBuilder:
//                                   (BuildContext context, int index) {
//                                 return Container(
//                                   height: 1,
//                                   color: Colors.grey[500],
//                                 );
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }
//                 }),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void _showDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("가입 승인 오류"),
//         content: Text("선택한 유저가 없습니다"),
//         actions: <Widget>[
//           ElevatedButton(
//             child: Text("나가기"),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
