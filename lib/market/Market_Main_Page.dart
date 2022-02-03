import 'dart:async';
import 'package:circular_menu/circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/first_screen_1_0.dart';
import 'package:snstennis/home.dart';
import 'package:snstennis/instant/instant_main.dart';
import 'Market_Chat_Room.dart';
import 'Market_Item_Info.dart';
import 'Market_Item_Post_Write.dart';
import 'Market_User_Buy_List.dart';
import 'Market_User_Sell_List.dart';

class MarketMainPage extends StatefulWidget {
  final List item_id;

  const MarketMainPage({Key? key, required this.item_id}) : super(key: key);

  @override
  _MarketMainPageState createState() => _MarketMainPageState(item_id);
}

class _MarketMainPageState extends State<MarketMainPage>
    with TickerProviderStateMixin {
  List Market_Item_ID_List = [];
  List data = [];
  late List chat_data = [];
  late List total_chat_id = [];
  int _selectedNaviIndex = 3;

  List test_total_chat_id = [];

  List total_image_list = [];

  User user = FirebaseAuth.instance.currentUser!;

  TextEditingController _controller = TextEditingController();

  List report_user_list = [];

  List block_id_list = [];

  _MarketMainPageState(
    this.Market_Item_ID_List,
  );

  Future _get_report_item_id() async {
    //report_user_list.clear();
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
    }
  }

  Future _getItem(List item_id) async {
    print("_getItem 호출함");
    // List image_list = [];
    data.clear();

    CollectionReference refMarket =
        FirebaseFirestore.instance.collection("Market");

    for (int i = 0; i < item_id.length; i++) {
      DocumentSnapshot snapitemshot = await refMarket.doc(item_id[i]).get();

      data.add(snapitemshot.data());
    }

    return data;
  }

  // Future _get_Block_ID_List() async {
  //   DocumentReference ref =
  //       FirebaseFirestore.instance.collection("Users").doc(user.uid);

  //   DocumentSnapshot snapshot = await ref.get();

  //   // for(int i = 0; i < snapshot["BlockUserIDList"].length; i++){
  //   //   block_id_list.addAll()
  //   // }
  //   block_id_list.addAll(snapshot["BlockUserIDList"]);
  // }

  ///
  /// 중고마켓 채팅 Path 삭제 함수
  ///
  void _showDiaglog_Market_Delete_Chat(String chat_path) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("채팅방 삭제"),
              content: Text(
                "채팅방을 삭제하시겠습니까?",
                style: TextStyle(fontFamily: "GSANSM"),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(user.uid)
                              .collection("TotalMarketChat")
                              .doc("MarketChat")
                              .update({
                            "ItemID": FieldValue.arrayRemove([chat_path])
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "삭제",
                          style: TextStyle(
                              fontFamily: 'GSANSM',
                              fontSize: 14,
                              color: Colors.white),
                        )),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)..pop();
                        },
                        child: Text(
                          "취소",
                          style: TextStyle(
                              fontFamily: 'GSANSM',
                              fontSize: 14,
                              color: Colors.white),
                        )),
                  ],
                ),
              ]);
        });
  }

  Widget _market_Chat_Room() {
    UserAccountInfo userAccount_ = Provider.of(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(user.uid)
                    .collection("TotalMarketChat")
                    .doc("MarketChat")
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error!");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container();
                  } else {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    List chat_id_list = [];

                    if (data["ItemID"].length != 0) {
                      for (int i = 0; i < data["ItemID"].length; i++) {
                        chat_id_list.add(data["ItemID"][i]);
                        print("chat_id_list 값 : " + chat_id_list[i]);
                      }

                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("MarketChatRoom")
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshots) {
                            if (snapshots.hasError) {
                              return Text("Error!");
                            } else if (snapshots.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            } else {
                              var datas = snapshots.data!.docs;

                              List nick_name_list = [];
                              List change_nick_name_list = [];
                              List doc_chat_path = [];
                              List last_comment = [];
                              List image_url_list = [];

                              List buy_user_uid_list = [];
                              List sell_user_uid_list = [];

                              List check_report_list = [];

                              List other_report = [];
                              List report_state = [];

                              for (int i = 0; i < datas.length; i++) {
                                for (int j = 0; j < chat_id_list.length; j++) {
                                  if (datas[i].id == chat_id_list[j]) {
                                    Map<String, dynamic> data123 =
                                        datas[i].data() as Map<String, dynamic>;
                                    nick_name_list.add(data123["NickName1"]);
                                    change_nick_name_list
                                        .add(data123["NickName2"]);
                                    image_url_list.add(data123["ImageUrl"]);
                                    buy_user_uid_list
                                        .add(data123["NickName1UID"]);
                                    sell_user_uid_list
                                        .add(data123["NickName2UID"]);
                                    if (data123["ChatRoom"].length > 0) {
                                      last_comment.add(data123["ChatRoom"]
                                              [data123["ChatRoom"].length - 1]
                                          ["Comment"]);
                                    } else {
                                      last_comment.add("");
                                    }
                                    doc_chat_path.add(datas[i].id);
                                    other_report.add(data123['OtherReport']);
                                  }
                                }
                              }

                              bool temp = false;
                              if (other_report.length != 0) {
                                for (int i = 0; i < other_report.length; i++) {
                                  if (other_report[i].length != 0) {
                                    other_report[i].forEach((element) {
                                      if (userAccount_.uid == element) {
                                        temp = true;
                                      }
                                    });
                                    report_state.add(temp);
                                    temp = false;
                                  } else {
                                    report_state.add(false);
                                  }
                                }
                              } else {}

                              // if(other_report.length != 0) {
                              //   for(int i = 0; i < other_report.length; i++) {
                              //     if(other_report[i].length != 0) {
                              //       for(int j = 0; j < other_report[i].length; j++) {
                              //         if(other_report[i][j] == userAccount_.uid)
                              //         {
                              //           report_state.add(true);
                              //           break;
                              //         } else {
                              //           //report_state.add(false);
                              //           break;
                              //         }
                              //       }
                              //     } else {
                              //       report_state.add(false);
                              //     }

                              //   }
                              // } else {

                              // }

                              return Expanded(
                                child: ListView.separated(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: GestureDetector(
                                          onLongPress: () {
                                            _showDiaglog_Market_Delete_Chat(
                                                doc_chat_path[index]);
                                          },
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return MarketChatRoom(
                                                  chat_path:
                                                      doc_chat_path[index],
                                                  page_index: 0,
                                                  sell_user_uid:
                                                      sell_user_uid_list[index],
                                                  buy_user_uid:
                                                      buy_user_uid_list[index]);
                                            }));
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 15, 0, 15),
                                                child: ListTile(
                                                  trailing: SizedBox(
                                                    height: 120,
                                                    width: 100,
                                                    child: image_url_list[
                                                                index] !=
                                                            ""
                                                        ? CachedNetworkImage(
                                                            imageUrl:
                                                                image_url_list[
                                                                    index],
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                            ),
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(
                                                              width: 100,
                                                              height: 100,
                                                              // color: Colors.purple,
                                                              child: Image.asset(
                                                                  "assets/images/GIF/Rolling_295px.gif"),
                                                            ),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          )
                                                        : Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                  ),
                                                  // leading: Container(
                                                  //   width: 40,
                                                  //   height: 40,
                                                  //   child: ClipRRect(
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(
                                                  //             40),
                                                  //     child: Image.network(
                                                  //       'https://www.edmundsgovtech.com/wp-content/uploads/2020/01/default-picture_0_0.png',
                                                  //       fit: BoxFit.cover,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  title: Column(
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              nick_name_list[
                                                                          index] ==
                                                                      userAccount_
                                                                          .nickname
                                                                  ? change_nick_name_list[
                                                                      index]
                                                                  : nick_name_list[
                                                                      index],
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xff58585b),
                                                                  fontFamily:
                                                                      'GSANSB',
                                                                  fontSize: 16),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            report_state[
                                                                        index] ==
                                                                    true
                                                                ? Text(
                                                                    "신고한 사용자",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontFamily:
                                                                            'GSANSB',
                                                                        fontSize:
                                                                            10),
                                                                  )
                                                                : Container()
                                                          ]),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            last_comment[index],
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff58585b),
                                                                fontFamily:
                                                                    'GSANSM',
                                                                fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        height: 1.5,
                                        color: Colors.grey[200],
                                      );
                                    },
                                    itemCount: nick_name_list.length),
                              );
                            }
                          });
                    } else {
                      return Container(child: Text('\n채팅방이 없습니다.'));
                    }
                  }
                })
          ],
        )),
      ),
    );
  }

  // Widget _market_Chat_Room() {
  //   UserAccountInfo userAccount_ = Provider.of(context, listen: false);
  //   // report_user_list.clear();
  //   // _get_report_item_id();
  //   return Container(
  //     height: MediaQuery.of(context).size.height / 1.4,
  //     width: MediaQuery.of(context).size.width,
  //     child: Scaffold(
  //       backgroundColor: Colors.white,
  //       body: Container(
  //           child: Column(
  //         children: [
  //           StreamBuilder(
  //               stream: FirebaseFirestore.instance
  //                   .collection("Users")
  //                   .doc(user.uid)
  //                   .collection("TotalMarketChat")
  //                   .doc("MarketChat")
  //                   .snapshots(),
  //               builder: (BuildContext context, AsyncSnapshot snapshot) {
  //                 if (snapshot.hasError) {
  //                   return Text("Error!");
  //                 } else if (snapshot.connectionState == ConnectionState.waiting) {
  //                   return Container();
  //                 } else {
  //                   Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
  //                   List chat_id_list = [];

  //                   if (data["ItemID"].length != 0) {
  //                     for (int i = 0; i < data["ItemID"].length; i++) {
  //                       chat_id_list.add(data["ItemID"][i]);
  //                       print("chat_id_list 값 : " + chat_id_list[i]);
  //                     }

  //                     return StreamBuilder(
  //                         stream: FirebaseFirestore.instance
  //                             .collection("MarketChatRoom")
  //                             .snapshots(),
  //                         builder:
  //                             (BuildContext context, AsyncSnapshot snapshots) {
  //                           if (snapshots.hasError) {
  //                             return Text("Error!");
  //                           } else if (snapshots.connectionState == ConnectionState.waiting) {
  //                             return Container();
  //                           } else {
  //                             var datas = snapshots.data!.docs;

  //                             List nick_name_list = [];
  //                             List change_nick_name_list = [];
  //                             List doc_chat_path = [];
  //                             List last_comment = [];
  //                             List image_url_list = [];

  //                             List buy_user_uid_list = [];
  //                             List sell_user_uid_list = [];

  //                             List check_report_list = [];

  //                             for (int i = 0; i < datas.length; i++) {
  //                               for (int j = 0; j < chat_id_list.length; j++) {
  //                                 if (datas[i].id == chat_id_list[j]) {
  //                                   Map<String, dynamic> data123 = datas[i].data() as Map<String, dynamic>;
  //                                   nick_name_list.add(data123["NickName1"]);
  //                                   change_nick_name_list.add(data123["NickName2"]);
  //                                   image_url_list.add(data123["ImageUrl"]);
  //                                   buy_user_uid_list.add(data123["NickName1UID"]);
  //                                   sell_user_uid_list.add(data123["NickName2UID"]);
  //                                   if (data123["ChatRoom"].length > 0) {
  //                                     last_comment.add(data123["ChatRoom"][data123["ChatRoom"].length - 1]["Comment"]);
  //                                   } else {
  //                                     last_comment.add("");
  //                                   }
  //                                   doc_chat_path.add(datas[i].id);
  //                                 }
  //                               }
  //                             }

  //                             // if(report_user_list.length != 0) {
  //                             //   bool isReport = false;
  //                             //   for(int i = 0; i < datas.length; i++) {
  //                             //     isReport = false;
  //                             //     Map<String, dynamic> data123 = datas[i].data() as Map<String, dynamic>;
  //                             //     for(int j = 0; j < report_user_list.length; j++) {
  //                             //       if(report_user_list[j] == data123['NickName1UID']) {
  //                             //         isReport = true;
  //                             //       }
  //                             //       if(report_user_list[j] == data123['NickName2UID']) {
  //                             //         isReport = true;
  //                             //       }
  //                             //     }
  //                             //     check_report_list.add(isReport);
  //                             //   }
  //                             //   //report_user_list.clear();
  //                             // }
  //                             return Expanded(
  //                               child: ListView.separated(
  //                                   itemBuilder:
  //                                       (BuildContext context, int index) {
  //                                     return Container(
  //                                       width:
  //                                           MediaQuery.of(context).size.width,
  //                                       height: 100,
  //                                       decoration: BoxDecoration(
  //                                           color: Colors.white,
  //                                           borderRadius:
  //                                               BorderRadius.circular(5)),
  //                                       child: GestureDetector(
  //                                         onTap: () {
  //                                           Navigator.push(context,
  //                                               MaterialPageRoute(builder:
  //                                                   (BuildContext context) {
  //                                             return MarketChatRoom(
  //                                               chat_path: doc_chat_path[index],
  //                                               page_index: 0,
  //                                               sell_user_uid:
  //                                                   sell_user_uid_list[index], buy_user_uid: buy_user_uid_list[index]
  //                                             );
  //                                           }));
  //                                         },
  //                                         child: Column(
  //                                           children: [
  //                                             Padding(
  //                                               padding: EdgeInsets.fromLTRB(
  //                                                   0, 15, 0, 15),
  //                                               child: ListTile(
  //                                                 trailing: SizedBox(
  //                                                   height: 120,
  //                                                   width: 100,
  //                                                   // child: Container(
  //                                                   //   decoration: BoxDecoration(
  //                                                   //       color: Colors.grey,
  //                                                   //       borderRadius:
  //                                                   //           BorderRadius
  //                                                   //               .circular(5),
  //                                                   //       image:
  //                                                   //           DecorationImage(
  //                                                   //               image:
  //                                                   //                   NetworkImage(
  //                                                   //                 image_url_list[
  //                                                   //                     index],
  //                                                   //               ),
  //                                                   //               fit: BoxFit
  //                                                   //                   .fill)),
  //                                                   // ),
  //                                                   child: image_url_list[
  //                                                               index] !=
  //                                                           ""
  //                                                       ? CachedNetworkImage(
  //                                                           imageUrl:
  //                                                               image_url_list[
  //                                                                   index],
  //                                                           imageBuilder: (context,
  //                                                                   imageProvider) =>
  //                                                               Container(
  //                                                             decoration:
  //                                                                 BoxDecoration(
  //                                                               image:
  //                                                                   DecorationImage(
  //                                                                 image:
  //                                                                     imageProvider,
  //                                                                 fit: BoxFit
  //                                                                     .fill,
  //                                                                 // colorFilter: const ColorFilter.mode(
  //                                                                 //   Colors.red,
  //                                                                 //   BlendMode.colorBurn,
  //                                                                 // ),
  //                                                               ),
  //                                                             ),
  //                                                           ),
  //                                                           placeholder:
  //                                                               (context,
  //                                                                       url) =>
  //                                                                   Container(
  //                                                             width: 100,
  //                                                             height: 100,
  //                                                             // color: Colors.purple,
  //                                                             child: Image.asset(
  //                                                                 "assets/images/GIF/Rolling_295px.gif"),
  //                                                           ),
  //                                                           errorWidget: (context,
  //                                                                   url,
  //                                                                   error) =>
  //                                                               const Icon(Icons
  //                                                                   .error),
  //                                                         )
  //                                                       : Container(
  //                                                           decoration:
  //                                                               BoxDecoration(
  //                                                             color:
  //                                                                 Colors.grey,
  //                                                             borderRadius:
  //                                                                 BorderRadius
  //                                                                     .circular(
  //                                                                         5),
  //                                                           ),
  //                                                         ),
  //                                                 ),
  //                                                 // leading: Container(
  //                                                 //   width: 40,
  //                                                 //   height: 40,
  //                                                 //   child: ClipRRect(
  //                                                 //     borderRadius:
  //                                                 //         BorderRadius.circular(
  //                                                 //             40),
  //                                                 //     child: Image.network(
  //                                                 //       'https://www.edmundsgovtech.com/wp-content/uploads/2020/01/default-picture_0_0.png',
  //                                                 //       fit: BoxFit.cover,
  //                                                 //     ),
  //                                                 //   ),
  //                                                 // ),
  //                                                 title: Column(
  //                                                   children: [
  //                                                     Row(children: [
  //                                                       Text(
  //                                                         nick_name_list[index] == userAccount_.nickname
  //                                                             ? change_nick_name_list[index]
  //                                                             : nick_name_list[index],
  //                                                         style: TextStyle(
  //                                                             color: Color(0xff58585b),
  //                                                             fontFamily:'GSANSB',
  //                                                             fontSize: 16),
  //                                                       ),
  //                                                       SizedBox(
  //                                                         width: 5,
  //                                                       ),
  //                                                     check_report_list.length != 0 ?
  //                                                       check_report_list[index] == true ?
  //                                                       Text("신고한 사용자", style: TextStyle(
  //                                                         color: Colors.red,
  //                                                         fontFamily:'GSANSB',
  //                                                         fontSize:10),
  //                                                       )
  //                                                       : Container()
  //                                                     : Container(),
  //                                                     ]),
  //                                                     SizedBox(
  //                                                       height: 15,
  //                                                     ),
  //                                                     Row(
  //                                                       children: [
  //                                                         Text(
  //                                                           last_comment[index],
  //                                                           style: TextStyle(
  //                                                               color: Color(
  //                                                                   0xff58585b),
  //                                                               fontFamily:
  //                                                                   'GSANSM',
  //                                                               fontSize: 14),
  //                                                         ),
  //                                                       ],
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                     );
  //                                   },
  //                                   separatorBuilder:
  //                                       (BuildContext context, int index) {
  //                                     return Container(
  //                                       height: 1.5,
  //                                       color: Colors.grey[200],
  //                                     );
  //                                   },
  //                                   itemCount: nick_name_list.length),
  //                             );
  //                           }
  //                         });
  //                   } else {
  //                     return Container(child: Text('\n채팅방이 없습니다.'));
  //                   }
  //                 }
  //               })
  //         ],
  //       )),
  //     ),
  //   );
  // }

  // Widget _market_Chat_Room() {
  //   UserAccountInfo userAccount_ = Provider.of(context, listen: false);
  //   return Expanded(
  //     child: Container(
  //       color: Colors.blueGrey,
  //       //height: MediaQuery.of(context).size.height / 1.4,
  //       width: MediaQuery.of(context).size.width,
  //       child: Scaffold(
  //         backgroundColor: Colors.white,
  //         body: Container(
  //           //color: Colors.amberAccent,
  //             child: Column(
  //           children: [
  //             StreamBuilder(
  //                 stream: FirebaseFirestore.instance
  //                     .collection("Users")
  //                     .doc(user.uid)
  //                     .collection("TotalMarketChat")
  //                     .doc("MarketChat")
  //                     .snapshots(),
  //                 builder: (BuildContext context, AsyncSnapshot snapshot) {
  //                   if (snapshot.hasError) {
  //                     return Text("Error!");
  //                   } else if (snapshot.connectionState == ConnectionState.waiting) {
  //                     return Container();
  //                   } else {
  //                     Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
  //                     List chat_id_list = [];

  //                     if (data["ItemID"].length != 0) {
  //                       for (int i = 0; i < data["ItemID"].length; i++) {
  //                         chat_id_list.add(data["ItemID"][i]);
  //                         print("chat_id_list 값 : " + chat_id_list[i]);
  //                       }

  //                       return StreamBuilder(
  //                           stream: FirebaseFirestore.instance
  //                               .collection("MarketChatRoom")
  //                               .snapshots(),
  //                           builder:
  //                               (BuildContext context, AsyncSnapshot snapshots) {
  //                             if (snapshots.hasError) {
  //                               return Text("Error!");
  //                             } else if (snapshots.connectionState == ConnectionState.waiting) {
  //                               return Container();
  //                             } else {
  //                               var datas = snapshots.data!.docs;

  //                               List nick_name_list = [];
  //                               List change_nick_name_list = [];
  //                               List doc_chat_path = [];
  //                               List last_comment = [];
  //                               List image_url_list = [];
  //                               List sell_user_uid_list = [];

  //                               for (int i = 0; i < datas.length; i++) {
  //                                 for (int j = 0; j < chat_id_list.length; j++) {
  //                                   if (datas[i].id == chat_id_list[j]) {
  //                                     Map<String, dynamic> data123 = datas[i].data() as Map<String, dynamic>;
  //                                     nick_name_list.add(data123["NickName1"]);
  //                                     change_nick_name_list .add(data123["NickName2"]);
  //                                     image_url_list.add(data123["ImageUrl"]);
  //                                     sell_user_uid_list.add(data123["NickName2UID"]);
  //                                     if (data123["ChatRoom"].length > 0) {
  //                                       last_comment.add(data123["ChatRoom"][data123["ChatRoom"].length - 1]["Comment"]);
  //                                     } else {
  //                                       last_comment.add("");
  //                                     }
  //                                     doc_chat_path.add(datas[i].id);
  //                                   }
  //                                 }
  //                               }

  //                               return Expanded(
  //                                 child: ListView.separated(
  //                                     itemBuilder:
  //                                         (BuildContext context, int index) {
  //                                       return Container(
  //                                         width:
  //                                             MediaQuery.of(context).size.width,
  //                                         height: 100,
  //                                         decoration: BoxDecoration(
  //                                             color: Colors.white,
  //                                             borderRadius:
  //                                                 BorderRadius.circular(5)),
  //                                         child: GestureDetector(
  //                                           onTap: () {
  //                                             Navigator.push(context,
  //                                                 MaterialPageRoute(builder:
  //                                                     (BuildContext context) {
  //                                               return MarketChatRoom(
  //                                                 chat_path: doc_chat_path[index],
  //                                                 page_index: 0, sell_user_uid: sell_user_uid_list[index],
  //                                               );
  //                                             }));
  //                                           },
  //                                           child: Column(
  //                                             children: [
  //                                               Padding(
  //                                                 padding: EdgeInsets.fromLTRB(
  //                                                     0, 15, 0, 15),
  //                                                 child: ListTile(
  //                                                   trailing: SizedBox(
  //                                                     height: 120,
  //                                                     width: 100,
  //                                                     // child: Container(
  //                                                     //   decoration: BoxDecoration(
  //                                                     //       color: Colors.grey,
  //                                                     //       borderRadius:
  //                                                     //           BorderRadius
  //                                                     //               .circular(5),
  //                                                     //       image:
  //                                                     //           DecorationImage(
  //                                                     //               image:
  //                                                     //                   NetworkImage(
  //                                                     //                 image_url_list[
  //                                                     //                     index],
  //                                                     //               ),
  //                                                     //               fit: BoxFit
  //                                                     //                   .fill)),
  //                                                     // ),
  //                                                     child: image_url_list[
  //                                                                 index] !=
  //                                                             ""
  //                                                         ? CachedNetworkImage(
  //                                                             imageUrl:
  //                                                                 image_url_list[
  //                                                                     index],
  //                                                             imageBuilder: (context,
  //                                                                     imageProvider) =>
  //                                                                 Container(
  //                                                               decoration:
  //                                                                   BoxDecoration(
  //                                                                 image:
  //                                                                     DecorationImage(
  //                                                                   image:
  //                                                                       imageProvider,
  //                                                                   fit: BoxFit
  //                                                                       .fill,
  //                                                                   // colorFilter: const ColorFilter.mode(
  //                                                                   //   Colors.red,
  //                                                                   //   BlendMode.colorBurn,
  //                                                                   // ),
  //                                                                 ),
  //                                                               ),
  //                                                             ),
  //                                                             placeholder: (context,
  //                                                                     url) =>
  //                                                                 const CircularProgressIndicator(
  //                                                               strokeWidth: 1.0,
  //                                                             ),
  //                                                             errorWidget: (context,
  //                                                                     url,
  //                                                                     error) =>
  //                                                                 const Icon(Icons
  //                                                                     .error),
  //                                                           )
  //                                                         : Container(
  //                                                             decoration:
  //                                                                 BoxDecoration(
  //                                                               color:
  //                                                                   Colors.grey,
  //                                                               borderRadius:
  //                                                                   BorderRadius
  //                                                                       .circular(
  //                                                                           5),
  //                                                             ),
  //                                                           ),
  //                                                   ),
  //                                                   leading: Container(
  //                                                     width: 40,
  //                                                     height: 40,
  //                                                     child: ClipRRect(
  //                                                       borderRadius:
  //                                                           BorderRadius.circular(
  //                                                               40),
  //                                                       child: Image.network(
  //                                                         'https://www.edmundsgovtech.com/wp-content/uploads/2020/01/default-picture_0_0.png',
  //                                                         fit: BoxFit.cover,
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                   title: Column(
  //                                                     children: [
  //                                                       Row(children: [
  //                                                         Text(
  //                                                           nick_name_list[
  //                                                                       index] ==
  //                                                                   userAccount_
  //                                                                       .nickname
  //                                                               ? change_nick_name_list[
  //                                                                   index]
  //                                                               : nick_name_list[
  //                                                                   index],
  //                                                           style: TextStyle(
  //                                                               color: Color(
  //                                                                   0xff58585b),
  //                                                               fontFamily:
  //                                                                   'GSANSB',
  //                                                               fontSize: 16),
  //                                                         ),
  //                                                       ]),
  //                                                       SizedBox(
  //                                                         height: 15,
  //                                                       ),
  //                                                       Row(
  //                                                         children: [
  //                                                           Text(
  //                                                             last_comment[index],
  //                                                             style: TextStyle(
  //                                                                 color: Color(
  //                                                                     0xff58585b),
  //                                                                 fontFamily:
  //                                                                     'GSANSM',
  //                                                                 fontSize: 14),
  //                                                           ),
  //                                                         ],
  //                                                       ),
  //                                                     ],
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       );
  //                                     },
  //                                     separatorBuilder:
  //                                         (BuildContext context, int index) {
  //                                       return Container(
  //                                         height: 1.5,
  //                                         color: Colors.grey[200],
  //                                       );
  //                                     },
  //                                     itemCount: nick_name_list.length),
  //                               );
  //                             }
  //                           });
  //                     } else {
  //                       return Container(child: Text('\n채팅방이 없습니다.'));
  //                     }
  //                   }
  //                 })
  //           ],
  //         )),
  //       ),
  //     ),
  //   );
  // }

  // Widget _total_Market_Item() {
  //   List test = [];
  //   // test.addAll(Market_Item_ID_List);

  //   for (int i = 0; i < Market_Item_ID_List.length; i++) {
  //     test.add(Market_Item_ID_List[i]);
  //   }
  //   Market_Item_ID_List.clear();
  //   return Container(
  //     height: MediaQuery.of(context).size.height / 1.4,
  //     child: FutureBuilder(
  //         future: _getItem(test),
  //         builder: (BuildContext context, AsyncSnapshot snapshot) {
  //           if (snapshot.hasData == false) {
  //             return Container();
  //           } else if (snapshot.hasError) {
  //             return Text("에러에러");
  //           } else if (snapshot.connectionState == ConnectionState.waiting) {
  //             return Container();
  //           } else {
  //             List item_title = [];
  //             List item_intro = [];
  //             List item_price = [];
  //             List item_datetime = [];
  //             List item_nick_name = [];
  //             List item_user_uid = [];
  //             List item_image_url = [];

  //             for (int i = 0; i < data.length; i++) {
  //               item_title.add(data[i]["Title"]);
  //               item_intro.add(data[i]["Intro"]);
  //               item_price.add(data[i]["Price"]);
  //               item_datetime.add(data[i]["DateTime"]);
  //               item_nick_name.add(data[i]["NickName"]);
  //               item_user_uid.add(data[i]["UserUID"]);
  //               for (int j = 0; j < data[i]["ImageUrl"].length; i++) {
  //                 item_image_url.add(data[i]["ImageUrl"][j]);
  //               }
  //             }

  //             return ListView.separated(
  //                 itemBuilder: (BuildContext context, int index) {
  //                   return Container(
  //                     width: MediaQuery.of(context).size.width,
  //                     height: 150,
  //                     decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(5)),
  //                     child: GestureDetector(
  //                       onTap: () async {
  //                         // Navigator.push(context, MaterialPageRoute(
  //                         //     builder: (BuildContext context) {
  //                         //   return MarketItemInfo(
  //                         //     prev_intro: item_intro[index],
  //                         //     prev_nick_name: item_nick_name[index],
  //                         //     prev_price: item_price[index],
  //                         //     prev_title: item_title[index],
  //                         //     prev_datetime: item_datetime[index],
  //                         //     prev_imageurl: "",
  //                         //     prev_UserUID: item_user_uid[index],
  //                         //   );
  //                         // }));
  //                         final recive = await Navigator.push(context,
  //                             MaterialPageRoute(
  //                                 builder: (BuildContext context) {
  //                           return MarketItemInfo(
  //                             prev_intro: item_intro[index],
  //                             prev_nick_name: item_nick_name[index],
  //                             prev_price: item_price[index],
  //                             prev_title: item_title[index],
  //                             prev_datetime: item_datetime[index],
  //                             prev_imageurl: item_image_url,
  //                             prev_UserUID: item_user_uid[index],
  //                             prev_itemID: '',
  //                           );
  //                         }));
  //                         setState(() {
  //                           if (recive == 2) {
  //                             _tabController.index = 2;
  //                           }
  //                         });
  //                       },
  //                       child: Column(
  //                         // crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Padding(
  //                             padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
  //                             child: ListTile(
  //                               leading: SizedBox(
  //                                 height: 120,
  //                                 width: 100,
  //                                 child: Container(
  //                                   decoration: BoxDecoration(
  //                                       color: Colors.grey,
  //                                       borderRadius: BorderRadius.circular(5)),
  //                                 ),
  //                               ),
  //                               title: Column(
  //                                 children: [
  //                                   Row(children: [
  //                                     Text(
  //                                       item_title[index],
  //                                       style: TextStyle(
  //                                           color: Color(0xff58585b),
  //                                           fontFamily: 'GSANSM',
  //                                           fontSize: 14),
  //                                     ),
  //                                   ]),
  //                                   SizedBox(
  //                                     height: 10.0,
  //                                   ),
  //                                   Row(children: [
  //                                     Text(
  //                                       item_datetime[index],
  //                                       style: TextStyle(
  //                                           color: Colors.grey[400],
  //                                           fontFamily: 'GSANSM',
  //                                           fontSize: 12),
  //                                     ),
  //                                   ]),
  //                                   SizedBox(
  //                                     height: 10.0,
  //                                   ),
  //                                   Row(children: [
  //                                     Text(
  //                                       item_price[index],
  //                                       style: TextStyle(
  //                                           color: Colors.grey[400],
  //                                           fontFamily: 'GSANSB',
  //                                           fontSize: 13),
  //                                     ),
  //                                   ]),
  //                                 ],
  //                               ),
  //                               // subtitle: Text(
  //                               //   b[index],
  //                               //   style: TextStyle(
  //                               //       color: Color(0xff9f9f9f),
  //                               //       fontFamily: 'GSANSM',
  //                               //       fontSize: 12.0),
  //                               // ),
  //                               // trailing: Padding(
  //                               //   padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
  //                               //   child: Text(
  //                               //     item_price[index],
  //                               //     style: TextStyle(
  //                               //         color: Color(0xff9f9f9f),
  //                               //         fontFamily: 'GSANSM',
  //                               //         fontSize: 12.0),
  //                               //   ),
  //                               // ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     // child: GestureDetector(
  //                     //   onTap: () {},
  //                     //   child: Padding(
  //                     //     padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
  //                     //     child: Row(
  //                     //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     //       children: [
  //                     //         Text(
  //                     //           item_title[index],
  //                     //           style: TextStyle(
  //                     //               fontFamily: 'GSANSM',
  //                     //               color: Color(0xff58585b),
  //                     //               fontSize: 14),
  //                     //         ),
  //                     //         Text(item_intro[index],
  //                     //             style: TextStyle(
  //                     //                 fontFamily: 'GSANSM',
  //                     //                 color: Color(0xff58585b),
  //                     //                 fontSize: 14)),
  //                     //         Text(
  //                     //           item_price[index],
  //                     //           style: TextStyle(
  //                     //               fontFamily: 'GSANSM',
  //                     //               color: Color(0xff9f9f9f),
  //                     //               fontSize: 12),
  //                     //         ),
  //                     //       ],
  //                     //     ),
  //                     //   ),
  //                     // )
  //                   );
  //                 },
  //                 separatorBuilder: (BuildContext context, int index) {
  //                   return Container(
  //                     height: 1.5,
  //                     color: Colors.grey[200],
  //                   );
  //                 },
  //                 itemCount: item_title.length);
  //           }
  //         }),
  //   );
  // }

  Widget _total_Market_Item_another() {
    data.clear();
    return Container(
      height: MediaQuery.of(context).size.height / 1.4,
      child: FutureBuilder(
          future: FirebaseFirestore.instance.collection("Market").get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData == false) {
              return Container();
            } else if (snapshot.hasError) {
              return Text("에러");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else {
              List total_item_data = [];

              for (int i = 0; i < snapshot.data.docs.length; i++) {
                total_item_data.add(snapshot.data.docs[i].id);
              }
              data.clear();
              return FutureBuilder(
                  future: _getItem(total_item_data),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData == false) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Text("에러에러");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container();
                    } else {
                      List item_title = [];
                      List item_intro = [];
                      List item_price = [];
                      List item_datetime = [];
                      List item_nick_name = [];
                      List item_user_uid = [];
                      List item_image_url = [];
                      List item_id = [];
                      List item_read_count = [];
                      List item_report_count = [];

                      // for (int i = 0; i < data.length; i++) {
                      //   item_title.add(data[i]["Title"]);
                      //   item_intro.add(data[i]["Intro"]);
                      //   item_price.add(data[i]["Price"]);
                      //   item_datetime.add(data[i]["DateTime"]);
                      //   item_nick_name.add(data[i]["NickName"]);
                      //   item_user_uid.add(data[i]["UserUID"]);
                      //   item_id.add(data[i]["ItemID"]);
                      //   for (int j = 0; j < data[i]["ImageUrl"].length; j++) {
                      //     item_image_url.add(data[i]["ImageUrl"][j]);
                      //   }
                      // }

                      for (int i = 0; i < data.length; i++) {
                        item_title.add(data[i]["Title"]);
                        item_intro.add(data[i]["Intro"]);
                        item_price.add(data[i]["Price"]);
                        item_datetime.add(data[i]["DateTime"]);
                        item_nick_name.add(data[i]["NickName"]);
                        item_user_uid.add(data[i]["UserUID"]);
                        item_id.add(data[i]["ItemID"]);
                        item_image_url.add(data[i]["ImageUrl"]);
                        item_read_count.add(data[i]["readCount"]);
                        item_report_count.add(data[i]["reportCount"]);
                        // for (int j = 0; j < data[i]["ImageUrl"].length; j++) {
                        //   test.add({i: data[i]["ImageUrl"][j]});
                        // }
                      }

                      return ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: GestureDetector(
                                onTap: () async {
                                  // Navigator.push(context, MaterialPageRoute(
                                  //     builder: (BuildContext context) {
                                  //   return MarketItemInfo(
                                  //     prev_intro: item_intro[index],
                                  //     prev_nick_name: item_nick_name[index],
                                  //     prev_price: item_price[index],
                                  //     prev_title: item_title[index],
                                  //     prev_datetime: item_datetime[index],
                                  //     prev_imageurl: "",
                                  //     prev_UserUID: item_user_uid[index],
                                  //   );
                                  // }));
                                  final recive = await Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return MarketItemInfo(
                                      prev_intro: item_intro[index],
                                      prev_nick_name: item_nick_name[index],
                                      prev_price: item_price[index],
                                      prev_title: item_title[index],
                                      prev_datetime: item_datetime[index],
                                      prev_imageurl: item_image_url[index],
                                      prev_UserUID: item_user_uid[index],
                                      prev_itemID: item_id[index],
                                      prev_test: [""],
                                      prev_read_count: item_read_count[index],
                                      prev_report_count:
                                          item_report_count[index],
                                      prev_profile_image: '',
                                    );
                                  }));
                                  setState(() {
                                    if (recive == 2) {
                                      _tabController.index = 2;
                                    }
                                  });
                                },
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 0, 15),
                                      child: ListTile(
                                        leading: SizedBox(
                                          height: 120,
                                          width: 100,
                                          // child: Container(
                                          //   decoration: BoxDecoration(
                                          //       color: Colors.grey,
                                          //       borderRadius:
                                          //           BorderRadius.circular(5),
                                          //       image: DecorationImage(
                                          //           image: NetworkImage(

                                          //               item_image_url[index]),
                                          //           fit: BoxFit.fill)
                                          //           ),
                                          //   child: CachedNetworkImage(
                                          //     imageUrl: item_image_url[index],
                                          //     placeholder: (context, url) =>
                                          //         const CircularProgressIndicator(
                                          //       strokeWidth: 1.0,

                                          //     ),

                                          //   ),
                                          // ),
                                          child: item_image_url[index] != ""
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      item_image_url[index],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fill,
                                                        // colorFilter: const ColorFilter.mode(
                                                        //   Colors.red,
                                                        //   BlendMode.colorBurn,
                                                        // ),
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(
                                                    strokeWidth: 1.0,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                        ),
                                        // leading: ExtendedImage.network(
                                        //     total_image_list[index],
                                        //     width: 200,
                                        //     height: 200,
                                        //     fit: BoxFit.fill,
                                        //     cache: true,
                                        //     border: Border.all(
                                        //         color: Colors.red, width: 1.0),
                                        //     shape: BoxShape.circle,
                                        //     borderRadius: BorderRadius.all(
                                        //         Radius.circular(30.0))),
                                        title: Column(
                                          children: [
                                            Row(children: [
                                              Text(
                                                item_title[index],
                                                style: TextStyle(
                                                    color: Color(0xff58585b),
                                                    fontFamily: 'GSANSM',
                                                    fontSize: 14),
                                              ),
                                            ]),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(children: [
                                              Text(
                                                item_datetime[index],
                                                style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontFamily: 'GSANSM',
                                                    fontSize: 12),
                                              ),
                                            ]),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(children: [
                                              Text(
                                                item_price[index],
                                                style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontFamily: 'GSANSB',
                                                    fontSize: 13),
                                              ),
                                            ]),
                                          ],
                                        ),
                                        // subtitle: Text(
                                        //   b[index],
                                        //   style: TextStyle(
                                        //       color: Color(0xff9f9f9f),
                                        //       fontFamily: 'GSANSM',
                                        //       fontSize: 12.0),
                                        // ),
                                        // trailing: Padding(
                                        //   padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                                        //   child: Text(
                                        //     item_price[index],
                                        //     style: TextStyle(
                                        //         color: Color(0xff9f9f9f),
                                        //         fontFamily: 'GSANSM',
                                        //         fontSize: 12.0),
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // child: GestureDetector(
                              //   onTap: () {},
                              //   child: Padding(
                              //     padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text(
                              //           item_title[index],
                              //           style: TextStyle(
                              //               fontFamily: 'GSANSM',
                              //               color: Color(0xff58585b),
                              //               fontSize: 14),
                              //         ),
                              //         Text(item_intro[index],
                              //             style: TextStyle(
                              //                 fontFamily: 'GSANSM',
                              //                 color: Color(0xff58585b),
                              //                 fontSize: 14)),
                              //         Text(
                              //           item_price[index],
                              //           style: TextStyle(
                              //               fontFamily: 'GSANSM',
                              //               color: Color(0xff9f9f9f),
                              //               fontSize: 12),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // )
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 1.5,
                              color: Colors.grey[200],
                            );
                          },
                          itemCount: item_title.length);
                    }
                  });
            }
          }),
    );
  }

  Widget buy_sell_List() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 30, 15, 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final recive = await Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return UserBuyList();
                      }));
                      setState(() {
                        if (recive == 2) {
                          _tabController.index = 2;
                        }
                      });
                    },
                    child: Image.asset(
                      "assets/images/PNG/buy1.png",
                      width: 140,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final recive = await Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return USerSellList();
                      }));
                      setState(() {
                        if (recive == 2) {
                          _tabController.index = 2;
                        }
                      });
                    },
                    child: Image.asset(
                      "assets/images/PNG/sell1.png",
                      width: 140,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  late TabController _tabController =
      new TabController(length: 3, vsync: this, initialIndex: 0);

  @override
  void initState() {
    // TODO: implement initState

    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);

    // if (returnNum == 2) {
    //   _tabController.index = 2;
    // }

    _tabController.addListener(_switchTabIndex);

    //_get_report_item_id();

    super.initState();
  }

  @override
  void dispose() {
    report_user_list.clear();
    super.dispose();
  }

  void _switchTabIndex() {
    print(_tabController.index);
    setState(() {});
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("이용제한"),
          content: Text("신고횟수 초과로 이용에 제한된 상태입니다\n판매글을 게시할 수 없는 상태입니다"),
          actions: <Widget>[
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
  Widget build(BuildContext context) {
    UserAccountInfo userAccount_ = Provider.of(context, listen: false);
    data.clear();
    _get_report_item_id();

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
          actions: [],
          centerTitle: true,
          elevation: 0,
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
                    "거래내역",
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
              ]),
        ),
        floatingActionButton: _tabController.index == 0
            ? FloatingActionButton(
                onPressed: () {
                  if (userAccount_.reportCount >= 5) {
                    _showDialog(context);
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MarketItemPostWrite();
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
              )
            : Container(),
        // floatingActionButton: CircularMenu(
        //   // menu alignment
        //   alignment: Alignment.bottomRight,
        //   // menu radius
        //   radius: 70,
        //   // widget in the background holds actual page content
        //   //backgroundWidget: MyCustomWidget(),
        //   // global key to control the animation anywhere in the code.
        //   key: GlobalKey<CircularMenuState>(),
        //   // animation duration
        //   animationDuration: Duration(milliseconds: 300),
        //   // animation curve in forward
        //   curve: Curves.easeInOut,
        //   // animation curve in reverse
        //   reverseCurve: Curves.fastOutSlowIn,
        //   // first item angle
        //   //startingAngleInRadian : 0 ,
        //   // last item angle
        //   //endingAngleInRadian : 3.141592 * 3,
        //   // toggle button callback
        //   toggleButtonOnPressed: () {
        //     //callback
        //   },
        //   // toggle button appearance properties
        //   toggleButtonColor: Theme.of(context).primaryColor,
        //   toggleButtonBoxShadow: [
        //     BoxShadow(
        //       color: Theme.of(context).primaryColor,
        //       blurRadius: 1,
        //     ),
        //   ],
        //   //toggleButtonAnimatedIconData: AnimatedIcons.add_event,

        //   toggleButtonIconColor: Colors.white,
        //   toggleButtonMargin: 10.0,
        //   toggleButtonPadding: 10.0,
        //   toggleButtonSize: 30.0,
        //   items: [
        //     CircularMenuItem(
        //         iconSize: 30,
        //         boxShadow: [
        //           BoxShadow(
        //             color: Theme.of(context).primaryColor,
        //             blurRadius: 1,
        //           ),
        //         ],
        //         icon: Icons.groups,
        //         color: Theme.of(context).primaryColor,
        //         onTap: () {}),
        //     CircularMenuItem(
        //         boxShadow: [
        //           BoxShadow(
        //             color: Theme.of(context).primaryColor,
        //             blurRadius: 1,
        //           ),
        //         ],
        //         icon: Icons.post_add,
        //         color: Theme.of(context).primaryColor,
        //         onTap: () {
        //           if(userAccount_.reportCount >= 5){
        //             _showDialog(context);
        //           }else{
        //             Navigator.push(context,
        //               MaterialPageRoute(builder: (BuildContext context) {
        //             return MarketItemPostWrite();
        //           }));
        //           }
        //         }),
        //   ],
        // ),

        body: TabBarView(controller: _tabController, children: [
          SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  children: [
                    // Divider(
                    //     thickness: 1.5, height: 1.5, color: Colors.grey[200]),
                    // _total_Market_Item(),
                    // _total_Market_Item_another()

                    MarketRequestPage(
                      parentAction: _updateMyIndex,
                    )
                  ],
                ),
              ),
            ),
          ),
          buy_sell_List(),
          SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  children: [
                    // Divider(
                    //     thickness: 1.5, height: 1.5, color: Colors.grey[200]),
                    _market_Chat_Room(),
                  ],
                ),
              ),
            ),
          ),
          // _market_Chat_Room()
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
                  //backgroundColor: Colors.grey[300],
                  backgroundColor: Colors.white,
                  elevation: 3,
                  selectedItemColor: Theme.of(context).primaryColor,
                  //selectedItemColor: Colors.grey[800],
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
      ),
    );
  }

  _updateMyIndex(int chage_index) {
    setState(() {
      _tabController.index = chage_index;
    });
  }
}

