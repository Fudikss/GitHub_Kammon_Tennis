import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/Club_Settings.dart';
import 'package:snstennis/club/Gathering_Post_1_1.dart';
import 'package:snstennis/club/Gathering_Post_Write_1_1.dart';
import 'package:snstennis/club/Nomal_Post_1_0.dart';
import 'package:snstennis/club/Nomal_Post_Write_1_1.dart';
import 'package:snstennis/club/Notice_Post_1_2.dart';
import 'package:snstennis/club/Notice_Post_Write_1_1.dart';
import 'package:snstennis/club/club_drawer_1_0.dart';
import 'package:snstennis/club/first_screen_1_0.dart';
import 'package:snstennis/home.dart';
import 'package:snstennis/instant/instant_main.dart';
import 'package:snstennis/market/Market_Main_Page.dart';

class ClubMainPage extends StatefulWidget {
  final String club_uid;
  final String club_name;
  final String image_url;

  const ClubMainPage(
      {Key? key,
      required this.club_uid,
      required this.club_name,
      required this.image_url})
      : super(key: key);

  @override
  _ClubMainPageState createState() =>
      _ClubMainPageState(club_uid, club_name, image_url);
}

TextEditingController _controller = TextEditingController();
GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();

class _ClubMainPageState extends State<ClubMainPage>
    with SingleTickerProviderStateMixin {
  String name = "";
  String club_uid = '';
  String url_image = "";
  late User user;
  final FocusNode _focusNode = FocusNode();

  int _selectedNaviIndex = 2;

  late UserAccountInfo userAccount_;

  late String user_grade = "";

  User user1 = FirebaseAuth.instance.currentUser!;

  List board_select = ["일반게시글", "공지사항", "모임"];
  String _selectedValue = "일반게시글";

  bool change_select = false;

  String change_string = "";

  _ClubMainPageState(this.name, this.club_uid, this.url_image);

  Future<UserAccountInfo> getData(String club_uid) async {
    var check_grade;
    CollectionReference ref = FirebaseFirestore.instance.collection('Club');
    DocumentSnapshot snapshot =
        await ref.doc(name).collection("ClubMember").doc("MemberList").get();
    var data = snapshot.data() as Map;

    for (int i = 0; i < data["ClubMember"].length; i++) {
      if (data["ClubMember"][i]["UserID"] == user.uid) {
        check_grade = data["ClubMember"][i]["Grade"];
      }
    }
    userAccount_.checkGrade(check_grade);
    return userAccount_;
  }

  Stream<DocumentSnapshot> _getComment() {
    return FirebaseFirestore.instance
        .collection("Club")
        .doc(name)
        .collection("ChatRoom")
        .doc("ChatRoom")
        .snapshots();
  }

  Widget _noticeBorad() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 170,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '공지사항',
                style: TextStyle(
                    fontFamily: 'GSANSB',
                    color: Colors.grey[700],
                    fontSize: 16),
              ),
              // Text(
              //   '더보기 +',
              //   style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
              // ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedValue = "공지사항";
                      change_select = true;
                      Timer(Duration(milliseconds: 300), () {
                        _tabController.index = 1;
                      });
                      // _tabController.index = 1;
                      // _selectedValue = "모임";
                      // change_select = true;
                    });
                  },
                  child: Text(
                    "더보기",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'GSANSM',
                        fontSize: 12.0),
                  ))
            ],
          ),
          Container(
            height: 120,
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Club")
                    .doc(name)
                    .collection("Post")
                    .doc("NoticePost")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error!");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container();
                  } else {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;

                    //_getGrade(user1.uid, club_uid);

                    List a = [];
                    List b = [];
                    List date_time = [];
                    List key_num = [];
                    List post_intro = [];
                    List notice_post_uid_list = [];
                    List notice_post_datetime_list = [];
                    List notice_post_image_url_list = [];
                    List notice_post_commnet_id_list = [];
                    List notice_post_video_url = [];

                    List revers_title = [];
                    List revers_intro = [];
                    List revers_Nick = [];
                    List revers_date_time = [];
                    List revers_uid = [];
                    List revers_image_url = [];
                    List revers_key_num = [];
                    List revers_comment_id = [];
                    List revers_video_url = [];

                    //if (data["NoticePost"] != null) {
                    if (data["NoticePost"].length != 0) {
                      for (int i = 0; i < data["NoticePost"].length; i++) {
                        a.add(data["NoticePost"][i]["ClubPostTitle"]);
                        b.add(data["NoticePost"][i]["NickName"]);
                        date_time.add(data["NoticePost"][i]["DateTime"]);
                        notice_post_uid_list
                            .add(data["NoticePost"][i]["UserUID"]);
                        // notice_post_datetime_list
                        //     .add(data["NoticePost"][i]["DateTime"]);
                        notice_post_image_url_list
                            .add(data["NoticePost"][i]["ClubPostImage"]);
                        key_num.add(data["NoticePost"][i]["KeyNumber"]);
                        post_intro.add(data["NoticePost"][i]["ClubPostIntro"]);
                        notice_post_commnet_id_list
                            .add(data["NoticePost"][i]["CommentID"]);
                        notice_post_video_url
                            .add(data["NoticePost"][i]["VideoUrl"]);
                      }

                      revers_title = List.of(a.reversed);
                      revers_Nick = List.of(b.reversed);
                      revers_date_time = List.of(date_time.reversed);
                      revers_key_num = List.of(key_num.reversed);
                      revers_intro = List.of(post_intro.reversed);
                      revers_uid = List.of(notice_post_uid_list.reversed);
                      revers_image_url =
                          List.of(notice_post_image_url_list.reversed);
                      revers_comment_id =
                          List.of(notice_post_commnet_id_list.reversed);
                      return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5)),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return NoticePost(
                                        index: int.parse(revers_key_num[index]),
                                        club_uid: name,
                                        key_num: revers_key_num[index],
                                        prev_post_intro: revers_intro[index],
                                        prev_post_nickname: revers_Nick[index],
                                        prev_post_title: revers_title[index],
                                        prev_post_datetime:
                                            revers_date_time[index],
                                        prev_post_uid: revers_uid[index],
                                        prev_post_image_url:
                                            revers_image_url[index],
                                        prev_post_comment_id:
                                            revers_comment_id[index],
                                        prev_post_video_url: '',
                                        prev_post_profile_image: '',
                                      );
                                    }));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          revers_date_time[index],
                                          style: TextStyle(
                                              fontFamily: 'GSANSM',
                                              color: Color(0xff58585b),
                                              fontSize: 14),
                                        ),
                                        Text(revers_title[index],
                                            style: TextStyle(
                                                fontFamily: 'GSANSM',
                                                color: Color(0xff58585b),
                                                fontSize: 14)),
                                        Text(
                                          revers_Nick[index],
                                          style: TextStyle(
                                              fontFamily: 'GSANSM',
                                              color: Color(0xff9f9f9f),
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(height: 5);
                          },
                          itemCount: revers_title.length >= 3
                              ? 3
                              : revers_title.length >= 2
                                  ? 2
                                  : 1);
                    } else {
                      return Container(child: Text('\n등록된 글이 없습니다.'));
                    }
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget _noticeBorad_tab() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 1.5,

      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       '공지사항',
          //       style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
          //     ),
          //     // Text(
          //     //   '더보기 +',
          //     //   style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
          //     // ),
          //   ],
          // ),
          SizedBox(
            height: 10,
          ),
          Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
          Expanded(
            child: Container(
              // height: 520,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Club")
                      .doc(name)
                      .collection("Post")
                      .doc("NoticePost")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error!");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container();
                    } else {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;

                      //_getGrade(user1.uid, club_uid);

                      List a = [];
                      List b = [];
                      List c = [];
                      List notice_post_uid_list = [];
                      List notice_post_datetime_list = [];
                      List notice_post_image_url_list = [];
                      List key_num = [];
                      List notice_post_comment_id_list = [];
                      List notice_post_video_url = [];
                      List notice_post_profile_image = [];

                      //if (data["NoticePost"] != null) {
                      if (data["NoticePost"].length != 0) {
                        for (int i = 0; i < data["NoticePost"].length; i++) {
                          a.add(data["NoticePost"][i]["ClubPostTitle"]);
                          b.add(data["NoticePost"][i]["ClubPostIntro"]);
                          c.add(data["NoticePost"][i]["NickName"]);
                          notice_post_uid_list
                              .add(data["NoticePost"][i]["UserUID"]);
                          notice_post_datetime_list
                              .add(data["NoticePost"][i]["DateTime"]);
                          notice_post_image_url_list
                              .add(data["NoticePost"][i]["ClubPostImage"]);
                          key_num.add(data["NoticePost"][i]["KeyNumber"]);
                          notice_post_comment_id_list
                              .add(data["NoticePost"][i]["CommentID"]);
                          notice_post_video_url
                              .add(data["NoticePost"][i]["VideoUrl"]);
                          notice_post_image_url_list
                              .add(data["NoticePost"][i]["Profile_image"]);
                        }

                        // revers_title = List.of(a.reversed);
                        // revers_intro = List.of(b.reversed);
                        // revers_Nick = List.of(c.reversed);

                        return ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              return SingleChildScrollView(
                                child: Container(
                                    // width: 250,
                                    // height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return NoticePost(
                                            index: index,
                                            club_uid: name,
                                            key_num: key_num[index],
                                            prev_post_intro: b[index],
                                            prev_post_nickname: c[index],
                                            prev_post_title: a[index],
                                            prev_post_datetime:
                                                notice_post_datetime_list[
                                                    index],
                                            prev_post_image_url:
                                                notice_post_image_url_list[
                                                    index],
                                            prev_post_uid:
                                                notice_post_uid_list[index],
                                            prev_post_comment_id:
                                                notice_post_comment_id_list[
                                                    index],
                                            prev_post_video_url:
                                                notice_post_video_url[index],
                                            prev_post_profile_image:
                                                notice_post_image_url_list[
                                                    index],
                                          );
                                        }));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            title: Text(
                                              a[index],
                                              style: TextStyle(
                                                  color: Color(0xff58585b),
                                                  fontFamily: 'GSANSB',
                                                  fontSize: 14),
                                            ),
                                            subtitle: Text(
                                              b[index],
                                              style: TextStyle(
                                                  color: Color(0xff9f9f9f),
                                                  fontFamily: 'GSANSM',
                                                  fontSize: 12.0),
                                            ),
                                            trailing: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 25, 0, 0),
                                              child: Text(
                                                c[index],
                                                style: TextStyle(
                                                    color: Color(0xff9f9f9f),
                                                    fontFamily: 'GSANSM',
                                                    fontSize: 12.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                height: 10,
                                color: Colors.grey[100],
                              );
                            },
                            itemCount: a.length);
                      } else {
                        return Container(child: Text('\n등록된 글이 없습니다.'));
                      }
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget _normalBoard() {
    return Container(
      height: 400,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '게시판',
                style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
              ),
              // Text(
              //   '더보기 +',
              //   style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
              // ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 350,
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Club")
                    .doc(name)
                    .collection("Post")
                    .doc("NomalPost")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error!");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container();
                  } else {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    List a = [];
                    List b = [];
                    List c = [];
                    //if (data["NomalPost"] != null) {
                    if (data["NomalPost"].length != 0) {
                      for (int i = 0; i < data["NomalPost"].length; i++) {
                        a.add(data["NomalPost"][i]["ClubPostTitle"]);
                        b.add(data["NomalPost"][i]["ClubPostIntro"]);
                        c.add(data["NomalPost"][i]["NickName"]);
                      }
                      return ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey, width: 1)),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.push(context, MaterialPageRoute(
                                    //     builder: (BuildContext context) {
                                    //   return NomalPost(
                                    //     index: index,
                                    //     club_uid: name,

                                    //   );
                                    // }));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: FlutterLogo(size: 72.0),
                                          title: Text(
                                            a[index],
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontFamily: 'GSANSB',
                                                fontSize: 14.0),
                                          ),
                                          trailing: Text(
                                            c[index],
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontFamily: 'GSANSB',
                                                fontSize: 12.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(height: 5);
                          },
                          itemCount: a.length);
                    } else {
                      return Container(child: Text('\n등록된 글이 없습니다.'));
                    }
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget _normalBoard_tab() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
          Expanded(
            child: Container(
              // height: 450,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Club")
                      .doc(name)
                      .collection("Post")
                      .doc("NomalPost")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error!");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container();
                    } else {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      List a = [];
                      List b = [];
                      List c = [];
                      List nomal_post_uid_list = [];
                      List nomal_post_datetime_list = [];
                      List nomal_post_image_url_list = [];
                      List number_key = [];
                      List nomal_post_comment_id = [];

                      //if (data["NomalPost"] != null) {
                      if (data["NomalPost"].length != 0) {
                        for (int i = 0; i < data["NomalPost"].length; i++) {
                          a.add(data["NomalPost"][i]["ClubPostTitle"]);
                          b.add(data["NomalPost"][i]["ClubPostIntro"]);
                          c.add(data["NomalPost"][i]["NickName"]);
                          nomal_post_uid_list
                              .add(data["NomalPost"][i]["UserUID"]);
                          nomal_post_datetime_list
                              .add(data["NomalPost"][i]["DateTime"]);
                          nomal_post_image_url_list
                              .add(data["NomalPost"][i]["ClubPostImage"]);
                          number_key.add(data["NomalPost"][i]["KeyNumber"]);
                          nomal_post_comment_id
                              .add(data["NomalPost"][i]["CommentID"]);
                        }
                        return ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return NomalPost(
                                          index: index,
                                          club_uid: name,
                                          prev_post_intro: b[index],
                                          prev_post_nickname: c[index],
                                          prev_post_title: a[index],
                                          key_num: number_key[index],
                                          prev_post_datetime:
                                              nomal_post_datetime_list[index],
                                          prev_post_image_url:
                                              nomal_post_image_url_list[index],
                                          prev_post_uid:
                                              nomal_post_uid_list[index],
                                          prev_post_comment_id:
                                              nomal_post_comment_id[index],
                                          prev_post_profile_image: '',
                                        );
                                      }));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            // leading: FlutterLogo(size: 72.0),
                                            title: Text(
                                              a[index],
                                              style: TextStyle(
                                                  color: Color(0xff58585b),
                                                  fontFamily: 'GSANSB',
                                                  fontSize: 14),
                                            ),
                                            subtitle: Text(
                                              b[index],
                                              style: TextStyle(
                                                  color: Color(0xff9f9f9f),
                                                  fontFamily: 'GSANSM',
                                                  fontSize: 12.0),
                                            ),
                                            trailing: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 25, 0, 0),
                                              child: Text(
                                                c[index],
                                                style: TextStyle(
                                                    color: Color(0xff9f9f9f),
                                                    fontFamily: 'GSANSM',
                                                    fontSize: 12.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                  height: 10, color: Colors.grey[100]);
                            },
                            itemCount: a.length);
                      } else {
                        return Container(child: Text('\n등록된 글이 없습니다.'));
                      }
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }

  Widget _gatherBoard() {
    return Container(
      height: 170,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '모 임',
                style: TextStyle(
                    fontFamily: 'GSANSB',
                    color: Color(0xff58585b),
                    fontSize: 16),
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedValue = "모임";
                      change_select = true;
                      Timer(Duration(milliseconds: 300), () {
                        _tabController.index = 1;
                      });
                      // _tabController.index = 1;
                      // _selectedValue = "모임";
                      // change_select = true;
                    });
                  },
                  child: Text(
                    "더보기",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'GSANSM',
                        fontSize: 12.0),
                  )),
            ],
          ),
          Container(
            height: 120,
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Club")
                    .doc(name)
                    .collection("Post")
                    .doc("GatheringPost")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error!");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container();
                  } else {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    List a = [];
                    List b = [];
                    List c = [];
                    List date_time = [];
                    List post_intro = [];
                    List max_num = [];
                    List uid_list = [];

                    List revers_title = [];
                    List revers_nick_name = [];
                    // List revers_key_num = [];
                    List revers_date_time = [];
                    List revers_max_num = [];
                    List revers_post_intro = [];
                    List revers_uid_list = [];

                    if (data["GatheringPost"].length != 0) {
                      for (int i = 0; i < data["GatheringPost"].length; i++) {
                        a.add(data["GatheringPost"][i]["ClubPostTitle"]);
                        b.add(data["GatheringPost"][i]["NickName"]);
                        c.add(data["GatheringPost"][i]["KeyNumber"]);
                        date_time.add(data["GatheringPost"][i]["DateTime"]);
                        max_num.add(data["GatheringPost"][i]["MaxNumber"]);
                        post_intro
                            .add(data["GatheringPost"][i]["ClubPostIntro"]);
                        uid_list
                            .add(data["GatheringPost"][i]["GatheringMaster"]);
                      }

                      revers_title = List.of(a.reversed);
                      revers_nick_name = List.of(b.reversed);
                      // revers_key_num = List.of(c.reversed);
                      revers_date_time = List.of(date_time.reversed);
                      revers_max_num = List.of(max_num.reversed);
                      revers_post_intro = List.of(post_intro.reversed);
                      revers_uid_list = List.of(uid_list.reversed);
                      return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5)),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return GatheringPost(
                                        club_uid: name,
                                        post_index: a.length - 1 - index,
                                        prev_post_title: revers_title[index],
                                        prev_post_intro:
                                            revers_post_intro[index],
                                        max_num: revers_max_num[index],
                                        prev_post_datetime:
                                            revers_date_time[index],
                                        prev_post_nickname:
                                            revers_nick_name[index],
                                        prev_post_uid: revers_uid_list[index],
                                        prev_join_id: '',
                                      );
                                    }));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          revers_date_time[index],
                                          style: TextStyle(
                                              fontFamily: 'GSANSM',
                                              color: Color(0xff58585b),
                                              fontSize: 14),
                                        ),
                                        Text(
                                          revers_title[index],
                                          style: TextStyle(
                                              fontFamily: 'GSANSM',
                                              color: Color(0xff58585b),
                                              fontSize: 14),
                                        ),
                                        Text(
                                          revers_nick_name[index],
                                          style: TextStyle(
                                              fontFamily: 'GSANSM',
                                              color: Color(0xff9f9f9f),
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(height: 5);
                          },
                          itemCount: revers_title.length >= 3
                              ? 3
                              : revers_title.length >= 2
                                  ? 2
                                  : 1);
                    } else {
                      return Container(child: Text('\n등록된 글이 없습니다.'));
                    }
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget _gatherBoard_tab() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Padding(
          //       padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          //       child: Text(
          //         '모 임',
          //         style:
          //             TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
          //       ),
          //     ),
          //     // Text(
          //     //   '더보기 +',
          //     //   style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
          //     // ),
          //   ],
          // ),
          SizedBox(
            height: 10,
          ),
          Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
          Expanded(
            child: Container(
              // height: 500,
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Club")
                      .doc(name)
                      .collection("Post")
                      .doc("GatheringPost")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error!");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container();
                    } else {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      List a = [];
                      List b = [];
                      List c = [];
                      List person_num = [];
                      List max_num = [];
                      List uid_list = [];
                      List date_time_list = [];
                      if (data["GatheringPost"].length != 0) {
                        for (int i = 0; i < data["GatheringPost"].length; i++) {
                          a.add(data["GatheringPost"][i]["ClubPostTitle"]);
                          b.add(data["GatheringPost"][i]["ClubPostIntro"]);
                          c.add(data["GatheringPost"][i]["NickName"]);
                          person_num
                              .add(data["GatheringPost"][i]["PersonNumber"]);
                          max_num.add(data["GatheringPost"][i]["MaxNumber"]);
                          uid_list
                              .add(data["GatheringPost"][i]["GatheringMaster"]);
                          date_time_list
                              .add(data["GatheringPost"][i]["DateTime"]);
                        }

                        return ListView.separated(
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (BuildContext context) {
                                        return GatheringPost(
                                          club_uid: name,
                                          post_index: index,
                                          prev_post_title: a[index],
                                          max_num: max_num[index],
                                          prev_post_intro: b[index],
                                          prev_post_datetime:
                                              date_time_list[index],
                                          prev_post_nickname: c[index],
                                          prev_post_uid: uid_list[index],
                                          prev_join_id: '',
                                        );
                                      }));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                              title: Text(
                                                a[index],
                                                style: TextStyle(
                                                    color: Color(0xff58585b),
                                                    fontFamily: 'GSANSB',
                                                    fontSize: 14),
                                              ),
                                              subtitle: Text(
                                                person_num[index].toString() +
                                                    "/" +
                                                    max_num[index],
                                                style: TextStyle(
                                                    color: Color(0xff9f9f9f),
                                                    fontFamily: 'GSANSM',
                                                    fontSize: 12.0),
                                              ),
                                              trailing: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 20, 0, 0),
                                                    child: Text(
                                                      c[index],
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff9f9f9f),
                                                          fontFamily: 'GSANSM',
                                                          fontSize: 12.0),
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   person_num[index]
                                                  //           .toString() +
                                                  //       "/" +
                                                  //       max_num[index],
                                                  //   style: TextStyle(
                                                  //       color:
                                                  //           Color(0xff9f9f9f),
                                                  //       fontFamily: 'GSANSM',
                                                  //       fontSize: 12.0),
                                                  // ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                height: 10,
                                color: Colors.grey[100],
                              );
                            },
                            itemCount: a.length);
                      } else {
                        return Container(child: Text('\n등록된 글이 없습니다.'));
                      }
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }

  // Widget _total_Post() {
  //   return Container(
  //     height: MediaQuery.of(context).size.height / 1.5,
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
  //         Expanded(
  //           child: Container(
  //             child: FutureBuilder(
  //                 future: FirebaseFirestore.instance
  //                     .collection("Club")
  //                     .doc(name)
  //                     .collection("Post")
  //                     .get(),
  //                 builder: (BuildContext context, AsyncSnapshot snapshot) {
  //                   if (snapshot.hasError) {
  //                     return Text("Error!");
  //                   } else if (snapshot.connectionState ==
  //                       ConnectionState.waiting) {
  //                     return Container();
  //                   }else{
  //                     List notice = [];

  //                      return Container();
  //                   }

  //                 }),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _bottomButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: ElevatedButton(
            onPressed: () async {
              ///
              /// 추후 추가로 자신의 UID data를 넣어야한다.
              ///
              try {
                await FirebaseFirestore.instance
                    .collection("Club")
                    .doc(name)
                    .update({
                  "ClubMember": FieldValue.arrayUnion([user.uid]),
                });

                ///
                /// 여기선 로그인하고있는 유저의 UID를 doc에 넣어 User Collection에서 유저의 UID를 가지고 있는 DOC에 넣어 JoinClub Array에 추가 기능
                ///
                await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(user.uid)
                    .update({
                  "JoinClub": FieldValue.arrayUnion([club_uid])
                });

                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return ClubMainPage(
                    club_name: club_uid,
                    club_uid: name,
                    image_url: url_image,
                  );
                }));
              } catch (e) {
                print(e);
              }
            },
            style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Color(0xffe9394f),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
                elevation: 1),
            child: Text(
              "가입하기",
              style: TextStyle(
                fontFamily: 'GSANSB',
                fontSize: 16,
              ),
            )),
      ),
    );
  }

  Widget change_Board() {
    if (_selectedValue == "일반게시글") {
      return _normalBoard_tab();
    } else if (_selectedValue == "공지사항") {
      return _noticeBorad_tab();
    } else {
      return _gatherBoard_tab();
    }
  }

  Widget choice_change_Board() {
    if (change_string == "공지사항") {
      return Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0), child: _noticeBorad_tab());
    } else {
      return Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0), child: _gatherBoard_tab());
    }
  }

  Widget ChatRoom() {
    //List<ChatMessageWidget> _messages = [];
    //List<ChatMessageWidget> reversedList = [];
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: _getComment(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Error!");
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container();
                } else {
                  //_messages.clear();

                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  List user_nick_name = [];
                  List chat_comment = [];
                  List total_user_uid = [];
                  List time_stamp = [];
                  List profile_image = [];

                  if (data["ChatRoom"].length != 0) {
                    // _messages.clear();

                    for (int i = 0; i < data["ChatRoom"].length; i++) {
                      user_nick_name.add(data["ChatRoom"][i]["NickName"]);
                      chat_comment.add(data["ChatRoom"][i]["Comment"]);
                      total_user_uid.add(data["ChatRoom"][i]["UserUID"]);
                      time_stamp.add(data["ChatRoom"][i]["TimeStamp"]);
                      profile_image.add(data["ChatRoom"][i]["Profile_image"]);
                    }

                    List reversChat = [];
                    List reversNick = [];
                    List reversUid = [];
                    List reversTime = [];
                    List revers_profile = [];

                    reversChat = List.from(chat_comment.reversed).toList();
                    reversNick = List.from(user_nick_name.reversed).toList();
                    reversUid = List.from(total_user_uid.reversed).toList();
                    reversTime = List.from(time_stamp.reversed).toList();
                    revers_profile = List.of(profile_image.reversed).toList();

                    return ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      itemBuilder: (_, int index) {
                        // return _messages[index];

                        return ListTile(
                          title: Column(
                            crossAxisAlignment: user.uid == reversUid[index]
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                child: Text(
                                  user.uid == reversUid[index]
                                      ? ""
                                      : reversNick[index],
                                  style: TextStyle(
                                      fontFamily: 'GSANSM', fontSize: 11.0),
                                ),
                              ),
                              user.uid == reversUid[index]
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 20, 0, 0),
                                          child: Text(
                                            reversTime[index],
                                            style: TextStyle(
                                                fontFamily: 'GSANSM',
                                                fontSize: 9.0),
                                          ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            padding: EdgeInsets.fromLTRB(
                                                15, 10, 15, 10),
                                            decoration: BoxDecoration(
                                                color: Color(0xffFBD6C2),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 1),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(0))),
                                            child: Text(
                                              reversChat[index],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily: 'GSANSM'),
                                            )),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          // onTap: () {
                                          //   print(reversNick[index].toString());
                                          // },
                                          onLongPress: () {
                                            if (userAccount_.grade ==
                                                "NomalUser") {
                                              _showDialog_error(context);
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return Container(
                                                    child: SimpleDialog(
                                                      backgroundColor:
                                                          Colors.white,
                                                      elevation: 2.0,
                                                      children: <Widget>[
                                                        SimpleDialogOption(
                                                          onPressed: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      "채팅글 삭제"),
                                                                  content: Text(
                                                                    "정말로 삭제하시겠습니까?",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "GSANSM"),
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ElevatedButton(
                                                                          child:
                                                                              Text(
                                                                            "삭제",
                                                                            style: TextStyle(
                                                                                fontFamily: 'GSANSM',
                                                                                fontSize: 14,
                                                                                color: Colors.white),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            for (int i = 0;
                                                                                i < reversUid.length;
                                                                                i++) {
                                                                              if (
                                                                                  // user_nick_name[i] == reversNick[index] &&
                                                                                  chat_comment[i] == reversChat[index] && total_user_uid[i] == reversUid[index]) {
                                                                                List delete_chat = [
                                                                                  {
                                                                                    "Comment": "삭제된 메세지입니다.",
                                                                                    "NickName": reversNick[index],
                                                                                    "TimeStamp": reversTime[index],
                                                                                    "UserUID": reversUid[index]
                                                                                  }
                                                                                ];

                                                                                List delete_chat_1 = [
                                                                                  {
                                                                                    "Comment": reversChat[index],
                                                                                    "NickName": reversNick[index],
                                                                                    "TimeStamp": reversTime[index],
                                                                                    "UserUID": reversUid[index],
                                                                                    "Profile_image": revers_profile[index]
                                                                                  }
                                                                                ];
                                                                                FirebaseFirestore.instance.collection("Club").doc(name).collection("ChatRoom").doc("ChatRoom").update({
                                                                                  "ChatRoom": FieldValue.arrayRemove(delete_chat_1),
                                                                                });

                                                                                // FirebaseFirestore
                                                                                //     .instance
                                                                                //     .collection(
                                                                                //         "Club")
                                                                                //     .doc(name)
                                                                                //     .collection(
                                                                                //         "ChatRoom")
                                                                                //     .doc(
                                                                                //         "ChatRoom")
                                                                                //     .update({
                                                                                //   "ChatRoom": FieldValue
                                                                                //       .arrayUnion(
                                                                                //           delete_chat),
                                                                                // });
                                                                                Navigator.of(context)..pop()..pop();
                                                                              }
                                                                            }
                                                                          },
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              30,
                                                                        ),
                                                                        ElevatedButton(
                                                                          child:
                                                                              Text(
                                                                            "취소",
                                                                            style: TextStyle(
                                                                                fontFamily: 'GSANSM',
                                                                                fontSize: 14,
                                                                                color: Colors.white),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: Text(
                                                            '메세지 삭제',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "GSANSM"),
                                                          ),
                                                        ),
                                                        Divider(
                                                            thickness: 1.5,
                                                            height: 1.5,
                                                            color: Colors.grey),
                                                        SimpleDialogOption(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            '취소',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "GSANSM"),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: revers_profile[index] == ""
                                              ? Container(
                                                  width: 40,
                                                  height: 40,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      child: SvgPicture.asset(
                                                        'assets/images/SVG/profile_pink.svg',
                                                        width: 40,
                                                      )),
                                                )
                                              : Container(
                                                  width: 40,
                                                  height: 40,
                                                  child: CircleAvatar(
                                                      backgroundColor: Colors
                                                          .white,
                                                      radius: 120,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              revers_profile[
                                                                  index])),
                                                ),
                                        ),
                                        Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            padding: EdgeInsets.fromLTRB(
                                                15, 10, 15, 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Color(0xffFBD6C2),
                                                    width: 1),
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(0),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                            child: Text(
                                              reversChat[index],
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontFamily: 'GSANSM'),
                                            )),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 20, 20, 0),
                                          child: Text(
                                            reversTime[index],
                                            style: TextStyle(
                                                fontFamily: 'GSANSM',
                                                fontSize: 9.0),
                                          ),
                                        ),
                                      ],
                                    )
                            ],
                          ),
                        );
                      },
                      itemCount: data["ChatRoom"].length,
                    );
                  } else {
                    return Text("채팅글 없음");
                  }
                }
              },
            ),
          ),
          Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
          SingleChildScrollView(
            child: Container(
              color: Colors.grey[200],
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5),
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: TextField(
                          controller: _controller,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              fillColor: Colors.grey[200],
                              filled: true,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      var txt = _controller.text;
                      //var now = DateTime.now().millisecondsSinceEpoch;
                      if (txt != "") {
                        List add_text = [];
                        add_text.add({
                          "Comment": txt,
                          "NickName": userAccount_.nickname,
                          "UserUID": user1.uid,
                          "TimeStamp": formatDate(
                              DateTime.now(), [am, ' ', hh, ':', nn]),
                          "Profile_image": userAccount_.profile_image
                        });
                        _controller.clear();
                        await FirebaseFirestore.instance
                            .collection('Club')
                            .doc(name)
                            .collection("ChatRoom")
                            .doc("ChatRoom")
                            .update(
                                {"ChatRoom": FieldValue.arrayUnion(add_text)});
                        add_text.clear();

                        // _focusNode.requestFocus();
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                      } else {
                        print("채팅 공백 시도함");
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xffe83a4f),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset("assets/images/SVG/arrow.svg"),
                          onPressed: null,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  late TabController _tabController =
      new TabController(length: 3, vsync: this, initialIndex: 0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);

    _tabController.addListener(_switchTabIndex);
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  void _switchTabIndex() {
    print(_tabController.index);
    setState(() {});
  }

  // final list_controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser!;
    print("build안에 _selectedValue값 변경 내역\t" + _selectedValue);

    userAccount_ = Provider.of(context, listen: false);

    // Timer(
    //   Duration(seconds: 1),
    //   () => list_controller.jumpTo(list_controller.position.maxScrollExtent),
    // );

    String _colorName = 'No';
    Color _color = Colors.black;
    getData(club_uid);

    return WillPopScope(
      onWillPop: () {
        setState(() {
          print("back press 실행");
        });
        if (_tabController.index == 1 || _tabController.index == 2) {
          _tabController.index = 0;
          return Future(() => false);
        } else {
          return Future(() => true);
        }
      },
      child: Scaffold(
        body: DefaultTabController(
          length: 3,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            endDrawer: Drawer(
                child: ClubDrawer(
              club_uid: name,
              club_name: club_uid,
            )),
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xFFFFFFFF),
              iconTheme: IconThemeData(color: Colors.grey),
              automaticallyImplyLeading: false,
              title: SvgPicture.asset(
                'assets/images/SVG/LOGO_KAMMON_small.svg',
                width: 110,
              ),
              //SvgPicture.asset('assets/images/SVG/logo.svg', width: 150,),
              leading: IconButton(
                onPressed: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (BuildContext context) {
                  //   return FirstScreen();
                  // }));
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              actions: [],
              centerTitle: true,
              elevation: 0,
              shape: Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
              bottom: TabBar(
                indicatorColor: Color(0xffe83a4f),
                indicatorWeight: 3.0,
                controller: _tabController,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    child: Text(
                      "MAIN",
                      style: TextStyle(
                          fontFamily: 'GSANSM',
                          fontSize: 14,
                          color: Color(0xff58585b)),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "게시판",
                      style: TextStyle(
                          fontFamily: 'GSANSM',
                          fontSize: 14,
                          color: Color(0xff58585b)),
                    ),
                  ),

                  Tab(
                    child: Text(
                      "채팅",
                      style: TextStyle(
                          fontFamily: 'GSANSM',
                          fontSize: 14,
                          color: Color(0xff58585b)),
                    ),
                  ),
                  // Tab(icon: Icon(Icons.directions_bike)),
                ],
              ),
            ),
            floatingActionButton: _tabController.index != 1
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      if (_selectedValue == "일반게시글") {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Nomal(
                              club_name: club_uid, club_real_uid: name);
                        }));
                      } else if (_selectedValue == "모임") {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Gathering(club_uid: club_uid, club_name: name);
                        }));
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Notice(club_uid: club_uid, club_name: name);
                        }));
                      }
                    },
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 4,
                    child: Icon(
                      Icons.add,
                      color: Color(0xFFFFFFFF),
                      size: 40,
                    ),
                  ),

            // CircularMenu(
            //     // menu alignment
            //     alignment: Alignment.bottomRight,
            //     // menu radius
            //     radius: 70,
            //     // widget in the background holds actual page content
            //     //backgroundWidget: MyCustomWidget(),
            //     // global key to control the animation anywhere in the code.
            //     key: GlobalKey<CircularMenuState>(),
            //     // animation duration
            //     animationDuration: Duration(milliseconds: 300),
            //     // animation curve in forward
            //     curve: Curves.easeInOut,
            //     // animation curve in reverse
            //     reverseCurve: Curves.fastOutSlowIn,
            //     // first item angle
            //     //startingAngleInRadian : 0 ,
            //     // last item angle
            //     //endingAngleInRadian : 3.141592 * 3,
            //     // toggle button callback
            //     toggleButtonOnPressed: () {
            //       //callback
            //     },
            //     // toggle button appearance properties
            //     toggleButtonColor: Theme.of(context).primaryColor,
            //     toggleButtonBoxShadow: [
            //       BoxShadow(
            //         color: Theme.of(context).primaryColor,
            //         blurRadius: 1,
            //       ),
            //     ],
            //     //toggleButtonAnimatedIconData: AnimatedIcons.add_event,

            //     toggleButtonIconColor: Colors.white,
            //     toggleButtonMargin: 10.0,
            //     toggleButtonPadding: 10.0,
            //     toggleButtonSize: 30.0,
            //     items: [
            //       CircularMenuItem(
            //           iconSize: 30,
            //           boxShadow: [
            //             BoxShadow(
            //               color: Theme.of(context).primaryColor,
            //               blurRadius: 1,
            //             ),
            //           ],
            //           icon: Icons.groups,
            //           color: Theme.of(context).primaryColor,
            //           onTap: () {
            //             setState(() {
            //               _color = Colors.green;
            //               _colorName = 'Green';
            //             });

            //             Navigator.push(context, MaterialPageRoute(
            //                 builder: (BuildContext context) {
            //               return Gathering(
            //                   club_uid: club_uid, club_name: name);
            //             }));
            //           }),
            //       CircularMenuItem(
            //           boxShadow: [
            //             BoxShadow(
            //               color: Theme.of(context).primaryColor,
            //               blurRadius: 1,
            //             ),
            //           ],
            //           icon: Icons.post_add,
            //           color: Theme.of(context).primaryColor,
            //           onTap: () {
            //             setState(() {
            //               _color = Colors.blue;
            //               _colorName = 'Blue';
            //             });
            //             Navigator.push(context, MaterialPageRoute(
            //                 builder: (BuildContext context) {
            //               return Nomal(
            //                   club_name: club_uid, club_real_uid: name);
            //             }));
            //           }),
            //       CircularMenuItem(
            //           boxShadow: [
            //             BoxShadow(
            //               color: Theme.of(context).primaryColor,
            //               blurRadius: 1,
            //             ),
            //           ],
            //           icon: Icons.campaign,
            //           color: Theme.of(context).primaryColor,
            //           onTap: () {
            //             setState(() {
            //               _color = Colors.orange;
            //               _colorName = 'Orange';
            //             });
            //             Navigator.push(context, MaterialPageRoute(
            //                 builder: (BuildContext context) {
            //               return Notice(
            //                   club_uid: club_uid, club_name: name);
            //             }));
            //           }),
            //     ],
            //   ),
            body: TabBarView(controller: _tabController, children: [
              SafeArea(
                  child: SingleChildScrollView(
                child: Container(
                  color: Color(0xFFFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: Text(
                              club_uid,
                              style: TextStyle(
                                  fontFamily: 'GSANSB',
                                  fontSize: 20.0,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              //color: Theme.of(context).primaryColorLight,
                              // decoration: BoxDecoration(
                              //   color: Theme.of(context).primaryColorLight,
                              //   // image: DecorationImage(
                              //   //     image: NetworkImage(
                              //   //       url_image,
                              //   //     ),
                              //   //     fit: BoxFit.fill),
                              // ),
                              child: url_image != ""
                                  ? CachedNetworkImage(
                                      imageUrl: url_image,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                            // colorFilter: const ColorFilter.mode(
                                            //   Colors.red,
                                            //   BlendMode.colorBurn,
                                            // ),
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Container(
                                        width: 200,
                                        height: 200,
                                        // color: Colors.purple,
                                        child: Image.asset(
                                            "assets/images/GIF/Rolling_295px.gif"),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    )
                                  : Container(
                                      color: Colors.red[100],
                                      // decoration: BoxDecoration(
                                      //   color: Colors.red[200],
                                      // ),
                                    )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Column(
                              children: [
                                _noticeBorad(),
                                SizedBox(
                                  height: 20,
                                ),
                                _gatherBoard(),
                              ],
                            ),
                          )
                        ]),
                  ),
                ),
              )),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: DropdownButton(
                        elevation: 0,
                        isExpanded: false,
                        value: _selectedValue,
                        items: board_select.map(
                          (value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontSize: 14, fontFamily: 'GMARKETSANSM'),
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value.toString();

                            print("onChange" + _selectedValue);
                          });
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: change_Board()),
                  ],
                ),
              ),
              // Container(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Padding(
              //         padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              //         child: DropdownButton(
              //           elevation: 0,
              //           isExpanded: false,
              //           value: _selectedValue,
              //           items: board_select.map(
              //             (value) {
              //               return DropdownMenuItem(
              //                 value: value,
              //                 child: Text(
              //                   value,
              //                   style: TextStyle(
              //                       fontSize: 14, fontFamily: 'GMARKETSANSM'),
              //                 ),
              //               );
              //             },
              //           ).toList(),
              //           onChanged: (value) {
              //             setState(() {
              //               _selectedValue = value.toString();

              //               print("onChange" + _selectedValue);
              //             });
              //           },
              //         ),
              //       ),
              //       Padding(
              //           padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              //           child: change_Board()),
              //     ],
              //   ),
              // ),
              ChatRoom(),
            ]),
            bottomNavigationBar: SizedBox(
                height: 60,
                child: Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 5.0,
                            offset: Offset(0.0, 0.75))
                      ],
                    ),
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.white,
                      elevation: 3,
                      selectedItemColor: Theme.of(context).primaryColor,
                      currentIndex: _selectedNaviIndex,
                      onTap: (int index) {
                        _selectedNaviIndex = index;
                        setState(() {
                          if (_selectedNaviIndex == 0) {
                            print(_selectedNaviIndex);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return Home();
                            }));
                          }
                          if (_selectedNaviIndex == 1) {
                            print(_selectedNaviIndex);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return InstantPLay();
                            }));
                          }
                          if (_selectedNaviIndex == 2) {
                            print(_selectedNaviIndex);
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return FirstScreen();
                            }));
                          }
                          if (_selectedNaviIndex == 3) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return MarketMainPage(
                                  item_id: userAccount_.marketChatItem);
                            }));
                          }
                        });
                      },
                      items: [
                        BottomNavigationBarItem(
                          title: Text(
                            '홈',
                            style:
                                TextStyle(fontFamily: 'GSANSM', fontSize: 11),
                          ),
                          icon: SvgPicture.asset(
                            'assets/images/SVG/home.svg',
                            width: 23,
                          ),
                          activeIcon: SvgPicture.asset(
                            'assets/images/SVG/home_selected.svg',
                            width: 23,
                          ),
                        ),
                        BottomNavigationBarItem(
                          title: Text(
                            '벙개',
                            style:
                                TextStyle(fontFamily: 'GSANSM', fontSize: 11),
                          ),
                          icon: SvgPicture.asset(
                            'assets/images/SVG/light.svg',
                            width: 23,
                          ),
                          activeIcon: SvgPicture.asset(
                            'assets/images/SVG/light_selected.svg',
                            width: 23,
                          ),
                        ),
                        BottomNavigationBarItem(
                          title: Text('클럽',
                              style: TextStyle(
                                  fontFamily: 'GSANSM', fontSize: 11)),
                          icon: SvgPicture.asset(
                            'assets/images/SVG/club.svg',
                            width: 23,
                          ),
                          activeIcon: SvgPicture.asset(
                            'assets/images/SVG/club_selected.svg',
                            width: 23,
                          ),
                        ),
                        BottomNavigationBarItem(
                          title: Text(
                            '중고장터',
                            style:
                                TextStyle(fontFamily: 'GSANSM', fontSize: 11),
                          ),
                          icon: SvgPicture.asset(
                            'assets/images/SVG/basket.svg',
                            width: 23,
                          ),
                          activeIcon: SvgPicture.asset(
                            'assets/images/SVG/basket_selected.svg',
                            width: 23,
                          ),
                        ),
                        BottomNavigationBarItem(
                          title: Text('더보기',
                              style: TextStyle(
                                  fontFamily: 'GSANSM', fontSize: 11)),
                          icon: SvgPicture.asset(
                            'assets/images/SVG/more.svg',
                            width: 23,
                          ),
                          activeIcon: SvgPicture.asset(
                            'assets/images/SVG/more_selected.svg',
                            width: 23,
                          ),
                        ),
                      ],
                    ))),
          ),
        ),
      ),
    );
  }
}

