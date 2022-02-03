import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:date_format/date_format.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/market/Market_Click_Image.dart';

import 'Market_Click_Image.dart';
import 'Market_Chat_Room.dart';
import 'Market_Report_Page.dart';
import 'Market_Item_User_Report.dart';

class MarketItemInfo extends StatefulWidget {
  final String prev_nick_name;
  final String prev_title;
  final String prev_intro;
  final String prev_price;
  final String prev_datetime;
  final String prev_imageurl;
  final String prev_UserUID;
  final String prev_itemID;
  final List prev_test;
  final int prev_read_count;
  final int prev_report_count;
  final String prev_profile_image;

  const MarketItemInfo(
      {Key? key,
      required this.prev_nick_name,
      required this.prev_title,
      required this.prev_intro,
      required this.prev_price,
      required this.prev_datetime,
      required this.prev_imageurl,
      required this.prev_UserUID,
      required this.prev_itemID,
      required this.prev_test,
      required this.prev_read_count,
      required this.prev_report_count,
      required this.prev_profile_image})
      : super(key: key);

  @override
  _MarketItemInfoState createState() => _MarketItemInfoState(
      prev_nick_name,
      prev_title,
      prev_intro,
      prev_price,
      prev_datetime,
      prev_imageurl,
      prev_UserUID,
      prev_itemID,
      prev_test,
      prev_read_count,
      prev_report_count,
      prev_profile_image);
}

class _MarketItemInfoState extends State<MarketItemInfo> {
  int _selectedNaviIndex = 0;

  String nickname = "";
  String title = "";
  String intro = "";
  String price = "";
  String datetime = "";
  String image_url = "";
  String user_uid = "";
  String item_id = "";
  List test = [];
  String profile_image = "";

  int read_count;
  int report_count;

  bool check_item = false;

  User user = FirebaseAuth.instance.currentUser!;

  _MarketItemInfoState(
      this.nickname,
      this.title,
      this.intro,
      this.price,
      this.datetime,
      this.image_url,
      this.user_uid,
      this.item_id,
      this.test,
      this.read_count,
      this.report_count,
      this.profile_image);

  Future _get_item_info_doc() async {
    List buy_item_id = [];
    DocumentReference ref = FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection("BuyAndSell")
        .doc("BuyList");

    DocumentSnapshot result = await ref.get();

    for (int i = 0; i < result["BuyItem"].length; i++) {
      buy_item_id.add(result["BuyItem"][i]["ItemID"]);
    }

    for (int i = 0; i < buy_item_id.length; i++) {
      if (buy_item_id[i] == item_id) {
        setState(() {
          check_item = true;
        });
      }
    }

    if (user_uid != user.uid) {
      FirebaseFirestore.instance.collection('Market').doc(item_id).update({
        'readCount': FieldValue.increment(1),
      }).then((value) => print('ok'));
    }
  }

