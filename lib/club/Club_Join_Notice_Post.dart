import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';

import 'Club_Post_Image.dart';

class JoinNoticePost extends StatefulWidget {
  final int index;
  final String key_num;
  final String club_uid;
  final String prev_post_title;
  final String prev_post_intro;
  final String prev_post_nickname;
  final String prev_post_uid;
  final String prev_post_datetime;
  final String prev_post_image_url;
  final String prev_post_comment_id;
  final String prev_post_video_url;
  final String prev_post_profile_image;
  const JoinNoticePost(
      {Key? key,
      required this.index,
      required this.club_uid,
      required this.prev_post_title,
      required this.prev_post_intro,
      required this.prev_post_nickname,
      required this.key_num,
      required this.prev_post_uid,
      required this.prev_post_datetime,
      required this.prev_post_image_url,
      required this.prev_post_comment_id,
      required this.prev_post_video_url,
      required this.prev_post_profile_image})
      : super(key: key);

  @override
  _JoinNoticePostState createState() => _JoinNoticePostState(
      index,
      club_uid,
      prev_post_title,
      prev_post_intro,
      prev_post_nickname,
      key_num,
      prev_post_uid,
      prev_post_datetime,
      prev_post_image_url,
      prev_post_comment_id,
      prev_post_video_url,
      prev_post_profile_image);
}

class _JoinNoticePostState extends State<JoinNoticePost> {
  String name = "";
  String club_uid = '';
  String post_title = "";
  String post_intro = "";
  String nickname = "";
  String key_number = "";
  String image_url = "";
  String check_post_uid = "";
  String date_time = "";
  int post_index;
  String comment_id = "";
  String video_url = "";
  String profile_image = "";

  User user = FirebaseAuth.instance.currentUser!;

  _JoinNoticePostState(
      this.post_index,
      this.club_uid,
      this.post_title,
      this.post_intro,
      this.nickname,
      this.key_number,
      this.check_post_uid,
      this.date_time,
      this.image_url,
      this.comment_id,
      this.video_url,
      this.profile_image);

  Widget _comment_stream() {
    return SafeArea(
      child: Container(
        height: 180,
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Club")
              .doc(club_uid)
              .collection("Post")
              .doc("NoticePost")
              .collection("NoticePostComment")
              .doc(comment_id)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Error!");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else {
              Map<String, dynamic> comment_data =
                  snapshot.data!.data() as Map<String, dynamic>;

              List comment_title = [];
              List comment_datetime = [];
              List comment_nickname = [];
              List comment_profile_image = [];

              if (comment_data["ChatList"] != null) {
                for (int i = 0; i < comment_data["ChatList"].length; i++) {
                  comment_title.add(comment_data["ChatList"][i]["Comment"]);
                  comment_datetime.add(comment_data["ChatList"][i]["DateTime"]);
                  comment_nickname.add(comment_data["ChatList"][i]["NickName"]);
                  comment_profile_image
                      .add(comment_data["ChatList"][i]["Profile_image"]);
                }

                // comment_title.reversed;
                // comment_datetime.reversed;
                // comment_nickname.reversed;
                return Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Container(
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return SingleChildScrollView(
                            child: Card(
                              elevation: 0,
                              child: Container(
                                // decoration: BoxDecoration(
                                //   color: Colors.grey[200],
                                //   borderRadius: BorderRadius.circular(5),
                                // ),
                                child: ListTile(
                                  leading: comment_profile_image[index] == ""
                                      ? Container(
                                          width: 40,
                                          height: 40,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: SvgPicture.asset(
                                                'assets/images/SVG/profile_pink.svg',
                                                width: 40,
                                              )),
                                        )
                                      : Container(
                                          width: 40,
                                          height: 40,
                                          child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 120,
                                              backgroundImage: NetworkImage(
                                                  comment_profile_image[
                                                      index])),
                                        ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment_nickname[index],
                                        style: TextStyle(fontFamily: "GSANSB"),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        comment_title[index],
                                        style: TextStyle(fontFamily: "GSANSM"),
                                      ),
                                    ],
                                  ),
                                  trailing: Text(comment_datetime[index]),
                                  dense: true,
                                  onTap: () {},
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 5,
                          );
                        },
                        itemCount: comment_title.length,
                      ),
                    ),
                  ),
                );
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
                            '댓글이 없습니다.',
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
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
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
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Container(
                        child: Column(children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              width: 2,
                              color: Colors.grey.shade400,
                            )),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              post_title,
                              style: TextStyle(
                                fontSize: 16.5,
                                fontFamily: 'GSANSM',
                              ),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 25,
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                width: 1,
                                color: Colors.grey.shade600,
                              )),
                            ),
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Row(children: [
                                  profile_image == ""
                                      ? Container(
                                          width: 40,
                                          height: 40,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: SvgPicture.asset(
                                                'assets/images/SVG/profile_pink.svg',
                                                width: 40,
                                              )),
                                        )
                                      : Container(
                                          width: 40,
                                          height: 40,
                                          child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 120,
                                              backgroundImage:
                                                  NetworkImage(profile_image)),
                                        ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    ///
                                    /// 작성한 회원의 사진과 이름 출력 부분
                                    ///
                                    nickname,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'GSANSM',
                                    ),
                                  ),
                                ]))),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            Container(
                              width: 350,
                              height: 300,
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                  width: 2,
                                  color: Colors.grey.shade400,
                                )),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      image_url != ""
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return ClubClickImage(
                                                      url: image_url);
                                                }));
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 10),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 200,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            image_url),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : video_url != ""
                                              ? Container()
                                              // Container(
                                              //     width: MediaQuery.of(context)
                                              //         .size
                                              //         .width,
                                              //     height: 200,
                                              //     child: Center(
                                              //       child: _controller
                                              //               .value.isInitialized
                                              //           ? GestureDetector(
                                              //               onTap: () {
                                              //                 setState(() {
                                              //                   _controller
                                              //                           .value
                                              //                           .isPlaying
                                              //                       ? _controller
                                              //                           .pause()
                                              //                       : _controller
                                              //                           .play();
                                              //                 });
                                              //               },
                                              //               child: AspectRatio(
                                              //                 aspectRatio:
                                              //                     _controller
                                              //                         .value
                                              //                         .aspectRatio,
                                              //                 child: Stack(
                                              //                   alignment: Alignment
                                              //                       .bottomCenter,
                                              //                   children: <
                                              //                       Widget>[
                                              //                     VideoPlayer(
                                              //                         _controller),
                                              //                     VideoProgressIndicator(
                                              //                         _controller,
                                              //                         allowScrubbing:
                                              //                             true),
                                              //                   ],
                                              //                 ),
                                              //               ),
                                              //             )
                                              //           : Container(),
                                              //     ),
                                              //   )
                                              : Container(),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 10),
                                        child: Text(
                                          post_intro,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontFamily: 'GSANSM',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _comment_stream(),
                    ])),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
