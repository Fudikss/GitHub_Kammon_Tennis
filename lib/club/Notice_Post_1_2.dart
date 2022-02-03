import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:video_player/video_player.dart';

import 'Club_Post_Image.dart';

class NoticePost extends StatefulWidget {
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
  const NoticePost(
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
  _NoticePostState createState() => _NoticePostState(
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

class _NoticePostState extends State<NoticePost> {
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

  late VideoPlayerController _controller;

  User user = FirebaseAuth.instance.currentUser!;

  final _textController = TextEditingController();
  late FocusNode _focusNode = FocusNode();

  _NoticePostState(
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

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // _controller = VideoPlayerController.network(
    //   video_url,
    //   videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    // )..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
  }

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
  }

  Widget _comment() {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: _buildTextComposer(),
    );
  }

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

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        height: 60,
        constraints: BoxConstraints(
            // maxHeight: MediaQuery.of(context).size.height * 0.5
            maxHeight: 100),
        // margin: const EdgeInsets.symmetric(horizontal: 8.0),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),

        child: Row(
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: TextField(
                  // scrollPadding: EdgeInsets.only(bottom: 100),
                  controller: _textController,
                  maxLines: null,
                  onSubmitted: _handleSubmitted,
                  keyboardType: TextInputType.multiline,
                  decoration:
                      const InputDecoration.collapsed(hintText: '댓글 작성'),
                  onTap: () {},
                  // focusNode: _focusNode,
                ),
              ),
            ),
            // Container(
            //     margin: const EdgeInsets.symmetric(horizontal: 4.0),
            //     child: IconButton(
            //         icon: SvgPicture.asset("assets/images/SVG/arrow.svg"),
            //         onPressed: () async {
            //           _handleSubmitted(_textController.text);
            //         })

            //     // _textController.text != ""
            //     //     ? IconButton(
            //     //         icon: SvgPicture.asset("assets/images/SVG/arrow.svg"),
            //     //         onPressed: () async {
            //     //           _handleSubmitted(_textController.text);
            //     //         })
            //     //     : Container()

