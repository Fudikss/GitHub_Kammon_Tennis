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
import 'package:snstennis/instant/instant_main.dart';
import 'package:snstennis/market/Market_Main_Page.dart';

import '../home.dart';
import 'Notice_Post_1_2.dart';
import 'Notice_Post_Write_1_1.dart';
import 'first_screen_1_0.dart';

class ClubNoticePostList extends StatefulWidget {
  final String prev_club_uid;
  final String prev_club_name;
  const ClubNoticePostList(
      {Key? key, required this.prev_club_uid, required this.prev_club_name})
      : super(key: key);

  @override
  _ClubNoticePostListState createState() =>
      _ClubNoticePostListState(prev_club_uid, prev_club_name);
}

class _ClubNoticePostListState extends State<ClubNoticePostList> {
  String club_uid = "";
  String club_name = "";

  late UserAccountInfo userAccount_;

  int _selectedNaviIndex = 2;

  _ClubNoticePostListState(this.club_uid, this.club_name);
  @override
  Widget build(BuildContext context) {
    userAccount_ = Provider.of(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        // title: SvgPicture.asset(
        //   'assets/images/SVG/LOGO_KAMMON_small.svg',
        //   width: 110,
        // ),
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
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 20, 30, 20),
                child: Text(
                  "공지글",
                  style: TextStyle(
                      fontFamily: 'GSANSB',
                      fontSize: 20.0,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Expanded(
                // height: 450,
                child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Club")
                        .doc(club_uid)
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
                            notice_post_profile_image
                                .add(data["NoticePost"][i]["Profile_image"]);
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
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return NoticePost(
                                              index: index,
                                              club_uid: club_uid,
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
                                                  notice_post_profile_image[
                                                      index]);
                                        }));
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              // leading: FlutterLogo(size: 72.0),
                                              title: Text(
                                                a[index],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: Color(0xff58585b),
                                                    fontFamily: 'GSANSB',
                                                    fontSize: 14),
                                              ),
                                              subtitle: Text(
                                                notice_post_datetime_list[
                                                    index],
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
                          return Container(
                            color: Colors.grey[100],
                            child: Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                          color: Colors.grey[600]),
                                    ),
                                    Text(
                                      '공지글이 없습니다.',
                                      style: TextStyle(
                                          fontFamily: 'GSANSM',
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    )
                                  ]),
                            ),
                          );
                        }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return Notice(club_name: club_uid, club_uid: club_name);
          }));
        },
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
        child: Icon(
          Icons.add,
          color: Color(0xFFFFFFFF),
          size: 40,
        ),
      ),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return Home();
                      }));
                    }
                    if (_selectedNaviIndex == 1) {
                      print(_selectedNaviIndex);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return InstantPLay();
                      }));
                    }
                    if (_selectedNaviIndex == 2) {
                      print(_selectedNaviIndex);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return FirstScreen();
                      }));
                    }
                    if (_selectedNaviIndex == 3) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
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
                      style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),
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
                      style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),
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
                        style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
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
                      style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),
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
                        style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
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
    );
  }
}