  void _showDeleteDialog(
      BuildContext context,
      String delete_item_id,
      String delete_item_datetime,
      String delete_item_imageurl,
      String delete_item_intro,
      String delete_item_price,
      String delete_item_title,
      String delete_item_nickname) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("게시글 삭제"),
          content: Text("게시글을 삭제하시겠습니까?"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("삭제하기"),
              onPressed: () async {
                try {
                  FirebaseFirestore.instance
                      .collection("Market")
                      .doc(item_id)
                      .delete();
                  DocumentReference ref = FirebaseFirestore.instance
                      .collection("Users")
                      .doc(user.uid)
                      .collection("BuyAndSell")
                      .doc("SellList");

                  DocumentSnapshot doc = await ref.get();

                  for (int i = 0; i < doc["SellItem"].length; i++) {
                    if (doc["SellItem"][i]["ItemID"] == delete_item_id) {
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(user.uid)
                          .collection("BuyAndSell")
                          .doc("SellList")
                          .update({
                        "SellItem": FieldValue.arrayRemove([
                          {
                            "DateTime": delete_item_datetime,
                            "ImageUrl": delete_item_imageurl,
                            "Intro": delete_item_intro,
                            "ItemID": delete_item_id,
                            "NickName": delete_item_nickname,
                            "Price": delete_item_price,
                            "Title": delete_item_title,
                            "UserUID": user.uid,
                          }
                        ])
                      });
                    }
                  }
                  Navigator.of(context)..pop()..pop();
                } catch (e) {}
              },
            ),
            ElevatedButton(
              child: Text("나가기"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _get_item_info_doc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserAccountInfo userAccount_ = Provider.of(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
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
        actions: [
          user_uid != user.uid
              ? TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MarketReport(
                        nickname: nickname,
                        uid: user_uid,
                        item_uid: item_id,
                      );
                    }));
                  },
                  child: Text(
                    "신고하기",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'GSANSM',
                        fontSize: 13.0),
                  ))
              : TextButton(
                  onPressed: () {
                    _showDeleteDialog(context, item_id, datetime, image_url,
                        intro, price, title, nickname);
                  },
                  child: Text(
                    "삭제하기",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'GSANSM',
                        fontSize: 13.0),
                  )),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return MarketClickImage(url: image_url);
                  }));
                },
                child: image_url != ""
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3.5,
                        // color: Theme.of(context).primaryColorLight,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          image: DecorationImage(
                              image: NetworkImage(
                                image_url,
                              ),
                              fit: BoxFit.fill),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3.5,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                        )),
                // child: Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height / 3.5,
                //   child: CachedNetworkImage(
                //     imageUrl: image_url,
                //     imageBuilder: (context, imageProvider) => Container(
                //       decoration: BoxDecoration(
                //         image: DecorationImage(
                //           image: imageProvider,
                //           fit: BoxFit.fill,
                //           // colorFilter: const ColorFilter.mode(
                //           //   Colors.red,
                //           //   BlendMode.colorBurn,
                //           // ),
                //         ),
                //       ),
                //     ),
                //     placeholder: (context, url) =>
                //         const CircularProgressIndicator(),
                //     errorWidget: (context, url, error) =>
                //         const Icon(Icons.error),
                //   ),
                // ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: GestureDetector(
                          onTap: () {
                            if (user_uid != user.uid) {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return MarketItemUserReport(
                                  prev_problem_user_uid: user_uid,
                                  prev_problem_user_nick_name: nickname,
                                );
                              }));
                            } else {
                              return;
                            }
                          },
                          child: profile_image == ''
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: SvgPicture.asset(
                                    'assets/images/SVG/profile_pink.svg',
                                    width: 40,
                                  ))
                              : CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 120,
                                  backgroundImage: NetworkImage(profile_image)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nickname,
                            // style: Theme.of(context).textTheme.subtitle1,
                            style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'GSANSM',
                                color: Theme.of(context).primaryColor),
                          ),
                          Text(
                            datetime,
                            style: Theme.of(context).textTheme.subtitle2,
                            // style: TextStyle(
                            //     fontSize: 11,
                            //     fontFamily: 'GSANSM',
                            //     color: Theme.of(context).primaryColor),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          report_count != 0
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                      Container(
                                        child: Text(
                                          '신고가 접수된 게시물입니다.',
                                          //style: Theme.of(context).textTheme.subtitle2,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'GSANSB',
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        child: Text(
                                          '신고 수 : ' + report_count.toString(),
                                          //style: Theme.of(context).textTheme.subtitle2,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'GSANSB',
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                    ])
                              : Container()
                        ]),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Divider(
                      thickness: 1.5, height: 1.5, color: Colors.grey[200])),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontFamily: 'GSANSB', fontSize: 16),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      intro,
                      style: TextStyle(fontFamily: 'GSANSM', fontSize: 13),
                    ),
                  ],
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
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            //backgroundColor: Colors.grey[300],
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: Theme.of(context).primaryColor,
            //selectedItemColor: Colors.grey[800],
            currentIndex: _selectedNaviIndex,
            onTap: (int index) {
              _selectedNaviIndex = index;
              setState(() {
                if (_selectedNaviIndex == 0) {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (BuildContext context) {
                  //   return FirstScreen();
                  // }));
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                title: Container(height: 0.0),
                icon: Container(),
              ),
              BottomNavigationBarItem(
                title: Container(height: 0.0),
                icon: Text(
                  price,
                  style: TextStyle(fontFamily: 'GSANSB', fontSize: 16),
                ),
              ),
              BottomNavigationBarItem(
                title: Container(height: 7.0),
                icon: Container(
                    width: 130,
                    height: 38,
                    child: user.uid == user_uid
                        ? ElevatedButton(
                            child: Text(
                              "채팅목록보기",
                              style: TextStyle(
                                fontFamily: 'GSANSB',
                                fontSize: 15,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Color(0xffe9394f),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 0),
                            onPressed: () {
                              print("채팅목록버튼");
                              Navigator.pop(context, 2);
                            },
                          )
                        : check_item
                            ? ElevatedButton(
                                child: Text(
                                  "채팅목록보기",
                                  style: TextStyle(
                                    fontFamily: 'GSANSB',
                                    fontSize: 15,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Color(0xffe9394f),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 0),
                                onPressed: () {
                                  print("채팅목록버튼");
                                  Navigator.pop(context, 2);
                                },
                              )
                            : ElevatedButton(
                                child: Text(
                                  "채팅시작하기",
                                  style: TextStyle(
                                    fontFamily: 'GSANSB',
                                    fontSize: 15,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Color(0xffe9394f),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 0),
                                onPressed: () {
                                  List chat_item_id = [];

                                  List buy_list = [];

                                  var docid = FirebaseFirestore.instance
                                      .collection("MarketChatRoom")
                                      .doc();

                                  FirebaseFirestore.instance
                                      .collection("MarketChatRoom")
                                      .doc(docid.id)
                                      .set({
                                    "NickName1": userAccount_.nickname,
                                    "NickName1UID": user.uid,
                                    "ImageUrl": image_url,
                                    // "UserNickNameList": [
                                    //   nickname,
                                    //   userAccount_.nickname_
                                    // ],
                                    "NickName2": nickname,
                                    "NickName2UID": user_uid,
                                    "DateTime": formatDate(DateTime.now(),
                                        [yyyy, ".", mm, '.', dd]),
                                    "ChatRoom": [],
                                    'OtherReport': []
                                  });

                                  buy_list = [
                                    {
                                      "DateTime": datetime,
                                      "ImageUrl": image_url,
                                      "Intro": intro,
                                      "ItemID": item_id,
                                      "NickName": nickname,
                                      "Price": price,
                                      "Title": title,
                                      "UserUID": user_uid,
                                      "profile_image": profile_image
                                    }
                                  ];

                                  chat_item_id.add(docid.id);

                                  ///
                                  /// 구매자 채팅 ID 업데이트
                                  ///
                                  FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(user.uid)
                                      .collection("TotalMarketChat")
                                      .doc("MarketChat")
                                      .update({
                                    "ItemID":
                                        FieldValue.arrayUnion(chat_item_id)
                                  });

                                  ///
                                  /// 판매자 채팅 ID 업데이트
                                  ///
                                  FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(user_uid)
                                      .collection("TotalMarketChat")
                                      .doc("MarketChat")
                                      .update({
                                    "ItemID":
                                        FieldValue.arrayUnion(chat_item_id)
                                  });

                                  ///
                                  /// 구매자 구매내역 리스트 업데이트
                                  ///
                                  FirebaseFirestore.instance
                                      .collection("Users")
                                      .doc(user.uid)
                                      .collection("BuyAndSell")
                                      .doc("BuyList")
                                      .update({
                                    "BuyItem": FieldValue.arrayUnion(buy_list),
                                  });

                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return MarketChatRoom(
                                      chat_path: docid.id,
                                      page_index: 1,
                                      sell_user_uid: user_uid,
                                      buy_user_uid: user.uid,
                                    );
                                  }));
                                },
                              )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