            //     ),
            Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xffe83a4f),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: IconButton(
                  icon: SvgPicture.asset("assets/images/SVG/arrow.svg"),
                  onPressed: () async {
                    _handleSubmitted(_textController.text);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) async {
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);

    user = FirebaseAuth.instance.currentUser!;

    _textController.clear();

    if (text == "") {
      _showTextErrorDialog(context);
    } else {
      List comment_list = [];

      comment_list.add({
        "Comment": text,
        "DateTime": formatDate(DateTime.now(), [yyyy, ".", mm, '.', dd]),
        "NickName": userAccount_.nickname,
        "UserUID": user.uid,
        "Profile_image": userAccount_.profile_image
      });

      try {
        await FirebaseFirestore.instance
            .collection("Club")
            .doc(club_uid)
            .collection("Post")
            .doc("NoticePost")
            .collection("NoticePostComment")
            .doc(comment_id)
            .update({"ChatList": FieldValue.arrayUnion(comment_list)});
      } catch (e) {
        print(e);
      }

      comment_list.clear();

      _focusNode.requestFocus();
    }
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
                  _showDialog_delete(
                      context,
                      post_title,
                      post_intro,
                      image_url,
                      date_time,
                      key_number,
                      nickname,
                      check_post_uid,
                      club_uid,
                      comment_id,
                      profile_image);
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
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 200,
                                                  child: Center(
                                                    child: _controller
                                                            .value.isInitialized
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _controller
                                                                        .value
                                                                        .isPlaying
                                                                    ? _controller
                                                                        .pause()
                                                                    : _controller
                                                                        .play();
                                                              });
                                                            },
                                                            child: AspectRatio(
                                                              aspectRatio:
                                                                  _controller
                                                                      .value
                                                                      .aspectRatio,
                                                              child: Stack(
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                children: <
                                                                    Widget>[
                                                                  VideoPlayer(
                                                                      _controller),
                                                                  VideoProgressIndicator(
                                                                      _controller,
                                                                      allowScrubbing:
                                                                          true),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                  ),
                                                )
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
                      _comment(),
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

void _showTextErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "댓글 내용",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "댓글 내용이 없습니다.",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        actions: <Widget>[
          Center(
            child: ElevatedButton(
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
                  side: BorderSide(
                      width: 1, color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          // ElevatedButton(
          //   child: Text(
          //     "나가기",
          //     style: TextStyle(
          //         color: Theme.of(context).primaryColor,
          //         fontSize: 14,
          //         fontFamily: 'GSANSM'),
          //   ),
          //   style: ElevatedButton.styleFrom(
          //       fixedSize: Size(80, 20),
          //       primary: Colors.white,
          //       side:
          //           BorderSide(width: 1, color: Theme.of(context).primaryColor),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(5))),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      );
    },
  );
}

void _showDialog_delete(
    BuildContext context,
    String title,
    String intro,
    String Image_url,
    String date_time,
    String key_num,
    String nick_name,
    String user_uid,
    String club_uid,
    String id_comment,
    String profile_image) {
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
                      "ClubPostImage": Image_url,
                      "DateTime": date_time,
                      "KeyNumber": key_num,
                      "NickName": nick_name,
                      "UserUID": user_uid,
                      "CommentID": id_comment,
                      "Profile_image": profile_image,
                      "VideoUrl": ""
                    }
                  ];

                  FirebaseFirestore.instance
                      .collection("Club")
                      .doc(club_uid)
                      .collection("Post")
                      .doc("NoticePost")
                      .collection("NoticePostComment")
                      .doc(id_comment)
                      .delete();

                  FirebaseFirestore.instance
                      .collection("Club")
                      .doc(club_uid)
                      .collection("Post")
                      .doc("NoticePost")
                      .update(
                          {"NoticePost": FieldValue.arrayRemove(delete_data)});

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
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:date_format/date_format.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';
// import 'package:snstennis/account/user_account_info.dart';

// class NoticePost extends StatefulWidget {
//   final int index;
//   final String key_num;
//   final String club_uid;
//   final String prev_post_title;
//   final String prev_post_intro;
//   final String prev_post_nickname;
//   const NoticePost(
//       {Key? key,
//       required this.index,
//       required this.club_uid,
//       required this.prev_post_title,
//       required this.prev_post_intro,
//       required this.prev_post_nickname,
//       required this.key_num})
//       : super(key: key);

//   @override
//   _NoticePostState createState() => _NoticePostState(index, club_uid,
//       prev_post_title, prev_post_intro, prev_post_nickname, key_num);
// }

// class _NoticePostState extends State<NoticePost> {
//   String name = "";
//   String club_uid = '';
//   String post_title = "";
//   String post_intro = "";
//   String nickname = "";
//   String key_number = "";
//   int post_index;

//   User user = FirebaseAuth.instance.currentUser!;

//   final _textController = TextEditingController();
//   late FocusNode _focusNode = FocusNode();

//   _NoticePostState(this.post_index, this.club_uid, this.post_title,
//       this.post_intro, this.nickname, this.key_number);

//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//   }

//   Widget _comment() {
//     return Container(
//       decoration: BoxDecoration(color: Theme.of(context).cardColor),
//       child: _buildTextComposer(),
//     );
//   }

//   Widget _comment_stream() {
//     return SafeArea(
//       child: Container(
//         height: 180,
//         child: StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("Club")
//               .doc(club_uid)
//               .collection("Post")
//               .doc("NoticePost")
//               .collection("NoticePostComment")
//               .doc("NoticeComment")
//               .snapshots(),
//           builder:
//               (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return Text("Error!");
//             } else if (snapshot.connectionState == ConnectionState.waiting) {
//               return Container();
//             } else {
//               Map<String, dynamic> comment_data =
//                   snapshot.data!.data() as Map<String, dynamic>;

//               List comment_title = [];
//               List comment_datetime = [];
//               List comment_nickname = [];

//               if (comment_data[key_number] != null) {
//                 for (int i = 0; i < comment_data[key_number].length; i++) {
//                   comment_title.add(comment_data[key_number][i]["Comment"]);
//                   comment_datetime.add(comment_data[key_number][i]["DateTime"]);
//                   comment_nickname.add(comment_data[key_number][i]["NickName"]);
//                 }

//                 // comment_title.reversed;
//                 // comment_datetime.reversed;
//                 // comment_nickname.reversed;
//                 return Container(
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
//                     child: Container(
//                       height: 320,
//                       width: MediaQuery.of(context).size.width,
//                       child: ListView.separated(
//                         scrollDirection: Axis.vertical,
//                         shrinkWrap: true,
//                         itemBuilder: (BuildContext context, int index) {
//                           return SingleChildScrollView(
//                             child: Card(
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: ListTile(
//                                   leading: Text(comment_nickname[index]),
//                                   title: Text(comment_title[index]),
//                                   trailing: Text(comment_datetime[index]),
//                                   dense: true,
//                                   onTap: () {},
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         separatorBuilder: (BuildContext context, int index) {
//                           return Container(
//                             height: 1,
//                           );
//                         },
//                         itemCount: comment_title.length,
//                       ),
//                     ),
//                   ),
//                 );
//               } else {
//                 return Container(child: Text('\n등록된 댓글이 없습니다.'));
//               }
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildTextComposer() {
//     return IconTheme(
//       data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
//       child: Container(
//         height: 60,
//         constraints: BoxConstraints(
//             // maxHeight: MediaQuery.of(context).size.height * 0.5
//             maxHeight: 100),
//         // margin: const EdgeInsets.symmetric(horizontal: 8.0),
//         margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),

//         child: Row(
//           children: [
//             Flexible(
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//                 child: TextField(
//                   // scrollPadding: EdgeInsets.only(bottom: 100),
//                   controller: _textController,
//                   maxLines: null,
//                   onSubmitted: _handleSubmitted,
//                   keyboardType: TextInputType.multiline,
//                   decoration:
//                       const InputDecoration.collapsed(hintText: '댓글 작성'),
//                   onTap: () {},
//                   // focusNode: _focusNode,
//                 ),
//               ),
//             ),
//             // Container(
//             //     margin: const EdgeInsets.symmetric(horizontal: 4.0),
//             //     child: IconButton(
//             //         icon: SvgPicture.asset("assets/images/SVG/arrow.svg"),
//             //         onPressed: () async {
//             //           _handleSubmitted(_textController.text);
//             //         })

//             //     // _textController.text != ""
//             //     //     ? IconButton(
//             //     //         icon: SvgPicture.asset("assets/images/SVG/arrow.svg"),
//             //     //         onPressed: () async {
//             //     //           _handleSubmitted(_textController.text);
//             //     //         })
//             //     //     : Container()

//             //     ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
//               child: Container(
//                 width: 30,
//                 height: 30,
//                 decoration: BoxDecoration(
//                   color: Color(0xffe83a4f),
//                   borderRadius: BorderRadius.circular(60),
//                 ),
//                 child: IconButton(
//                   icon: SvgPicture.asset("assets/images/SVG/arrow.svg"),
//                   onPressed: () async {
//                     _handleSubmitted(_textController.text);
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleSubmitted(String text) async {
//     UserAccountInfo userAccount_ =
//         Provider.of<UserAccountInfo>(context, listen: false);

//     user = FirebaseAuth.instance.currentUser!;

//     _textController.clear();

//     if (text == "") {
//       _showTextErrorDialog(context);
//     } else {
//       List comment_list = [];

//       comment_list.add({
//         "Comment": text,
//         "DateTime": formatDate(DateTime.now(), [yyyy, ".", mm, '.', dd]),
//         "NickName": userAccount_.nickname,
//         "UserUID": user.uid
//       });

//       try {
//         await FirebaseFirestore.instance
//             .collection("Club")
//             .doc(club_uid)
//             .collection("Post")
//             .doc("NoticePost")
//             .collection("NoticePostComment")
//             .doc("NoticeComment")
//             .update(
//                 {post_index.toString(): FieldValue.arrayUnion(comment_list)});
//       } catch (e) {
//         print(e);
//       }

//       comment_list.clear();

//       _focusNode.requestFocus();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     UserAccountInfo userAccount_ =
//         Provider.of<UserAccountInfo>(context, listen: false);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFFFFFF),
//         iconTheme: IconThemeData(color: Colors.grey),
//         automaticallyImplyLeading: false,
//         title:
//             // Image.asset(
//             //   'assets/images/PNG/logo2.png',
//             //   width: 110,
//             // ),
//             SvgPicture.asset(
//           'assets/images/SVG/LOGO_horizontal.svg',
//           width: 110,
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//             // Navigator.of(context).push(
//             //   MaterialPageRoute(
//             //     builder: (BuildContext context) => ClubMainPage(club_uid: club_uid, club_name: name),
//             //   ),
//             // );
//           },
//           icon: Icon(Icons.arrow_back_ios),
//         ),
//         actions: [],
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: SafeArea(
//           child: Container(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//                     child: Container(
//                         child: Column(children: [
//                       SizedBox(
//                         height: 20.0,
//                       ),
//                       Container(
//                           width: 350,
//                           height: 30,
//                           decoration: BoxDecoration(
//                             border: Border(
//                                 bottom: BorderSide(
//                               width: 2,
//                               color: Colors.grey.shade400,
//                             )),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
//                             child: Text(
//                               post_title,
//                               style: TextStyle(
//                                 fontSize: 20.0,
//                                 fontFamily: 'GSANSM',
//                               ),
//                             ),
//                           )),
//                       Padding(
//                         padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
//                         child: Container(
//                             width: 350,
//                             height: 25,
//                             decoration: BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                 width: 1,
//                                 color: Colors.grey.shade600,
//                               )),
//                             ),
//                             child: Padding(
//                                 padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
//                                 child: Row(children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(40),
//                                     child: Image.network(
//                                       'https://www.edmundsgovtech.com/wp-content/uploads/2020/01/default-picture_0_0.png',
//                                       //Image.network('gs://commontest-c3dc8.appspot.com/Users/KakaoTalk_20210822_005858328.jpg',
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(
//                                     ///
//                                     /// 작성한 회원의 사진과 이름 출력 부분
//                                     ///
//                                     nickname,
//                                     style: TextStyle(
//                                       fontSize: 16.0,
//                                       fontFamily: 'GSANSM',
//                                     ),
//                                   ),
//                                 ]))),
//                       ),
//                       SizedBox(
//                         height: 20.0,
//                       ),
//                       Container(
//                         width: 350,
//                         height: 300,
//                         decoration: BoxDecoration(
//                           color: Color(0xffFBD6C2),
//                           borderRadius: BorderRadius.circular(5),
//                           // border: Border.all(
//                           //     color: Colors.grey
//                           // ),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
//                           child: Text(
//                             post_intro,
//                             style: TextStyle(
//                               fontSize: 16.0,
//                               fontFamily: 'GSANSM',
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                       _comment(),
//                       _comment_stream(),
//                     ])),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// void _showTextErrorDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("댓글 내용"),
//         content: Text("댓글 내용이 없습니다."),
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
