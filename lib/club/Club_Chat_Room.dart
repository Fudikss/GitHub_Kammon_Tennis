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
import 'club_drawer_1_0.dart';
import 'first_screen_1_0.dart';

class ClubChatRoom extends StatefulWidget {
  final String prev_club_uid;
  final String prev_club_name;
  const ClubChatRoom(
      {Key? key, required this.prev_club_uid, required this.prev_club_name})
      : super(key: key);

  @override
  _ClubChatRoomState createState() =>
      _ClubChatRoomState(prev_club_uid, prev_club_name);
}

class _ClubChatRoomState extends State<ClubChatRoom> {
  String club_uid = "";
  String name = "";

  int _selectedNaviIndex = 2;
  late UserAccountInfo userAccount_;

  User user = FirebaseAuth.instance.currentUser!;

  _ClubChatRoomState(this.club_uid, this.name);

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
        // shape: Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Club")
                      .doc(club_uid)
                      .collection("ChatRoom")
                      .doc("ChatRoom")
                      .snapshots(),
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
                          profile_image
                              .add(data["ChatRoom"][i]["Profile_image"]);
                        }

                        List reversChat = [];
                        List reversNick = [];
                        List reversUid = [];
                        List reversTime = [];
                        List revers_profile = [];

                        reversChat = List.from(chat_comment.reversed).toList();
                        reversNick =
                            List.from(user_nick_name.reversed).toList();
                        reversUid = List.from(total_user_uid.reversed).toList();
                        reversTime = List.from(time_stamp.reversed).toList();
                        revers_profile =
                            List.of(profile_image.reversed).toList();

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
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 20, 0, 0),
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
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    0))),
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
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      title:
                                                                          Text(
                                                                        "채팅글 삭제",
                                                                        style: TextStyle(
                                                                            color: Theme.of(context)
                                                                                .primaryColor,
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'GSANSM'),
                                                                      ),
                                                                      content:
                                                                          Text(
                                                                        "정말로 삭제하시겠습니까?",
                                                                        style: TextStyle(
                                                                            color: Theme.of(context)
                                                                                .primaryColor,
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'GSANSM'),
                                                                      ),
                                                                      actions: <
                                                                          Widget>[
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            ElevatedButton(
                                                                              child: Text(
                                                                                "삭제",
                                                                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontFamily: 'GSANSM'),
                                                                              ),
                                                                              onPressed: () {
                                                                                for (int i = 0; i < reversUid.length; i++) {
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
                                                                                    FirebaseFirestore.instance.collection("Club").doc(club_uid).collection("ChatRoom").doc("ChatRoom").update({
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
                                                                              style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.white, side: BorderSide(width: 1, color: Theme.of(context).primaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 30,
                                                                            ),
                                                                            ElevatedButton(
                                                                              child: Text(
                                                                                "취소",
                                                                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontFamily: 'GSANSM'),
                                                                              ),
                                                                              style: ElevatedButton.styleFrom(fixedSize: Size(80, 20), primary: Colors.white, side: BorderSide(width: 1, color: Theme.of(context).primaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                                              onPressed: () {
                                                                                Navigator.of(context)..pop()..pop();
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
                                                                color: Colors
                                                                    .grey),
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
                                                              BorderRadius
                                                                  .circular(40),
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/images/SVG/profile_pink.svg',
                                                            width: 40,
                                                          )),
                                                    )
                                                  : Container(
                                                      width: 40,
                                                      height: 40,
                                                      child: CircleAvatar(
                                                          backgroundColor:
                                                              Colors.white,
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
                                                        color:
                                                            Color(0xffFBD6C2),
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10))),
                                                child: Text(
                                                  reversChat[index],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontFamily: 'GSANSM'),
                                                )),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 20, 20, 0),
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
                                    '채팅이 없습니다.',
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
              Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
              SingleChildScrollView(
                child: Container(
                  // height: 50,
                  color: Colors.grey[200],
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5),
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                              },
                              child: Container(
                                height: 45,
                                child: TextField(
                                  controller: _controller,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "GSANSM",
                                    height: 1,
                                  ),
                                  // decoration: InputDecoration(
                                  //     fillColor: Colors.grey[200],
                                  //     filled: true,
                                  //     border: InputBorder.none,
                                  //     focusedBorder: InputBorder.none,
                                  //     hintStyle: TextStyle(color: Colors.black)),
                                  // decoration: InputDecoration(
                                  //   fillColor: Colors.grey[200],
                                  //   filled: true,
                                  // ),
                                  textInputAction: TextInputAction.newline,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 5, 5, 5),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      hintStyle:
                                          TextStyle(color: Colors.grey[100])),
                                ),
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
                                "UserUID": user.uid,
                                "TimeStamp": formatDate(
                                    DateTime.now(), [am, ' ', hh, ':', nn]),
                                "Profile_image": userAccount_.profile_image
                              });
                              _controller.clear();
                              await FirebaseFirestore.instance
                                  .collection('Club')
                                  .doc(club_uid)
                                  .collection("ChatRoom")
                                  .doc("ChatRoom")
                                  .update({
                                "ChatRoom": FieldValue.arrayUnion(add_text)
                              });
                              add_text.clear();

                              // _focusNode.requestFocus();
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
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
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(0xffe83a4f),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                    "assets/images/SVG/arrow.svg"),
                                onPressed: null,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
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

void _showDialog_error(BuildContext context) {
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
