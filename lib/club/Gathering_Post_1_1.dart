import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';

class GatheringPost extends StatefulWidget {
  final String prev_post_title;
  final String prev_post_intro;
  final int post_index;
  final String club_uid;
  final String max_num;
  final String prev_post_nickname;
  final String prev_post_uid;
  final String prev_post_datetime;
  final String prev_join_id;
  const GatheringPost(
      {Key? key,
      required this.prev_post_title,
      required this.prev_post_intro,
      required this.club_uid,
      required this.max_num,
      required this.post_index,
      required this.prev_post_nickname,
      required this.prev_post_uid,
      required this.prev_post_datetime,
      required this.prev_join_id})
      : super(key: key);

  @override
  _GatheringPostState createState() => _GatheringPostState(
      prev_post_title,
      prev_post_intro,
      club_uid,
      max_num,
      post_index,
      prev_post_nickname,
      prev_post_uid,
      prev_post_datetime,
      prev_join_id);
}

class _GatheringPostState extends State<GatheringPost> {
  String post_title = "";
  String post_intro = "";
  String uid_club = "";
  String person_max = "";
  int num;

  String nickname = "";
  String check_post_uid = "";
  String date_time = "";
  String join_id = "";

  ///
  /// FloatingActionButton["나가기에 들어갈 데이터 모음"]
  ///
  String select_data_user_uid = "";
  late Map<String, dynamic> select_data_list;

  ///
  ///
  ///

  List<String> select_payment = ["선불", "후불"];

  bool change_button = false;

  int _selectedNaviIndex = 1;

  User user = FirebaseAuth.instance.currentUser!;
  _GatheringPostState(
      this.post_title,
      this.post_intro,
      this.uid_club,
      this.person_max,
      this.num,
      this.nickname,
      this.check_post_uid,
      this.date_time,
      this.join_id);

