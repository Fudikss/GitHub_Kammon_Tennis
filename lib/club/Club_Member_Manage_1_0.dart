import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/Club_Settings.dart';
import 'package:snstennis/club/club_drawer_1_0.dart';
import 'Club_Member_Join_List.dart';

class ClubMemberManage extends StatefulWidget {
  final String club_name;
  final String club_real_name;
  const ClubMemberManage(
      {Key? key, required this.club_name, required this.club_real_name})
      : super(key: key);

  @override
  _ClubMemberManageState createState() =>
      _ClubMemberManageState(club_name, club_real_name);
}

class _ClubMemberManageState extends State<ClubMemberManage> {
  String name = "";
  String club_real_name = '';
  String user_grade = "";
  User user = FirebaseAuth.instance.currentUser!;

  _ClubMemberManageState(this.name, this.club_real_name);

  @override
  Widget build(BuildContext context) {
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);

    String grade = userAccount_.grade;

    return Scaffold(
      endDrawer: Drawer(
        child: ClubDrawer(
          club_uid: name,
          club_name: club_real_name,
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        title: SvgPicture.asset(
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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
              child: Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xffFAE0D4),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Row(children: [
                    SizedBox(
                      width: 20,
                    ),
                    TextButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ClubMemberJoinList(
                              club_uid: name,
                              club_name: club_real_name,
                            );
                          }));
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xffFAE0D4))),
                        icon: Icon(
                          Icons.person_add,
                          color: Color(0xffe9394f),
                          size: 28.0,
                        ),
                        label: Text(
                          "가입 신청 목록",
                          style: TextStyle(
                              color: Color(0xffe9394f),
                              fontSize: 15.0,
                              fontFamily: 'GSANSB',
                              decorationThickness: 1),
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(120, 0, 0, 0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return ClubMemberJoinList(
                                club_uid: name,
                                club_name: club_real_name,
                              );
                            }));
                          },
                          icon: Icon(
                            Icons.keyboard_arrow_right,
                            color: Color(0xffe9394f),
                            size: 30.0,
                          )),
                    )
                  ]),
                ),
              ),
            ),
            StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Club")
                    .doc(name)
                    .collection("ClubMember")
                    .doc("MemberList")
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

                    if (data["ClubMember"] == null) {
                      return Container();
                    } else {
                      for (int i = 0; i < data["ClubMember"].length; i++) {
                        a.add(data["ClubMember"][i]["UserID"]);
                        b.add(data["ClubMember"][i]["Grade"]);
                        c.add(data["ClubMember"][i]["NickName"]);
                      }
                    }

                    //_imageToStorage(data);

                    return Expanded(
                      child: Column(
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
                                      // leading: Text(c[index]),

                                      leading: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(c[index],
                                                style: TextStyle(
                                                    fontFamily: 'GSANSB',
                                                    fontSize: 14)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                b[index] == "NomalUser"
                                                    ? "일반회원"
                                                    : b[index] == "SysOp"
                                                        ? "운영진"
                                                        : "마스터",
                                                style: TextStyle(
                                                    fontFamily: 'GSANSM',
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ),

                                      // title: Text(
                                      //     b[index] == "NomalUser"
                                      //         ? "일반회원"
                                      //         : b[index] == "SysOp"
                                      //             ? "운영진"
                                      //             : "마스터",
                                      //     style: TextStyle(
                                      //         fontFamily: 'GSANSM',
                                      //         fontSize: 14)),

                                      //subtitle: Text(b[index]),
                                      trailing: Icon(
                                        Icons.settings,
                                        color: Colors.red[200],
                                      ),

                                      onTap: () {
                                        if (grade == "Master" &&
                                            a[index] != user.uid) {
                                          _showDialog_Master(
                                              context, a, a[index], name, b, c);
                                        } else if (grade == "SysOp" &&
                                            a[index] != user.uid &&
                                            b[index] != "SysOp" &&
                                            b[index] != "Master") {
                                          _showDialog_SysOp(
                                              context, a, a[index], name, b, c);
                                        }
                                      },
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
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}

void _showDialog_Master(
    BuildContext context,
    List all_member,
    String choice_member,
    String club_name,
    List grade_list,
    List nick_name_list) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "회원 관리",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "권한 및 탈퇴",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        actions: <Widget>[
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text(
                      "권한 변경",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontFamily: 'GSANSM'),
                    ),
                    onPressed: () {
                      _showDialog_Change_Grade(context, all_member,
                          choice_member, club_name, grade_list, nick_name_list);
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(80, 20),
                        primary: Colors.white,
                        side: BorderSide(
                            width: 1, color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    child: Text(
                      "강제 탈퇴",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontFamily: 'GSANSM'),
                    ),
                    onPressed: () async {
                      List total_user = [];
                      String delete_user_uid = "";
                      List delete_user_uid_list = [];

                      for (int i = 0; i < all_member.length; i++) {
                        if (all_member[i] == choice_member) {
                          delete_user_uid = all_member[i];
                          delete_user_uid_list.add(club_name);

                          all_member.removeAt(i);
                          grade_list.removeAt(i);
                          nick_name_list.removeAt(i);
                        }
                      }

                      for (int i = 0; i < all_member.length; i++) {
                        total_user.add({
                          "UserID": all_member[i],
                          "Grade": grade_list[i],
                          "NickName": nick_name_list[i]
                        });
                      }

                      await FirebaseFirestore.instance
                          .collection("Club")
                          .doc(club_name)
                          .collection("ClubMember")
                          .doc("MemberList")
                          .update({"ClubMember": total_user});

                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(delete_user_uid)
                          .update({
                        "JoinClub": FieldValue.arrayRemove(delete_user_uid_list)
                      });

                      FirebaseFirestore.instance
                          .collection('Club')
                          .doc(club_name)
                          .update({
                        'MemberCount': FieldValue.increment(-1),
                      }).then((value) => print('ok'));

                      all_member.clear();
                      grade_list.clear();
                      Navigator.pop(context);
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text(
                      "권한 이임",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontFamily: 'GSANSM'),
                    ),
                    onPressed: () async {
                      List change_grade_member = [];
                      // List change_my_grade = [];

                      for (int i = 0; i < all_member.length; i++) {
                        if (all_member[i] == choice_member) {
                          grade_list[i] = "Master";
                        }
                        if (all_member[i] == user.uid) {
                          grade_list[i] = "NomalUser";
                        }
                      }

                      for (int i = 0; i < all_member.length; i++) {
                        change_grade_member.add({
                          "UserID": all_member[i],
                          "Grade": grade_list[i],
                          "NickName": nick_name_list[i]
                        });
                      }

                      FirebaseFirestore.instance
                          .collection("Club")
                          .doc(club_name)
                          .collection("ClubMember")
                          .doc("MemberList")
                          .update({"ClubMember": change_grade_member});

                      // all_member.clear();
                      // grade_list.clear();
                      change_grade_member.clear();

                      // 이 부분 Get.offAll()로 위치 변경하기
                      // Navigator.of(context)..pop()..pop()..pop()..pop();

                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(80, 20),
                        primary: Colors.white,
                        side: BorderSide(
                            width: 1, color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    child: Text(
                      "취소",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14,
                          fontFamily: 'GSANSM'),
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
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     ElevatedButton(
          //       child: Text(
          //         "권한 변경",
          //       ),
          //       onPressed: () {
          //         _showDialog_Change_Grade(context, all_member, choice_member,
          //             club_name, grade_list, nick_name_list);
          //       },
          //       style: OutlinedButton.styleFrom(
          //         backgroundColor: Color(0xffe9394f),
          //       ),
          //     ),
          //     SizedBox(
          //       width: 10,
          //     ),
          //     ElevatedButton(
          //       child: Text("강제 탈퇴"),
          //       onPressed: () async {
          //         List total_user = [];
          //         String delete_user_uid = "";
          //         List delete_user_uid_list = [];

          //         for (int i = 0; i < all_member.length; i++) {
          //           if (all_member[i] == choice_member) {
          //             delete_user_uid = all_member[i];
          //             delete_user_uid_list.add(club_name);

          //             all_member.removeAt(i);
          //             grade_list.removeAt(i);
          //             nick_name_list.removeAt(i);
          //           }
          //         }

          //         for (int i = 0; i < all_member.length; i++) {
          //           total_user.add({
          //             "UserID": all_member[i],
          //             "Grade": grade_list[i],
          //             "NickName": nick_name_list[i]
          //           });
          //         }

          //         await FirebaseFirestore.instance
          //             .collection("Club")
          //             .doc(club_name)
          //             .collection("ClubMember")
          //             .doc("MemberList")
          //             .update({"ClubMember": total_user});

          //         await FirebaseFirestore.instance
          //             .collection("Users")
          //             .doc(delete_user_uid)
          //             .update({
          //           "JoinClub": FieldValue.arrayRemove(delete_user_uid_list)
          //         });

          //         all_member.clear();
          //         grade_list.clear();
          //         Navigator.pop(context);
          //       },
          //       style: OutlinedButton.styleFrom(
          //         backgroundColor: Color(0xffe9394f),
          //       ),
          //     ),
          //     SizedBox(
          //       width: 10,
          //     ),
          //     ElevatedButton(
          //       child: Text("취소"),
          //       onPressed: () {
          //         Navigator.of(context).pop();
          //       },
          //     ),
          //   ],
          // ),
        ],
      );
    },
  );
}

void _showDialog_SysOp(
    BuildContext context,
    List all_member,
    String choice_member,
    String club_name,
    List grade_list,
    List nick_name_list) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "회원 관리",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "탈퇴",
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
                  "강제 탈퇴",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontFamily: 'GSANSM'),
                ),
                onPressed: () async {
                  List total_user = [];
                  String delete_user_uid = "";
                  List delete_user_uid_list = [];

                  for (int i = 0; i < all_member.length; i++) {
                    if (all_member[i] == choice_member) {
                      delete_user_uid = all_member[i];
                      delete_user_uid_list.add(club_name);

                      all_member.removeAt(i);
                      grade_list.removeAt(i);
                      nick_name_list.removeAt(i);
                    }
                  }

                  for (int i = 0; i < all_member.length; i++) {
                    total_user.add({
                      "UserID": all_member[i],
                      "Grade": grade_list[i],
                      "NickName": nick_name_list[i]
                    });
                  }
                  await FirebaseFirestore.instance
                      .collection("Club")
                      .doc(club_name)
                      .collection("ClubMember")
                      .doc("MemberList")
                      .update({"ClubMember": total_user});

                  await FirebaseFirestore.instance
                      .collection("Users")
                      .doc(delete_user_uid)
                      .update({
                    "JoinClub": FieldValue.arrayRemove(delete_user_uid_list)
                  });

                  all_member.clear();
                  grade_list.clear();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(80, 20),
                    primary: Colors.white,
                    side: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                child: Text(
                  "취소",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontFamily: 'GSANSM'),
                ),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(80, 20),
                    primary: Colors.white,
                    side: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}

