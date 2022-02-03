import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:date_format/date_format.dart';
import 'package:snstennis/account/user_account_info.dart';

import 'Club_Gathering_Post_List.dart';
// import 'Club_Notice_Post_List_Page.dart';
import 'Club_Join_Notice_Post_List_Page.dart';

class ClubJoinPage extends StatefulWidget {
  final String club_uid;
  final String club_name;
  final String image_url;
  final String club_intro;
  const ClubJoinPage(
      {Key? key,
      required this.club_uid,
      required this.club_name,
      required this.image_url,
      required this.club_intro})
      : super(key: key);

  @override
  _ClubJoinPageState createState() =>
      _ClubJoinPageState(club_uid, club_name, image_url, club_intro);
}

class _ClubJoinPageState extends State<ClubJoinPage> {
  String name = "";
  String club_uid = '';
  String url_image = "";
  String club_intro = "";

  int _selectedNaviIndex = 2;

  late UserAccountInfo userAccount_;

  late String user_grade = "";

  User user = FirebaseAuth.instance.currentUser!;

  bool check_more_club_intro = false;

  _ClubJoinPageState(this.club_uid, this.name, this.url_image, this.club_intro);

  Future<UserAccountInfo> getData(String club_uid) async {
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);
    var check_grade;
    CollectionReference ref = FirebaseFirestore.instance.collection('Club');
    DocumentSnapshot snapshot = await ref
        .doc(club_uid)
        .collection("ClubMember")
        .doc("MemberList")
        .get();
    var data = snapshot.data() as Map;

    for (int i = 0; i < data["ClubMember"].length; i++) {
      if (data["ClubMember"][i]["UserID"] == user.uid) {
        check_grade = data["ClubMember"][i]["Grade"];
      }
    }
    userAccount_.checkGrade(check_grade);
    return userAccount_;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(club_uid);
  }

  Widget bottom_change_button() {
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);
    return Container(
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("Club")
            .doc(club_uid)
            .collection("ClubMember")
            .doc("WaitJoinClub")
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData == false) {
            return Container();
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: 15),
              ),
            );
          } else {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            List member_list = [];
            bool check = false;

            if (data["WaitJoinClub"].length != 0) {
              for (int i = 0; i < data["WaitJoinClub"].length; i++) {
                member_list.add(data["WaitJoinClub"][i]["UserUID"]);
              }

              for (int i = 0; i < member_list.length; i++) {
                if (user.uid == member_list[i]) {
                  check = true;
                  print("성공함수실행");
                }
              }
            }

            if (check == false) {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: ElevatedButton(
                      onPressed: () async {
                        List total_data = [
                          {
                            "UserUID": user.uid,
                            "DateTime": formatDate(
                                DateTime.now(), [yyyy, ".", mm, '.', dd]),
                            "WaitUserName": userAccount_.nickname
                          }
                        ];

                        try {
                          await FirebaseFirestore.instance
                              .collection("Club")
                              .doc(club_uid)
                              .collection("ClubMember")
                              .doc("WaitJoinClub")
                              .update({
                            "WaitJoinClub": FieldValue.arrayUnion(total_data),
                          });

                          _showJoinToast("가입신청이 완료 되었습니다!!");
                          Navigator.of(context)..pop()..pop()..pop();
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
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: ElevatedButton(
                      onPressed: () async {
                        _showDialog(context);
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
                        "가입승인 대기중",
                        style: TextStyle(
                          fontFamily: 'GSANSB',
                          fontSize: 16,
                        ),
                      )),
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 20, 30, 20),
                child: Text(
                  name,
                  style: TextStyle(
                      fontFamily: 'GSANSB',
                      fontSize: 25.0,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: url_image != ""
                      ? CachedNetworkImage(
                          imageUrl: url_image,
                          imageBuilder: (context, imageProvider) => Container(
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
                        )),
              SizedBox(
                height: 10,
              ),
              check_more_club_intro != true
                  ? Column(children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        color: Colors.grey[100],
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Text(club_intro,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.black45,
                                  fontFamily: "GSANSM")),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 30,
                        // color: Colors.grey[100],
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40))),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                check_more_club_intro = true;
                              });
                            },
                            icon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),

                      // Stack(children: [
                      //   Container(
                      //     width: MediaQuery.of(context).size.width,
                      //     height: 10,
                      //     color: Colors.black,
                      //     // child: IconButton(
                      //     //   onPressed: () {
                      //     //     setState(() {
                      //     //       check_more_club_intro = true;
                      //     //     });
                      //     //   },
                      //     //   icon: Icon(Icons.arrow_drop_down),
                      //     // )
                      //   ),
                      //   Center(
                      //     child: IconButton(
                      //       onPressed: () {
                      //         setState(() {
                      //           check_more_club_intro = true;
                      //         });
                      //       },
                      //       icon: Icon(Icons.arrow_drop_down),
                      //     ),
                      //   )
                      // ])
                    ])
                  : Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[100],
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(club_intro,
                                style: TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black45,
                                    fontFamily: "GSANSM")),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 30,
                          // color: Colors.grey[100],
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40))),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  check_more_club_intro = false;
                                });
                              },
                              icon: Icon(Icons.arrow_drop_up),
                            ),
                          ),
                        ),
                      ],
                    ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return JoinNoticePostList(
                              prev_club_uid: club_uid, prev_club_name: name);
                        }));
                      },
                      child: Container(
                        width: 180,
                        height: 180,
                        // color: Colors.green[600],
                        // decoration: BoxDecoration(
                        //   color: Colors.green[400],
                        //   borderRadius: BorderRadius.circular(30),
                        // ),
                        child: SvgPicture.asset(
                            "assets/images/SVG/notice_post_1_0.svg"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ClubGatheringPostList(
                              prev_club_uid: club_uid, prev_club_name: name);
                        }));
                      },
                      child: Container(
                        width: 180,
                        height: 180,
                        // color: Colors.green[600],
                        // decoration: BoxDecoration(
                        //   color: Colors.green[400],
                        //   borderRadius: BorderRadius.circular(30),
                        // ),
                        // child: Center(
                        //   child: Text(
                        //     "모임방",
                        //     style: TextStyle(
                        //         fontFamily: "GSANSM",
                        //         fontSize: 20,
                        //         color: Colors.white),
                        //   ),
                        // ),
                        child: SvgPicture.asset(
                            "assets/images/SVG/gathering_post_1_0.svg"),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: bottom_change_button(),
              )
            ],
          ),
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
          "승인 대기",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "신청 승인 대기중입니다.",
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
              onPressed: () {
                Navigator.of(context)..pop();
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(80, 20),
                  primary: Colors.white,
                  side: BorderSide(
                      width: 1, color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
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
          //   onPressed: () {
          //     Navigator.of(context)..pop();
          //   },
          //   style: ElevatedButton.styleFrom(
          //       fixedSize: Size(80, 20),
          //       primary: Colors.white,
          //       side:
          //           BorderSide(width: 1, color: Theme.of(context).primaryColor),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(5))),
          // ),
        ],
      );
    },
  );
}

void _showJoinToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Color(0xffe9394f),
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      fontSize: 15.0);
}