  Widget _get_List_Member(String post_name, String post_intro) {
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Club")
            .doc(uid_club)
            .collection("Post")
            .doc("GatheringPost")
            .collection("GatheringPostList")
            .doc(join_id)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Error!");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            Map<String, dynamic> data_list =
                snapshot.data!.data() as Map<String, dynamic>;

            select_data_list = snapshot.data!.data() as Map<String, dynamic>;

            List c = [];
            List d = [];
            List e = [];
            String data_user_uid = "";
            int person_num;

            int parse_int_var = int.parse(person_max);

            for (int i = 0; i < data_list[post_name].length; i++) {
              c.add(data_list[post_name][i]["User"]);
              d.add(data_list[post_name][i]["State"]);
              e.add(data_list[post_name][i]["NickName"]);
            }

            data_user_uid = data_list[post_name][0]["User"];

            select_data_user_uid = data_list[post_name][0]["User"];

            person_num = data_list[post_name].length;

            // WidgetsBinding.instance!.addPostFrameCallback((_) {
            //   setState(() {
            //     request_num = person_num;
            //   });
            // });

            // e..removeAt(0);
            // d..removeAt(0);

            for (int i = 0; i < c.length; i++) {
              if (c[i] == user.uid) {
                // setState(() {
                //   change_button = true;
                // });
                change_button = true;
              }
            }

            return Column(children: [
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          post_name,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'GSANSB',
                          ),
                        ),
                        Text(
                          person_num.toString() + "/" + person_max,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'GSANSM',
                          ),
                        ),
                      ]),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Divider(
                      thickness: 1.5,
                      height: 1.5,
                      color: Colors.grey.shade400)),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  // width: 350,
                  // decoration: BoxDecoration(
                  //   color: Color(0xffFBD6C2),
                  //   borderRadius: BorderRadius.circular(5),
                  //   //border: Border.all(color: Colors.grey),
                  // ),
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                      width: 2,
                      color: Colors.grey.shade400,
                    )),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text(
                      post_intro,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'GSANSM',
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          nickname,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'GSANSM',
                              color: Colors.grey[600]),
                        ),
                        Text(
                          "주최자",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'GSANSM',
                              color: Colors.grey[600]),
                        ),
                      ]),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Divider(
                      thickness: 1.5,
                      height: 1.5,
                      color: Colors.grey.shade400)),
              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: Container(
                    height: 280,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleChildScrollView(
                          child: Card(
                            elevation: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Theme.of(context).primaryColorLight,
                                    width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                /*leading: CircleAvatar(
                                                    ///
                                                    /// 이미지 출력 함수 구현 해야함
                                                    ///
                                                  ),*/
                                title: Text(
                                  e[index],
                                  style: TextStyle(fontFamily: "GSANSB"),
                                ),
                                trailing: Text(d[index]),
                                onTap: () {},
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 1,
                        );
                      },
                      itemCount: e.length,
                    ),
                  ),
                ),
              ),
              BottomAppBar(
                elevation: 0,
                child: change_button == false
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        "결제 방식 선택",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                            fontFamily: 'GSANSM'),
                                      ),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: [
                                            Text(
                                              "결제는 선불 및 후불만 가능합니다.",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 16,
                                                  fontFamily: 'GSANSM'),
                                            )
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            ///
                                            /// User데이터에 자신의 UID가 들어가야함
                                            ///

                                            List gathering_join_data = [
                                              {
                                                "User": user.uid,
                                                "State": "선불",
                                                "NickName":
                                                    userAccount_.nickname
                                              }
                                            ];

                                            FirebaseFirestore.instance
                                                .collection("Club")
                                                .doc(uid_club)
                                                .collection("Post")
                                                .doc("GatheringPost")
                                                .collection("GatheringPostList")
                                                .doc(join_id)
                                                .update({
                                              post_title: FieldValue.arrayUnion(
                                                  gathering_join_data),
                                            });

                                            // FirebaseFirestore.instance
                                            //     .collection("Club")
                                            //     .doc(uid_club)
                                            //     .collection("Post")
                                            //     .doc("GatheringPost")
                                            //     .set({
                                            //   "GatheringPost": FieldValue.arrayUnion(
                                            //     [
                                            //       {
                                            //         "ClubPostTitle": "모여라",
                                            //         "ClubPostIntro": "모여라",
                                            //         "DateTime": "2021.11.29",
                                            //         "GatheringMaster":
                                            //             "esecTqk7hZPpiwyn1cZC6P0oiha2",
                                            //         "MaxNumber": "4",
                                            //         "NickName": "푸딩조아",
                                            //         "PersonNumber": person_num + 1,
                                            //       },
                                            //       SetOptions(merge: true),
                                            //     ],
                                            //   ),
                                            // });

                                            setState(() {
                                              change_button = true;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "선불",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontFamily: 'GSANSM'),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: Size(80, 20),
                                              primary: Colors.white,
                                              side: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5))),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            ///
                                            /// User데이터에 자신의 UID가 들어가야함
                                            ///
                                            List gathering_join_data = [
                                              {
                                                "User": user.uid,
                                                "State": "후불",
                                                "NickName":
                                                    userAccount_.nickname
                                              }
                                            ];

                                            FirebaseFirestore.instance
                                                .collection("Club")
                                                .doc(uid_club)
                                                .collection("Post")
                                                .doc("GatheringPost")
                                                .collection("GatheringPostList")
                                                .doc(join_id)
                                                .update({
                                              post_title: FieldValue.arrayUnion(
                                                  gathering_join_data)
                                            });

                                            setState(() {
                                              change_button = true;
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "후불",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontFamily: 'GSANSM'),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: Size(80, 20),
                                              primary: Colors.white,
                                              side: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5))),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "취소",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontFamily: 'GSANSM'),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              fixedSize: Size(80, 20),
                                              primary: Colors.white,
                                              side: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5))),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              "모임 참여하기",
                              style: TextStyle(
                                  fontFamily: 'GSANSB',
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                            style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Color(0xffe9394f),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Color(0xffe9394f),
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(50)),
                                elevation: 0),
                          ),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
                          child: data_user_uid == user.uid
                              ? Container()
                              : ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              "모임 나가기",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 16,
                                                  fontFamily: 'GSANSM'),
                                            ),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: [
                                                  Text(
                                                    "해당 모임에서 나가시겠습니까?",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 16,
                                                        fontFamily: 'GSANSM'),
                                                  )
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  ////
                                                  /// 로그인한 상태에서 자신의 UID로 탐색 후 일치하면 삭제 안되면 미삭제
                                                  ///
                                                  String uid = user.uid;

                                                  ///
                                                  /// boolean값으로 UID 탐색 후 삭제
                                                  ///

                                                  List gathering_member_user =
                                                      [];
                                                  List gathering_member_state =
                                                      [];
                                                  List
                                                      gathering_member_nickname =
                                                      [];

                                                  List total = [];

                                                  for (int i = 0;
                                                      i <
                                                          data_list[post_title]
                                                              .length;
                                                      i++) {
                                                    gathering_member_user.add(
                                                        data_list[post_title][i]
                                                            ["User"]);
                                                    gathering_member_state.add(
                                                        data_list[post_title][i]
                                                            ["State"]);
                                                    gathering_member_nickname
                                                        .add(data_list[
                                                                post_title][i]
                                                            ["NickName"]);
                                                  }

                                                  for (int i = 0;
                                                      i <
                                                          gathering_member_user
                                                              .length;
                                                      i++) {
                                                    if (gathering_member_user[
                                                            i] ==
                                                        uid) {
                                                      gathering_member_user
                                                          .removeAt(i);
                                                      gathering_member_state
                                                          .removeAt(i);
                                                      gathering_member_nickname
                                                          .removeAt(i);
                                                    }
                                                  }

                                                  for (int i = 0;
                                                      i <
                                                          gathering_member_user
                                                              .length;
                                                      i++) {
                                                    total.add({
                                                      "User":
                                                          gathering_member_user[
                                                              i],
                                                      "State":
                                                          gathering_member_state[
                                                              i],
                                                      "NickName":
                                                          gathering_member_nickname[
                                                              i]
                                                    });
                                                  }

                                                  try {
                                                    FirebaseFirestore.instance
                                                        .collection("Club")
                                                        .doc(uid_club)
                                                        .collection("Post")
                                                        .doc("GatheringPost")
                                                        .collection(
                                                            "GatheringPostList")
                                                        .doc(join_id)
                                                        .update({
                                                      post_title: total
                                                    });
                                                  } catch (e) {
                                                    print(e);
                                                  }
                                                  setState(() {
                                                    change_button = false;
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "나가기",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 14,
                                                      fontFamily: 'GSANSM'),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    fixedSize: Size(80, 20),
                                                    primary: Colors.white,
                                                    side: BorderSide(
                                                        width: 1,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "취소",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 14,
                                                      fontFamily: 'GSANSM'),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    fixedSize: Size(80, 20),
                                                    primary: Colors.white,
                                                    side: BorderSide(
                                                        width: 1,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Text(
                                    "모임 나가기",
                                    style: TextStyle(
                                        fontFamily: 'GSANSB',
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                      primary: Colors.white,
                                      backgroundColor: Color(0xffe9394f),
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color(0xffe9394f),
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      elevation: 0),
                                ),
                        ),
                      ),
              ),
            ]);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        // title:
        //     // Image.asset(
        //     //   'assets/images/PNG/logo2.png',
        //     //   width: 110,
        //     // ),
        //     SvgPicture.asset(
        //   'assets/images/SVG/LOGO_horizontal.svg',
        //   width: 110,
        // ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (BuildContext context) => ClubMainPage(club_uid: club_uid, club_name: name),
            //   ),
            // );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          TextButton(
              onPressed: () {
                if (check_post_uid == user.uid ||
                    userAccount_.grade == "SysOp" ||
                    userAccount_.grade == "Master") {
                  _showDialog_delete(context, post_title, post_intro, date_time,
                      nickname, check_post_uid, uid_club, person_max, join_id);
                } else {
                  _showDialog_grade_error(
                    context,
                  );
                }
              },
              child: Text(
                "게시글 삭제",
                style: TextStyle(color: Colors.black, fontFamily: "GSANSM"),
              ))
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [_get_List_Member(post_title, post_intro)],
            ),
          ),
        ),
      ),
      // floatingActionButton: change_button == false
      //     ? Container(
      //         width: 70,
      //         height: 70,
      //         child: Padding(
      //           padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      //           child: ElevatedButton(
      //             onPressed: () {
      //               showDialog(
      //                   context: context,
      //                   barrierDismissible: false,
      //                   builder: (BuildContext context) {
      //                     return AlertDialog(
      //                       title: Text("결제 방식 선택"),
      //                       content: SingleChildScrollView(
      //                         child: ListBody(
      //                           children: [Text("결제는 선불 및 후불만 가능합니다.")],
      //                         ),
      //                       ),
      //                       actions: [
      //                         ElevatedButton(
      //                           onPressed: () {
      //                             ///
      //                             /// User데이터에 자신의 UID가 들어가야함
      //                             ///

      //                             List gathering_join_data = [
      //                               {
      //                                 "User": user.uid,
      //                                 "State": "선불",
      //                                 "NickName": userAccount_.nickname
      //                               }
      //                             ];

      //                             FirebaseFirestore.instance
      //                                 .collection("Club")
      //                                 .doc(uid_club)
      //                                 .collection("Post")
      //                                 .doc("GatheringPost")
      //                                 .collection("GatheringPostList")
      //                                 .doc("GatheringJoinList")
      //                                 .update({
      //                               post_title: FieldValue.arrayUnion(
      //                                   gathering_join_data),
      //                             });

      //                             // FirebaseFirestore.instance
      //                             //     .collection("Club")
      //                             //     .doc(uid_club)
      //                             //     .collection("Post")
      //                             //     .doc("GatheringPost")
      //                             //     .set({
      //                             //   "GatheringPost": FieldValue.arrayUnion(
      //                             //     [
      //                             //       {
      //                             //         "ClubPostTitle": "모여라",
      //                             //         "ClubPostIntro": "모여라",
      //                             //         "DateTime": "2021.11.29",
      //                             //         "GatheringMaster":
      //                             //             "esecTqk7hZPpiwyn1cZC6P0oiha2",
      //                             //         "MaxNumber": "4",
      //                             //         "NickName": "푸딩조아",
      //                             //         "PersonNumber": person_num + 1,
      //                             //       },
      //                             //       SetOptions(merge: true),
      //                             //     ],
      //                             //   ),
      //                             // });

      //                             setState(() {
      //                               change_button = true;
      //                             });
      //                             Navigator.pop(context);
      //                           },
      //                           child: Text("선불"),
      //                         ),
      //                         ElevatedButton(
      //                             onPressed: () {
      //                               ///
      //                               /// User데이터에 자신의 UID가 들어가야함
      //                               ///
      //                               List gathering_join_data = [
      //                                 {
      //                                   "User": user.uid,
      //                                   "State": "후불",
      //                                   "NickName": userAccount_.nickname
      //                                 }
      //                               ];

      //                               FirebaseFirestore.instance
      //                                   .collection("Club")
      //                                   .doc(uid_club)
      //                                   .collection("Post")
      //                                   .doc("GatheringPost")
      //                                   .collection("GatheringPostList")
      //                                   .doc("GatheringJoinList")
      //                                   .update({
      //                                 post_title: FieldValue.arrayUnion(
      //                                     gathering_join_data)
      //                               });

      //                               setState(() {
      //                                 change_button = true;
      //                               });
      //                               Navigator.pop(context);
      //                             },
      //                             child: Text("후불")),
      //                         ElevatedButton(
      //                             onPressed: () {
      //                               Navigator.pop(context);
      //                             },
      //                             child: Text("취소")),
      //                       ],
      //                     );
      //                   });
      //             },
      //             child: Text(
      //               "참여",
      //               style: TextStyle(
      //                   fontFamily: 'GSANSB',
      //                   fontSize: 18,
      //                   color: Colors.white),
      //             ),
      //             style: OutlinedButton.styleFrom(
      //                 primary: Colors.white,
      //                 backgroundColor: Color(0xffe9394f),
      //                 shape: RoundedRectangleBorder(
      //                     side: BorderSide(
      //                         color: Color(0xffe9394f),
      //                         width: 1,
      //                         style: BorderStyle.solid),
      //                     borderRadius: BorderRadius.circular(50)),
      //                 elevation: 5),
      //           ),
      //         ),
      //       )
      //     : Container(
      //         width: 70,
      //         height: 70,
      //         child: Padding(
      //           padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      //           child: select_data_user_uid == user.uid
      //               ? Container()
      //               : ElevatedButton(
      //                   onPressed: () {
      //                     showDialog(
      //                         context: context,
      //                         barrierDismissible: false,
      //                         builder: (BuildContext context) {
      //                           return AlertDialog(
      //                             title: Text("모임 나가기"),
      //                             content: SingleChildScrollView(
      //                               child: ListBody(
      //                                 children: [Text("해당 모임에서 나가시겠습니까?")],
      //                               ),
      //                             ),
      //                             actions: [
      //                               ElevatedButton(
      //                                   onPressed: () async {
      //                                     ////
      //                                     /// 로그인한 상태에서 자신의 UID로 탐색 후 일치하면 삭제 안되면 미삭제
      //                                     ///
      //                                     String uid = user.uid;

      //                                     ///
      //                                     /// boolean값으로 UID 탐색 후 삭제
      //                                     ///

      //                                     List gathering_member_user = [];
      //                                     List gathering_member_state = [];
      //                                     List gathering_member_nickname = [];

      //                                     List total = [];

      //                                     for (int i = 0;
      //                                         i <
      //                                             select_data_list[post_title]
      //                                                 .length;
      //                                         i++) {
      //                                       gathering_member_user.add(
      //                                           select_data_list[post_title][i]
      //                                               ["User"]);
      //                                       gathering_member_state.add(
      //                                           select_data_list[post_title][i]
      //                                               ["State"]);
      //                                       gathering_member_nickname.add(
      //                                           select_data_list[post_title][i]
      //                                               ["NickName"]);
      //                                     }

      //                                     for (int i = 0;
      //                                         i < gathering_member_user.length;
      //                                         i++) {
      //                                       if (gathering_member_user[i] ==
      //                                           uid) {
      //                                         gathering_member_user.removeAt(i);
      //                                         gathering_member_state
      //                                             .removeAt(i);
      //                                         gathering_member_nickname
      //                                             .removeAt(i);
      //                                       }
      //                                     }

      //                                     for (int i = 0;
      //                                         i < gathering_member_user.length;
      //                                         i++) {
      //                                       total.add({
      //                                         "User": gathering_member_user[i],
      //                                         "State":
      //                                             gathering_member_state[i],
      //                                         "NickName":
      //                                             gathering_member_nickname[i]
      //                                       });
      //                                     }

      //                                     try {
      //                                       FirebaseFirestore.instance
      //                                           .collection("Club")
      //                                           .doc(uid_club)
      //                                           .collection("Post")
      //                                           .doc("GatheringPost")
      //                                           .collection("GatheringPostList")
      //                                           .doc("GatheringJoinList")
      //                                           .update({post_title: total});
      //                                     } catch (e) {
      //                                       print(e);
      //                                     }
      //                                     setState(() {
      //                                       change_button = false;
      //                                     });

      //                                     Navigator.pop(context);
      //                                   },
      //                                   child: Text("나가기")),
      //                               ElevatedButton(
      //                                   onPressed: () {
      //                                     Navigator.pop(context);
      //                                   },
      //                                   child: Text("취소")),
      //                             ],
      //                           );
      //                         });
      //                   },
      //                   child: Text(
      //                     "나가기",
      //                     style: TextStyle(
      //                         fontFamily: 'GSANSB',
      //                         fontSize: 15,
      //                         color: Colors.white),
      //                   ),
      //                   style: OutlinedButton.styleFrom(
      //                       primary: Colors.white,
      //                       backgroundColor: Color(0xffe9394f),
      //                       shape: RoundedRectangleBorder(
      //                           side: BorderSide(
      //                               color: Color(0xffe9394f),
      //                               width: 1,
      //                               style: BorderStyle.solid),
      //                           borderRadius: BorderRadius.circular(50)),
      //                       elevation: 5),
      //                 ),
      //         ),
      //       ),
    );
  }
}