void _showDialog_Change_Grade(
    BuildContext context,
    List all_member,
    String choice_member,
    String club_name,
    List grade_list,
    List nick_name_list) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "등급 변경",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "등급을 선택해주세요",
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
                  "운영자",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontFamily: 'GSANSM'),
                ),
                onPressed: () async {
                  List change_grade_member = [];

                  for (int i = 0; i < all_member.length; i++) {
                    if (all_member[i] == choice_member) {
                      grade_list[i] = "SysOp";
                    }
                  }

                  for (int i = 0; i < all_member.length; i++) {
                    change_grade_member.add({
                      "UserID": all_member[i],
                      "Grade": grade_list[i],
                      "NickName": nick_name_list[i]
                    });
                  }

                  print(change_grade_member);

                  await FirebaseFirestore.instance
                      .collection("Club")
                      .doc(club_name)
                      .collection("ClubMember")
                      .doc("MemberList")
                      .update({"ClubMember": change_grade_member});

                  // all_member.clear();
                  // grade_list.clear();
                  change_grade_member.clear();
                  Navigator.of(context)..pop()..pop();
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(80, 20),
                    primary: Colors.white,
                    side: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                child: Text(
                  "일반회원",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontFamily: 'GSANSM'),
                ),
                onPressed: () async {
                  List change_grade_member = [];

                  for (int i = 0; i < all_member.length; i++) {
                    if (all_member[i] == choice_member) {
                      grade_list[i] = "NomalUser";
                    }
                  }

                  for (int i = 0; i < all_member.length; i++) {
                    change_grade_member.add({
                      "UserID": all_member[i],
                      "Grade": grade_list[i],
                      "NickName": nick_name_list[i]
                    });
                  }

                  print(change_grade_member);

                  await FirebaseFirestore.instance
                      .collection("Club")
                      .doc(club_name)
                      .collection("ClubMember")
                      .doc("MemberList")
                      .update({"ClubMember": change_grade_member});

                  // all_member.clear();
                  // grade_list.clear();
                  change_grade_member.clear();
                  Navigator.of(context)..pop()..pop();
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(80, 20),
                    primary: Colors.white,
                    side: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                child: Text(
                  "취소",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontFamily: 'GSANSM'),
                ),
                onPressed: () {
                  int count = 2;
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
          ),
        ],
      );
    },
  );
}