void _showDialog_error(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("권한 탐색"),
        content: Text("접근할 수 있는 권한이 없습니다"),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              "나가기",
              style: TextStyle(
                  fontFamily: 'GSANSM', fontSize: 14, color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _showDialog_delete_check(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("채팅글 삭제"),
        content: Text(
          "정말로 삭제하시겠습니까?",
          style: TextStyle(fontFamily: "GSANSM"),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              "나가기",
              style: TextStyle(
                  fontFamily: 'GSANSM', fontSize: 14, color: Colors.white),
            ),
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
// import 'dart:async';

// import 'package:circular_menu/circular_menu.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:date_format/date_format.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/club/Chat_Message_Widget.dart';
// import 'package:snstennis/club/Gathering_Post_1_1.dart';
// import 'package:snstennis/club/Gathering_Post_Write_1_1.dart';
// import 'package:snstennis/club/Nomal_Post_Write_1_1.dart';
// import 'package:snstennis/club/Notice_Post_1_2.dart';
// import 'package:snstennis/club/Notice_Post_Write_1_1.dart';
// import 'package:snstennis/club/club_drawer_1_0.dart';
// import 'package:snstennis/club/first_screen_1_0.dart';
// import 'package:snstennis/home.dart';
// import 'package:snstennis/instant/instant_main.dart';
// import 'package:snstennis/market/Market_Main_Page.dart';

// //import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// import 'dart:io';

// // import 'Notice_Post.dart';
// // import 'Nomal_Post.dart';
// import 'Club_Member_Join_List.dart';
// import 'Nomal_Post_1_0.dart';

// class ClubMainPage extends StatefulWidget {
//   final String club_uid;
//   final String club_name;
//   final String image_url;

//   const ClubMainPage(
//       {Key? key,
//       required this.club_uid,
//       required this.club_name,
//       required this.image_url})
//       : super(key: key);

//   @override
//   _ClubMainPageState createState() =>
//       _ClubMainPageState(club_uid, club_name, image_url);
// }

// TextEditingController _controller = TextEditingController();
// GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();

// class _ClubMainPageState extends State<ClubMainPage>
//     with SingleTickerProviderStateMixin {
//   String name = "";
//   String club_uid = '';
//   String url_image = "";
//   late User user;
//   final FocusNode _focusNode = FocusNode();

//   int _selectedNaviIndex = 2;

//   late UserAccountInfo userAccount_;

//   late String user_grade = "";

//   User user1 = FirebaseAuth.instance.currentUser!;

//   List board_select = ["일반게시글", "공지사항", "모임"];

//   String _selectedValue = "일반게시글";

//   bool change_select = false;

//   String change_string = "";

//   _ClubMainPageState(this.name, this.club_uid, this.url_image);

//   Future<UserAccountInfo> getData(String club_uid) async {
//     var check_grade;
//     CollectionReference ref = FirebaseFirestore.instance.collection('Club');
//     DocumentSnapshot snapshot =
//         await ref.doc(name).collection("ClubMember").doc("MemberList").get();
//     var data = snapshot.data() as Map;

//     for (int i = 0; i < data["ClubMember"].length; i++) {
//       if (data["ClubMember"][i]["UserID"] == user.uid) {
//         check_grade = data["ClubMember"][i]["Grade"];
//       }
//     }
//     userAccount_.checkGrade(check_grade);
//     return userAccount_;
//   }

//   Stream<DocumentSnapshot> _getComment() {
//     return FirebaseFirestore.instance
//         .collection("Club")
//         .doc(name)
//         .collection("ChatRoom")
//         .doc("ChatRoom")
//         .snapshots();
//   }

//   // Widget member_Grade_View(){
//   //   if(userAccount_.grade_ == "Master" || userAccount_.grade_ == "SysOP"){
//   //     return SafeArea(child: child)
//   //   }else{

//   //   }
//   // }

//   Widget _noticeBorad() {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 170,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '공지사항',
//                 style: TextStyle(
//                     fontFamily: 'GSANSB',
//                     color: Colors.grey[700],
//                     fontSize: 16),
//               ),
//               // Text(
//               //   '더보기 +',
//               //   style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
//               // ),
//               TextButton(
//                   onPressed: () {
//                     setState(() {
//                       // _selectedValue = "공지사항";
//                       _tabController.index = 1;
//                     });
//                   },
//                   child: Text(
//                     "더보기",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontFamily: 'GSANSM',
//                         fontSize: 12.0),
//                   ))
//             ],
//           ),
//           Container(
//             height: 120,
//             child: StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("Club")
//                     .doc(name)
//                     .collection("Post")
//                     .doc("NoticePost")
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<DocumentSnapshot> snapshot) {
//                   if (snapshot.hasError) {
//                     return Text("Error!");
//                   } else if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return Container();
//                   } else {
//                     Map<String, dynamic> data =
//                         snapshot.data!.data() as Map<String, dynamic>;

//                     //_getGrade(user1.uid, club_uid);

//                     List a = [];
//                     List b = [];
//                     List date_time = [];
//                     List key_num = [];
//                     List post_intro = [];

//                     List revers_title = [];
//                     List revers_intro = [];
//                     List revers_Nick = [];
//                     List revers_date_time = [];
//                     List revers_key_num = [];

//                     //if (data["NoticePost"] != null) {
//                     if (data["NoticePost"].length != 0) {
//                       for (int i = 0; i < data["NoticePost"].length; i++) {
//                         a.add(data["NoticePost"][i]["ClubPostTitle"]);
//                         b.add(data["NoticePost"][i]["NickName"]);
//                         date_time.add(data["NoticePost"][i]["DateTime"]);
//                         key_num.add(data["NoticePost"][i]["KeyNumber"]);
//                         post_intro.add(data["NoticePost"][i]["ClubPostIntro"]);
//                       }

//                       revers_title = List.of(a.reversed);
//                       revers_Nick = List.of(b.reversed);
//                       revers_date_time = List.of(date_time.reversed);
//                       revers_key_num = List.of(key_num.reversed);
//                       revers_intro = List.of(post_intro);
//                       return ListView.separated(
//                           physics: NeverScrollableScrollPhysics(),
//                           itemBuilder: (BuildContext context, int index) {
//                             return Container(
//                                 height: 35,
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey[200],
//                                     borderRadius: BorderRadius.circular(5)),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(context, MaterialPageRoute(
//                                         builder: (BuildContext context) {
//                                       return NoticePost(
//                                         index: int.parse(revers_key_num[index]),
//                                         club_uid: name,
//                                         key_num: revers_key_num[index],
//                                         prev_post_intro: revers_intro[index],
//                                         prev_post_nickname: revers_Nick[index],
//                                         prev_post_title: revers_title[index],
//                                       );
//                                     }));
//                                   },
//                                   child: Padding(
//                                     padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           revers_date_time[index],
//                                           style: TextStyle(
//                                               fontFamily: 'GSANSM',
//                                               color: Color(0xff58585b),
//                                               fontSize: 14),
//                                         ),
//                                         Text(revers_title[index],
//                                             style: TextStyle(
//                                                 fontFamily: 'GSANSM',
//                                                 color: Color(0xff58585b),
//                                                 fontSize: 14)),
//                                         Text(
//                                           revers_Nick[index],
//                                           style: TextStyle(
//                                               fontFamily: 'GSANSM',
//                                               color: Color(0xff9f9f9f),
//                                               fontSize: 12),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ));
//                           },
//                           separatorBuilder: (BuildContext context, int index) {
//                             return Container(height: 5);
//                           },
//                           itemCount: revers_title.length >= 3
//                               ? 3
//                               : revers_title.length >= 2
//                                   ? 2
//                                   : 1);
//                     } else {
//                       return Container(child: Text('\n등록된 글이 없습니다.'));
//                     }
//                   }
//                 }),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _noticeBorad_tab() {
//     return Container(
//       // width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height / 1.5,

//       child: Column(
//         children: [
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     Text(
//           //       '공지사항',
//           //       style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
//           //     ),
//           //     // Text(
//           //     //   '더보기 +',
//           //     //   style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
//           //     // ),
//           //   ],
//           // ),
//           SizedBox(
//             height: 10,
//           ),
//           Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
//           Expanded(
//             child: Container(
//               // height: 520,
//               child: StreamBuilder<DocumentSnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection("Club")
//                       .doc(name)
//                       .collection("Post")
//                       .doc("NoticePost")
//                       .snapshots(),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<DocumentSnapshot> snapshot) {
//                     if (snapshot.hasError) {
//                       return Text("Error!");
//                     } else if (snapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return Container();
//                     } else {
//                       Map<String, dynamic> data =
//                           snapshot.data!.data() as Map<String, dynamic>;

//                       //_getGrade(user1.uid, club_uid);

//                       List a = [];
//                       List b = [];
//                       List c = [];
//                       List key_num = [];

//                       List revers_title = [];
//                       List revers_Nick = [];
//                       List revers_intro = [];
//                       //if (data["NoticePost"] != null) {
//                       if (data["NoticePost"].length != 0) {
//                         for (int i = 0; i < data["NoticePost"].length; i++) {
//                           a.add(data["NoticePost"][i]["ClubPostTitle"]);
//                           b.add(data["NoticePost"][i]["ClubPostIntro"]);
//                           c.add(data["NoticePost"][i]["NickName"]);
//                           key_num.add(data["NoticePost"][i]["KeyNumber"]);
//                         }

//                         // revers_title = List.of(a.reversed);
//                         // revers_intro = List.of(b.reversed);
//                         // revers_Nick = List.of(c.reversed);

//                         return ListView.separated(
//                             itemBuilder: (BuildContext context, int index) {
//                               return SingleChildScrollView(
//                                 child: Container(
//                                     // width: 250,
//                                     // height: 80,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(5),
//                                     ),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         Navigator.push(context,
//                                             MaterialPageRoute(builder:
//                                                 (BuildContext context) {
//                                           return NoticePost(
//                                             index: index,
//                                             club_uid: name,
//                                             key_num: key_num[index],
//                                             prev_post_intro: b[index],
//                                             prev_post_nickname: c[index],
//                                             prev_post_title: a[index],
//                                           );
//                                         }));
//                                       },
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           ListTile(
//                                             title: Text(
//                                               a[index],
//                                               style: TextStyle(
//                                                   color: Color(0xff58585b),
//                                                   fontFamily: 'GSANSB',
//                                                   fontSize: 14),
//                                             ),
//                                             subtitle: Text(
//                                               b[index],
//                                               style: TextStyle(
//                                                   color: Color(0xff9f9f9f),
//                                                   fontFamily: 'GSANSM',
//                                                   fontSize: 12.0),
//                                             ),
//                                             trailing: Padding(
//                                               padding: EdgeInsets.fromLTRB(
//                                                   0, 25, 0, 0),
//                                               child: Text(
//                                                 c[index],
//                                                 style: TextStyle(
//                                                     color: Color(0xff9f9f9f),
//                                                     fontFamily: 'GSANSM',
//                                                     fontSize: 12.0),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       // child: Padding(
//                                       //   padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
//                                       //   child: Column(
//                                       //     // mainAxisAlignment:
//                                       //     //     MainAxisAlignment.spaceBetween,

//                                       //     children: [
//                                       //       // Text(
//                                       //       //   a[index],
//                                       //       //   style: TextStyle(
//                                       //       //       fontFamily: 'GSANSM',
//                                       //       //       color: Colors.grey[700]),
//                                       //       // ),
//                                       //       // Text(
//                                       //       //   b[index],
//                                       //       //   style: TextStyle(
//                                       //       //       fontFamily: 'GSANSM',
//                                       //       //       color: Colors.grey[700]),
//                                       //       // ),
//                                       //       ListTile(
//                                       //         title: Text(
//                                       //           a[index],
//                                       //           style: TextStyle(
//                                       //               color: Colors.grey[700],
//                                       //               fontFamily: 'GSANSB'),
//                                       //         ),
//                                       //       ),
//                                       //     ],
//                                       //   ),
//                                       // ),
//                                     )),
//                               );
//                             },
//                             separatorBuilder:
//                                 (BuildContext context, int index) {
//                               return Container(
//                                 height: 10,
//                                 color: Colors.grey[100],
//                               );
//                             },
//                             itemCount: a.length);
//                       } else {
//                         return Container(child: Text('\n등록된 글이 없습니다.'));
//                       }
//                     }
//                   }),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _normalBoard() {
//     return Container(
//       height: 400,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '게시판',
//                 style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
//               ),
//               // Text(
//               //   '더보기 +',
//               //   style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
//               // ),
//             ],
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             height: 350,
//             child: StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("Club")
//                     .doc(name)
//                     .collection("Post")
//                     .doc("NomalPost")
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<DocumentSnapshot> snapshot) {
//                   if (snapshot.hasError) {
//                     return Text("Error!");
//                   } else if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return Container();
//                   } else {
//                     Map<String, dynamic> data =
//                         snapshot.data!.data() as Map<String, dynamic>;
//                     List a = [];
//                     List b = [];
//                     List c = [];
//                     //if (data["NomalPost"] != null) {
//                     if (data["NomalPost"].length != 0) {
//                       for (int i = 0; i < data["NomalPost"].length; i++) {
//                         a.add(data["NomalPost"][i]["ClubPostTitle"]);
//                         b.add(data["NomalPost"][i]["ClubPostIntro"]);
//                         c.add(data["NomalPost"][i]["NickName"]);
//                       }
//                       return ListView.separated(
//                           itemBuilder: (BuildContext context, int index) {
//                             return Container(
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(5),
//                                     border: Border.all(
//                                         color: Colors.grey, width: 1)),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     // Navigator.push(context, MaterialPageRoute(
//                                     //     builder: (BuildContext context) {
//                                     //   return NomalPost(
//                                     //     index: index,
//                                     //     club_uid: name,

//                                     //   );
//                                     // }));
//                                   },
//                                   child: Padding(
//                                     padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         ListTile(
//                                           leading: FlutterLogo(size: 72.0),
//                                           title: Text(
//                                             a[index],
//                                             style: TextStyle(
//                                                 color: Colors.grey[700],
//                                                 fontFamily: 'GSANSB',
//                                                 fontSize: 14.0),
//                                           ),
//                                           // subtitle: Text(
//                                           //   b[index],
//                                           //   style: TextStyle(
//                                           //       color: Colors.grey[700],
//                                           //       fontFamily: 'GSANSB',
//                                           //       fontSize: 12.0),
//                                           // ),
//                                           trailing: Text(
//                                             c[index],
//                                             style: TextStyle(
//                                                 color: Colors.grey[700],
//                                                 fontFamily: 'GSANSB',
//                                                 fontSize: 12.0),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ));
//                           },
//                           separatorBuilder: (BuildContext context, int index) {
//                             return Container(height: 5);
//                           },
//                           itemCount: a.length);
//                     } else {
//                       return Container(child: Text('\n등록된 글이 없습니다.'));
//                     }
//                   }
//                 }),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _normalBoard_tab() {
//     return Container(
//       height: MediaQuery.of(context).size.height / 1.5,
//       child: Column(
//         children: [
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     Text(
//           //       '게시판',
//           //       style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
//           //     ),
//           //     // Text(
//           //     //   '더보기 +',
//           //     //   style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
//           //     // ),
//           //   ],
//           // ),
//           SizedBox(
//             height: 10,
//           ),
//           Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
//           Expanded(
//             child: Container(
//               // height: 450,
//               child: StreamBuilder<DocumentSnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection("Club")
//                       .doc(name)
//                       .collection("Post")
//                       .doc("NomalPost")
//                       .snapshots(),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<DocumentSnapshot> snapshot) {
//                     if (snapshot.hasError) {
//                       return Text("Error!");
//                     } else if (snapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return Container();
//                     } else {
//                       Map<String, dynamic> data =
//                           snapshot.data!.data() as Map<String, dynamic>;
//                       List a = [];
//                       List b = [];
//                       List c = [];
//                       List number_key = [];
//                       //if (data["NomalPost"] != null) {
//                       if (data["NomalPost"].length != 0) {
//                         for (int i = 0; i < data["NomalPost"].length; i++) {
//                           a.add(data["NomalPost"][i]["ClubPostTitle"]);
//                           b.add(data["NomalPost"][i]["ClubPostIntro"]);
//                           c.add(data["NomalPost"][i]["NickName"]);
//                           number_key.add(data["NomalPost"][i]["KeyNumber"]);
//                         }
//                         return ListView.separated(
//                             itemBuilder: (BuildContext context, int index) {
//                               return Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(context, MaterialPageRoute(
//                                           builder: (BuildContext context) {
//                                         return NomalPost(
//                                             index: index,
//                                             club_uid: name,
//                                             prev_post_intro: b[index],
//                                             prev_post_nickname: c[index],
//                                             prev_post_title: a[index],
//                                             key_num: number_key[index]);
//                                       }));
//                                     },
//                                     child: Padding(
//                                       padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           ListTile(
//                                             // leading: FlutterLogo(size: 72.0),
//                                             title: Text(
//                                               a[index],
//                                               style: TextStyle(
//                                                   color: Color(0xff58585b),
//                                                   fontFamily: 'GSANSB',
//                                                   fontSize: 14),
//                                             ),
//                                             subtitle: Text(
//                                               b[index],
//                                               style: TextStyle(
//                                                   color: Color(0xff9f9f9f),
//                                                   fontFamily: 'GSANSM',
//                                                   fontSize: 12.0),
//                                             ),
//                                             trailing: Padding(
//                                               padding: EdgeInsets.fromLTRB(
//                                                   0, 25, 0, 0),
//                                               child: Text(
//                                                 c[index],
//                                                 style: TextStyle(
//                                                     color: Color(0xff9f9f9f),
//                                                     fontFamily: 'GSANSM',
//                                                     fontSize: 12.0),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ));
//                             },
//                             separatorBuilder:
//                                 (BuildContext context, int index) {
//                               return Container(
//                                   height: 10, color: Colors.grey[100]);
//                             },
//                             itemCount: a.length);
//                       } else {
//                         return Container(child: Text('\n등록된 글이 없습니다.'));
//                       }
//                     }
//                   }),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _gatherBoard() {
//     return Container(
//       height: 170,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '모 임',
//                 style: TextStyle(
//                     fontFamily: 'GSANSB',
//                     color: Color(0xff58585b),
//                     fontSize: 16),
//               ),
//               TextButton(
//                   onPressed: () {
//                     setState(() {
//                       _tabController.index = 1;
//                       _selectedValue = "모임";
//                       change_select = true;
//                     });
//                   },
//                   child: Text(
//                     "더보기",
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontFamily: 'GSANSM',
//                         fontSize: 12.0),
//                   )),
//             ],
//           ),
//           Container(
//             height: 120,
//             child: StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("Club")
//                     .doc(name)
//                     .collection("Post")
//                     .doc("GatheringPost")
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<DocumentSnapshot> snapshot) {
//                   if (snapshot.hasError) {
//                     return Text("Error!");
//                   } else if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return Container();
//                   } else {
//                     Map<String, dynamic> data =
//                         snapshot.data!.data() as Map<String, dynamic>;
//                     List a = [];
//                     List b = [];
//                     List c = [];
//                     List date_time = [];
//                     List post_intro = [];
//                     List max_num = [];

//                     List revers_title = [];
//                     List revers_nick_name = [];
//                     List revers_key_num = [];
//                     List revers_date_time = [];
//                     List revers_max_num = [];
//                     List revers_post_intro = [];

//                     if (data["GatheringPost"].length != 0) {
//                       for (int i = 0; i < data["GatheringPost"].length; i++) {
//                         a.add(data["GatheringPost"][i]["ClubPostTitle"]);
//                         b.add(data["GatheringPost"][i]["NickName"]);
//                         c.add(data["GatheringPost"][i]["KeyNumber"]);
//                         date_time.add(data["GatheringPost"][i]["DateTime"]);
//                         max_num.add(data["GatheringPost"][i]["MaxNumber"]);
//                         post_intro
//                             .add(data["GatheringPost"][i]["ClubPostIntro"]);
//                       }

//                       revers_title = List.of(a.reversed);
//                       revers_nick_name = List.of(b.reversed);
//                       revers_key_num = List.of(c.reversed);
//                       revers_date_time = List.of(date_time.reversed);
//                       revers_max_num = List.of(max_num.reversed);
//                       revers_post_intro = List.of(post_intro.reversed);
//                       return ListView.separated(
//                           physics: NeverScrollableScrollPhysics(),
//                           itemBuilder: (BuildContext context, int index) {
//                             return Container(
//                                 height: 35,
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey[200],
//                                     borderRadius: BorderRadius.circular(5)),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(context, MaterialPageRoute(
//                                         builder: (BuildContext context) {
//                                       return GatheringPost(
//                                         club_uid: name,
//                                         post_index: a.length - 1 - index,
//                                         prev_post_title: revers_title[index],
//                                         prev_post_intro:
//                                             revers_post_intro[index],
//                                         max_num: revers_max_num[index],
//                                       );
//                                     }));
//                                   },
//                                   child: Padding(
//                                     padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           revers_date_time[index],
//                                           style: TextStyle(
//                                               fontFamily: 'GSANSM',
//                                               color: Color(0xff58585b),
//                                               fontSize: 14),
//                                         ),
//                                         Text(
//                                           revers_title[index],
//                                           style: TextStyle(
//                                               fontFamily: 'GSANSM',
//                                               color: Color(0xff58585b),
//                                               fontSize: 14),
//                                         ),
//                                         Text(
//                                           revers_nick_name[index],
//                                           style: TextStyle(
//                                               fontFamily: 'GSANSM',
//                                               color: Color(0xff9f9f9f),
//                                               fontSize: 12),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ));
//                           },
//                           separatorBuilder: (BuildContext context, int index) {
//                             return Container(height: 5);
//                           },
//                           itemCount: revers_title.length >= 3
//                               ? 3
//                               : revers_title.length >= 2
//                                   ? 2
//                                   : 1);
//                     } else {
//                       return Container(child: Text('\n등록된 글이 없습니다.'));
//                     }
//                   }
//                 }),
//           )
//         ],
//       ),
//     );
//   }

//   // Widget _gatherBoard_tab() {
//   //   return Container(
//   //     height: MediaQuery.of(context).size.height / 1.5,
//   //     child: Column(
//   //       children: [
//   //         // Row(
//   //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //         //   children: [
//   //         //     Padding(
//   //         //       padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//   //         //       child: Text(
//   //         //         '모 임',
//   //         //         style:
//   //         //             TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
//   //         //       ),
//   //         //     ),
//   //         //     // Text(
//   //         //     //   '더보기 +',
//   //         //     //   style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
//   //         //     // ),
//   //         //   ],
//   //         // ),
//   //         SizedBox(
//   //           height: 10,
//   //         ),
//   //         Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
//   //         Expanded(
//   //           child: Container(
//   //             // height: 500,
//   //             child: StreamBuilder<DocumentSnapshot>(
//   //                 stream: FirebaseFirestore.instance
//   //                     .collection("Club")
//   //                     .doc(name)
//   //                     .collection("Post")
//   //                     .doc("GatheringPost")
//   //                     .snapshots(),
//   //                 builder: (BuildContext context,
//   //                     AsyncSnapshot<DocumentSnapshot> snapshot) {
//   //                   if (snapshot.hasError) {
//   //                     return Text("Error!");
//   //                   } else if (snapshot.connectionState ==
//   //                       ConnectionState.waiting) {
//   //                     return Container();
//   //                   } else {
//   //                     Map<String, dynamic> data =
//   //                         snapshot.data!.data() as Map<String, dynamic>;
//   //                     List a = [];
//   //                     List b = [];
//   //                     List c = [];
//   //                     if (data["GatheringPost"].length != 0) {
//   //                       for (int i = 0; i < data["GatheringPost"].length; i++) {
//   //                         a.add(data["GatheringPost"][i]["ClubPostTitle"]);
//   //                         b.add(data["GatheringPost"][i]["ClubPostIntro"]);
//   //                         c.add(data["GatheringPost"][i]["NickName"]);
//   //                       }

//   //                       print(MediaQuery.of(context).size.height);
//   //                       return ListView.separated(
//   //                           itemBuilder: (BuildContext context, int index) {
//   //                             return Container(
//   //                                 decoration: BoxDecoration(
//   //                                     color: Colors.white,
//   //                                     borderRadius: BorderRadius.circular(5)),
//   //                                 child: GestureDetector(
//   //                                   onTap: () {
//   //                                     Navigator.push(context, MaterialPageRoute(
//   //                                         builder: (BuildContext context) {
//   //                                       return GatheringPost(
//   //                                         club_uid: club_uid,
//   //                                         post_index: index,
//   //                                         post_title: a[index],
//   //                                         club_name: name,
//   //                                       );
//   //                                     }));
//   //                                   },
//   //                                   child: Padding(
//   //                                     padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
//   //                                     child: Column(
//   //                                       crossAxisAlignment:
//   //                                           CrossAxisAlignment.start,
//   //                                       children: [
//   //                                         ListTile(
//   //                                           title: Text(
//   //                                             a[index],
//   //                                             style: TextStyle(
//   //                                                 color: Color(0xff58585b),
//   //                                                 fontFamily: 'GSANSB',
//   //                                                 fontSize: 14),
//   //                                           ),
//   //                                           subtitle: Text(
//   //                                             b[index],
//   //                                             style: TextStyle(
//   //                                                 color: Color(0xff9f9f9f),
//   //                                                 fontFamily: 'GSANSM',
//   //                                                 fontSize: 12.0),
//   //                                           ),
//   //                                           trailing: Padding(
//   //                                             padding: EdgeInsets.fromLTRB(
//   //                                                 0, 25, 0, 0),
//   //                                             child: Text(
//   //                                               c[index],
//   //                                               style: TextStyle(
//   //                                                   color: Color(0xff9f9f9f),
//   //                                                   fontFamily: 'GSANSM',
//   //                                                   fontSize: 12.0),
//   //                                             ),
//   //                                           ),
//   //                                         ),
//   //                                       ],
//   //                                     ),
//   //                                   ),
//   //                                 ));
//   //                           },
//   //                           separatorBuilder:
//   //                               (BuildContext context, int index) {
//   //                             return Container(
//   //                               height: 10,
//   //                               color: Colors.grey[100],
//   //                             );
//   //                           },
//   //                           itemCount: a.length);
//   //                     } else {
//   //                       return Container(child: Text('\n등록된 글이 없습니다.'));
//   //                     }
//   //                   }
//   //                 }),
//   //           ),
//   //         )
//   //       ],
//   //     ),
//   //   );
//   // }

//   Widget _gatherBoard_tab() {
//     return Container(
//       height: MediaQuery.of(context).size.height / 1.5,
//       child: Column(
//         children: [
//           // Row(
//           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //   children: [
//           //     Padding(
//           //       padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//           //       child: Text(
//           //         '모 임',
//           //         style:
//           //             TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
//           //       ),
//           //     ),
//           //     // Text(
//           //     //   '더보기 +',
//           //     //   style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[700]),
//           //     // ),
//           //   ],
//           // ),
//           SizedBox(
//             height: 10,
//           ),
//           Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
//           Expanded(
//             child: Container(
//               // height: 500,
//               child: StreamBuilder<DocumentSnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection("Club")
//                       .doc(name)
//                       .collection("Post")
//                       .doc("GatheringPost")
//                       .snapshots(),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<DocumentSnapshot> snapshot) {
//                     if (snapshot.hasError) {
//                       return Text("Error!");
//                     } else if (snapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return Container();
//                     } else {
//                       Map<String, dynamic> data =
//                           snapshot.data!.data() as Map<String, dynamic>;
//                       List a = [];
//                       List b = [];
//                       List c = [];
//                       List person_num = [];
//                       List max_num = [];
//                       if (data["GatheringPost"].length != 0) {
//                         for (int i = 0; i < data["GatheringPost"].length; i++) {
//                           a.add(data["GatheringPost"][i]["ClubPostTitle"]);
//                           b.add(data["GatheringPost"][i]["ClubPostIntro"]);
//                           c.add(data["GatheringPost"][i]["NickName"]);
//                           person_num
//                               .add(data["GatheringPost"][i]["PersonNumber"]);
//                           max_num.add(data["GatheringPost"][i]["MaxNumber"]);
//                         }

//                         return ListView.separated(
//                             itemBuilder: (BuildContext context, int index) {
//                               return Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(5)),
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(context, MaterialPageRoute(
//                                           builder: (BuildContext context) {
//                                         return GatheringPost(
//                                           club_uid: name,
//                                           post_index: index,
//                                           prev_post_title: a[index],
//                                           max_num: max_num[index],
//                                           prev_post_intro: b[index],
//                                         );
//                                       }));
//                                     },
//                                     child: Padding(
//                                       padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           ListTile(
//                                               title: Text(
//                                                 a[index],
//                                                 style: TextStyle(
//                                                     color: Color(0xff58585b),
//                                                     fontFamily: 'GSANSB',
//                                                     fontSize: 14),
//                                               ),
//                                               subtitle: Text(
//                                                 person_num[index].toString() +
//                                                     "/" +
//                                                     max_num[index],
//                                                 style: TextStyle(
//                                                     color: Color(0xff9f9f9f),
//                                                     fontFamily: 'GSANSM',
//                                                     fontSize: 12.0),
//                                               ),
//                                               trailing: Column(
//                                                 children: [
//                                                   Padding(
//                                                     padding:
//                                                         EdgeInsets.fromLTRB(
//                                                             0, 20, 0, 0),
//                                                     child: Text(
//                                                       c[index],
//                                                       style: TextStyle(
//                                                           color:
//                                                               Color(0xff9f9f9f),
//                                                           fontFamily: 'GSANSM',
//                                                           fontSize: 12.0),
//                                                     ),
//                                                   ),
//                                                   // Text(
//                                                   //   person_num[index]
//                                                   //           .toString() +
//                                                   //       "/" +
//                                                   //       max_num[index],
//                                                   //   style: TextStyle(
//                                                   //       color:
//                                                   //           Color(0xff9f9f9f),
//                                                   //       fontFamily: 'GSANSM',
//                                                   //       fontSize: 12.0),
//                                                   // ),
//                                                 ],
//                                               )),
//                                         ],
//                                       ),
//                                     ),
//                                   ));
//                             },
//                             separatorBuilder:
//                                 (BuildContext context, int index) {
//                               return Container(
//                                 height: 10,
//                                 color: Colors.grey[100],
//                               );
//                             },
//                             itemCount: a.length);
//                       } else {
//                         return Container(child: Text('\n등록된 글이 없습니다.'));
//                       }
//                     }
//                   }),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _bottomButton() {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       child: Padding(
//         padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
//         child: ElevatedButton(
//             onPressed: () async {
//               ///
//               /// 추후 추가로 자신의 UID data를 넣어야한다.
//               ///
//               try {
//                 await FirebaseFirestore.instance
//                     .collection("Club")
//                     .doc(name)
//                     .update({
//                   "ClubMember": FieldValue.arrayUnion([user.uid]),
//                 });

//                 ///
//                 /// 여기선 로그인하고있는 유저의 UID를 doc에 넣어 User Collection에서 유저의 UID를 가지고 있는 DOC에 넣어 JoinClub Array에 추가 기능
//                 ///
//                 await FirebaseFirestore.instance
//                     .collection("Users")
//                     .doc(user.uid)
//                     .update({
//                   "JoinClub": FieldValue.arrayUnion([club_uid])
//                 });

//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (BuildContext context) {
//                   return ClubMainPage(
//                     club_name: club_uid,
//                     club_uid: name,
//                     image_url: url_image,
//                   );
//                 }));
//               } catch (e) {
//                 print(e);
//               }
//             },
//             style: OutlinedButton.styleFrom(
//                 primary: Colors.white,
//                 backgroundColor: Color(0xffe9394f),
//                 shape: RoundedRectangleBorder(
//                     side: BorderSide(
//                         color: Theme.of(context).primaryColor,
//                         width: 1,
//                         style: BorderStyle.solid),
//                     borderRadius: BorderRadius.circular(50)),
//                 elevation: 1),
//             child: Text(
//               "가입하기",
//               style: TextStyle(
//                 fontFamily: 'GSANSB',
//                 fontSize: 16,
//               ),
//             )),
//       ),
//     );
//   }

//   Widget change_Board() {
//     if (_selectedValue == "일반게시글") {
//       return _normalBoard_tab();
//     } else if (_selectedValue == "공지사항") {
//       return _noticeBorad_tab();
//     } else {
//       return _gatherBoard_tab();
//     }
//   }

//   Widget choice_change_Board() {
//     if (change_string == "공지사항") {
//       return Padding(
//           padding: EdgeInsets.fromLTRB(0, 10, 0, 0), child: _noticeBorad_tab());
//     } else {
//       return Padding(
//           padding: EdgeInsets.fromLTRB(0, 10, 0, 0), child: _gatherBoard_tab());
//     }
//   }

//   Widget ChatRoom() {
//     List<ChatMessageWidget> _messages = [];
//     List<ChatMessageWidget> reversedList = [];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//           child: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<DocumentSnapshot>(
//               stream: _getComment(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<DocumentSnapshot> snapshot) {
//                 if (snapshot.hasError) {
//                   return Text("Error!");
//                 } else if (snapshot.connectionState ==
//                     ConnectionState.waiting) {
//                   return Container();
//                 } else {
//                   _messages.clear();

//                   Map<String, dynamic> data =
//                       snapshot.data!.data() as Map<String, dynamic>;

//                   List user_nick_name = [];
//                   List chat_comment = [];
//                   List total_user_uid = [];
//                   List time_stamp = [];

//                   if (data["ChatRoom"].length != 0) {
//                     // _messages.clear();

//                     for (int i = 0; i < data["ChatRoom"].length; i++) {
//                       user_nick_name.add(data["ChatRoom"][i]["NickName"]);
//                       chat_comment.add(data["ChatRoom"][i]["Comment"]);
//                       total_user_uid.add(data["ChatRoom"][i]["UserUID"]);
//                       time_stamp.add(data["ChatRoom"][i]["TimeStamp"]);
//                     }

//                     List reversChat = [];
//                     List reversNick = [];
//                     List reversUid = [];
//                     List reversTime = [];

//                     reversChat = List.from(chat_comment.reversed).toList();
//                     reversNick = List.from(user_nick_name.reversed).toList();
//                     reversUid = List.from(total_user_uid.reversed).toList();
//                     reversTime = List.from(time_stamp.reversed).toList();

//                     return ListView.builder(
//                       reverse: true,
//                       shrinkWrap: true,
//                       itemBuilder: (_, int index) {
//                         // return _messages[index];

//                         return ListTile(
//                           title: Column(
//                             crossAxisAlignment: user.uid == reversUid[index]
//                                 ? CrossAxisAlignment.end
//                                 : CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
//                                 child: Text(
//                                   user.uid == reversUid[index]
//                                       ? ""
//                                       : reversNick[index],
//                                   style: TextStyle(
//                                       fontFamily: 'GSANSM', fontSize: 11.0),
//                                 ),
//                               ),
//                               Row(
//                                   mainAxisAlignment:
//                                       user.uid == reversUid[index]
//                                           ? MainAxisAlignment.end
//                                           : MainAxisAlignment.start,
//                                   children: user.uid == reversUid[index]
//                                       ? [
//                                           Padding(
//                                             // padding: EdgeInsets.symmetric(horizontal: 13),
//                                             padding: EdgeInsets.fromLTRB(
//                                                 20, 20, 0, 0),
//                                             child: Text(
//                                               reversTime[index],
//                                               style: TextStyle(
//                                                   fontFamily: 'GSANSM',
//                                                   fontSize: 9.0),
//                                             ),
//                                           ),
//                                           Container(
//                                               margin: EdgeInsets.symmetric(
//                                                   horizontal: 5),
//                                               padding: EdgeInsets.fromLTRB(
//                                                   15, 10, 15, 10),
//                                               decoration: BoxDecoration(
//                                                   color: user.uid == reversUid[index]
//                                                       ? Color(0xffFBD6C2)
//                                                       : Colors.white,
//                                                   border: Border.all(
//                                                       color: user.uid ==
//                                                               reversUid[index]
//                                                           ? Colors.white
//                                                           : Color(0xffe9394f),
//                                                       width: 1),
//                                                   borderRadius: BorderRadius.only(
//                                                       topLeft: Radius.circular(
//                                                           user.uid == reversUid[index]
//                                                               ? 10
//                                                               : 0),
//                                                       topRight:
//                                                           Radius.circular(user.uid == reversUid[index] ? 0 : 10),
//                                                       bottomLeft: Radius.circular(10),
//                                                       bottomRight: Radius.circular(10))),
//                                               child: Text(
//                                                 reversChat[index],
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 14,
//                                                     fontFamily: 'GSANSM'),
//                                               )),
//                                         ]
//                                       : [
//                                           CircleAvatar(
//                                             backgroundColor: Colors.blue,
//                                           ),
//                                           Container(
//                                               margin: EdgeInsets.symmetric(
//                                                   horizontal: 5),
//                                               padding: EdgeInsets.fromLTRB(
//                                                   15, 10, 15, 10),
//                                               decoration: BoxDecoration(
//                                                   color: user.uid == reversUid[index]
//                                                       ? Color(0xffFBD6C2)
//                                                       : Colors.white,
//                                                   border: Border.all(
//                                                       color: user.uid ==
//                                                               reversUid[index]
//                                                           ? Colors.white
//                                                           : Color(0xffe9394f),
//                                                       width: 1),
//                                                   borderRadius: BorderRadius.only(
//                                                       topLeft: Radius.circular(
//                                                           user.uid == reversUid[index]
//                                                               ? 10
//                                                               : 0),
//                                                       topRight:
//                                                           Radius.circular(user.uid == reversUid[index] ? 0 : 10),
//                                                       bottomLeft: Radius.circular(10),
//                                                       bottomRight: Radius.circular(10))),
//                                               child: Text(
//                                                 reversChat[index],
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontSize: 14,
//                                                     fontFamily: 'GSANSM'),
//                                               )),
//                                           Padding(
//                                             // padding: EdgeInsets.symmetric(horizontal: 13),
//                                             padding: EdgeInsets.fromLTRB(
//                                                 0, 20, 20, 0),
//                                             child: Text(
//                                               reversTime[index],
//                                               style: TextStyle(
//                                                   fontFamily: 'GSANSM',
//                                                   fontSize: 9.0),
//                                             ),
//                                           )
//                                         ]),
//                             ],
//                           ),
//                         );
//                       },
//                       itemCount: data["ChatRoom"].length,
//                     );

//                     // return ListView(
//                     //   children: [
//                     //     ListView.builder(
//                     //         itemCount: _messages.length,
//                     //         itemBuilder: (BuildContext context, int index) {
//                     //           return _messages[index];
//                     //         })
//                     //   ],
//                     // );
//                   } else {
//                     return Text("채팅글 없음");
//                   }
//                 }
//               },
//             ),
//           ),
//           Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
//           SingleChildScrollView(
//             child: Container(
//               color: Colors.grey[200],
//               constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.5),
//               margin: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).padding.bottom),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                       child: GestureDetector(
//                         onTap: () {
//                           FocusScope.of(context).unfocus();
//                         },
//                         child: TextField(
//                           controller: _controller,
//                           maxLines: null,
//                           keyboardType: TextInputType.multiline,
//                           style: TextStyle(fontSize: 20),
//                           decoration: InputDecoration(
//                               fillColor: Colors.grey[200],
//                               filled: true,
//                               border: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                               hintStyle: TextStyle(color: Colors.black)),
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       var txt = _controller.text;
//                       //var now = DateTime.now().millisecondsSinceEpoch;
//                       if (txt != "") {
//                         List add_text = [];
//                         add_text.add({
//                           "Comment": txt,
//                           "NickName": userAccount_.nickname,
//                           "UserUID": user1.uid,
//                           "TimeStamp": formatDate(
//                               DateTime.now(), [am, ' ', hh, ':', nn]),
//                           "DateTime": Timestamp.now(),
//                         });
//                         _controller.clear();
//                         await FirebaseFirestore.instance
//                             .collection('Club')
//                             .doc(name)
//                             .collection("ChatRoom")
//                             .doc("ChatRoom")
//                             .update(
//                                 {"ChatRoom": FieldValue.arrayUnion(add_text)});
//                         add_text.clear();

//                         // _focusNode.requestFocus();
//                         FocusScopeNode currentFocus = FocusScope.of(context);
//                         if (!currentFocus.hasPrimaryFocus) {
//                           currentFocus.unfocus();
//                         }
//                       } else {
//                         print("채팅 공백 시도함");
//                       }
//                       // List add_text = [];
//                       // add_text.add({
//                       //   "Comment": txt,
//                       //   "NickName": userAccount_.nickname_,
//                       //   "UserUID": user1.uid,
//                       //   "TimeStamp":
//                       //       formatDate(DateTime.now(), [am, ' ', hh, ':', nn]),
//                       //   "DateTime": Timestamp.now(),
//                       // });
//                       // _controller.clear();
//                       // await FirebaseFirestore.instance
//                       //     .collection('Club')
//                       //     .doc(name)
//                       //     .collection("ChatRoom")
//                       //     .doc("ChatRoom")
//                       //     .update(
//                       //         {"ChatRoom": FieldValue.arrayUnion(add_text)});
//                       // add_text.clear();

//                       // // _focusNode.requestFocus();
//                       // FocusScopeNode currentFocus = FocusScope.of(context);
//                       // if (!currentFocus.hasPrimaryFocus) {
//                       //   currentFocus.unfocus();
//                       // }
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
//                       // child: Icon(
//                       //   Icons.arrow_circle_up_sharp,
//                       //   // SvgPicture.asset("comon\assets\images\SVG\arrow.svg", width : 10),
//                       //   size: 33,
//                       //   color: Color(0xffe83a4f),
//                       // ),
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: Color(0xffe83a4f),
//                           borderRadius: BorderRadius.circular(60),
//                         ),
//                         child: IconButton(
//                           icon: SvgPicture.asset("assets/images/SVG/arrow.svg"),
//                           onPressed: null,
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       )),
//     );
//   }

//   late TabController _tabController =
//       new TabController(length: 3, vsync: this, initialIndex: 0);

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this, initialIndex: 0);

//     _tabController.addListener(_switchTabIndex);
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose

//     super.dispose();
//   }

//   void _switchTabIndex() {
//     print(_tabController.index);
//     setState(() {});
//   }

//   // final list_controller = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     user = FirebaseAuth.instance.currentUser!;
//     print("build안에 _selectedValue값 변경 내역\t" + _selectedValue);

//     userAccount_ = Provider.of(context, listen: false);

//     // Timer(
//     //   Duration(seconds: 1),
//     //   () => list_controller.jumpTo(list_controller.position.maxScrollExtent),
//     // );

//     String _colorName = 'No';
//     Color _color = Colors.black;
//     getData(club_uid);

//     return WillPopScope(
//       onWillPop: () {
//         setState(() {
//           print("back press 실행");
//         });
//         if (_tabController.index == 1 || _tabController.index == 2) {
//           _tabController.index = 0;
//           return Future(() => false);
//         } else {
//           return Future(() => true);
//         }
//       },
//       child: Scaffold(
//         body: DefaultTabController(
//           length: 3,
//           child: Scaffold(
//             resizeToAvoidBottomInset: false,
//             endDrawer: Drawer(
//                 child: ClubDrawer(
//               club_uid: name,
//               club_name: club_uid,
//             )),
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               backgroundColor: Color(0xFFFFFFFF),
//               iconTheme: IconThemeData(color: Colors.grey),
//               automaticallyImplyLeading: false,
//               title: SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
//               //SvgPicture.asset('assets/images/SVG/logo.svg', width: 150,),
//               leading: IconButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (BuildContext context) {
//                     return FirstScreen();
//                   }));
//                 },
//                 icon: Icon(Icons.arrow_back_ios),
//               ),
//               actions: [],
//               centerTitle: true,
//               elevation: 0,
//               shape: Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
//               bottom: TabBar(
//                 indicatorColor: Color(0xffe83a4f),
//                 indicatorWeight: 3.0,
//                 controller: _tabController,
//                 unselectedLabelColor: Colors.black,
//                 tabs: [
//                   Tab(
//                     child: Text(
//                       "MAIN",
//                       style: TextStyle(
//                           fontFamily: 'GSANSM',
//                           fontSize: 14,
//                           color: Color(0xff58585b)),
//                     ),
//                   ),
//                   Tab(
//                     child: Text(
//                       "게시판",
//                       style: TextStyle(
//                           fontFamily: 'GSANSM',
//                           fontSize: 14,
//                           color: Color(0xff58585b)),
//                     ),
//                   ),

//                   Tab(
//                     child: Text(
//                       "채팅",
//                       style: TextStyle(
//                           fontFamily: 'GSANSM',
//                           fontSize: 14,
//                           color: Color(0xff58585b)),
//                     ),
//                   ),
//                   // Tab(icon: Icon(Icons.directions_bike)),
//                 ],
//               ),
//             ),
//             floatingActionButton: _tabController.index != 1
//                 ? Container()
//                 : CircularMenu(
//                     // menu alignment
//                     alignment: Alignment.bottomRight,
//                     // menu radius
//                     radius: 70,
//                     // widget in the background holds actual page content
//                     //backgroundWidget: MyCustomWidget(),
//                     // global key to control the animation anywhere in the code.
//                     key: GlobalKey<CircularMenuState>(),
//                     // animation duration
//                     animationDuration: Duration(milliseconds: 300),
//                     // animation curve in forward
//                     curve: Curves.easeInOut,
//                     // animation curve in reverse
//                     reverseCurve: Curves.fastOutSlowIn,
//                     // first item angle
//                     //startingAngleInRadian : 0 ,
//                     // last item angle
//                     //endingAngleInRadian : 3.141592 * 3,
//                     // toggle button callback
//                     toggleButtonOnPressed: () {
//                       //callback
//                     },
//                     // toggle button appearance properties
//                     toggleButtonColor: Theme.of(context).primaryColor,
//                     toggleButtonBoxShadow: [
//                       BoxShadow(
//                         color: Theme.of(context).primaryColor,
//                         blurRadius: 1,
//                       ),
//                     ],
//                     //toggleButtonAnimatedIconData: AnimatedIcons.add_event,

//                     toggleButtonIconColor: Colors.white,
//                     toggleButtonMargin: 10.0,
//                     toggleButtonPadding: 10.0,
//                     toggleButtonSize: 30.0,
//                     items: [
//                       CircularMenuItem(
//                           iconSize: 30,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Theme.of(context).primaryColor,
//                               blurRadius: 1,
//                             ),
//                           ],
//                           icon: Icons.groups,
//                           color: Theme.of(context).primaryColor,
//                           onTap: () {
//                             setState(() {
//                               _color = Colors.green;
//                               _colorName = 'Green';
//                             });

//                             Navigator.push(context, MaterialPageRoute(
//                                 builder: (BuildContext context) {
//                               return Gathering(
//                                   club_uid: club_uid, club_name: name);
//                             }));
//                           }),
//                       CircularMenuItem(
//                           boxShadow: [
//                             BoxShadow(
//                               color: Theme.of(context).primaryColor,
//                               blurRadius: 1,
//                             ),
//                           ],
//                           icon: Icons.post_add,
//                           color: Theme.of(context).primaryColor,
//                           onTap: () {
//                             setState(() {
//                               _color = Colors.blue;
//                               _colorName = 'Blue';
//                             });
//                             Navigator.push(context, MaterialPageRoute(
//                                 builder: (BuildContext context) {
//                               return Nomal(
//                                   club_name: club_uid, club_real_uid: name);
//                             }));
//                           }),
//                       CircularMenuItem(
//                           boxShadow: [
//                             BoxShadow(
//                               color: Theme.of(context).primaryColor,
//                               blurRadius: 1,
//                             ),
//                           ],
//                           icon: Icons.campaign,
//                           color: Theme.of(context).primaryColor,
//                           onTap: () {
//                             setState(() {
//                               _color = Colors.orange;
//                               _colorName = 'Orange';
//                             });
//                             Navigator.push(context, MaterialPageRoute(
//                                 builder: (BuildContext context) {
//                               return Notice(
//                                   club_uid: club_uid, club_name: name);
//                             }));
//                           }),
//                     ],
//                   ),
//             body: TabBarView(controller: _tabController, children: [
//               SafeArea(
//                   child: SingleChildScrollView(
//                 child: Container(
//                   color: Color(0xFFFFFFFF),
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
//                             child: Text(
//                               club_uid,
//                               style: TextStyle(
//                                   fontFamily: 'GSANSB',
//                                   fontSize: 20.0,
//                                   color: Theme.of(context).primaryColor),
//                             ),
//                           ),
//                           Container(
//                               width: MediaQuery.of(context).size.width,
//                               height: 200,
//                               //color: Theme.of(context).primaryColorLight,
//                               // decoration: BoxDecoration(
//                               //   color: Theme.of(context).primaryColorLight,
//                               //   // image: DecorationImage(
//                               //   //     image: NetworkImage(
//                               //   //       url_image,
//                               //   //     ),
//                               //   //     fit: BoxFit.fill),
//                               // ),
//                               child: url_image != ""
//                                   ? CachedNetworkImage(
//                                       imageUrl: url_image,
//                                       imageBuilder: (context, imageProvider) =>
//                                           Container(
//                                         decoration: BoxDecoration(
//                                           image: DecorationImage(
//                                             image: imageProvider,
//                                             fit: BoxFit.cover,
//                                             alignment: Alignment.center,
//                                             // colorFilter: const ColorFilter.mode(
//                                             //   Colors.red,
//                                             //   BlendMode.colorBurn,
//                                             // ),
//                                           ),
//                                         ),
//                                       ),
//                                       placeholder: (context, url) => Container(
//                                         width: 200,
//                                         height: 200,
//                                         // color: Colors.purple,
//                                         child: Image.asset(
//                                             "assets/images/GIF/Rolling_295px.gif"),
//                                       ),
//                                       errorWidget: (context, url, error) =>
//                                           const Icon(Icons.error),
//                                     )
//                                   : Container(
//                                       color: Colors.red[100],
//                                       // decoration: BoxDecoration(
//                                       //   color: Colors.red[200],
//                                       // ),
//                                     )),
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
//                             child: Column(
//                               children: [
//                                 _noticeBorad(),
//                                 SizedBox(
//                                   height: 20,
//                                 ),
//                                 _gatherBoard(),
//                               ],
//                             ),
//                           )
//                         ]),
//                   ),
//                 ),
//               )),
//               change_select != false
//                   ? Container()
//                   : Container(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
//                             child: DropdownButton(
//                               elevation: 0,
//                               isExpanded: false,
//                               value: _selectedValue,
//                               items: board_select.map(
//                                 (value) {
//                                   return DropdownMenuItem(
//                                     value: value,
//                                     child: Text(
//                                       value,
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontFamily: 'GMARKETSANSM'),
//                                     ),
//                                   );
//                                 },
//                               ).toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   _selectedValue = value.toString();

//                                   print("onChange" + _selectedValue);
//                                 });
//                               },
//                             ),
//                           ),
//                           Padding(
//                               padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//                               child: change_Board()),
//                         ],
//                       ),
//                     ),
//               ChatRoom(),
//             ]),
//             bottomNavigationBar: SizedBox(
//           height: 60,
//           child: Container(
//             decoration: BoxDecoration(
//               boxShadow: <BoxShadow>[
//                 BoxShadow(
//                     color: Colors.black54,
//                     blurRadius: 5.0,
//                     offset: Offset(0.0, 0.75)
//                 )
//               ],
//             ),
//             child: BottomNavigationBar(
//               type: BottomNavigationBarType.fixed,
//               backgroundColor: Colors.white,
//               elevation: 3,
//               selectedItemColor: Theme.of(context).primaryColor,
//               currentIndex: _selectedNaviIndex,
//               onTap: (int index) {
//                 _selectedNaviIndex = index;
//                 setState(() {
//                   if(_selectedNaviIndex == 0) { 
//                     print(_selectedNaviIndex);
//                     Navigator.push(context, MaterialPageRoute(
//                         builder: (BuildContext context){
//                           return Home();
//                         }
//                     ));
//                   }
//                   if(_selectedNaviIndex == 1) { 
//                     print(_selectedNaviIndex);
//                     Navigator.push(context, MaterialPageRoute(
//                         builder: (BuildContext context){
//                           return InstantPLay();
//                         }
//                     ));
//                   }
//                   if(_selectedNaviIndex == 2) { 
//                     print(_selectedNaviIndex);
//                     Navigator.push(context, MaterialPageRoute(
//                         builder: (BuildContext context){
//                           return FirstScreen();
//                         }
//                     ));
//                   }
//                   if(_selectedNaviIndex == 3) { 
//                     Navigator.push(context, MaterialPageRoute(
//                       builder: (BuildContext context){
//                         return MarketMainPage(item_id: userAccount_.marketChatItem);
//                       }
//                     ));
//                   }
//                 });
//               },
//               items: [
//                 BottomNavigationBarItem(
//                   title: Text('홈', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
//                   icon: SvgPicture.asset('assets/images/SVG/home.svg', width: 23,),
//                   activeIcon: SvgPicture.asset('assets/images/SVG/home_selected.svg', width: 23,),
//                 ),
//                 BottomNavigationBarItem(
//                   title: Text('벙개', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
//                   icon: SvgPicture.asset('assets/images/SVG/light.svg', width: 23,),
//                   activeIcon: SvgPicture.asset('assets/images/SVG/light_selected.svg', width: 23,),
//                 ),
//                 BottomNavigationBarItem(
//                   title: Text('클럽', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
//                   icon: SvgPicture.asset('assets/images/SVG/club.svg', width: 23,),
//                   activeIcon: SvgPicture.asset('assets/images/SVG/club_selected.svg', width: 23,),
//                 ),
//                 BottomNavigationBarItem(
//                   title: Text('중고장터', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
//                   icon: SvgPicture.asset('assets/images/SVG/basket.svg', width: 23,),
//                   activeIcon: SvgPicture.asset('assets/images/SVG/basket_selected.svg', width: 23,),
//                 ),
//                 BottomNavigationBarItem(
//                   title: Text('더보기', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
//                   icon: SvgPicture.asset('assets/images/SVG/more.svg', width: 23,),
//                   activeIcon: SvgPicture.asset('assets/images/SVG/more_selected.svg', width: 23,),
//                 ),
//               ],
//             )
//           )
//         ),
//           ),
//         ),
//       ),
//     );
//   }
// }