void _showDialog_delete(
    BuildContext context,
    String title,
    String intro,
    String date_time,
    String nick_name,
    String user_uid,
    String club_uid,
    String max_num,
    String join_id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "게시글 삭제",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "정말로 삭제하시겠습니까?",
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
                  "삭제",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontFamily: 'GSANSM'),
                ),
                onPressed: () {
                  List delete_data = [
                    {
                      "ClubPostTitle": title,
                      "ClubPostIntro": intro,
                      "DateTime": date_time,
                      "NickName": nick_name,
                      "GatheringMaster": user_uid,
                      "MaxNumber": max_num,
                      "PersonNumber": 1,
                      "GatheringPostJoinList": join_id
                    }
                  ];

                  FirebaseFirestore.instance
                      .collection("Club")
                      .doc(club_uid)
                      .collection("Post")
                      .doc("GatheringPost")
                      .update({
                    "GatheringPost": FieldValue.arrayRemove(delete_data)
                  });

                  FirebaseFirestore.instance
                      .collection("Club")
                      .doc(club_uid)
                      .collection("Post")
                      .doc("GatheringPost")
                      .collection("GatheringPostList")
                      .doc(join_id)
                      .delete();
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
                width: 30,
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

void _showDialog_grade_error(
  BuildContext context,
) {
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
                side:
                    BorderSide(width: 1, color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
          ),
        ],
      );
    },
  );
}