//1.0.0.+7
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/club/club_drawer_1_0.dart';
// import 'Club_Member_Join_List.dart';

// class ClubMemberManage extends StatefulWidget {
//   final String club_name;
//   final String club_real_name;
//   const ClubMemberManage(
//       {Key? key, required this.club_name, required this.club_real_name})
//       : super(key: key);

//   @override
//   _ClubMemberManageState createState() =>
//       _ClubMemberManageState(club_name, club_real_name);
// }

// class _ClubMemberManageState extends State<ClubMemberManage> {
//   String name = "";
//   String club_real_name = '';
//   String user_grade = "";
//   User user = FirebaseAuth.instance.currentUser!;

//   _ClubMemberManageState(this.name, this.club_real_name);

//   @override
//   Widget build(BuildContext context) {
//     UserAccountInfo userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);

//     String grade = userAccount_.grade;

//     return Scaffold(
//       endDrawer: Drawer(
//         child: ClubDrawer(
//           club_uid: name,
//           club_name: club_real_name,
//         ),
//       ),
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFFFFFF),
//         iconTheme: IconThemeData(color: Colors.grey),
//         automaticallyImplyLeading: false,
//         title:
//           SvgPicture.asset(
//           'assets/images/SVG/LOGO_KAMMON_small.svg',
//           width: 110,
//         ),
//         actions: [],
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
//               child: Container(
//                 width: 350,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Color(0xffFAE0D4),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Center(
//                   child: Row(children: [
//                     SizedBox(
//                       width: 20,
//                     ),
//                     TextButton.icon(
//                         onPressed: () {
//                           Navigator.push(context, MaterialPageRoute(
//                               builder: (BuildContext context) {
//                             return ClubMemberJoinList(
//                               club_uid: name,
//                               club_name: club_real_name,
//                             );
//                           }));
//                         },
//                         style: ButtonStyle(
//                             backgroundColor:
//                                 MaterialStateProperty.all(Color(0xffFAE0D4))),
//                         icon: Icon(
//                           Icons.person_add,
//                           color: Color(0xffe9394f),
//                           size: 28.0,
//                         ),
//                         label: Text(
//                           "가입 신청 목록",
//                           style: TextStyle(
//                               color: Color(0xffe9394f),
//                               fontSize: 15.0,
//                               fontFamily: 'GSANSB',
//                               decorationThickness: 1),
//                         )),
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(120, 0, 0, 0),
//                       child: IconButton(
//                           onPressed: () {
//                             Navigator.push(context, MaterialPageRoute(
//                                 builder: (BuildContext context) {
//                               return ClubMemberJoinList(
//                                 club_uid: name,
//                                 club_name: club_real_name,
//                               );
//                             }));
//                           },
//                           icon: Icon(
//                             Icons.keyboard_arrow_right,
//                             color: Color(0xffe9394f),
//                             size: 30.0,
//                           )),
//                     )
//                   ]),
//                 ),
//               ),
//             ),
//             StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("Club")
//                     .doc(name)
//                     .collection("ClubMember")
//                     .doc("MemberList")
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

