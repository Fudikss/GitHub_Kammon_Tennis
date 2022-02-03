import 'dart:async';
import 'dart:developer';
import 'package:circular_menu/circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/Club_Settings.dart';

import 'Market_Main_Page.dart';
import 'Market_User_Report.dart';

class MarketChatRoom extends StatefulWidget {
  final String chat_path;
  final int page_index;
  final String buy_user_uid;
  final String sell_user_uid;
  const MarketChatRoom(
      {Key? key,
      required this.chat_path,
      required this.page_index,
      required this.sell_user_uid,
      required this.buy_user_uid})
      : super(key: key);

  @override
  _MarketChatRoomState createState() =>
      _MarketChatRoomState(chat_path, page_index, buy_user_uid, sell_user_uid);
}

// final globalScaffoldKey = GlobalKey<ScaffoldState>();

class _MarketChatRoomState extends State<MarketChatRoom>
    with SingleTickerProviderStateMixin {
  String path_chat_room = "";
  int index_page;
  String uid_sell_user;
  String uid_buy_user;

  late ScrollController _scrollController;
  TextEditingController comment = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  User user = FirebaseAuth.instance.currentUser!;

  late UserAccountInfo userAccount_;

  List report_user_list = [];

  bool report_check = false;

  String report_buy_user_uid = "";
  String report_sell_user_uid = "";

  TextEditingController _controller = TextEditingController();

  int _selectedNaviIndex = 3;

  _MarketChatRoomState(this.path_chat_room, this.index_page, this.uid_buy_user,
      this.uid_sell_user);

  Stream<DocumentSnapshot> _getComment() {
    return FirebaseFirestore.instance
        .collection("MarketChatRoom")
        .doc(path_chat_room)
        .snapshots();
  }

  Future _get_report_item_id() async {
    report_user_list.clear();
    DocumentReference ref = FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection("Report")
        .doc("ReportList");

    DocumentSnapshot snapshot = await ref.get();

    if (snapshot["UserReportList"].length != 0) {
      for (int i = 0; i < snapshot["UserReportList"].length; i++) {
        report_user_list.add(snapshot["UserReportList"][i]);
      }

      for (int i = 0; i < report_user_list.length; i++) {
        if (report_user_list[i] == uid_sell_user) {
          setState(() {
            report_check = true;
          });
        }
        if (report_user_list[i] == uid_buy_user) {
          setState(() {
            report_check = true;
          });
        }
      }
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _get_report_item_id();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget market_Chat_Room() {
    // List<ChatMessageWidget> _messages = [];
    // List<ChatMessageWidget> reversedList = [];
    UserAccountInfo userAccount_ = Provider.of(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height / 1.22,
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
                  // _messages.clear();

                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  List user_nick_name = [];
                  List chat_comment = [];
                  List total_user_uid = [];
                  List time_stamp = [];

                  if (data["ChatRoom"].length != 0) {
                    // _messages.clear();

                    for (int i = 0; i < data["ChatRoom"].length; i++) {
                      user_nick_name.add(data["ChatRoom"][i]["NickName"]);
                      chat_comment.add(data["ChatRoom"][i]["Comment"]);
                      total_user_uid.add(data["ChatRoom"][i]["UserUID"]);
                      time_stamp.add(data["ChatRoom"][i]["TimeStamp"]);
                    }

                    List reversChat = [];
                    List reversNick = [];
                    List reversUid = [];
                    List reversTime = [];

                    reversChat = List.from(chat_comment.reversed).toList();
                    reversNick = List.from(user_nick_name.reversed).toList();
                    reversUid = List.from(total_user_uid.reversed).toList();
                    reversTime = List.from(time_stamp.reversed).toList();

                    return ListView.builder(
                      // controller: _scrollController,
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
                                          onTap: () {},
                                          child: CircleAvatar(
                                            backgroundColor: Colors.blue,
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
                              // Padding(
                              //   // padding: EdgeInsets.symmetric(horizontal: 13),
                              //   padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                              //   child: Text(
                              //     reversNick[index],
                              //     style: TextStyle(
                              //         fontFamily: 'GSANSM', fontSize: 11.0),
                              //   ),
                              // ),
                              // Container(
                              //     margin: EdgeInsets.symmetric(horizontal: 5),
                              //     padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              //     decoration: BoxDecoration(
                              //         color: user.uid == reversUid[index]
                              //             ? Color(0xffFBD6C2)
                              //             : Colors.white,
                              //         border: Border.all(
                              //             color: user.uid == reversUid[index]
                              //                 ? Colors.white
                              //                 : Color(0xffe9394f),
                              //             width: 1),
                              //         borderRadius: BorderRadius.only(
                              //             topLeft: Radius.circular(
                              //                 user.uid == reversUid[index]
                              //                     ? 10
                              //                     : 0),
                              //             topRight: Radius.circular(
                              //                 user.uid == reversUid[index]
                              //                     ? 0
                              //                     : 10),
                              //             bottomLeft: Radius.circular(10),
                              //             bottomRight: Radius.circular(10))),
                              //     child: Text(
                              //       reversChat[index],
                              //       style: TextStyle(
                              //           color: Colors.black,
                              //           fontSize: 14,
                              //           fontFamily: 'GSANSM'),
                              //     )),
                              // Row(
                              //   mainAxisAlignment: user.uid == reversUid[index]
                              //       ? MainAxisAlignment.end
                              //       : MainAxisAlignment.start,
                              //   children: [
                              //     Padding(
                              //       padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                              //       child: Text(
                              //         reversTime[index],
                              //         style: TextStyle(
                              //             fontFamily: 'GSANSM', fontSize: 9.0),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        );
                      },
                      itemCount: data["ChatRoom"].length,
                    );
                  } else {
                    return Container(child: Center(child: Text("채팅글 없음")));
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
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        //       padding: EdgeInsets.only(
                        // bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: GestureDetector(
                          onTap: () {},
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

                        if (txt != "") {
                          List add_text = [];
                          add_text.add({
                            "Comment": txt,
                            "NickName": userAccount_.nickname,
                            "UserUID": user.uid,
                            "TimeStamp": formatDate(
                                DateTime.now(), [am, ' ', hh, ':', nn]),
                            "DateTime": Timestamp.now(),
                          });
                          _controller.clear();
                          await FirebaseFirestore.instance
                              .collection('MarketChatRoom')
                              .doc(path_chat_room)
                              .update({
                            "ChatRoom": FieldValue.arrayUnion(add_text)
                          });
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
                            icon:
                                SvgPicture.asset("assets/images/SVG/arrow.svg"),
                            onPressed: null,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // SingleChildScrollView(
          //   child: SizedBox(
          //     width: MediaQuery.of(context).size.width,
          //     child: Container(
          //       width: MediaQuery.of(context).size.width,
          //       child: Padding(
          //         padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               children: [
          //                 Expanded(
          //                     flex: 4,
          //                     child: SizedBox(
          //                       height: 40,
          //                       child: TextField(
          //                         onTap: () {
          //                           _scrollController.animateTo(
          //                               MediaQuery.of(context).size.height,
          //                               duration: Duration(milliseconds: 500),
          //                               curve: Curves.ease);
          //                         },
          //                         controller: comment,
          //                         decoration: InputDecoration(
          //                           contentPadding: new EdgeInsets.symmetric(
          //                               vertical: 0.0, horizontal: 10.0),
          //                           hintText: '댓글을 작성해 보세요.',
          //                           enabledBorder: OutlineInputBorder(
          //                               borderSide: BorderSide(
          //                                 color: Colors.grey.shade400,
          //                                 width: 1,
          //                               ),
          //                               borderRadius: const BorderRadius.all(
          //                                   Radius.circular(10))),
          //                           focusedBorder: OutlineInputBorder(
          //                               borderSide: BorderSide(
          //                                 color: Colors.grey.shade400,
          //                                 width: 2,
          //                               ),
          //                               borderRadius: const BorderRadius.all(
          //                                   Radius.circular(10))),
          //                         ),
          //                       ),
          //                     )),
          //                 SizedBox(
          //                   width: 10,
          //                 ),
          //                 Expanded(
          //                     flex: 1,
          //                     child: OutlinedButton(
          //                         onPressed: () async {
          //                           var txt = comment.text;

          //                           if (txt != "") {
          //                             List add_text = [];
          //                             add_text.add({
          //                               "Comment": txt,
          //                               "NickName": userAccount_.nickname,
          //                               "UserUID": user.uid,
          //                               "TimeStamp": formatDate(DateTime.now(),
          //                                   [am, ' ', hh, ':', nn]),
          //                               "DateTime": Timestamp.now(),
          //                             });
          //                             comment.clear();
          //                             await FirebaseFirestore.instance
          //                                 .collection('MarketChatRoom')
          //                                 .doc(path_chat_room)
          //                                 .update({
          //                               "ChatRoom":
          //                                   FieldValue.arrayUnion(add_text)
          //                             });
          //                             add_text.clear();

          //                             // _focusNode.requestFocus();
          //                             FocusScopeNode currentFocus =
          //                                 FocusScope.of(context);
          //                             if (!currentFocus.hasPrimaryFocus) {
          //                               currentFocus.unfocus();
          //                             }
          //                           } else {
          //                             print("채팅 공백 시도함");
          //                           }

          //                           // _insertComment(userAccount_.uid);
          //                           // comment.clear();
          //                           FocusScope.of(context).unfocus();
          //                         },
          //                         style: OutlinedButton.styleFrom(
          //                             primary: Colors.white,
          //                             //backgroundColor: Theme.of(context).primaryColor,
          //                             backgroundColor: Colors.grey[200],
          //                             shape: RoundedRectangleBorder(
          //                                 side: BorderSide(
          //                                     color: Colors.grey.shade200,
          //                                     width: 1,
          //                                     style: BorderStyle.solid),
          //                                 borderRadius:
          //                                     BorderRadius.circular(10)),
          //                             elevation: 3),
          //                         child: Text(
          //                           '등록',
          //                           style: TextStyle(
          //                               color: Colors.grey[700],
          //                               fontFamily: 'GSANSM',
          //                               fontSize: 12),
          //                         ))),
          //               ],
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Widget _change_Market_Chat_Room() {
  //   return Expanded(
  //       child: SingleChildScrollView(
  //     child: Container(
  //         width: MediaQuery.of(context).size.width,
  //         height: 200,
  //         child: StreamBuilder(
  //             stream: _getComment(),
  //             builder: (BuildContext context,
  //                 AsyncSnapshot<DocumentSnapshot> snapshot) {
  //               if (snapshot.hasError) {
  //                 return Center(child: Text('DB Error!!'));
  //               }
  //               if (snapshot.connectionState == ConnectionState.waiting) {
  //                 return Center(child: CircularProgressIndicator());
  //               } else {
  //                 Map<String, dynamic> data =
  //                     snapshot.data!.data() as Map<String, dynamic>;

  //                 List user_nick_name = [];
  //                 List chat_comment = [];
  //                 List total_user_uid = [];
  //                 List time_stamp = [];

  //                 if (data["ChatRoom"].length != 0) {
  //                   // _messages.clear();

  //                   for (int i = 0; i < data["ChatRoom"].length; i++) {
  //                     user_nick_name.add(data["ChatRoom"][i]["NickName"]);
  //                     chat_comment.add(data["ChatRoom"][i]["Comment"]);
  //                     total_user_uid.add(data["ChatRoom"][i]["UserUID"]);
  //                     time_stamp.add(data["ChatRoom"][i]["TimeStamp"]);
  //                   }

  //                   List reversChat = [];
  //                   List reversNick = [];
  //                   List reversUid = [];
  //                   List reversTime = [];

  //                   reversChat = List.from(chat_comment.reversed).toList();
  //                   reversNick = List.from(user_nick_name.reversed).toList();
  //                   reversUid = List.from(total_user_uid.reversed).toList();
  //                   reversTime = List.from(time_stamp.reversed).toList();

  //                   return ListView.builder(
  //                     // controller: _scrollController,
  //                     reverse: true,
  //                     shrinkWrap: true,
  //                     itemBuilder: (_, int index) {
  //                       // return _messages[index];

  //                       return ListTile(
  //                         title: Column(
  //                           crossAxisAlignment: user.uid == reversUid[index]
  //                               ? CrossAxisAlignment.end
  //                               : CrossAxisAlignment.start,
  //                           children: [
  //                             Padding(
  //                               // padding: EdgeInsets.symmetric(horizontal: 13),
  //                               padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
  //                               child: Text(
  //                                 reversNick[index],
  //                                 style: TextStyle(
  //                                     fontFamily: 'GSANSM', fontSize: 11.0),
  //                               ),
  //                             ),
  //                             Container(
  //                                 margin: EdgeInsets.symmetric(horizontal: 5),
  //                                 padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
  //                                 decoration: BoxDecoration(
  //                                     color: user.uid == reversUid[index]
  //                                         ? Color(0xffFBD6C2)
  //                                         : Colors.white,
  //                                     border: Border.all(
  //                                         color: user.uid == reversUid[index]
  //                                             ? Colors.white
  //                                             : Color(0xffe9394f),
  //                                         width: 1),
  //                                     borderRadius: BorderRadius.only(
  //                                         topLeft: Radius.circular(
  //                                             user.uid == reversUid[index]
  //                                                 ? 10
  //                                                 : 0),
  //                                         topRight: Radius.circular(
  //                                             user.uid == reversUid[index]
  //                                                 ? 0
  //                                                 : 10),
  //                                         bottomLeft: Radius.circular(10),
  //                                         bottomRight: Radius.circular(10))),
  //                                 child: Text(
  //                                   reversChat[index],
  //                                   style: TextStyle(
  //                                       color: Colors.black,
  //                                       fontSize: 14,
  //                                       fontFamily: 'GSANSM'),
  //                                 )),
  //                             Row(
  //                               mainAxisAlignment: user.uid == reversUid[index]
  //                                   ? MainAxisAlignment.end
  //                                   : MainAxisAlignment.start,
  //                               children: [
  //                                 Padding(
  //                                   padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
  //                                   child: Text(
  //                                     reversTime[index],
  //                                     style: TextStyle(
  //                                         fontFamily: 'GSANSM', fontSize: 9.0),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       );
  //                     },
  //                     itemCount: data["ChatRoom"].length,
  //                   );
  //                 } else {
  //                   return Text("채팅글 없음");
  //                 }
  //               }
  //             })),
  //   ));
  // }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("이용제한"),
          content: Text("신고횟수 초과로 이용에 제한된 상태입니다\n채팅을 할 수 없는 상태입니다"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("나가기"),
              onPressed: () {
                Navigator.of(context)..pop()..pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserAccountInfo userAccount_ = Provider.of(context, listen: false);
    //_get_report_item_id();

    return WillPopScope(
      onWillPop: () {
        if (index_page == 1) {
          Navigator.of(context)..pop()..pop();
          return Future(() => true);
        } else {
          Navigator.of(context).pop();
          return Future(() => true);
        }
      },
      child: Scaffold(
        // key: globalScaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          iconTheme: IconThemeData(color: Colors.grey),
          title:
              // Image.asset(
              //   'assets/images/PNG/logo2.png',
              //   width: 110,
              // ),
              SvgPicture.asset(
            'assets/images/SVG/LOGO_KAMMON_small.svg',
            width: 110,
          ),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
        body: GestureDetector(
          onTap: () async {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Column(children: [
              Stack(
                children: [
                  report_check
                      ? Container(
                          width: 200,
                          decoration: BoxDecoration(color: Colors.red),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                            child: Center(
                              child: Text(
                                "신고한 사용자입니다",
                                style: TextStyle(
                                    fontFamily: "GSANSM", color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
              Expanded(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 550,
                    child: StreamBuilder(
                        stream: _getComment(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text('DB Error!!'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;

                            List user_nick_name = [];
                            List chat_comment = [];
                            List total_user_uid = [];
                            List time_stamp = [];
                            List profile_image = [];

                            if (data["ChatRoom"].length != 0) {
                              // _messages.clear();

                              for (int i = 0;
                                  i < data["ChatRoom"].length;
                                  i++) {
                                user_nick_name
                                    .add(data["ChatRoom"][i]["NickName"]);
                                chat_comment
                                    .add(data["ChatRoom"][i]["Comment"]);
                                total_user_uid
                                    .add(data["ChatRoom"][i]["UserUID"]);
                                time_stamp
                                    .add(data["ChatRoom"][i]["TimeStamp"]);
                                profile_image
                                    .add(data["ChatRoom"][i]["Profile_image"]);
                              }

                              report_buy_user_uid = data["NickName1UID"];
                              report_sell_user_uid = data["NickName2UID"];

                              List reversChat = [];
                              List reversNick = [];
                              List reversUid = [];
                              List reversTime = [];

                              reversChat =
                                  List.from(chat_comment.reversed).toList();
                              reversNick =
                                  List.from(user_nick_name.reversed).toList();
                              reversUid =
                                  List.from(total_user_uid.reversed).toList();
                              reversTime =
                                  List.from(time_stamp.reversed).toList();

                              return ListView.builder(
                                // controller: _scrollController,
                                reverse: true,
                                shrinkWrap: true,
                                itemBuilder: (_, int index) {
                                  // return _messages[index];

                                  return ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          user.uid == reversUid[index]
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 5, 10),
                                          child: Text(
                                            user.uid == reversUid[index]
                                                ? ""
                                                : reversNick[index],
                                            style: TextStyle(
                                                fontFamily: 'GSANSM',
                                                fontSize: 11.0),
                                          ),
                                        ),
                                        user.uid == reversUid[index]
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 20, 0, 0),
                                                    child: Text(
                                                      reversTime[index],
                                                      style: TextStyle(
                                                          fontFamily: 'GSANSM',
                                                          fontSize: 9.0),
                                                    ),
                                                  ),
                                                  Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 10, 15, 10),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffFBD6C2),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 1),
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomLeft:
                                                                  Radius.circular(10),
                                                              bottomRight: Radius.circular(0))),
                                                      child: Text(
                                                        reversChat[index],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'GSANSM'),
                                                      )),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      // showDialog(
                                                      //   context: context,
                                                      //   builder: (_) {
                                                      //     return Container(
                                                      //       child: SimpleDialog(
                                                      //         backgroundColor:
                                                      //             Colors.white,
                                                      //         elevation: 2.0,
                                                      //         title: Text(
                                                      //           "신고하기",
                                                      //           style: TextStyle(
                                                      //               color: Colors
                                                      //                   .black,
                                                      //               fontSize:
                                                      //                   20.0,
                                                      //               height: 1.5,
                                                      //               fontFamily:
                                                      //                   "GSANSB"),
                                                      //         ),
                                                      //         children: <
                                                      //             Widget>[
                                                      //           SimpleDialogOption(
                                                      //             onPressed:
                                                      //                 () {},
                                                      //             child: Text(
                                                      //               '사용자 신고하기',
                                                      //               style: TextStyle(
                                                      //                   fontFamily:
                                                      //                       "GSANSM"),
                                                      //             ),
                                                      //           ),
                                                      //           SimpleDialogOption(
                                                      //             onPressed:
                                                      //                 () {},
                                                      //             child: Text(
                                                      //               '취소',
                                                      //               style: TextStyle(
                                                      //                   fontFamily:
                                                      //                       "GSANSM"),
                                                      //             ),
                                                      //           ),
                                                      //         ],
                                                      //       ),
                                                      //     );
                                                      //   },
                                                      // );
                                                    },
                                                    // child: CircleAvatar(
                                                    //   backgroundColor:
                                                    //       Colors.blue,
                                                    // ),
                                                    child: userAccount_
                                                                .profile_image ==
                                                            ""
                                                        ? Container(
                                                            width: 40,
                                                            height: 40,
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            40),
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/images/SVG/profile_pink.svg',
                                                                  width: 40,
                                                                )),
                                                          )
                                                        : Container(
                                                            width: 40,
                                                            height: 40,
                                                            child: CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                radius: 120,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        userAccount_
                                                                            .profile_image)),
                                                          ),
                                                  ),
                                                  Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15, 10, 15, 10),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xffFBD6C2),
                                                              width: 1),
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomLeft:
                                                                  Radius.circular(0),
                                                              bottomRight: Radius.circular(10))),
                                                      child: Text(
                                                        reversChat[index],
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'GSANSM'),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
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
                                        // Padding(
                                        //   // padding: EdgeInsets.symmetric(horizontal: 13),
                                        //   padding:
                                        //       EdgeInsets.fromLTRB(5, 0, 5, 10),
                                        //   child: Text(
                                        //     reversNick[index],
                                        //     style: TextStyle(
                                        //         fontFamily: 'GSANSM',
                                        //         fontSize: 11.0),
                                        //   ),
                                        // ),
                                        // Container(
                                        //     margin: EdgeInsets.symmetric(
                                        //         horizontal: 5),
                                        //     padding: EdgeInsets.fromLTRB(
                                        //         15, 10, 15, 10),
                                        //     decoration: BoxDecoration(
                                        //         color:
                                        //             user.uid == reversUid[index]
                                        //                 ? Color(0xffFBD6C2)
                                        //                 : Colors.white,
                                        //         border: Border.all(
                                        //             color: user.uid ==
                                        //                     reversUid[index]
                                        //                 ? Colors.white
                                        //                 : Color(0xffe9394f),
                                        //             width: 1),
                                        //         borderRadius: BorderRadius.only(
                                        //             topLeft: Radius.circular(
                                        //                 user.uid == reversUid[index]
                                        //                     ? 10
                                        //                     : 0),
                                        //             topRight: Radius.circular(
                                        //                 user.uid == reversUid[index] ? 0 : 10),
                                        //             bottomLeft: Radius.circular(10),
                                        //             bottomRight: Radius.circular(10))),
                                        //     child: Text(
                                        //       reversChat[index],
                                        //       style: TextStyle(
                                        //           color: Colors.black,
                                        //           fontSize: 14,
                                        //           fontFamily: 'GSANSM'),
                                        //     )),
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       user.uid == reversUid[index]
                                        //           ? MainAxisAlignment.end
                                        //           : MainAxisAlignment.start,
                                        //   children: [
                                        //     Padding(
                                        //       padding: EdgeInsets.fromLTRB(
                                        //           20, 5, 20, 10),
                                        //       child: Text(
                                        //         reversTime[index],
                                        //         style: TextStyle(
                                        //             fontFamily: 'GSANSM',
                                        //             fontSize: 9.0),
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
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
                        })),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.grey,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Container(
                                    child: IconButton(
                                      icon: Image.asset(
                                        "assets/images/PNG/siren.png",
                                      ),
                                      onPressed: () {
                                        if (uid_buy_user == user.uid) {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return MarketUserReport(
                                                //prev_problem_user_uid: report_sell_user_uid,
                                                prev_problem_user_uid:
                                                    uid_sell_user,
                                                prev_problem_user_nick_name: "",
                                                prev_reporter_user_uid: "",
                                                prev_reporter_user_nick_name:
                                                    "",
                                                path_chat_room: path_chat_room);
                                          }));
                                        } else {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return MarketUserReport(
                                                prev_problem_user_uid:
                                                    uid_buy_user,
                                                prev_problem_user_nick_name: "",
                                                prev_reporter_user_uid: "",
                                                prev_reporter_user_nick_name:
                                                    "",
                                                path_chat_room: path_chat_room);
                                          }));
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 4,
                                    child: SizedBox(
                                      height: 40,
                                      child: TextField(
                                        onTap: () {
                                          // _scrollController.animateTo(
                                          //     MediaQuery.of(context)
                                          //         .size
                                          //         .height,
                                          //     duration:
                                          //         Duration(milliseconds: 500),
                                          //     curve: Curves.ease);
                                        },
                                        controller: _controller,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              new EdgeInsets.symmetric(
                                                  vertical: 0.0,
                                                  horizontal: 10.0),
                                          hintText: '댓글을 작성해 보세요.',
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade400,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade400,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (userAccount_.reportCount >= 5) {
                                          _showDialog(context);
                                        } else {
                                          var txt = _controller.text;
                                          if (txt != "") {
                                            List add_text = [];
                                            add_text.add({
                                              "Comment": txt,
                                              "NickName": userAccount_.nickname,
                                              "UserUID": user.uid,
                                              "TimeStamp": formatDate(
                                                  DateTime.now(),
                                                  [am, ' ', hh, ':', nn]),
                                              "DateTime": Timestamp.now(),
                                              "Profile_image":
                                                  userAccount_.profile_image
                                            });
                                            _controller.clear();
                                            await FirebaseFirestore.instance
                                                .collection('MarketChatRoom')
                                                .doc(path_chat_room)
                                                .update({
                                              "ChatRoom": FieldValue.arrayUnion(
                                                  add_text)
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
                                        }
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 5, 5, 5),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Color(0xffe83a4f),
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          child: IconButton(
                                            icon: SvgPicture.asset(
                                                "assets/images/SVG/arrow.svg"),
                                            onPressed: null,
                                          ),
                                        ),
                                      ),
                                    )),
                                // Expanded(
                                //     flex: 1,
                                //     child: OutlinedButton(
                                //         onPressed: () async {
                                //           if(userAccount_.reportCount >= 5){
                                //             _showDialog(context);
                                //           }else{

                                //             var txt = _controller.text;
                                //             if (txt != "") {
                                //             List add_text = [];
                                //             add_text.add({
                                //               "Comment": txt,
                                //               "NickName": userAccount_.nickname,
                                //               "UserUID": user.uid,
                                //               "TimeStamp": formatDate(
                                //                   DateTime.now(),
                                //                   [am, ' ', hh, ':', nn]),
                                //               "DateTime": Timestamp.now(),
                                //             });
                                //             _controller.clear();
                                //             await FirebaseFirestore.instance
                                //                 .collection('MarketChatRoom')
                                //                 .doc(path_chat_room)
                                //                 .update({
                                //               "ChatRoom": FieldValue.arrayUnion(
                                //                   add_text)
                                //             });
                                //             add_text.clear();

                                //             // _focusNode.requestFocus();
                                //             FocusScopeNode currentFocus =
                                //                 FocusScope.of(context);
                                //             if (!currentFocus.hasPrimaryFocus) {
                                //               currentFocus.unfocus();
                                //             }
                                //           } else {
                                //             print("채팅 공백 시도함");
                                //           }
                                //           }
                                //           // var txt = _controller.text;

                                //           // if (txt != "") {
                                //           //   List add_text = [];
                                //           //   add_text.add({
                                //           //     "Comment": txt,
                                //           //     "NickName": userAccount_.nickname,
                                //           //     "UserUID": user.uid,
                                //           //     "TimeStamp": formatDate(
                                //           //         DateTime.now(),
                                //           //         [am, ' ', hh, ':', nn]),
                                //           //     "DateTime": Timestamp.now(),
                                //           //   });
                                //           //   _controller.clear();
                                //           //   await FirebaseFirestore.instance
                                //           //       .collection('MarketChatRoom')
                                //           //       .doc(path_chat_room)
                                //           //       .update({
                                //           //     "ChatRoom": FieldValue.arrayUnion(
                                //           //         add_text)
                                //           //   });
                                //           //   add_text.clear();

                                //           //   // _focusNode.requestFocus();
                                //           //   FocusScopeNode currentFocus =
                                //           //       FocusScope.of(context);
                                //           //   if (!currentFocus.hasPrimaryFocus) {
                                //           //     currentFocus.unfocus();
                                //           //   }
                                //           // } else {
                                //           //   print("채팅 공백 시도함");
                                //           // }
                                //           FocusScope.of(context).unfocus();
                                //         },
                                //         style: OutlinedButton.styleFrom(
                                //             primary: Colors.white,
                                //             //backgroundColor: Theme.of(context).primaryColor,
                                //             backgroundColor: Colors.grey[200],
                                //             shape: RoundedRectangleBorder(
                                //                 side: BorderSide(
                                //                     color: Colors.grey.shade200,
                                //                     width: 1,
                                //                     style: BorderStyle.solid),
                                //                 borderRadius:
                                //                     BorderRadius.circular(10)),
                                //             elevation: 0),
                                //         child: Text(
                                //           '등록',
                                //           style: TextStyle(
                                //               color: Colors.grey[700],
                                //               fontFamily: 'GSANSM',
                                //               fontSize: 12),
                                //         )
                                //     )
                                // ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              )
            ]),
          ),
        ),

        // bottomNavigationBar: SizedBox(
        //     height: 60,
        //     child: Container(
        //         decoration: BoxDecoration(
        //           boxShadow: <BoxShadow>[
        //             BoxShadow(
        //                 color: Colors.black54,
        //                 blurRadius: 5.0,
        //                 offset: Offset(0.0, 0.75))
        //           ],
        //         ),
        //         child: BottomNavigationBar(
        //           type: BottomNavigationBarType.fixed,
        //           //backgroundColor: Colors.grey[300],
        //           backgroundColor: Colors.white,
        //           elevation: 3,
        //           selectedItemColor: Theme.of(context).primaryColor,
        //           //selectedItemColor: Colors.grey[800],
        //           currentIndex: _selectedNaviIndex,
        //           onTap: (int index) {
        //             _selectedNaviIndex = index;
        //             setState(() {
        //               if (_selectedNaviIndex == 0) {
        //                 print(_selectedNaviIndex);
        //                 // Navigator.push(context, MaterialPageRoute(
        //                 //     builder: (BuildContext context){
        //                 //       return Home();
        //                 //     }
        //                 // ));
        //               }
        //               if (_selectedNaviIndex == 1) {
        //                 print(_selectedNaviIndex);
        //                 // Navigator.push(context, MaterialPageRoute(
        //                 //     builder: (BuildContext context){
        //                 //       return InstantPLay();
        //                 //     }
        //                 // ));
        //               }
        //               if (_selectedNaviIndex == 2) {
        //                 print(_selectedNaviIndex);
        //                 Navigator.push(context,
        //                     MaterialPageRoute(builder: (BuildContext context) {
        //                   return FirstScreen();
        //                 }));
        //               }
        //               if (_selectedNaviIndex == 3) {
        //                 Navigator.push(context,
        //                     MaterialPageRoute(builder: (BuildContext context) {
        //                   return MarketMainPage(
        //                       item_id: userAccount_.marketChatItem);
        //                 }));
        //               }
        //             });
        //           },
        //           items: [
        //             BottomNavigationBarItem(
        //               title: Text(
        //                 '홈',
        //                 style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),
        //               ),
        //               icon: SvgPicture.asset(
        //                 'assets/images/SVG/home.svg',
        //                 width: 23,
        //               ),
        //               activeIcon: SvgPicture.asset(
        //                 'assets/images/SVG/home_selected.svg',
        //                 width: 23,
        //               ),
        //             ),
        //             BottomNavigationBarItem(
        //               title: Text(
        //                 '벙개',
        //                 style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),
        //               ),
        //               icon: SvgPicture.asset(
        //                 'assets/images/SVG/light.svg',
        //                 width: 23,
        //               ),
        //               activeIcon: SvgPicture.asset(
        //                 'assets/images/SVG/light_selected.svg',
        //                 width: 23,
        //               ),
        //             ),
        //             BottomNavigationBarItem(
        //               title: Text('클럽',
        //                   style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
        //               icon: SvgPicture.asset(
        //                 'assets/images/SVG/club.svg',
        //                 width: 23,
        //               ),
        //               activeIcon: SvgPicture.asset(
        //                 'assets/images/SVG/club_selected.svg',
        //                 width: 23,
        //               ),
        //             ),
        //             BottomNavigationBarItem(
        //               title: Text(
        //                 '중고장터',
        //                 style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),
        //               ),
        //               icon: SvgPicture.asset(
        //                 'assets/images/SVG/basket.svg',
        //                 width: 23,
        //               ),
        //               activeIcon: SvgPicture.asset(
        //                 'assets/images/SVG/basket_selected.svg',
        //                 width: 23,
        //               ),
        //             ),
        //             BottomNavigationBarItem(
        //               title: Text('더보기',
        //                   style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
        //               icon: SvgPicture.asset(
        //                 'assets/images/SVG/more.svg',
        //                 width: 23,
        //               ),
        //               activeIcon: SvgPicture.asset(
        //                 'assets/images/SVG/more_selected.svg',
        //                 width: 23,
        //               ),
        //             ),
        //           ],
        //         )
        //         )
        //         ),
      ),
    );
  }
}
