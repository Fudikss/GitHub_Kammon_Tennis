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

  bool gathering_participation_button = false;
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

    // bool participation_button_lesson = true;
    // bool participation_button_novice = false;
    // bool participation_button_game = false;

    // bool gathering_pre_payment = false;
    // bool gathering_deferred_payment = false;

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

            List grade_list = [];
            List participation = [];
            List guest_list = [];
            List profile_list = [];

            int parse_int_var = int.parse(person_max);

            bool lesson_check = false;
            bool game_check = false;
            bool num_check = false;

            String gathering_parti = "";

            for (int i = 0; i < data_list[post_name].length; i++) {
              c.add(data_list[post_name][i]["User"]);
              d.add(data_list[post_name][i]["State"]);
              e.add(data_list[post_name][i]["NickName"]);
              grade_list.add(data_list[post_name][i]["Grade"]);
              participation.add(data_list[post_name][i]["Participation"]);
              guest_list.add(data_list[post_name][i]["Guest"]);
              profile_list.add(data_list[post_name][i]["Profile_image"]);
            }

            data_user_uid = data_list[post_name][0]["User"];

            select_data_user_uid = data_list[post_name][0]["User"];

            person_num = data_list[post_name].length;

            gathering_parti = data_list["Gathering_participation"];

            int num_person = data_list["PersonNum"];

            if (gathering_parti == "on") {
              gathering_participation_button = true;
            }

            if (num_person == parse_int_var) {
              num_check = true;
            }

            ///
            /// Lesson User Total List
            ///
            List participation_uid = [];
            List participation_payment = [];
            List participation_nick_name = [];
            List participation_grade = [];
            List participation_participation = [];
            List participation_guest = [];
            List participation_profile_image = [];

            List game_play_uid = [];
            List game_play_payment = [];
            List game_play_nick_name = [];
            List game_play_grade = [];
            List game_play_participation = [];
            List game_play_guest = [];
            List game_play_profile_image = [];

            List management_uid = [];
            List management_payment = [];
            List management_nick_name = [];
            List management_grade = [];
            List management_participation = [];
            List management_guest = [];
            List management_profile_image = [];

            for (int i = 0; i < c.length; i++) {
              if (participation[i] == "레슨") {
                lesson_check = true;
                participation_uid.add(data_list[post_name][i]["User"]);
                participation_payment.add(data_list[post_name][i]["State"]);
                participation_nick_name
                    .add(data_list[post_name][i]["NickName"]);
                participation_grade.add(data_list[post_name][i]["Grade"]);
                participation_participation
                    .add(data_list[post_name][i]["Participation"]);
                participation_guest.add(data_list[post_name][i]["Guest"]);
                participation_profile_image
                    .add(data_list[post_name][i]["Profile_image"]);
              } else if (participation[i] == "게임") {
                game_check = true;
                game_play_uid.add(data_list[post_name][i]["User"]);
                game_play_payment.add(data_list[post_name][i]["State"]);
                game_play_nick_name.add(data_list[post_name][i]["NickName"]);
                game_play_grade.add(data_list[post_name][i]["Grade"]);
                game_play_participation
                    .add(data_list[post_name][i]["Participation"]);
                game_play_guest.add(data_list[post_name][i]["Guest"]);
                game_play_profile_image
                    .add(data_list[post_name][i]["Profile_image"]);
              } else {
                management_uid.add(data_list[post_name][i]["User"]);
                management_payment.add(data_list[post_name][i]["State"]);
                management_nick_name.add(data_list[post_name][i]["NickName"]);
                management_grade.add(data_list[post_name][i]["Grade"]);
                management_participation
                    .add(data_list[post_name][i]["Participation"]);
                management_guest.add(data_list[post_name][i]["Guest"]);
                management_profile_image
                    .add(data_list[post_name][i]["Profile_image"]);
              }
            }

            for (int i = 0; i < c.length; i++) {
              if (c[i] == user.uid) {
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
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            border:
                                Border.all(color: Color(0xffFBD6C2), width: 1)),
                        child: Center(
                            child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return AlertDialog(
                                      content: Container(
                                        height:
                                            MediaQuery.of(context).size.height -
                                                100,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.separated(
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                // height: MediaQuery.of(context)
                                                //         .size
                                                //         .height -
                                                //     100,
                                                height: 140,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                    right: BorderSide(
                                                                        width:
                                                                            1.5,
                                                                        color: Colors
                                                                            .grey))),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          5,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  child: Row(
                                                                    children: [
                                                                      profile_list[index] ==
                                                                              ""
                                                                          ? Container(
                                                                              width: 35,
                                                                              height: 35,
                                                                              child: ClipRRect(
                                                                                  borderRadius: BorderRadius.circular(40),
                                                                                  child: SvgPicture.asset(
                                                                                    'assets/images/SVG/profile_pink.svg',
                                                                                    width: 40,
                                                                                  )),
                                                                            )
                                                                          : Container(
                                                                              width: 35,
                                                                              height: 35,
                                                                              child: CircleAvatar(backgroundColor: Colors.white, radius: 120, backgroundImage: NetworkImage(profile_list[index])),
                                                                            ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        e[index],
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "GSANSM",
                                                                            fontSize:
                                                                                13),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          10,
                                                                          0,
                                                                          10),
                                                                  child: Container(
                                                                      height: 1,
                                                                      width:
                                                                          110,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                grade_list[index] ==
                                                                        "NomalUser"
                                                                    ? Text(
                                                                        "일반회원",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "GSANSM",
                                                                            fontSize:
                                                                                15),
                                                                      )
                                                                    : Text(
                                                                        "운영진",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "GSANSM",
                                                                            fontSize:
                                                                                15),
                                                                      ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          10,
                                                                          0,
                                                                          10),
                                                                  child: Container(
                                                                      height: 1,
                                                                      width:
                                                                          110,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                Text(
                                                                  "초대 : " +
                                                                      guest_list[
                                                                          index],
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "GSANSM",
                                                                      fontSize:
                                                                          15),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    participation[
                                                                        index],
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "GSANSM",
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            10),
                                                                    child: Container(
                                                                        height:
                                                                            1,
                                                                        width:
                                                                            170,
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                  Text(
                                                                    d[index],
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "GSANSM",
                                                                        fontSize:
                                                                            20),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return Container(
                                                height: 10,
                                                color: Colors.grey[100],
                                              );
                                            },
                                            itemCount: c.length),
                                      ),
                                    );
                                  });
                                });
                          },
                          child: Text(
                            "총인원",
                            style:
                                TextStyle(fontFamily: "GSANSM", fontSize: 20),
                          ),
                        )),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            border:
                                Border.all(color: Color(0xffFBD6C2), width: 1)),
                        child: Center(
                            child: Text(
                          person_num.toString() + "명",
                          style: TextStyle(fontFamily: "GSANSM", fontSize: 20),
                        )),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      data_user_uid == user.uid
                          ? Container(
                              height: 100,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (gathering_participation_button == false) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "모임 모집 완료",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 16,
                                                fontFamily: 'GSANSM'),
                                          ),
                                          content: Text(
                                            "모임 모집을 완료 하시겠습니까?",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 14,
                                                fontFamily: 'GSANSM'),
                                          ),
                                          actions: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  child: Text(
                                                    "예",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 16,
                                                        fontFamily: 'GSANSM'),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                      fixedSize: Size(80, 20),
                                                      primary: Colors.white,
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5))),
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection("Club")
                                                        .doc(uid_club)
                                                        .collection("Post")
                                                        .doc("GatheringPost")
                                                        .collection(
                                                            "GatheringPostList")
                                                        .doc(join_id)
                                                        .update({
                                                      "Gathering_participation":
                                                          "on"
                                                    });

                                                    setState(() {
                                                      gathering_participation_button =
                                                          true;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                ElevatedButton(
                                                  child: Text(
                                                    "아니요",
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
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5))),
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
                                  } else {
                                    return;
                                  }
                                },
                                child: Text("모임 마감 하기"),
                              ))
                          : gathering_participation_button == false
                              ? num_check
                                  ? GestureDetector(
                                      onTap: () {
                                        if (change_button == true) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                  "모임 참가 취소",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 16,
                                                      fontFamily: 'GSANSM'),
                                                ),
                                                content: Text(
                                                  "해당 모임 참가를 취소하시겠습니까?",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 16,
                                                      fontFamily: 'GSANSM'),
                                                ),
                                                actions: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ElevatedButton(
                                                        child: Text(
                                                          "예",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'GSANSM'),
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                            fixedSize:
                                                                Size(80, 20),
                                                            primary:
                                                                Colors.white,
                                                            side: BorderSide(
                                                                width: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5))),
                                                        onPressed: () {
                                                          String delete_grade =
                                                              "";
                                                          String delete_guest =
                                                              "";
                                                          String
                                                              delete_nick_name =
                                                              "";
                                                          String
                                                              delete_participation =
                                                              "";
                                                          String
                                                              delete_profile_iamge =
                                                              "";
                                                          String delete_state =
                                                              "";
                                                          String delete_user =
                                                              "";

                                                          for (int i = 0;
                                                              i < c.length;
                                                              i++) {
                                                            if (c[i] ==
                                                                user.uid) {
                                                              delete_user =
                                                                  c[i];
                                                              delete_profile_iamge =
                                                                  profile_list[
                                                                      i];

                                                              delete_state =
                                                                  d[i];
                                                              delete_grade =
                                                                  grade_list[i];
                                                              delete_participation =
                                                                  participation[
                                                                      i];
                                                              delete_nick_name =
                                                                  e[i];
                                                              delete_guest =
                                                                  guest_list[i];
                                                              break;
                                                            }
                                                          }

                                                          List delete_list = [
                                                            {
                                                              "Grade":
                                                                  delete_grade,
                                                              "Guest":
                                                                  delete_guest,
                                                              "NickName":
                                                                  delete_nick_name,
                                                              "Participation":
                                                                  delete_participation,
                                                              "Profile_image":
                                                                  delete_profile_iamge,
                                                              "State":
                                                                  delete_state,
                                                              "User":
                                                                  delete_user
                                                            }
                                                          ];

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Club")
                                                              .doc(uid_club)
                                                              .collection(
                                                                  "Post")
                                                              .doc(
                                                                  "GatheringPost")
                                                              .collection(
                                                                  "GatheringPostList")
                                                              .doc(join_id)
                                                              .update({
                                                            post_title
                                                                    .toString():
                                                                FieldValue
                                                                    .arrayRemove(
                                                                        delete_list)
                                                          });

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Club")
                                                              .doc(uid_club)
                                                              .collection(
                                                                  "Post")
                                                              .doc(
                                                                  "GatheringPost")
                                                              .collection(
                                                                  "GatheringPostList")
                                                              .doc(join_id)
                                                              .update({
                                                            "PersonNum":
                                                                FieldValue
                                                                    .increment(
                                                                        -1)
                                                          });

                                                          setState(() {
                                                            change_button =
                                                                false;
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      ElevatedButton(
                                                        child: Text(
                                                          "아니요",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'GSANSM'),
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                            fixedSize:
                                                                Size(80, 20),
                                                            primary:
                                                                Colors.white,
                                                            side: BorderSide(
                                                                width: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5))),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          _showDialog_unParticipation_Error(
                                              context);
                                        }
                                        // String delete_grade = "";
                                        // String delete_guest = "";
                                        // String delete_nick_name = "";
                                        // String delete_participation = "";
                                        // String delete_profile_iamge = "";
                                        // String delete_state = "";
                                        // String delete_user = "";

                                        // for (int i = 0; i < c.length; i++) {
                                        //   if (c[i] == user.uid) {
                                        //     delete_user = c[i];
                                        //     delete_profile_iamge =
                                        //         profile_list[i];
                                        //     delete_state = d[i];
                                        //     delete_grade = grade_list[i];
                                        //     delete_participation =
                                        //         participation[i];
                                        //     delete_nick_name = e[i];
                                        //     delete_guest = guest_list[i];
                                        //     break;
                                        //   }
                                        // }

                                        // List delete_list = [
                                        //   {
                                        //     "Grade": delete_grade,
                                        //     "Guest": delete_guest,
                                        //     "NickName": delete_nick_name,
                                        //     "Participation":
                                        //         delete_participation,
                                        //     "Profile_image":
                                        //         delete_profile_iamge,
                                        //     "State": delete_state,
                                        //     "User": delete_user
                                        //   }
                                        // ];

                                        // FirebaseFirestore.instance
                                        //     .collection("Club")
                                        //     .doc(uid_club)
                                        //     .collection("Post")
                                        //     .doc("GatheringPost")
                                        //     .collection("GatheringPostList")
                                        //     .doc(join_id)
                                        //     .update({
                                        //   post_title.toString():
                                        //       FieldValue.arrayRemove(
                                        //           delete_list)
                                        // });

                                        // FirebaseFirestore.instance
                                        //     .collection("Club")
                                        //     .doc(uid_club)
                                        //     .collection("Post")
                                        //     .doc("GatheringPost")
                                        //     .collection("GatheringPostList")
                                        //     .doc(join_id)
                                        //     .update({
                                        //   "PersonNum": FieldValue.increment(-1)
                                        // });

                                        // setState(() {
                                        //   change_button = false;
                                        // });
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.green,
                                        child: Text(
                                          "인원 충족 & 참가 취소",
                                          style: TextStyle(
                                              fontFamily: "GSANSM",
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : change_button
                                      ? Container(
                                          height: 100,
                                          width: 100,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (change_button == true) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "모임 참가 취소",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'GSANSM'),
                                                      ),
                                                      content: Text(
                                                        "해당 모임 참가를 취소하시겠습니까?",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'GSANSM'),
                                                      ),
                                                      actions: <Widget>[
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            ElevatedButton(
                                                              child: Text(
                                                                "예",
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'GSANSM'),
                                                              ),
                                                              style: ElevatedButton.styleFrom(
                                                                  fixedSize:
                                                                      Size(80,
                                                                          20),
                                                                  primary: Colors
                                                                      .white,
                                                                  side: BorderSide(
                                                                      width: 1,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5))),
                                                              onPressed: () {
                                                                String
                                                                    delete_grade =
                                                                    "";
                                                                String
                                                                    delete_guest =
                                                                    "";
                                                                String
                                                                    delete_nick_name =
                                                                    "";
                                                                String
                                                                    delete_participation =
                                                                    "";
                                                                String
                                                                    delete_profile_iamge =
                                                                    "";
                                                                String
                                                                    delete_state =
                                                                    "";
                                                                String
                                                                    delete_user =
                                                                    "";

                                                                for (int i = 0;
                                                                    i < c.length;
                                                                    i++) {
                                                                  if (c[i] ==
                                                                      user.uid) {
                                                                    delete_user =
                                                                        c[i];
                                                                    delete_profile_iamge =
                                                                        profile_list[
                                                                            i];

                                                                    delete_state =
                                                                        d[i];
                                                                    delete_grade =
                                                                        grade_list[
                                                                            i];
                                                                    delete_participation =
                                                                        participation[
                                                                            i];
                                                                    delete_nick_name =
                                                                        e[i];
                                                                    delete_guest =
                                                                        guest_list[
                                                                            i];
                                                                    break;
                                                                  }
                                                                }

                                                                List
                                                                    delete_list =
                                                                    [
                                                                  {
                                                                    "Grade":
                                                                        delete_grade,
                                                                    "Guest":
                                                                        delete_guest,
                                                                    "NickName":
                                                                        delete_nick_name,
                                                                    "Participation":
                                                                        delete_participation,
                                                                    "Profile_image":
                                                                        delete_profile_iamge,
                                                                    "State":
                                                                        delete_state,
                                                                    "User":
                                                                        delete_user
                                                                  }
                                                                ];

                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "Club")
                                                                    .doc(
                                                                        uid_club)
                                                                    .collection(
                                                                        "Post")
                                                                    .doc(
                                                                        "GatheringPost")
                                                                    .collection(
                                                                        "GatheringPostList")
                                                                    .doc(
                                                                        join_id)
                                                                    .update({
                                                                  post_title
                                                                          .toString():
                                                                      FieldValue
                                                                          .arrayRemove(
                                                                              delete_list)
                                                                });

                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "Club")
                                                                    .doc(
                                                                        uid_club)
                                                                    .collection(
                                                                        "Post")
                                                                    .doc(
                                                                        "GatheringPost")
                                                                    .collection(
                                                                        "GatheringPostList")
                                                                    .doc(
                                                                        join_id)
                                                                    .update({
                                                                  "PersonNum":
                                                                      FieldValue
                                                                          .increment(
                                                                              -1)
                                                                });

                                                                setState(() {
                                                                  change_button =
                                                                      false;
                                                                });
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            ElevatedButton(
                                                              child: Text(
                                                                "아니요",
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'GSANSM'),
                                                              ),
                                                              style: ElevatedButton.styleFrom(
                                                                  fixedSize:
                                                                      Size(80,
                                                                          20),
                                                                  primary: Colors
                                                                      .white,
                                                                  side: BorderSide(
                                                                      width: 1,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5))),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              } else {
                                                _showDialog_unParticipation_Error(
                                                    context);
                                              }
                                              // String delete_grade = "";
                                              // String delete_guest = "";
                                              // String delete_nick_name = "";
                                              // String delete_participation = "";
                                              // String delete_profile_iamge = "";
                                              // String delete_state = "";
                                              // String delete_user = "";

                                              // for (int i = 0;
                                              //     i < c.length;
                                              //     i++) {
                                              //   if (c[i] == user.uid) {
                                              //     delete_user = c[i];
                                              //     delete_profile_iamge =
                                              //         profile_list[i];

                                              //     delete_state = d[i];
                                              //     delete_grade = grade_list[i];
                                              //     delete_participation =
                                              //         participation[i];
                                              //     delete_nick_name = e[i];
                                              //     delete_guest = guest_list[i];
                                              //     break;
                                              //   }
                                              // }

                                              // List delete_list = [
                                              //   {
                                              //     "Grade": delete_grade,
                                              //     "Guest": delete_guest,
                                              //     "NickName": delete_nick_name,
                                              //     "Participation":
                                              //         delete_participation,
                                              //     "Profile_image":
                                              //         delete_profile_iamge,
                                              //     "State": delete_state,
                                              //     "User": delete_user
                                              //   }
                                              // ];

                                              // FirebaseFirestore.instance
                                              //     .collection("Club")
                                              //     .doc(uid_club)
                                              //     .collection("Post")
                                              //     .doc("GatheringPost")
                                              //     .collection(
                                              //         "GatheringPostList")
                                              //     .doc(join_id)
                                              //     .update({
                                              //   post_title.toString():
                                              //       FieldValue.arrayRemove(
                                              //           delete_list)
                                              // });

                                              // FirebaseFirestore.instance
                                              //     .collection("Club")
                                              //     .doc(uid_club)
                                              //     .collection("Post")
                                              //     .doc("GatheringPost")
                                              //     .collection(
                                              //         "GatheringPostList")
                                              //     .doc(join_id)
                                              //     .update({
                                              //   "PersonNum":
                                              //       FieldValue.increment(-1)
                                              // });

                                              // setState(() {
                                              //   change_button = false;
                                              // });
                                            },
                                            child: Text(
                                              "참가 취소",
                                              style: TextStyle(
                                                  fontFamily: "GSANSM",
                                                  color: Colors.white),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                fixedSize: Size(60, 20),
                                                primary: Theme.of(context)
                                                    .primaryColor,
                                                side: BorderSide(
                                                    width: 1,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
                                          ))
                                      : Container(
                                          height: 100,
                                          width: 100,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder:
                                                        (BuildContext context) {
                                                      bool
                                                          participation_button_lesson =
                                                          false;
                                                      bool
                                                          participation_button_game =
                                                          false;

                                                      bool
                                                          gathering_pre_payment =
                                                          false;
                                                      bool
                                                          gathering_deferred_payment =
                                                          false;

                                                      String participation = "";
                                                      String payment = "";

                                                      return StatefulBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            StateSetter
                                                                setState) {
                                                          return AlertDialog(
                                                            title: Center(
                                                              child: Text(
                                                                "참가 & 결제 선택",
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'GSANSM'),
                                                              ),
                                                            ),
                                                            content:
                                                                SingleChildScrollView(
                                                              child: ListBody(
                                                                children: [
                                                                  Text(
                                                                    "결제는 선불 및 후불만 가능합니다.",
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            'GSANSM'),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            actions: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            20,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "참가 유형",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              'GSANSM',
                                                                          fontSize:
                                                                              13.0),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          participation_button_lesson =
                                                                              !participation_button_lesson;
                                                                          participation_button_game =
                                                                              false;

                                                                          participation =
                                                                              "레슨";
                                                                        });
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                          fixedSize: Size(
                                                                              60,
                                                                              20),
                                                                          primary: participation_button_lesson
                                                                              ? Theme.of(context)
                                                                                  .primaryColor
                                                                              : Colors
                                                                                  .white,
                                                                          side: BorderSide(
                                                                              width: 1,
                                                                              color: Theme.of(context).primaryColor),
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                                      child:
                                                                          Text(
                                                                        "레슨",
                                                                        style: TextStyle(
                                                                            color: participation_button_lesson
                                                                                ? Colors.white
                                                                                : Theme.of(context).primaryColor,
                                                                            fontSize: 12.0,
                                                                            fontFamily: 'GSANSM'),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          participation_button_game =
                                                                              !participation_button_game;
                                                                          participation_button_lesson =
                                                                              false;

                                                                          participation =
                                                                              "게임";
                                                                        });
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                          fixedSize: Size(
                                                                              60,
                                                                              20),
                                                                          primary: participation_button_game
                                                                              ? Theme.of(context)
                                                                                  .primaryColor
                                                                              : Colors
                                                                                  .white,
                                                                          side: BorderSide(
                                                                              width: 1,
                                                                              color: Theme.of(context).primaryColor),
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                                      child:
                                                                          Text(
                                                                        "게임",
                                                                        style: TextStyle(
                                                                            color: participation_button_game
                                                                                ? Colors.white
                                                                                : Theme.of(context).primaryColor,
                                                                            fontSize: 12.0,
                                                                            fontFamily: 'GSANSM'),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            20,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "결제 유형",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              'GSANSM',
                                                                          fontSize:
                                                                              13.0),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          gathering_pre_payment =
                                                                              !gathering_pre_payment;
                                                                          gathering_deferred_payment =
                                                                              false;
                                                                          payment =
                                                                              "선불";
                                                                        });
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                          fixedSize: Size(
                                                                              60,
                                                                              20),
                                                                          primary: gathering_pre_payment
                                                                              ? Theme.of(context)
                                                                                  .primaryColor
                                                                              : Colors
                                                                                  .white,
                                                                          side: BorderSide(
                                                                              width: 1,
                                                                              color: Theme.of(context).primaryColor),
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                                      child:
                                                                          Text(
                                                                        "선불",
                                                                        style: TextStyle(
                                                                            color: gathering_pre_payment
                                                                                ? Colors.white
                                                                                : Theme.of(context).primaryColor,
                                                                            fontSize: 12.0,
                                                                            fontFamily: 'GSANSM'),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          gathering_deferred_payment =
                                                                              !gathering_deferred_payment;
                                                                          gathering_pre_payment =
                                                                              false;

                                                                          payment =
                                                                              "후불";
                                                                        });
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                          fixedSize: Size(
                                                                              60,
                                                                              20),
                                                                          primary: gathering_deferred_payment
                                                                              ? Theme.of(context)
                                                                                  .primaryColor
                                                                              : Colors
                                                                                  .white,
                                                                          side: BorderSide(
                                                                              width: 1,
                                                                              color: Theme.of(context).primaryColor),
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                                      child:
                                                                          Text(
                                                                        "후불",
                                                                        style: TextStyle(
                                                                            color: gathering_deferred_payment
                                                                                ? Colors.white
                                                                                : Theme.of(context).primaryColor,
                                                                            fontSize: 12.0,
                                                                            fontFamily: 'GSANSM'),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            80,
                                                                            0,
                                                                            0),
                                                                child: Center(
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      if (participation !=
                                                                              "" &&
                                                                          payment !=
                                                                              "") {
                                                                        List
                                                                            gathering_join_data =
                                                                            [
                                                                          {
                                                                            "User":
                                                                                user.uid,
                                                                            "State":
                                                                                payment,
                                                                            "NickName":
                                                                                userAccount_.nickname,
                                                                            "Grade":
                                                                                userAccount_.grade,
                                                                            "Participation":
                                                                                participation,
                                                                            "Guest":
                                                                                "0",
                                                                            "Profile_image":
                                                                                userAccount_.profile_image
                                                                          }
                                                                        ];

                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection("Club")
                                                                            .doc(uid_club)
                                                                            .collection("Post")
                                                                            .doc("GatheringPost")
                                                                            .collection("GatheringPostList")
                                                                            .doc(join_id)
                                                                            .update({
                                                                          post_title:
                                                                              FieldValue.arrayUnion(gathering_join_data),
                                                                        });

                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection(
                                                                                "Club")
                                                                            .doc(
                                                                                uid_club)
                                                                            .collection(
                                                                                "Post")
                                                                            .doc(
                                                                                "GatheringPost")
                                                                            .collection(
                                                                                "GatheringPostList")
                                                                            .doc(
                                                                                join_id)
                                                                            .update({
                                                                          "PersonNum":
                                                                              FieldValue.increment(1)
                                                                        });

                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      } else {
                                                                        print(
                                                                            "참가 신청 공백");
                                                                      }
                                                                    },
                                                                    style: ElevatedButton.styleFrom(
                                                                        fixedSize: Size(
                                                                            150,
                                                                            30),
                                                                        primary:
                                                                            Theme.of(context)
                                                                                .primaryColor,
                                                                        side: BorderSide(
                                                                            width:
                                                                                1,
                                                                            color: Theme.of(context)
                                                                                .primaryColor),
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5))),
                                                                    child: Text(
                                                                      "참가",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              20.0,
                                                                          fontFamily:
                                                                              'GSANSM'),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color(0xffe9394f),
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color:
                                                              Color(0xffe9394f),
                                                          width: 1,
                                                          style: BorderStyle
                                                              .solid),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50)),
                                                  elevation: 0),
                                              child: Text("참가하기",
                                                  style: TextStyle(
                                                      fontFamily: "GSANSB",
                                                      fontSize: 16,
                                                      color: Colors.white))),
                                        )
                              : GestureDetector(
                                  onTap: () {
                                    if (change_button == true) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              "모임 참가 취소",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 16,
                                                  fontFamily: 'GSANSM'),
                                            ),
                                            content: Text(
                                              "해당 모임 참가를 취소하시겠습니까?",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 16,
                                                  fontFamily: 'GSANSM'),
                                            ),
                                            actions: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    child: Text(
                                                      "예",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 16,
                                                          fontFamily: 'GSANSM'),
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                        fixedSize: Size(80, 20),
                                                        primary: Colors.white,
                                                        side: BorderSide(
                                                            width: 1,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                                    onPressed: () {
                                                      String delete_grade = "";
                                                      String delete_guest = "";
                                                      String delete_nick_name =
                                                          "";
                                                      String
                                                          delete_participation =
                                                          "";
                                                      String
                                                          delete_profile_iamge =
                                                          "";
                                                      String delete_state = "";
                                                      String delete_user = "";

                                                      for (int i = 0;
                                                          i < c.length;
                                                          i++) {
                                                        if (c[i] == user.uid) {
                                                          delete_user = c[i];
                                                          delete_profile_iamge =
                                                              profile_list[i];

                                                          delete_state = d[i];
                                                          delete_grade =
                                                              grade_list[i];
                                                          delete_participation =
                                                              participation[i];
                                                          delete_nick_name =
                                                              e[i];
                                                          delete_guest =
                                                              guest_list[i];
                                                          break;
                                                        }
                                                      }

                                                      List delete_list = [
                                                        {
                                                          "Grade": delete_grade,
                                                          "Guest": delete_guest,
                                                          "NickName":
                                                              delete_nick_name,
                                                          "Participation":
                                                              delete_participation,
                                                          "Profile_image":
                                                              delete_profile_iamge,
                                                          "State": delete_state,
                                                          "User": delete_user
                                                        }
                                                      ];

                                                      FirebaseFirestore.instance
                                                          .collection("Club")
                                                          .doc(uid_club)
                                                          .collection("Post")
                                                          .doc("GatheringPost")
                                                          .collection(
                                                              "GatheringPostList")
                                                          .doc(join_id)
                                                          .update({
                                                        post_title.toString():
                                                            FieldValue
                                                                .arrayRemove(
                                                                    delete_list)
                                                      });

                                                      FirebaseFirestore.instance
                                                          .collection("Club")
                                                          .doc(uid_club)
                                                          .collection("Post")
                                                          .doc("GatheringPost")
                                                          .collection(
                                                              "GatheringPostList")
                                                          .doc(join_id)
                                                          .update({
                                                        "PersonNum": FieldValue
                                                            .increment(-1)
                                                      });

                                                      setState(() {
                                                        change_button = false;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  ElevatedButton(
                                                    child: Text(
                                                      "아니요",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontSize: 16,
                                                          fontFamily: 'GSANSM'),
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                        fixedSize: Size(80, 20),
                                                        primary: Colors.white,
                                                        side: BorderSide(
                                                            width: 1,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      _showDialog_unParticipation_Error(
                                          context);
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.black,
                                    child: Text(
                                      "마감 & 참가 취소",
                                      style: TextStyle(
                                          fontFamily: "GSANSM",
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // if (lesson_check == true) {
                                //   showDialog(
                                //       context: context,
                                //       builder: (BuildContext context) {
                                //         return StatefulBuilder(builder:
                                //             (BuildContext context,
                                //                 StateSetter setState) {
                                //           return AlertDialog(
                                //             content: Container(
                                //               height: MediaQuery.of(context)
                                //                       .size
                                //                       .height -
                                //                   100,
                                //               width: MediaQuery.of(context)
                                //                   .size
                                //                   .width,
                                //               child: ListView.separated(
                                //                   itemBuilder:
                                //                       (BuildContext context,
                                //                           int index) {
                                //                     return Container(
                                //                       // height: MediaQuery.of(context)
                                //                       //         .size
                                //                       //         .height -
                                //                       //     100,
                                //                       height: 140,
                                //                       width:
                                //                           MediaQuery.of(context)
                                //                               .size
                                //                               .width,
                                //                       decoration: BoxDecoration(
                                //                           border: Border.all(
                                //                               width: 1,
                                //                               color:
                                //                                   Colors.grey),
                                //                           borderRadius:
                                //                               BorderRadius
                                //                                   .circular(
                                //                                       10)),
                                //                       child: Column(
                                //                         children: [
                                //                           Expanded(
                                //                             child: Row(
                                //                               mainAxisAlignment:
                                //                                   MainAxisAlignment
                                //                                       .start,
                                //                               crossAxisAlignment:
                                //                                   CrossAxisAlignment
                                //                                       .center,
                                //                               children: [
                                //                                 Container(
                                //                                   decoration: BoxDecoration(
                                //                                       border: Border(
                                //                                           right: BorderSide(
                                //                                               width: 1.5,
                                //                                               color: Colors.grey))),
                                //                                   child: Column(
                                //                                     crossAxisAlignment:
                                //                                         CrossAxisAlignment
                                //                                             .center,
                                //                                     mainAxisAlignment:
                                //                                         MainAxisAlignment
                                //                                             .center,
                                //                                     children: [
                                //                                       Padding(
                                //                                         padding: EdgeInsets.fromLTRB(
                                //                                             5,
                                //                                             0,
                                //                                             10,
                                //                                             0),
                                //                                         child:
                                //                                             Row(
                                //                                           children: [
                                //                                             profile_list[index] == ""
                                //                                                 ? Container(
                                //                                                     width: 35,
                                //                                                     height: 35,
                                //                                                     child: ClipRRect(
                                //                                                         borderRadius: BorderRadius.circular(40),
                                //                                                         child: SvgPicture.asset(
                                //                                                           'assets/images/SVG/profile_pink.svg',
                                //                                                           width: 40,
                                //                                                         )),
                                //                                                   )
                                //                                                 : Container(
                                //                                                     width: 35,
                                //                                                     height: 35,
                                //                                                     child: CircleAvatar(backgroundColor: Colors.white, radius: 120, backgroundImage: NetworkImage(participation_profile_image[index])),
                                //                                                   ),
                                //                                             SizedBox(
                                //                                               width: 5,
                                //                                             ),
                                //                                             Text(
                                //                                               participation_nick_name[index],
                                //                                               style: TextStyle(fontFamily: "GSANSM", fontSize: 13),
                                //                                             )
                                //                                           ],
                                //                                         ),
                                //                                       ),
                                //                                       Padding(
                                //                                         padding: EdgeInsets.fromLTRB(
                                //                                             0,
                                //                                             10,
                                //                                             0,
                                //                                             10),
                                //                                         child: Container(
                                //                                             height:
                                //                                                 1,
                                //                                             width:
                                //                                                 110,
                                //                                             color:
                                //                                                 Colors.grey),
                                //                                       ),
                                //                                       participation_grade[index] ==
                                //                                               "NomalUser"
                                //                                           ? Text(
                                //                                               "일반회원",
                                //                                               style: TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                //                                             )
                                //                                           : Text(
                                //                                               "운영진",
                                //                                               style: TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                //                                             ),
                                //                                       Padding(
                                //                                         padding: EdgeInsets.fromLTRB(
                                //                                             0,
                                //                                             10,
                                //                                             0,
                                //                                             10),
                                //                                         child: Container(
                                //                                             height:
                                //                                                 1,
                                //                                             width:
                                //                                                 110,
                                //                                             color:
                                //                                                 Colors.grey),
                                //                                       ),
                                //                                       Text(
                                //                                         "초대 : " +
                                //                                             participation_guest[index],
                                //                                         style: TextStyle(
                                //                                             fontFamily:
                                //                                                 "GSANSM",
                                //                                             fontSize:
                                //                                                 15),
                                //                                       )
                                //                                     ],
                                //                                   ),
                                //                                 ),
                                //                                 Expanded(
                                //                                   child:
                                //                                       Container(
                                //                                     child:
                                //                                         Column(
                                //                                       crossAxisAlignment:
                                //                                           CrossAxisAlignment
                                //                                               .center,
                                //                                       mainAxisAlignment:
                                //                                           MainAxisAlignment
                                //                                               .center,
                                //                                       children: [
                                //                                         Text(
                                //                                           participation_participation[
                                //                                               index],
                                //                                           style: TextStyle(
                                //                                               fontFamily: "GSANSM",
                                //                                               fontSize: 20),
                                //                                         ),
                                //                                         Padding(
                                //                                           padding: EdgeInsets.fromLTRB(
                                //                                               0,
                                //                                               10,
                                //                                               0,
                                //                                               10),
                                //                                           child: Container(
                                //                                               height: 1,
                                //                                               width: 170,
                                //                                               color: Colors.grey),
                                //                                         ),
                                //                                         Text(
                                //                                           participation_payment[
                                //                                               index],
                                //                                           style: TextStyle(
                                //                                               fontFamily: "GSANSM",
                                //                                               fontSize: 20),
                                //                                         ),
                                //                                       ],
                                //                                     ),
                                //                                   ),
                                //                                 )
                                //                               ],
                                //                             ),
                                //                           )
                                //                         ],
                                //                       ),
                                //                     );
                                //                   },
                                //                   separatorBuilder:
                                //                       (BuildContext context,
                                //                           int index) {
                                //                     return Container(
                                //                       height: 10,
                                //                       color: Colors.grey[100],
                                //                     );
                                //                   },
                                //                   itemCount:
                                //                       participation_uid.length),
                                //             ),
                                //           );
                                //         });
                                //       });
                                // } else {
                                //   showDialog(
                                //       context: context,
                                //       builder: (BuildContext context) {
                                //         return Container(
                                //           height: MediaQuery.of(context)
                                //                   .size
                                //                   .height -
                                //               100,
                                //           width:
                                //               MediaQuery.of(context).size.width,
                                //           color: Colors.grey[100],
                                //           child: Center(
                                //             child: Column(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.center,
                                //                 children: [
                                //                   Icon(
                                //                     Icons.error_outline,
                                //                     size: 50,
                                //                     color: Colors.grey[500],
                                //                   ),
                                //                   SizedBox(
                                //                     height: 10,
                                //                   ),
                                //                   Text(
                                //                     '등록된',
                                //                     style: TextStyle(
                                //                         fontFamily: 'GSANSM',
                                //                         fontSize: 12,
                                //                         color:
                                //                             Colors.grey[600]),
                                //                   ),
                                //                   Text(
                                //                     '참가자가 없습니다.',
                                //                     style: TextStyle(
                                //                         fontFamily: 'GSANSM',
                                //                         fontSize: 12,
                                //                         color:
                                //                             Colors.grey[600]),
                                //                   )
                                //                 ]),
                                //           ),
                                //         );
                                //       });
                                // }
                              },
                              child: Text(
                                "레슨",
                                style: TextStyle(
                                    fontFamily: "GSANSB",
                                    fontSize: 24,
                                    color: Colors.grey[400]),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            lesson_check
                                ? GestureDetector(
                                    onTap: () {
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       return StatefulBuilder(builder:
                                      //           (BuildContext context,
                                      //               StateSetter setState) {
                                      //         return AlertDialog(
                                      //           content: Container(
                                      //             height: MediaQuery.of(context)
                                      //                     .size
                                      //                     .height -
                                      //                 100,
                                      //             width: MediaQuery.of(context)
                                      //                 .size
                                      //                 .width,
                                      //             child: ListView.separated(
                                      //                 itemBuilder:
                                      //                     (BuildContext context,
                                      //                         int index) {
                                      //                   return Container(
                                      //                     // height: MediaQuery.of(context)
                                      //                     //         .size
                                      //                     //         .height -
                                      //                     //     100,
                                      //                     height: 140,
                                      //                     width: MediaQuery.of(
                                      //                             context)
                                      //                         .size
                                      //                         .width,
                                      //                     decoration: BoxDecoration(
                                      //                         border: Border.all(
                                      //                             width: 1,
                                      //                             color: Colors
                                      //                                 .grey),
                                      //                         borderRadius:
                                      //                             BorderRadius
                                      //                                 .circular(
                                      //                                     10)),
                                      //                     child: Column(
                                      //                       children: [
                                      //                         Expanded(
                                      //                           child: Row(
                                      //                             mainAxisAlignment:
                                      //                                 MainAxisAlignment
                                      //                                     .start,
                                      //                             crossAxisAlignment:
                                      //                                 CrossAxisAlignment
                                      //                                     .center,
                                      //                             children: [
                                      //                               Container(
                                      //                                 decoration:
                                      //                                     BoxDecoration(
                                      //                                         border: Border(right: BorderSide(width: 1.5, color: Colors.grey))),
                                      //                                 child:
                                      //                                     Column(
                                      //                                   crossAxisAlignment:
                                      //                                       CrossAxisAlignment.center,
                                      //                                   mainAxisAlignment:
                                      //                                       MainAxisAlignment.center,
                                      //                                   children: [
                                      //                                     Padding(
                                      //                                       padding: EdgeInsets.fromLTRB(
                                      //                                           5,
                                      //                                           0,
                                      //                                           10,
                                      //                                           0),
                                      //                                       child:
                                      //                                           Row(
                                      //                                         children: [
                                      //                                           profile_list[index] == ""
                                      //                                               ? Container(
                                      //                                                   width: 35,
                                      //                                                   height: 35,
                                      //                                                   child: ClipRRect(
                                      //                                                       borderRadius: BorderRadius.circular(40),
                                      //                                                       child: SvgPicture.asset(
                                      //                                                         'assets/images/SVG/profile_pink.svg',
                                      //                                                         width: 40,
                                      //                                                       )),
                                      //                                                 )
                                      //                                               : Container(
                                      //                                                   width: 35,
                                      //                                                   height: 35,
                                      //                                                   child: CircleAvatar(backgroundColor: Colors.white, radius: 120, backgroundImage: NetworkImage(participation_profile_image[index])),
                                      //                                                 ),
                                      //                                           SizedBox(
                                      //                                             width: 5,
                                      //                                           ),
                                      //                                           Text(
                                      //                                             participation_nick_name[index],
                                      //                                             style: TextStyle(fontFamily: "GSANSM", fontSize: 13),
                                      //                                           )
                                      //                                         ],
                                      //                                       ),
                                      //                                     ),
                                      //                                     Padding(
                                      //                                       padding: EdgeInsets.fromLTRB(
                                      //                                           0,
                                      //                                           10,
                                      //                                           0,
                                      //                                           10),
                                      //                                       child: Container(
                                      //                                           height: 1,
                                      //                                           width: 110,
                                      //                                           color: Colors.grey),
                                      //                                     ),
                                      //                                     participation_grade[index] == "NomalUser"
                                      //                                         ? Text(
                                      //                                             "일반회원",
                                      //                                             style: TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                      //                                           )
                                      //                                         : Text(
                                      //                                             "운영진",
                                      //                                             style: TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                      //                                           ),
                                      //                                     Padding(
                                      //                                       padding: EdgeInsets.fromLTRB(
                                      //                                           0,
                                      //                                           10,
                                      //                                           0,
                                      //                                           10),
                                      //                                       child: Container(
                                      //                                           height: 1,
                                      //                                           width: 110,
                                      //                                           color: Colors.grey),
                                      //                                     ),
                                      //                                     Text(
                                      //                                       "초대 : " +
                                      //                                           participation_guest[index],
                                      //                                       style:
                                      //                                           TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                      //                                     )
                                      //                                   ],
                                      //                                 ),
                                      //                               ),
                                      //                               Expanded(
                                      //                                 child:
                                      //                                     Container(
                                      //                                   child:
                                      //                                       Column(
                                      //                                     crossAxisAlignment:
                                      //                                         CrossAxisAlignment.center,
                                      //                                     mainAxisAlignment:
                                      //                                         MainAxisAlignment.center,
                                      //                                     children: [
                                      //                                       Text(
                                      //                                         participation_participation[index],
                                      //                                         style: TextStyle(fontFamily: "GSANSM", fontSize: 20),
                                      //                                       ),
                                      //                                       Padding(
                                      //                                         padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      //                                         child: Container(height: 1, width: 170, color: Colors.grey),
                                      //                                       ),
                                      //                                       Text(
                                      //                                         participation_payment[index],
                                      //                                         style: TextStyle(fontFamily: "GSANSM", fontSize: 20),
                                      //                                       ),
                                      //                                     ],
                                      //                                   ),
                                      //                                 ),
                                      //                               )
                                      //                             ],
                                      //                           ),
                                      //                         )
                                      //                       ],
                                      //                     ),
                                      //                   );
                                      //                 },
                                      //                 separatorBuilder:
                                      //                     (BuildContext context,
                                      //                         int index) {
                                      //                   return Container(
                                      //                     height: 10,
                                      //                     color:
                                      //                         Colors.grey[100],
                                      //                   );
                                      //                 },
                                      //                 itemCount:
                                      //                     participation_uid
                                      //                         .length),
                                      //           ),
                                      //         );
                                      //       });
                                      //     });
                                    },
                                    child: Text(
                                      participation_uid.length.toString() + "명",
                                      style: TextStyle(
                                          fontFamily: "GSANSB",
                                          fontSize: 20,
                                          color: Colors.grey[300]),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       return Container(
                                      //         color: Colors.grey[100],
                                      //         child: Center(
                                      //           child: Column(
                                      //               mainAxisAlignment:
                                      //                   MainAxisAlignment
                                      //                       .center,
                                      //               children: [
                                      //                 Icon(
                                      //                   Icons.error_outline,
                                      //                   size: 50,
                                      //                   color: Colors.grey[500],
                                      //                 ),
                                      //                 SizedBox(
                                      //                   height: 10,
                                      //                 ),
                                      //                 Text(
                                      //                   '등록된',
                                      //                   style: TextStyle(
                                      //                       fontFamily:
                                      //                           'GSANSM',
                                      //                       fontSize: 12,
                                      //                       color: Colors
                                      //                           .grey[600]),
                                      //                 ),
                                      //                 Text(
                                      //                   '참가자가 없습니다.',
                                      //                   style: TextStyle(
                                      //                       fontFamily:
                                      //                           'GSANSM',
                                      //                       fontSize: 12,
                                      //                       color: Colors
                                      //                           .grey[600]),
                                      //                 )
                                      //               ]),
                                      //         ),
                                      //       );
                                      //     });
                                    },
                                    child: Text(
                                      "0명",
                                      style: TextStyle(
                                          fontFamily: "GSANSB",
                                          fontSize: 20,
                                          color: Colors.grey[300]),
                                    ),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                lesson_check
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return AlertDialog(
                                              content: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    100,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ListView.separated(
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        // height: MediaQuery.of(context)
                                                        //         .size
                                                        //         .height -
                                                        //     100,
                                                        height: 140,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border(right: BorderSide(width: 1.5, color: Colors.grey))),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              5,
                                                                              0,
                                                                              10,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              profile_list[index] == ""
                                                                                  ? Container(
                                                                                      width: 35,
                                                                                      height: 35,
                                                                                      child: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(40),
                                                                                          child: SvgPicture.asset(
                                                                                            'assets/images/SVG/profile_pink.svg',
                                                                                            width: 40,
                                                                                          )),
                                                                                    )
                                                                                  : Container(
                                                                                      width: 35,
                                                                                      height: 35,
                                                                                      child: CircleAvatar(backgroundColor: Colors.white, radius: 120, backgroundImage: NetworkImage(participation_profile_image[index])),
                                                                                    ),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Text(
                                                                                participation_nick_name[index],
                                                                                style: TextStyle(fontFamily: "GSANSM", fontSize: 13),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              10),
                                                                          child: Container(
                                                                              height: 1,
                                                                              width: 110,
                                                                              color: Colors.grey),
                                                                        ),
                                                                        participation_grade[index] ==
                                                                                "NomalUser"
                                                                            ? Text(
                                                                                "일반회원",
                                                                                style: TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                                                              )
                                                                            : Text(
                                                                                "운영진",
                                                                                style: TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                                                              ),
                                                                        Padding(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              10),
                                                                          child: Container(
                                                                              height: 1,
                                                                              width: 110,
                                                                              color: Colors.grey),
                                                                        ),
                                                                        Text(
                                                                          "초대 : " +
                                                                              participation_guest[index],
                                                                          style: TextStyle(
                                                                              fontFamily: "GSANSM",
                                                                              fontSize: 15),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            participation_participation[index],
                                                                            style:
                                                                                TextStyle(fontFamily: "GSANSM", fontSize: 20),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                0,
                                                                                10,
                                                                                0,
                                                                                10),
                                                                            child: Container(
                                                                                height: 1,
                                                                                width: 170,
                                                                                color: Colors.grey),
                                                                          ),
                                                                          Text(
                                                                            participation_payment[index],
                                                                            style:
                                                                                TextStyle(fontFamily: "GSANSM", fontSize: 20),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        height: 10,
                                                        color: Colors.grey[100],
                                                      );
                                                    },
                                                    itemCount: participation_uid
                                                        .length),
                                              ),
                                            );
                                          });
                                        })
                                    : showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            color: Colors.grey[100],
                                            child: Center(
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.error_outline,
                                                      size: 50,
                                                      color: Colors.grey[500],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '등록된',
                                                      style: TextStyle(
                                                          fontFamily: 'GSANSM',
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[600]),
                                                    ),
                                                    Text(
                                                      '참가자가 없습니다.',
                                                      style: TextStyle(
                                                          fontFamily: 'GSANSM',
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[600]),
                                                    )
                                                  ]),
                                            ),
                                          );
                                        });
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xffe9394f),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Color(0xffe9394f),
                                          width: 1,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(5)),
                                  elevation: 0),
                              child: Text(
                                "레슨\n목록",
                                style: TextStyle(
                                  fontFamily: "GSANSM",
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: VerticalDivider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // if (game_check == true) {
                                //   showDialog(
                                //       context: context,
                                //       builder: (BuildContext context) {
                                //         return StatefulBuilder(builder:
                                //             (BuildContext context,
                                //                 StateSetter setState) {
                                //           return AlertDialog(
                                //             content: Container(
                                //               height: MediaQuery.of(context)
                                //                       .size
                                //                       .height -
                                //                   100,
                                //               width: MediaQuery.of(context)
                                //                   .size
                                //                   .width,
                                //               child: ListView.separated(
                                //                   itemBuilder:
                                //                       (BuildContext context,
                                //                           int index) {
                                //                     return Container(
                                //                       // height: MediaQuery.of(context)
                                //                       //         .size
                                //                       //         .height -
                                //                       //     100,
                                //                       height: 140,
                                //                       width:
                                //                           MediaQuery.of(context)
                                //                               .size
                                //                               .width,
                                //                       decoration: BoxDecoration(
                                //                           border: Border.all(
                                //                               width: 1,
                                //                               color:
                                //                                   Colors.grey),
                                //                           borderRadius:
                                //                               BorderRadius
                                //                                   .circular(
                                //                                       10)),
                                //                       child: Column(
                                //                         children: [
                                //                           Expanded(
                                //                             child: Row(
                                //                               mainAxisAlignment:
                                //                                   MainAxisAlignment
                                //                                       .start,
                                //                               crossAxisAlignment:
                                //                                   CrossAxisAlignment
                                //                                       .center,
                                //                               children: [
                                //                                 Container(
                                //                                   decoration: BoxDecoration(
                                //                                       border: Border(
                                //                                           right: BorderSide(
                                //                                               width: 1.5,
                                //                                               color: Colors.grey))),
                                //                                   child: Column(
                                //                                     crossAxisAlignment:
                                //                                         CrossAxisAlignment
                                //                                             .center,
                                //                                     mainAxisAlignment:
                                //                                         MainAxisAlignment
                                //                                             .center,
                                //                                     children: [
                                //                                       Padding(
                                //                                         padding: EdgeInsets.fromLTRB(
                                //                                             5,
                                //                                             0,
                                //                                             10,
                                //                                             0),
                                //                                         child:
                                //                                             Row(
                                //                                           children: [
                                //                                             profile_list[index] == ""
                                //                                                 ? Container(
                                //                                                     width: 35,
                                //                                                     height: 35,
                                //                                                     child: ClipRRect(
                                //                                                         borderRadius: BorderRadius.circular(40),
                                //                                                         child: SvgPicture.asset(
                                //                                                           'assets/images/SVG/profile_pink.svg',
                                //                                                           width: 40,
                                //                                                         )),
                                //                                                   )
                                //                                                 : Container(
                                //                                                     width: 35,
                                //                                                     height: 35,
                                //                                                     child: CircleAvatar(backgroundColor: Colors.white, radius: 120, backgroundImage: NetworkImage(game_play_profile_image[index])),
                                //                                                   ),
                                //                                             SizedBox(
                                //                                               width: 5,
                                //                                             ),
                                //                                             Text(
                                //                                               game_play_nick_name[index],
                                //                                               style: TextStyle(fontFamily: "GSANSM", fontSize: 13),
                                //                                             )
                                //                                           ],
                                //                                         ),
                                //                                       ),
                                //                                       Padding(
                                //                                         padding: EdgeInsets.fromLTRB(
                                //                                             0,
                                //                                             10,
                                //                                             0,
                                //                                             10),
                                //                                         child: Container(
                                //                                             height:
                                //                                                 1,
                                //                                             width:
                                //                                                 110,
                                //                                             color:
                                //                                                 Colors.grey),
                                //                                       ),
                                //                                       game_play_grade[index] ==
                                //                                               "NomalUser"
                                //                                           ? Text(
                                //                                               "일반회원",
                                //                                               style: TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                //                                             )
                                //                                           : Text(
                                //                                               "운영진",
                                //                                               style: TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                //                                             ),
                                //                                       Padding(
                                //                                         padding: EdgeInsets.fromLTRB(
                                //                                             0,
                                //                                             10,
                                //                                             0,
                                //                                             10),
                                //                                         child: Container(
                                //                                             height:
                                //                                                 1,
                                //                                             width:
                                //                                                 110,
                                //                                             color:
                                //                                                 Colors.grey),
                                //                                       ),
                                //                                       Text(
                                //                                         "초대 : " +
                                //                                             game_play_guest[index],
                                //                                         style: TextStyle(
                                //                                             fontFamily:
                                //                                                 "GSANSM",
                                //                                             fontSize:
                                //                                                 15),
                                //                                       )
                                //                                     ],
                                //                                   ),
                                //                                 ),
                                //                                 Expanded(
                                //                                   child:
                                //                                       Container(
                                //                                     child:
                                //                                         Column(
                                //                                       crossAxisAlignment:
                                //                                           CrossAxisAlignment
                                //                                               .center,
                                //                                       mainAxisAlignment:
                                //                                           MainAxisAlignment
                                //                                               .center,
                                //                                       children: [
                                //                                         Text(
                                //                                           game_play_participation[
                                //                                               index],
                                //                                           style: TextStyle(
                                //                                               fontFamily: "GSANSM",
                                //                                               fontSize: 20),
                                //                                         ),
                                //                                         Padding(
                                //                                           padding: EdgeInsets.fromLTRB(
                                //                                               0,
                                //                                               10,
                                //                                               0,
                                //                                               10),
                                //                                           child: Container(
                                //                                               height: 1,
                                //                                               width: 170,
                                //                                               color: Colors.grey),
                                //                                         ),
                                //                                         Text(
                                //                                           game_play_payment[
                                //                                               index],
                                //                                           style: TextStyle(
                                //                                               fontFamily: "GSANSM",
                                //                                               fontSize: 20),
                                //                                         ),
                                //                                       ],
                                //                                     ),
                                //                                   ),
                                //                                 )
                                //                               ],
                                //                             ),
                                //                           )
                                //                         ],
                                //                       ),
                                //                     );
                                //                   },
                                //                   separatorBuilder:
                                //                       (BuildContext context,
                                //                           int index) {
                                //                     return Container(
                                //                       height: 10,
                                //                       color: Colors.grey[100],
                                //                     );
                                //                   },
                                //                   itemCount:
                                //                       game_play_uid.length),
                                //             ),
                                //           );
                                //         });
                                //       });
                                // } else {
                                //   showDialog(
                                //       context: context,
                                //       builder: (BuildContext context) {
                                //         return Container(
                                //           color: Colors.grey[100],
                                //           child: Center(
                                //             child: Column(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.center,
                                //                 children: [
                                //                   Icon(
                                //                     Icons.error_outline,
                                //                     size: 50,
                                //                     color: Colors.grey[500],
                                //                   ),
                                //                   SizedBox(
                                //                     height: 10,
                                //                   ),
                                //                   Text(
                                //                     '등록된',
                                //                     style: TextStyle(
                                //                         fontFamily: 'GSANSM',
                                //                         fontSize: 12,
                                //                         color:
                                //                             Colors.grey[600]),
                                //                   ),
                                //                   Text(
                                //                     '참가자가 없습니다.',
                                //                     style: TextStyle(
                                //                         fontFamily: 'GSANSM',
                                //                         fontSize: 12,
                                //                         color:
                                //                             Colors.grey[600]),
                                //                   )
                                //                 ]),
                                //           ),
                                //         );
                                //       });
                                // }
                              },
                              child: Text(
                                "게임",
                                style: TextStyle(
                                    fontFamily: "GSANSB",
                                    fontSize: 24,
                                    color: Colors.grey[400]),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            game_check
                                ? GestureDetector(
                                    onTap: () {
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       return StatefulBuilder(builder:
                                      //           (BuildContext context,
                                      //               StateSetter setState) {
                                      //         return AlertDialog(
                                      //           content: Container(
                                      //             height: MediaQuery.of(context)
                                      //                     .size
                                      //                     .height -
                                      //                 100,
                                      //             width: MediaQuery.of(context)
                                      //                 .size
                                      //                 .width,
                                      //             child: ListView.separated(
                                      //                 itemBuilder:
                                      //                     (BuildContext context,
                                      //                         int index) {
                                      //                   return Container(
                                      //                     // height: MediaQuery.of(context)
                                      //                     //         .size
                                      //                     //         .height -
                                      //                     //     100,
                                      //                     height: 140,
                                      //                     width: MediaQuery.of(
                                      //                             context)
                                      //                         .size
                                      //                         .width,
                                      //                     decoration: BoxDecoration(
                                      //                         border: Border.all(
                                      //                             width: 1,
                                      //                             color: Colors
                                      //                                 .grey),
                                      //                         borderRadius:
                                      //                             BorderRadius
                                      //                                 .circular(
                                      //                                     10)),
                                      //                     child: Column(
                                      //                       children: [
                                      //                         Expanded(
                                      //                           child: Row(
                                      //                             mainAxisAlignment:
                                      //                                 MainAxisAlignment
                                      //                                     .start,
                                      //                             crossAxisAlignment:
                                      //                                 CrossAxisAlignment
                                      //                                     .center,
                                      //                             children: [
                                      //                               Container(
                                      //                                 decoration:
                                      //                                     BoxDecoration(
                                      //                                         border: Border(right: BorderSide(width: 1.5, color: Colors.grey))),
                                      //                                 child:
                                      //                                     Column(
                                      //                                   crossAxisAlignment:
                                      //                                       CrossAxisAlignment.center,
                                      //                                   mainAxisAlignment:
                                      //                                       MainAxisAlignment.center,
                                      //                                   children: [
                                      //                                     Padding(
                                      //                                       padding: EdgeInsets.fromLTRB(
                                      //                                           5,
                                      //                                           0,
                                      //                                           10,
                                      //                                           0),
                                      //                                       child:
                                      //                                           Row(
                                      //                                         children: [
                                      //                                           profile_list[index] == ""
                                      //                                               ? Container(
                                      //                                                   width: 35,
                                      //                                                   height: 35,
                                      //                                                   child: ClipRRect(
                                      //                                                       borderRadius: BorderRadius.circular(40),
                                      //                                                       child: SvgPicture.asset(
                                      //                                                         'assets/images/SVG/profile_pink.svg',
                                      //                                                         width: 40,
                                      //                                                       )),
                                      //                                                 )
                                      //                                               : Container(
                                      //                                                   width: 35,
                                      //                                                   height: 35,
                                      //                                                   child: CircleAvatar(backgroundColor: Colors.white, radius: 120, backgroundImage: NetworkImage(game_play_profile_image[index])),
                                      //                                                 ),
                                      //                                           SizedBox(
                                      //                                             width: 5,
                                      //                                           ),
                                      //                                           Text(
                                      //                                             game_play_nick_name[index],
                                      //                                             style: TextStyle(fontFamily: "GSANSM", fontSize: 13),
                                      //                                           )
                                      //                                         ],
                                      //                                       ),
                                      //                                     ),
                                      //                                     Padding(
                                      //                                       padding: EdgeInsets.fromLTRB(
                                      //                                           0,
                                      //                                           10,
                                      //                                           0,
                                      //                                           10),
                                      //                                       child: Container(
                                      //                                           height: 1,
                                      //                                           width: 110,
                                      //                                           color: Colors.grey),
                                      //                                     ),
                                      //                                     game_play_grade[index] == "NomalUser"
                                      //                                         ? Text(
                                      //                                             "일반회원",
                                      //                                             style: TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                      //                                           )
                                      //                                         : Text(
                                      //                                             "운영진",
                                      //                                             style: TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                      //                                           ),
                                      //                                     Padding(
                                      //                                       padding: EdgeInsets.fromLTRB(
                                      //                                           0,
                                      //                                           10,
                                      //                                           0,
                                      //                                           10),
                                      //                                       child: Container(
                                      //                                           height: 1,
                                      //                                           width: 110,
                                      //                                           color: Colors.grey),
                                      //                                     ),
                                      //                                     Text(
                                      //                                       "초대 : " +
                                      //                                           game_play_guest[index],
                                      //                                       style:
                                      //                                           TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                      //                                     )
                                      //                                   ],
                                      //                                 ),
                                      //                               ),
                                      //                               Expanded(
                                      //                                 child:
                                      //                                     Container(
                                      //                                   child:
                                      //                                       Column(
                                      //                                     crossAxisAlignment:
                                      //                                         CrossAxisAlignment.center,
                                      //                                     mainAxisAlignment:
                                      //                                         MainAxisAlignment.center,
                                      //                                     children: [
                                      //                                       Text(
                                      //                                         game_play_participation[index],
                                      //                                         style: TextStyle(fontFamily: "GSANSM", fontSize: 20),
                                      //                                       ),
                                      //                                       Padding(
                                      //                                         padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      //                                         child: Container(height: 1, width: 170, color: Colors.grey),
                                      //                                       ),
                                      //                                       Text(
                                      //                                         game_play_payment[index],
                                      //                                         style: TextStyle(fontFamily: "GSANSM", fontSize: 20),
                                      //                                       ),
                                      //                                     ],
                                      //                                   ),
                                      //                                 ),
                                      //                               )
                                      //                             ],
                                      //                           ),
                                      //                         )
                                      //                       ],
                                      //                     ),
                                      //                   );
                                      //                 },
                                      //                 separatorBuilder:
                                      //                     (BuildContext context,
                                      //                         int index) {
                                      //                   return Container(
                                      //                     height: 10,
                                      //                     color:
                                      //                         Colors.grey[100],
                                      //                   );
                                      //                 },
                                      //                 itemCount:
                                      //                     game_play_uid.length),
                                      //           ),
                                      //         );
                                      //       });
                                      //     });
                                    },
                                    child: Text(
                                      game_play_uid.length.toString() + "명",
                                      style: TextStyle(
                                          fontFamily: "GSANSB",
                                          fontSize: 20,
                                          color: Colors.grey[300]),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       return Container(
                                      //         color: Colors.grey[100],
                                      //         child: Center(
                                      //           child: Column(
                                      //               mainAxisAlignment:
                                      //                   MainAxisAlignment
                                      //                       .center,
                                      //               children: [
                                      //                 Icon(
                                      //                   Icons.error_outline,
                                      //                   size: 50,
                                      //                   color: Colors.grey[500],
                                      //                 ),
                                      //                 SizedBox(
                                      //                   height: 10,
                                      //                 ),
                                      //                 Text(
                                      //                   '등록된',
                                      //                   style: TextStyle(
                                      //                       fontFamily:
                                      //                           'GSANSM',
                                      //                       fontSize: 12,
                                      //                       color: Colors
                                      //                           .grey[600]),
                                      //                 ),
                                      //                 Text(
                                      //                   '참가자가 없습니다.',
                                      //                   style: TextStyle(
                                      //                       fontFamily:
                                      //                           'GSANSM',
                                      //                       fontSize: 12,
                                      //                       color: Colors
                                      //                           .grey[600]),
                                      //                 )
                                      //               ]),
                                      //         ),
                                      //       );
                                      //     });
                                    },
                                    child: Text(
                                      "0명",
                                      style: TextStyle(
                                          fontFamily: "GSANSB",
                                          fontSize: 20,
                                          color: Colors.grey[300]),
                                    ),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                game_check
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return AlertDialog(
                                              content: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    100,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: ListView.separated(
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        // height: MediaQuery.of(context)
                                                        //         .size
                                                        //         .height -
                                                        //     100,
                                                        height: 140,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border(right: BorderSide(width: 1.5, color: Colors.grey))),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Padding(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              5,
                                                                              0,
                                                                              10,
                                                                              0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              profile_list[index] == ""
                                                                                  ? Container(
                                                                                      width: 35,
                                                                                      height: 35,
                                                                                      child: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(40),
                                                                                          child: SvgPicture.asset(
                                                                                            'assets/images/SVG/profile_pink.svg',
                                                                                            width: 40,
                                                                                          )),
                                                                                    )
                                                                                  : Container(
                                                                                      width: 35,
                                                                                      height: 35,
                                                                                      child: CircleAvatar(backgroundColor: Colors.white, radius: 120, backgroundImage: NetworkImage(game_play_profile_image[index])),
                                                                                    ),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                              Text(
                                                                                game_play_nick_name[index],
                                                                                style: TextStyle(fontFamily: "GSANSM", fontSize: 13),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              10),
                                                                          child: Container(
                                                                              height: 1,
                                                                              width: 110,
                                                                              color: Colors.grey),
                                                                        ),
                                                                        game_play_grade[index] ==
                                                                                "NomalUser"
                                                                            ? Text(
                                                                                "일반회원",
                                                                                style: TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                                                              )
                                                                            : Text(
                                                                                "운영진",
                                                                                style: TextStyle(fontFamily: "GSANSM", fontSize: 15),
                                                                              ),
                                                                        Padding(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              10),
                                                                          child: Container(
                                                                              height: 1,
                                                                              width: 110,
                                                                              color: Colors.grey),
                                                                        ),
                                                                        Text(
                                                                          "초대 : " +
                                                                              game_play_guest[index],
                                                                          style: TextStyle(
                                                                              fontFamily: "GSANSM",
                                                                              fontSize: 15),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            game_play_participation[index],
                                                                            style:
                                                                                TextStyle(fontFamily: "GSANSM", fontSize: 20),
                                                                          ),
                                                                          Padding(
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                0,
                                                                                10,
                                                                                0,
                                                                                10),
                                                                            child: Container(
                                                                                height: 1,
                                                                                width: 170,
                                                                                color: Colors.grey),
                                                                          ),
                                                                          Text(
                                                                            game_play_payment[index],
                                                                            style:
                                                                                TextStyle(fontFamily: "GSANSM", fontSize: 20),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        height: 10,
                                                        color: Colors.grey[100],
                                                      );
                                                    },
                                                    itemCount:
                                                        game_play_uid.length),
                                              ),
                                            );
                                          });
                                        })
                                    : showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            color: Colors.grey[100],
                                            child: Center(
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.error_outline,
                                                      size: 50,
                                                      color: Colors.grey[500],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      '등록된',
                                                      style: TextStyle(
                                                          fontFamily: 'GSANSM',
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[600]),
                                                    ),
                                                    Text(
                                                      '참가자가 없습니다.',
                                                      style: TextStyle(
                                                          fontFamily: 'GSANSM',
                                                          fontSize: 12,
                                                          color:
                                                              Colors.grey[600]),
                                                    )
                                                  ]),
                                            ),
                                          );
                                        });
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xffe9394f),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Color(0xffe9394f),
                                          width: 1,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(5)),
                                  elevation: 0),
                              child: Text(
                                "게임\n목록",
                                style: TextStyle(
                                  fontFamily: "GSANSM",
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: VerticalDivider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return StatefulBuilder(builder:
                                //           (BuildContext context,
                                //               StateSetter setState) {
                                //         return AlertDialog(
                                //           content: Container(
                                //             height: MediaQuery.of(context)
                                //                     .size
                                //                     .height -
                                //                 100,
                                //             width: MediaQuery.of(context)
                                //                 .size
                                //                 .width,
                                //             child: ListView.separated(
                                //                 itemBuilder:
                                //                     (BuildContext context,
                                //                         int index) {
                                //                   return Container(
                                //                     // height: MediaQuery.of(context)
                                //                     //         .size
                                //                     //         .height -
                                //                     //     100,
                                //                     height: 140,
                                //                     width:
                                //                         MediaQuery.of(context)
                                //                             .size
                                //                             .width,
                                //                     decoration: BoxDecoration(
                                //                         border: Border.all(
                                //                             width: 1,
                                //                             color: Colors.grey),
                                //                         borderRadius:
                                //                             BorderRadius
                                //                                 .circular(10)),
                                //                     child: Column(
                                //                       children: [
                                //                         Expanded(
                                //                           child: Row(
                                //                             mainAxisAlignment:
                                //                                 MainAxisAlignment
                                //                                     .start,
                                //                             crossAxisAlignment:
                                //                                 CrossAxisAlignment
                                //                                     .center,
                                //                             children: [
                                //                               Container(
                                //                                 decoration: BoxDecoration(
                                //                                     border: Border(
                                //                                         right: BorderSide(
                                //                                             width:
                                //                                                 1.5,
                                //                                             color:
                                //                                                 Colors.grey))),
                                //                                 child: Column(
                                //                                   crossAxisAlignment:
                                //                                       CrossAxisAlignment
                                //                                           .center,
                                //                                   mainAxisAlignment:
                                //                                       MainAxisAlignment
                                //                                           .center,
                                //                                   children: [
                                //                                     Padding(
                                //                                       padding: EdgeInsets
                                //                                           .fromLTRB(
                                //                                               5,
                                //                                               0,
                                //                                               10,
                                //                                               0),
                                //                                       child:
                                //                                           Row(
                                //                                         children: [
                                //                                           profile_list[index] == ""
                                //                                               ? Container(
                                //                                                   width: 35,
                                //                                                   height: 35,
                                //                                                   child: ClipRRect(
                                //                                                       borderRadius: BorderRadius.circular(40),
                                //                                                       child: SvgPicture.asset(
                                //                                                         'assets/images/SVG/profile_pink.svg',
                                //                                                         width: 40,
                                //                                                       )),
                                //                                                 )
                                //                                               : Container(
                                //                                                   width: 35,
                                //                                                   height: 35,
                                //                                                   child: CircleAvatar(backgroundColor: Colors.white, radius: 120, backgroundImage: NetworkImage(management_profile_image[index])),
                                //                                                 ),
                                //                                           SizedBox(
                                //                                             width:
                                //                                                 5,
                                //                                           ),
                                //                                           Text(
                                //                                             management_nick_name[index],
                                //                                             style:
                                //                                                 TextStyle(fontFamily: "GSANSM", fontSize: 13),
                                //                                           )
                                //                                         ],
                                //                                       ),
                                //                                     ),
                                //                                     Padding(
                                //                                       padding: EdgeInsets
                                //                                           .fromLTRB(
                                //                                               0,
                                //                                               10,
                                //                                               0,
                                //                                               10),
                                //                                       child: Container(
                                //                                           height:
                                //                                               1,
                                //                                           width:
                                //                                               110,
                                //                                           color:
                                //                                               Colors.grey),
                                //                                     ),
                                //                                     Text(
                                //                                       "운영진",
                                //                                       style: TextStyle(
                                //                                           fontFamily:
                                //                                               "GSANSM",
                                //                                           fontSize:
                                //                                               15),
                                //                                     ),
                                //                                     Padding(
                                //                                       padding: EdgeInsets
                                //                                           .fromLTRB(
                                //                                               0,
                                //                                               10,
                                //                                               0,
                                //                                               10),
                                //                                       child: Container(
                                //                                           height:
                                //                                               1,
                                //                                           width:
                                //                                               110,
                                //                                           color:
                                //                                               Colors.grey),
                                //                                     ),
                                //                                     Text(
                                //                                       "초대 : " +
                                //                                           management_guest[
                                //                                               index],
                                //                                       style: TextStyle(
                                //                                           fontFamily:
                                //                                               "GSANSM",
                                //                                           fontSize:
                                //                                               15),
                                //                                     )
                                //                                   ],
                                //                                 ),
                                //                               ),
                                //                               Expanded(
                                //                                 child:
                                //                                     Container(
                                //                                   child: Column(
                                //                                     crossAxisAlignment:
                                //                                         CrossAxisAlignment
                                //                                             .center,
                                //                                     mainAxisAlignment:
                                //                                         MainAxisAlignment
                                //                                             .center,
                                //                                     children: [
                                //                                       Text(
                                //                                         management_participation[
                                //                                             index],
                                //                                         style: TextStyle(
                                //                                             fontFamily:
                                //                                                 "GSANSM",
                                //                                             fontSize:
                                //                                                 20),
                                //                                       ),
                                //                                       Padding(
                                //                                         padding: EdgeInsets.fromLTRB(
                                //                                             0,
                                //                                             10,
                                //                                             0,
                                //                                             10),
                                //                                         child: Container(
                                //                                             height:
                                //                                                 1,
                                //                                             width:
                                //                                                 170,
                                //                                             color:
                                //                                                 Colors.grey),
                                //                                       ),
                                //                                       Text(
                                //                                         "없음",
                                //                                         style: TextStyle(
                                //                                             fontFamily:
                                //                                                 "GSANSM",
                                //                                             fontSize:
                                //                                                 20),
                                //                                       ),
                                //                                     ],
                                //                                   ),
                                //                                 ),
                                //                               )
                                //                             ],
                                //                           ),
                                //                         )
                                //                       ],
                                //                     ),
                                //                   );
                                //                 },
                                //                 separatorBuilder:
                                //                     (BuildContext context,
                                //                         int index) {
                                //                   return Container(
                                //                     height: 10,
                                //                     color: Colors.grey[100],
                                //                   );
                                //                 },
                                //                 itemCount:
                                //                     management_uid.length),
                                //           ),
                                //         );
                                //       });
                                //     });
                              },
                              child: Text(
                                "운영진",
                                style: TextStyle(
                                    fontFamily: "GSANSB",
                                    fontSize: 24,
                                    color: Colors.grey[400]),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                // showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return StatefulBuilder(builder:
                                //           (BuildContext context,
                                //               StateSetter setState) {
                                //         return AlertDialog(
                                //           content: Container(
                                //             height: MediaQuery.of(context)
                                //                     .size
                                //                     .height -
                                //                 100,
                                //             width: MediaQuery.of(context)
                                //                 .size
                                //                 .width,
                                //             child: ListView.separated(
                                //                 itemBuilder:
                                //                     (BuildContext context,
                                //                         int index) {
                                //                   return Container(
                                //                     // height: MediaQuery.of(context)
                                //                     //         .size
                                //                     //         .height -
                                //                     //     100,
                                //                     height: 140,
                                //                     width:
                                //                         MediaQuery.of(context)
                                //                             .size
                                //                             .width,
                                //                     decoration: BoxDecoration(
                                //                         border: Border.all(
                                //                             width: 1,
                                //                             color: Colors.grey),
                                //                         borderRadius:
                                //                             BorderRadius
                                //                                 .circular(10)),
                                //                     child: Column(
                                //                       children: [
                                //                         Expanded(
                                //                           child: Row(
                                //                             mainAxisAlignment:
                                //                                 MainAxisAlignment
                                //                                     .start,
                                //                             crossAxisAlignment:
                                //                                 CrossAxisAlignment
                                //                                     .center,
                                //                             children: [
                                //                               Container(
                                //                                 decoration: BoxDecoration(
                                //                                     border: Border(
                                //                                         right: BorderSide(
                                //                                             width:
                                //                                                 1.5,
                                //                                             color:
                                //                                                 Colors.grey))),
                                //                                 child: Column(
                                //                                   crossAxisAlignment:
                                //                                       CrossAxisAlignment
                                //                                           .center,
                                //                                   mainAxisAlignment:
                                //                                       MainAxisAlignment
                                //                                           .center,
                                //                                   children: [
                                //                                     Padding(
                                //                                       padding: EdgeInsets
                                //                                           .fromLTRB(
                                //                                               5,
                                //                                               0,
                                //                                               10,
                                //                                               0),
                                //                                       child:
                                //                                           Row(
                                //                                         children: [
                                //                                           profile_list[index] == ""
                                //                                               ? Container(
                                //                                                   width: 35,
                                //                                                   height: 35,
                                //                                                   child: ClipRRect(
                                //                                                       borderRadius: BorderRadius.circular(40),
                                //                                                       child: SvgPicture.asset(
                                //                                                         'assets/images/SVG/profile_pink.svg',
                                //                                                         width: 40,
                                //                                                       )),
                                //                                                 )
                                //                                               : Container(
                                //                                                   width: 35,
                                //                                                   height: 35,
                                //                                                   child: CircleAvatar(backgroundColor: Colors.white, radius: 120, backgroundImage: NetworkImage(management_profile_image[index])),
                                //                                                 ),
                                //                                           SizedBox(
                                //                                             width:
                                //                                                 5,
                                //                                           ),
                                //                                           Text(
                                //                                             management_nick_name[index],
                                //                                             style:
                                //                                                 TextStyle(fontFamily: "GSANSM", fontSize: 13),
                                //                                           )
                                //                                         ],
                                //                                       ),
                                //                                     ),
                                //                                     Padding(
                                //                                       padding: EdgeInsets
                                //                                           .fromLTRB(
                                //                                               0,
                                //                                               10,
                                //                                               0,
                                //                                               10),
                                //                                       child: Container(
                                //                                           height:
                                //                                               1,
                                //                                           width:
                                //                                               110,
                                //                                           color:
                                //                                               Colors.grey),
                                //                                     ),
                                //                                     Text(
                                //                                       "운영진",
                                //                                       style: TextStyle(
                                //                                           fontFamily:
                                //                                               "GSANSM",
                                //                                           fontSize:
                                //                                               15),
                                //                                     ),
                                //                                     Padding(
                                //                                       padding: EdgeInsets
                                //                                           .fromLTRB(
                                //                                               0,
                                //                                               10,
                                //                                               0,
                                //                                               10),
                                //                                       child: Container(
                                //                                           height:
                                //                                               1,
                                //                                           width:
                                //                                               110,
                                //                                           color:
                                //                                               Colors.grey),
                                //                                     ),
                                //                                     Text(
                                //                                       "초대 : " +
                                //                                           management_guest[
                                //                                               index],
                                //                                       style: TextStyle(
                                //                                           fontFamily:
                                //                                               "GSANSM",
                                //                                           fontSize:
                                //                                               15),
                                //                                     )
                                //                                   ],
                                //                                 ),
                                //                               ),
                                //                               Expanded(
                                //                                 child:
                                //                                     Container(
                                //                                   child: Column(
                                //                                     crossAxisAlignment:
                                //                                         CrossAxisAlignment
                                //                                             .center,
                                //                                     mainAxisAlignment:
                                //                                         MainAxisAlignment
                                //                                             .center,
                                //                                     children: [
                                //                                       Text(
                                //                                         management_participation[
                                //                                             index],
                                //                                         style: TextStyle(
                                //                                             fontFamily:
                                //                                                 "GSANSM",
                                //                                             fontSize:
                                //                                                 20),
                                //                                       ),
                                //                                       Padding(
                                //                                         padding: EdgeInsets.fromLTRB(
                                //                                             0,
                                //                                             10,
                                //                                             0,
                                //                                             10),
                                //                                         child: Container(
                                //                                             height:
                                //                                                 1,
                                //                                             width:
                                //                                                 170,
                                //                                             color:
                                //                                                 Colors.grey),
                                //                                       ),
                                //                                       Text(
                                //                                         "없음",
                                //                                         style: TextStyle(
                                //                                             fontFamily:
                                //                                                 "GSANSM",
                                //                                             fontSize:
                                //                                                 20),
                                //                                       ),
                                //                                     ],
                                //                                   ),
                                //                                 ),
                                //                               )
                                //                             ],
                                //                           ),
                                //                         )
                                //                       ],
                                //                     ),
                                //                   );
                                //                 },
                                //                 separatorBuilder:
                                //                     (BuildContext context,
                                //                         int index) {
                                //                   return Container(
                                //                     height: 10,
                                //                     color: Colors.grey[100],
                                //                   );
                                //                 },
                                //                 itemCount:
                                //                     management_uid.length),
                                //           ),
                                //         );
                                //       });
                                //     });
                              },
                              child: Text(
                                management_uid.length.toString() + "명",
                                style: TextStyle(
                                    fontFamily: "GSANSB",
                                    fontSize: 20,
                                    color: Colors.grey[300]),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return AlertDialog(
                                          content: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                100,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ListView.separated(
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Container(
                                                    // height: MediaQuery.of(context)
                                                    //         .size
                                                    //         .height -
                                                    //     100,
                                                    height: 140,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border(
                                                                        right: BorderSide(
                                                                            width:
                                                                                1.5,
                                                                            color:
                                                                                Colors.grey))),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              5,
                                                                              0,
                                                                              10,
                                                                              0),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          profile_list[index] == ""
                                                                              ? Container(
                                                                                  width: 35,
                                                                                  height: 35,
                                                                                  child: ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(40),
                                                                                      child: SvgPicture.asset(
                                                                                        'assets/images/SVG/profile_pink.svg',
                                                                                        width: 40,
                                                                                      )),
                                                                                )
                                                                              : Container(
                                                                                  width: 35,
                                                                                  height: 35,
                                                                                  child: CircleAvatar(backgroundColor: Colors.white, radius: 120, backgroundImage: NetworkImage(management_profile_image[index])),
                                                                                ),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            management_nick_name[index],
                                                                            style:
                                                                                TextStyle(fontFamily: "GSANSM", fontSize: 13),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              10),
                                                                      child: Container(
                                                                          height:
                                                                              1,
                                                                          width:
                                                                              110,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                    Text(
                                                                      "운영진",
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "GSANSM",
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              10),
                                                                      child: Container(
                                                                          height:
                                                                              1,
                                                                          width:
                                                                              110,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                    Text(
                                                                      "초대 : " +
                                                                          management_guest[
                                                                              index],
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              "GSANSM",
                                                                          fontSize:
                                                                              15),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                        management_participation[
                                                                            index],
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "GSANSM",
                                                                            fontSize:
                                                                                20),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            10),
                                                                        child: Container(
                                                                            height:
                                                                                1,
                                                                            width:
                                                                                170,
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                      Text(
                                                                        "없음",
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "GSANSM",
                                                                            fontSize:
                                                                                20),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Container(
                                                    height: 10,
                                                    color: Colors.grey[100],
                                                  );
                                                },
                                                itemCount:
                                                    management_uid.length),
                                          ),
                                        );
                                      });
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xffe9394f),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Color(0xffe9394f),
                                          width: 1,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(5)),
                                  elevation: 0),
                              child: Text(
                                "운영진\n목록",
                                style: TextStyle(
                                  fontFamily: "GSANSM",
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BottomAppBar(
                  elevation: 0,
                  child: gathering_participation_button
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          color: Colors.black,
                          child: Center(
                            child: Text("모집 마감된 게시글 입니다.",
                                style: TextStyle(
                                    fontFamily: "GSANSB",
                                    color: Colors.white,
                                    fontSize: 20)),
                          ),
                        )
                      : Container()),
            ]);
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);
    bool _flag = true;
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
              children: [
                _get_List_Member(post_title, post_intro),
              ],
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

void _showDialog_unParticipation_Error(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "모임 참가 취소 실패",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "해당 모임 참가자가 아닙니다.",
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
                  fontSize: 16,
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

void _showDialog_Success_Gathering(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "모임 모집 완료",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "모임 모집을 완료 하시겠습니까?",
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
                  "예",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
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
              ElevatedButton(
                child: Text(
                  "아니요",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
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
