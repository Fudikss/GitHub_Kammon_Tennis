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

import 'Club_Nomal_Post_List_Page.dart';
import 'Club_Notice_Post_List_Page.dart';
import 'Club_Gathering_Post_List.dart';
import 'Club_Chat_Room.dart';

class ClubMainPage extends StatefulWidget {
  final String club_uid;
  final String club_name;
  final String image_url;
  final String club_intro;
  const ClubMainPage(
      {Key? key,
      required this.club_uid,
      required this.club_name,
      required this.image_url,
      required this.club_intro})
      : super(key: key);

  @override
  _ClubMainPageState createState() =>
      _ClubMainPageState(club_uid, club_name, image_url, club_intro);
}

TextEditingController _controller = TextEditingController();
GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();

class _ClubMainPageState extends State<ClubMainPage> {
  String name = "";
  String club_uid = '';
  String url_image = "";
  String club_intro = "";

  final FocusNode _focusNode = FocusNode();

  int _selectedNaviIndex = 2;

  late UserAccountInfo userAccount_;

  late String user_grade = "";

  User user1 = FirebaseAuth.instance.currentUser!;

  bool check_more_club_intro = false;

  _ClubMainPageState(this.club_uid, this.name, this.url_image, this.club_intro);

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

  @override
  Widget build(BuildContext context) {
    userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: Drawer(
          child: ClubDrawer(
        club_uid: club_uid,
        club_name: clubname,
      )),
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
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
        // shape: Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
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
              // Padding(
              //   padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       check_more_club_intro != true
              //           ?
              //           // Container(
              //           //     width: 30,
              //           //     height: 30,
              //           //     child: IconButton(
              //           //         onPressed: () {
              //           //           setState(() {
              //           //             check_more_club_intro = true;
              //           //           });
              //           //         },
              //           //         icon: Icon(Icons.add)),
              //           //   )
              //           Container(
              //               width: 60,
              //               height: 30,
              //               child: TextButton(
              //                 onPressed: () {
              //                   setState(() {
              //                     check_more_club_intro = true;
              //                   });
              //                 },
              //                 style: ButtonStyle(
              //                   overlayColor: MaterialStateProperty.all(
              //                       Colors.transparent),
              //                 ),
              //                 child: Text(
              //                   "펼치기",
              //                   style: TextStyle(
              //                       fontFamily: "GSANSM",
              //                       color: Colors.black,
              //                       fontSize: 12),
              //                 ),
              //               ),
              //             )
              //           :
              //           Container(
              //               width: 60,
              //               height: 30,
              //               child: TextButton(
              //                 onPressed: () {
              //                   setState(() {
              //                     check_more_club_intro = false;
              //                   });
              //                 },
              //                 style: ButtonStyle(
              //                   overlayColor: MaterialStateProperty.all(
              //                       Colors.transparent),
              //                 ),
              //                 child: Text(
              //                   "접기",
              //                   style: TextStyle(
              //                       fontFamily: "GSANSM",
              //                       color: Colors.black,
              //                       fontSize: 12),
              //                 ),
              //               ),
              //             )
              //     ],
              //   ),
              // ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ClubNoticePostList(
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
                      // child: Center(
                      //   child: Text(
                      //     "공지방",
                      //     style: TextStyle(
                      //         fontFamily: "GSANSM",
                      //         fontSize: 20,
                      //         color: Colors.white),
                      //   ),
                      // ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ClubChatRoom(
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
                        //     "이야기방",
                        //     style: TextStyle(
                        //         fontFamily: "GSANSM",
                        //         fontSize: 20,
                        //         color: Colors.white),
                        //   ),
                        // ),
                        child: SvgPicture.asset(
                            "assets/images/SVG/club_chat_1_0.svg"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ClubNomalPostList(
                            prev_club_uid: club_uid,
                            prev_club_name: name,
                          );
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
                        //     "자유방",
                        //     style: TextStyle(
                        //         fontFamily: "GSANSM",
                        //         fontSize: 20,
                        //         color: Colors.white),
                        //   ),
                        // ),
                        child: SvgPicture.asset(
                            "assets/images/SVG/nomal_post_1_0.svg"),
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
            ],
          ),
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