class MarketRequestPage extends StatefulWidget {
  final ValueChanged<int> parentAction;
  const MarketRequestPage({Key? key, required this.parentAction})
      : super(key: key);

  @override
  _MarketRequestPageState createState() => _MarketRequestPageState();
}

class _MarketRequestPageState extends State<MarketRequestPage>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  List data = [];
  List report_user_list = [];

  User user = FirebaseAuth.instance.currentUser!;

  List block_id_list = [];

  Future _getItem(List item_id) async {
    print("_getItem 호출함");
    // List image_list = [];
    // data.clear();

    CollectionReference refMarket =
        FirebaseFirestore.instance.collection("Market");

    for (int i = 0; i < item_id.length; i++) {
      DocumentSnapshot snapitemshot = await refMarket.doc(item_id[i]).get();

      data.add(snapitemshot.data());
    }

    return data;
  }

  Future _get_Block_ID_List() async {
    block_id_list.clear();
    DocumentReference ref =
        FirebaseFirestore.instance.collection("Users").doc(user.uid);

    DocumentSnapshot snapshot = await ref.get();

    // for(int i = 0; i < snapshot["BlockUserIDList"].length; i++){
    //   block_id_list.addAll()
    // }
    if (snapshot["BlockUserIDList"].length != 0) {
      block_id_list.addAll(snapshot["BlockUserIDList"]);
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    // _get_Block_ID_List();
  }

  @override
  void dispose() {
    report_user_list.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserAccountInfo userAccount_ = Provider.of(context, listen: false);
    _get_Block_ID_List();
    return Expanded(
        child: Container(
      height: MediaQuery.of(context).size.height / 1.4,
      child: FutureBuilder(
          future: FirebaseFirestore.instance.collection("Market").get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData == false) {
              return Container();
            } else if (snapshot.hasError) {
              return Text("에러");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else {
              List total_item_data = [];

              for (int i = 0; i < snapshot.data.docs.length; i++) {
                total_item_data.add(snapshot.data.docs[i].id);
              }
              data.clear();
              return FutureBuilder(
                  future: _getItem(total_item_data),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData == false) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Text("에러에러");
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Container();
                    } else {
                      List item_title = [];
                      List item_intro = [];
                      List item_price = [];
                      List item_datetime = [];
                      List item_nick_name = [];
                      List item_user_uid = [];
                      List item_image_url = [];
                      List item_id = [];
                      List item_read_count = [];
                      List item_report_count = [];
                      List item_profile_image = [];

                      List block_bool_check_list = [];

                      for (int i = 0; i < data.length; i++) {
                        item_title.add(data[i]["Title"]);
                        item_intro.add(data[i]["Intro"]);
                        item_price.add(data[i]["Price"]);
                        item_datetime.add(data[i]["DateTime"]);
                        item_nick_name.add(data[i]["NickName"]);
                        item_user_uid.add(data[i]["UserUID"]);
                        item_id.add(data[i]["ItemID"]);
                        item_image_url.add(data[i]["ImageUrl"]);
                        item_read_count.add(data[i]["readCount"]);
                        item_report_count.add(data[i]["reportCount"]);
                        item_profile_image.add(data[i]["profile_image"]);
                      }

                      if (block_id_list.length != 0) {
                        for (int i = 0; i < item_user_uid.length; i++) {
                          for (int j = 0; j < block_id_list.length; j++) {
                            if (item_user_uid[i] == block_id_list[j]) {
                              item_title.removeAt(i);
                              item_intro.removeAt(i);
                              item_price.removeAt(i);
                              item_datetime.removeAt(i);
                              item_nick_name.removeAt(i);
                              item_user_uid.removeAt(i);
                              item_id.removeAt(i);
                              item_image_url.removeAt(i);
                              item_read_count.removeAt(i);
                              item_report_count.removeAt(i);
                              item_profile_image.removeAt(i);
                            }
                          }
                        }

                        for (int i = 0; i < item_user_uid.length; i++) {
                          block_bool_check_list.add(false);
                        }

                        // for (int i = 0; i < item_user_uid.length; i++) {
                        //   for (int j = 0; j < block_id_list.length; j++) {
                        //     if (item_user_uid[i] == block_id_list[j]) {
                        //       block_bool_check_list[i] = true;
                        //     }
                        //   }
                        // }
                      } else {
                        for (int i = 0; i < item_user_uid.length; i++) {
                          block_bool_check_list.add(false);
                        }
                      }

                      return ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: GestureDetector(
                                onTap: () async {
                                  final recive = await Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return MarketItemInfo(
                                      prev_intro: item_intro[index],
                                      prev_nick_name: item_nick_name[index],
                                      prev_price: item_price[index],
                                      prev_title: item_title[index],
                                      prev_datetime: item_datetime[index],
                                      prev_imageurl: item_image_url[index],
                                      prev_UserUID: item_user_uid[index],
                                      prev_itemID: item_id[index],
                                      prev_test: [""],
                                      prev_read_count: item_read_count[index],
                                      prev_report_count:
                                          item_report_count[index],
                                      prev_profile_image:
                                          item_profile_image[index],
                                    );
                                  }));
                                  setState(() {
                                    if (recive == 2) {
                                      widget.parentAction(2);
                                    }
                                  });
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 0, 15),
                                      child:
                                          block_bool_check_list[index] != true
                                              ? ListTile(
                                                  leading: SizedBox(
                                                      height: 120,
                                                      width: 100,
                                                      child: item_image_url[
                                                                  index] !=
                                                              ""
                                                          ? Container(
                                                              child: data[index]
                                                                          [
                                                                          'reportCount'] !=
                                                                      0
                                                                  ? CachedNetworkImage(
                                                                      imageUrl:
                                                                          item_image_url[
                                                                              index],
                                                                      imageBuilder:
                                                                          (context, imageProvider) =>
                                                                              Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                        child: CustomPaint(
                                                                            painter: ReportStamp(
                                                                                text: TextSpan(
                                                                          text:
                                                                              '신고',
                                                                          style: TextStyle(
                                                                              fontFamily: 'GSANSM',
                                                                              fontSize: 10,
                                                                              color: Colors.white),
                                                                        ))),
                                                                      ),
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              const CircularProgressIndicator(
                                                                        strokeWidth:
                                                                            1.0,
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Icon(
                                                                              Icons.error),
                                                                    )
                                                                  : Container(
                                                                      child:
                                                                          CachedNetworkImage(
                                                                      imageUrl:
                                                                          item_image_url[
                                                                              index],
                                                                      imageBuilder:
                                                                          (context, imageProvider) =>
                                                                              Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          image:
                                                                              DecorationImage(
                                                                            image:
                                                                                imageProvider,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              const CircularProgressIndicator(
                                                                        strokeWidth:
                                                                            1.0,
                                                                      ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          const Icon(
                                                                              Icons.error),
                                                                    )))
                                                          : Container()),
                                                  title: Column(children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          item_title[index],
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff58585b),
                                                              fontFamily:
                                                                  'GSANSM',
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Row(children: [
                                                      Text(
                                                        item_datetime[index],
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[400],
                                                            fontFamily:
                                                                'GSANSM',
                                                            fontSize: 12),
                                                      ),
                                                    ]),
                                                    SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            item_price[index],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[400],
                                                                fontFamily:
                                                                    'GSANSB',
                                                                fontSize: 13),
                                                          ),
                                                          Text(
                                                            '조회 수 : ' +
                                                                data[index][
                                                                        'readCount']
                                                                    .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[400],
                                                                fontFamily:
                                                                    'GSANSM',
                                                                fontSize: 13),
                                                          ),
                                                          data[index]['reportCount'] !=
                                                                  0
                                                              ? Text(
                                                                  '신고 수 : ' +
                                                                      data[index]
                                                                              [
                                                                              'reportCount']
                                                                          .toString(),
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      fontFamily:
                                                                          'GSANSM',
                                                                      fontSize:
                                                                          13),
                                                                )
                                                              : Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .grey,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                  ),
                                                                ),
                                                        ]),
                                                  ]),
                                                )
                                              : Container(),
                                      // ListTile(
                                      //   leading: SizedBox(
                                      //       height: 120,
                                      //       width: 100,
                                      //       child: item_image_url[index] != ""
                                      //           ? Container(
                                      //               child: data[index][
                                      //                           'reportCount'] !=
                                      //                       0
                                      //                   ? CachedNetworkImage(
                                      //                       imageUrl:
                                      //                           item_image_url[
                                      //                               index],
                                      //                       imageBuilder:
                                      //                           (context,
                                      //                                   imageProvider) =>
                                      //                               Container(
                                      //                         decoration:
                                      //                             BoxDecoration(
                                      //                           image:
                                      //                               DecorationImage(
                                      //                             image:
                                      //                                 imageProvider,
                                      //                             fit: BoxFit
                                      //                                 .fill,
                                      //                           ),
                                      //                         ),
                                      //                         child: CustomPaint(
                                      //                             painter: ReportStamp(
                                      //                                 text: TextSpan(
                                      //                           text: '신고',
                                      //                           style: TextStyle(
                                      //                               fontFamily:
                                      //                                   'GSANSM',
                                      //                               fontSize:
                                      //                                   10,
                                      //                               color: Colors
                                      //                                   .white),
                                      //                         ))),
                                      //                       ),
                                      //                       placeholder: (context,
                                      //                               url) =>
                                      //                           const CircularProgressIndicator(
                                      //                         strokeWidth:
                                      //                             1.0,
                                      //                       ),
                                      //                       errorWidget: (context,
                                      //                               url,
                                      //                               error) =>
                                      //                           const Icon(Icons
                                      //                               .error),
                                      //                     )
                                      //                   : Container(
                                      //                       child:
                                      //                           CachedNetworkImage(
                                      //                       imageUrl:
                                      //                           item_image_url[
                                      //                               index],
                                      //                       imageBuilder:
                                      //                           (context,
                                      //                                   imageProvider) =>
                                      //                               Container(
                                      //                         decoration:
                                      //                             BoxDecoration(
                                      //                           image:
                                      //                               DecorationImage(
                                      //                             image:
                                      //                                 imageProvider,
                                      //                             fit: BoxFit
                                      //                                 .fill,
                                      //                           ),
                                      //                         ),
                                      //                       ),
                                      //                       placeholder: (context,
                                      //                               url) =>
                                      //                           const CircularProgressIndicator(
                                      //                         strokeWidth:
                                      //                             1.0,
                                      //                       ),
                                      //                       errorWidget: (context,
                                      //                               url,
                                      //                               error) =>
                                      //                           const Icon(Icons
                                      //                               .error),
                                      //                     )))
                                      //           : Container()),
                                      //   title: Column(children: [
                                      //     Row(
                                      //       children: [
                                      //         Text(
                                      //           item_title[index],
                                      //           style: TextStyle(
                                      //               color: Color(0xff58585b),
                                      //               fontFamily: 'GSANSM',
                                      //               fontSize: 14),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //     SizedBox(
                                      //       height: 10.0,
                                      //     ),
                                      //     Row(children: [
                                      //       Text(
                                      //         item_datetime[index],
                                      //         style: TextStyle(
                                      //             color: Colors.grey[400],
                                      //             fontFamily: 'GSANSM',
                                      //             fontSize: 12),
                                      //       ),
                                      //     ]),
                                      //     SizedBox(
                                      //       height: 10.0,
                                      //     ),
                                      //     Row(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment
                                      //                 .spaceBetween,
                                      //         children: [
                                      //           Text(
                                      //             item_price[index],
                                      //             style: TextStyle(
                                      //                 color: Colors.grey[400],
                                      //                 fontFamily: 'GSANSB',
                                      //                 fontSize: 13),
                                      //           ),
                                      //           Text(
                                      //             '조회 수 : ' +
                                      //                 data[index]['readCount']
                                      //                     .toString(),
                                      //             style: TextStyle(
                                      //                 color: Colors.grey[400],
                                      //                 fontFamily: 'GSANSM',
                                      //                 fontSize: 13),
                                      //           ),
                                      //           data[index]['reportCount'] !=
                                      //                   0
                                      //               ? Text(
                                      //                   '신고 수 : ' +
                                      //                       data[index][
                                      //                               'reportCount']
                                      //                           .toString(),
                                      //                   style: TextStyle(
                                      //                       color: Theme.of(
                                      //                               context)
                                      //                           .primaryColor,
                                      //                       fontFamily:
                                      //                           'GSANSM',
                                      //                       fontSize: 13),
                                      //                 )
                                      //               : Container(
                                      //                   decoration:
                                      //                       BoxDecoration(
                                      //                     color: Colors.grey,
                                      //                     borderRadius:
                                      //                         BorderRadius
                                      //                             .circular(
                                      //                                 5),
                                      //                   ),
                                      //                 ),
                                      //         ]),
                                      //   ]),
                                      // )
                                    )
                                  ],
                                ),
                                // child: Column(
                                //   children: [
                                //     Padding(
                                //       padding:
                                //           EdgeInsets.fromLTRB(0, 15, 0, 15),
                                //       child: ListTile(
                                //         leading: SizedBox(
                                //           height: 120,
                                //           width: 100,
                                //           child: item_image_url[index] != ""
                                //               ? CachedNetworkImage(
                                //                   imageUrl:
                                //                       item_image_url[index],
                                //                   imageBuilder: (context,
                                //                           imageProvider) =>
                                //                       Container(
                                //                     decoration: BoxDecoration(
                                //                       image: DecorationImage(
                                //                         image: imageProvider,
                                //                         fit: BoxFit.fill,
                                //                       ),
                                //                     ),
                                //                   ),
                                //                   placeholder: (context, url) =>
                                //                       const CircularProgressIndicator(
                                //                     strokeWidth: 1.0,
                                //                   ),
                                //                   errorWidget: (context, url,
                                //                           error) =>
                                //                       const Icon(Icons.error),
                                //                 )
                                //               : Container(
                                //                   decoration: BoxDecoration(
                                //                     color: Colors.grey,
                                //                     borderRadius:
                                //                         BorderRadius.circular(
                                //                             5),
                                //                   ),
                                //                 ),
                                //         ),
                                //         title: Column(
                                //           children: [
                                //             Row(children: [
                                //               Text(
                                //                 item_title[index],
                                //                 style: TextStyle(
                                //                     color: Color(0xff58585b),
                                //                     fontFamily: 'GSANSM',
                                //                     fontSize: 14),
                                //               ),
                                //             ]),
                                //             SizedBox(
                                //               height: 10.0,
                                //             ),
                                //             Row(children: [
                                //               Text(
                                //                 item_datetime[index],
                                //                 style: TextStyle(
                                //                     color: Colors.grey[400],
                                //                     fontFamily: 'GSANSM',
                                //                     fontSize: 12),
                                //               ),
                                //             ]),
                                //             SizedBox(
                                //               height: 10.0,
                                //             ),
                                //             Row(children: [
                                //               Text(
                                //                 item_price[index],
                                //                 style: TextStyle(
                                //                     color: Colors.grey[400],
                                //                     fontFamily: 'GSANSB',
                                //                     fontSize: 13),
                                //               ),
                                //             ]),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 1.5,
                              color: Colors.grey[200],
                            );
                          },
                          itemCount: item_title.length);
                    }
                  });
            }
          }),
    ));
  }
}

class ReportStamp extends CustomPainter {
  final TextSpan text;

  ReportStamp({required this.text}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    var myPaint = Paint();
    myPaint.color = Colors.red;
    var path = Path();
    path.moveTo(size.width, size.height / 2);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width / 2, size.height);
    path.close();
    myPaint.style = PaintingStyle.fill;

    canvas.drawPath(path, myPaint);

    TextPainter textPainter = TextPainter(
      text: text,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: size.width);
    textPainter.paint(canvas, Offset(size.width / 1.30, size.height / 1.30));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