//                     if (data["ClubMember"] == null) {
//                       return Container();
//                     } else {
//                       for (int i = 0; i < data["ClubMember"].length; i++) {
//                         a.add(data["ClubMember"][i]["UserID"]);
//                         b.add(data["ClubMember"][i]["Grade"]);
//                         c.add(data["ClubMember"][i]["NickName"]);
//                       }
//                     }

//                     //_imageToStorage(data);

//                     return Expanded(
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//                             child: Container(
//                               height: MediaQuery.of(context).size.height - 200,
//                               width: MediaQuery.of(context).size.width,
//                               child: ListView.separated(
//                                 itemCount: a.length,
//                                 scrollDirection: Axis.vertical,
//                                 shrinkWrap: true,
//                                 itemBuilder: (BuildContext context, int index) {
//                                   return Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(5)),
//                                     child: ListTile(
//                                       /*leading: CircleAvatar(
//                                         backgroundColor: Colors.black,
//                                       ),*/
//                                       // leading: Text(c[index]),
//                                       title: Text(c[index]),
//                                       //subtitle: Text(b[index]),
//                                       trailing: Icon(
//                                         Icons.settings,
//                                         color: Colors.red[200],
//                                       ),
//                                       onTap: () {
//                                         if (grade == "Master" &&
//                                             a[index] != user.uid) {
//                                           _showDialog_Master(
//                                               context, a, a[index], name, b, c);
//                                         } else if (grade == "SysOp" &&
//                                             a[index] != user.uid &&
//                                             b[index] != "SysOp" &&
//                                             b[index] != "Master") {
//                                           _showDialog_SysOp(
//                                               context, a, a[index], name, b, c);
//                                         }
//                                       },
//                                     ),
//                                   );
//                                 },
//                                 separatorBuilder:
//                                     (BuildContext context, int index) {
//                                   return Container(
//                                     height: 1,
//                                     color: Colors.grey[500],
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                 }),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void _showDialog_Master(
//     BuildContext context,
//     List all_member,
//     String choice_member,
//     String club_name,
//     List grade_list,
//     List nick_name_list) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("회원 관리"),
//         content: Text("권한 및 탈퇴"),
//         actions: <Widget>[
//           ElevatedButton(
//             child: Text("권한 변경"),
//             onPressed: () {
//               _showDialog_Change_Grade(context, all_member, choice_member,
//                   club_name, grade_list, nick_name_list);
//             },
//             style: OutlinedButton.styleFrom(
//               backgroundColor: Color(0xffe9394f),
//             ),
//           ),
//           ElevatedButton(
//             child: Text("탈퇴"),
//             onPressed: () async {
//               List total_user = [];
//               String delete_user_uid = "";
//               List delete_user_uid_list = [];

//               for (int i = 0; i < all_member.length; i++) {
//                 if (all_member[i] == choice_member) {
//                   delete_user_uid = all_member[i];
//                   delete_user_uid_list.add(club_name);

//                   all_member.removeAt(i);
//                   grade_list.removeAt(i);
//                   nick_name_list.removeAt(i);
//                 }
//               }

//               for (int i = 0; i < all_member.length; i++) {
//                 total_user.add({
//                   "UserID": all_member[i],
//                   "Grade": grade_list[i],
//                   "NickName": nick_name_list[i]
//                 });
//               }

//               await FirebaseFirestore.instance
//                   .collection("Club")
//                   .doc(club_name)
//                   .collection("ClubMember")
//                   .doc("MemberList")
//                   .update({"ClubMember": total_user});

//               await FirebaseFirestore.instance
//                   .collection("Users")
//                   .doc(delete_user_uid)
//                   .update({
//                 "JoinClub": FieldValue.arrayRemove(delete_user_uid_list)
//               });

//               all_member.clear();
//               grade_list.clear();
//               Navigator.pop(context);
//             },
//             style: OutlinedButton.styleFrom(
//               backgroundColor: Color(0xffe9394f),
//             ),
//           ),
//           ElevatedButton(
//             child: Text("취소"),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

// void _showDialog_SysOp(
//     BuildContext context,
//     List all_member,
//     String choice_member,
//     String club_name,
//     List grade_list,
//     List nick_name_list) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("회원 관리"),
//         content: Text("탈퇴"),
//         actions: <Widget>[
//           ElevatedButton(
//             child: Text("탈퇴"),
//             onPressed: () async {
//               List total_user = [];
//               String delete_user_uid = "";
//               List delete_user_uid_list = [];

//               for (int i = 0; i < all_member.length; i++) {
//                 if (all_member[i] == choice_member) {
//                   delete_user_uid = all_member[i];
//                   delete_user_uid_list.add(club_name);

//                   all_member.removeAt(i);
//                   grade_list.removeAt(i);
//                   nick_name_list.removeAt(i);
//                 }
//               }

//               for (int i = 0; i < all_member.length; i++) {
//                 total_user.add({
//                   "UserID": all_member[i],
//                   "Grade": grade_list[i],
//                   "NickName": nick_name_list[i]
//                 });
//               }
//               await FirebaseFirestore.instance
//                   .collection("Club")
//                   .doc(club_name)
//                   .collection("ClubMember")
//                   .doc("MemberList")
//                   .update({"ClubMember": total_user});

//               await FirebaseFirestore.instance
//                   .collection("Users")
//                   .doc(delete_user_uid)
//                   .update({
//                 "JoinClub": FieldValue.arrayRemove(delete_user_uid_list)
//               });

//               all_member.clear();
//               grade_list.clear();
//               Navigator.pop(context);
//             },
//             style: OutlinedButton.styleFrom(
//               backgroundColor: Color(0xffe9394f),
//             ),
//           ),
//           ElevatedButton(
//             child: Text("취소"),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

// void _showDialog_Change_Grade(
//     BuildContext context,
//     List all_member,
//     String choice_member,
//     String club_name,
//     List grade_list,
//     List nick_name_list) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("등급 변경"),
//         content: Text("등급을 선택해주세요."),
//         actions: <Widget>[
//           ElevatedButton(
//             child: Text("운영자"),
//             onPressed: () async {
//               List change_grade_member = [];

//               for (int i = 0; i < all_member.length; i++) {
//                 if (all_member[i] == choice_member) {
//                   grade_list[i] = "SysOp";
//                 }
//               }

//               for (int i = 0; i < all_member.length; i++) {
//                 change_grade_member.add({
//                   "UserID": all_member[i],
//                   "Grade": grade_list[i],
//                   "NickName": nick_name_list[i]
//                 });
//               }

//               print(change_grade_member);

//               await FirebaseFirestore.instance
//                   .collection("Club")
//                   .doc(club_name)
//                   .collection("ClubMember")
//                   .doc("MemberList")
//                   .update({"ClubMember": change_grade_member});

//               // all_member.clear();
//               // grade_list.clear();
//               change_grade_member.clear();
//               Navigator.of(context)..pop()..pop();
//             },
//             style: OutlinedButton.styleFrom(
//               backgroundColor: Color(0xff87CE00),
//             ),
//           ),
//           ElevatedButton(
//             child: Text("일반회원"),
//             onPressed: () async {
//               List change_grade_member = [];

//               for (int i = 0; i < all_member.length; i++) {
//                 if (all_member[i] == choice_member) {
//                   grade_list[i] = "NomalUser";
//                 }
//               }

//               for (int i = 0; i < all_member.length; i++) {
//                 change_grade_member.add({
//                   "UserID": all_member[i],
//                   "Grade": grade_list[i],
//                   "NickName": nick_name_list[i]
//                 });
//               }

//               print(change_grade_member);

//               await FirebaseFirestore.instance
//                   .collection("Club")
//                   .doc(club_name)
//                   .collection("ClubMember")
//                   .doc("MemberList")
//                   .update({"ClubMember": change_grade_member});

//               // all_member.clear();
//               // grade_list.clear();
//               change_grade_member.clear();
//               Navigator.of(context)..pop()..pop();
//             },
//             style: OutlinedButton.styleFrom(
//               backgroundColor: Color(0xffEDD200),
//             ),
//           ),
//           ElevatedButton(
//             child: Text("취소"),
//             onPressed: () {
//               int count = 2;
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
