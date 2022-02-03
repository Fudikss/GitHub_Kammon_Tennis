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
// import 'package:snstennis/club/Gathering_Post_Write_1_1.dart';
import 'package:snstennis/club/Gathering_Post_Write_1_2.dart';
import 'package:snstennis/instant/instant_main.dart';
import 'package:snstennis/market/Market_Main_Page.dart';

import '../home.dart';
// import 'Gathering_Post_1_1.dart';
// import 'Gathering_Post_1_2.dart';
// import 'Gathering_Post_1_2 copy.dart';
import 'Gathering_Post_1_2 copy 2.dart';
import 'first_screen_1_0.dart';

class ClubGatheringPostList extends StatefulWidget {
  final String prev_club_uid;
  final String prev_club_name;
  const ClubGatheringPostList(
      {Key? key, required this.prev_club_uid, required this.prev_club_name})
      : super(key: key);

  @override
  _ClubGatheringPostListState createState() =>
      _ClubGatheringPostListState(prev_club_uid, prev_club_name);
}

class _ClubGatheringPostListState extends State<ClubGatheringPostList> {
  String club_uid = "";
  String club_name = "";
  List gathering_id_list = [];

  late UserAccountInfo userAccount_;

  int _selectedNaviIndex = 2;

  _ClubGatheringPostListState(this.club_uid, this.club_name);

  Stream<DocumentSnapshot> _get_Gathering_List() async* {
    List id_list = [];
    DocumentReference doc_ref =
        FirebaseFirestore.instance.collection("Gathering").doc(club_uid);

    DocumentSnapshot snapshot = await doc_ref.get();

    if (snapshot["Gathering_ID"].length != 0) {
      for (int i = 0; i < snapshot["Gathering_ID"].length; i++) {
        id_list.add(snapshot["Gathering_ID"][i]);
      }

      for (int i = 0; i < id_list.length; i++) {
        CollectionReference doc_ref_post = FirebaseFirestore.instance
            .collection("Gathering")
            .doc(club_uid)
            .collection("GatheringPost");

        DocumentSnapshot list_snapshot =
            await doc_ref_post.doc(id_list[i]).get();

        gathering_id_list.add(list_snapshot.data());
      }
    } else {
      return;
    }

    // for (int i = 0; i < snapshot["Gathering_ID"].length; i++) {
    //   id_list.add(snapshot["Gathering_ID"][i]);
    //   print(id_list[i]);
    // }

    // for (int i = 0; i < id_list.length; i++) {
    //   CollectionReference doc_ref_post = FirebaseFirestore.instance
    //       .collection("Gathering")
    //       .doc(club_uid)
    //       .collection("GatheringPost");

    //   DocumentSnapshot list_snapshot = await doc_ref_post.doc(id_list[i]).get();

    //   gathering_id_list.add(list_snapshot.data());
    // }
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
                  "모임방",
                  style: TextStyle(
                      fontFamily: 'GSANSB',
                      fontSize: 20.0,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: _get_Gathering_List(),

                    // FirebaseFirestore.instance
                    //     .collection("Club")
                    //     .doc(club_uid)
                    //     .collection("Post")
                    //     .doc("GatheringPost")
                    //     .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error!");
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container();
                      } else {
                        // Map<String, dynamic> data =
                        //     snapshot.data!.data() as Map<String, dynamic>;
                        List a = [];
                        List b = [];
                        List c = [];
                        List person_num = [];
                        List max_num = [];
                        List uid_list = [];
                        List date_time_list = [];
                        List join_id_list = [];
                        List gathering_doc_id_list = [];
                        List gathering_state_list = [];

                        if (gathering_id_list.length != 0) {
                          for (int i = 0; i < gathering_id_list.length; i++) {
                            a.add(gathering_id_list[i]["ClubPostTitle"]);
                            b.add(gathering_id_list[i]["ClubPostIntro"]);
                            c.add(gathering_id_list[i]["NickName"]);
                            person_num
                                .add(gathering_id_list[i]["PersonNumber"]);
                            max_num.add(gathering_id_list[i]["MaxNumber"]);
                            uid_list
                                .add(gathering_id_list[i]["GatheringMaster"]);
                            date_time_list
                                .add(gathering_id_list[i]["DateTime"]);
                            join_id_list.add(
                                gathering_id_list[i]["GatheringPostJoinList"]);
                            gathering_doc_id_list
                                .add(gathering_id_list[i]["GatheringDocID"]);
                            gathering_state_list
                                .add(gathering_id_list[i]["Gathering_State"]);
                          }

                          return ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return GatheringPost(
                                            club_uid: club_uid,
                                            post_index: index,
                                            prev_post_title: a[index],
                                            max_num: max_num[index],
                                            prev_post_intro: b[index],
                                            prev_post_datetime:
                                                date_time_list[index],
                                            prev_post_nickname: c[index],
                                            prev_post_uid: uid_list[index],
                                            prev_join_id: join_id_list[index],
                                            prev_gathering_doc_id:
                                                gathering_doc_id_list[index],
                                            prev_gathering_state:
                                                gathering_state_list[index],
                                          );
                                        }));
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                                                  "신청인원 : " +
                                                      person_num[index]
                                                          .toString() +
                                                      "  /  " +
                                                      max_num[index] +
                                                      "명 모집   /" +
                                                      date_time_list[index],
                                                  style: TextStyle(
                                                      color: Color(0xff9f9f9f),
                                                      fontFamily: 'GSANSM',
                                                      fontSize: 12.0),
                                                ),
                                                trailing: Column(
                                                  children: [
                                                    gathering_state_list[
                                                                index] ==
                                                            "off"
                                                        ? Text(
                                                            '모집중',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'GSANSM',
                                                                fontSize: 12,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor),
                                                          )
                                                        : Text('모집마감',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'GSANSM',
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[400],
                                                            )),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 10, 0, 0),
                                                      child: Text(
                                                        c[index],
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff9f9f9f),
                                                            fontFamily:
                                                                'GSANSM',
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
                                      '모임이 없습니다.',
                                      style: TextStyle(
                                          fontFamily: 'GSANSM',
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    )
                                  ]),
                            ),
                          );
                        }
                        // if (data["GatheringPost"].length != 0) {
                        //   for (int i = 0;
                        //       i < data["GatheringPost"].length;
                        //       i++) {
                        //     a.add(data["GatheringPost"][i]["ClubPostTitle"]);
                        //     b.add(data["GatheringPost"][i]["ClubPostIntro"]);
                        //     c.add(data["GatheringPost"][i]["NickName"]);
                        //     person_num
                        //         .add(data["GatheringPost"][i]["PersonNumber"]);
                        //     max_num.add(data["GatheringPost"][i]["MaxNumber"]);
                        //     uid_list.add(
                        //         data["GatheringPost"][i]["GatheringMaster"]);
                        //     date_time_list
                        //         .add(data["GatheringPost"][i]["DateTime"]);
                        //     join_id_list.add(data["GatheringPost"][i]
                        //         ["GatheringPostJoinList"]);
                        //   }

                        //   return ListView.separated(
                        //       itemBuilder: (BuildContext context, int index) {
                        //         return Container(
                        //             decoration: BoxDecoration(
                        //                 color: Colors.white,
                        //                 borderRadius: BorderRadius.circular(5)),
                        //             child: GestureDetector(
                        //               onTap: () {
                        //                 Navigator.push(context,
                        //                     MaterialPageRoute(builder:
                        //                         (BuildContext context) {
                        //                   return GatheringPost(
                        //                     club_uid: club_uid,
                        //                     post_index: index,
                        //                     prev_post_title: a[index],
                        //                     max_num: max_num[index],
                        //                     prev_post_intro: b[index],
                        //                     prev_post_datetime:
                        //                         date_time_list[index],
                        //                     prev_post_nickname: c[index],
                        //                     prev_post_uid: uid_list[index],
                        //                     prev_join_id: join_id_list[index],
                        //                   );
                        //                 }));
                        //               },
                        //               child: Padding(
                        //                 padding:
                        //                     EdgeInsets.fromLTRB(5, 5, 5, 5),
                        //                 child: Column(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: [
                        //                     ListTile(
                        //                         title: Text(
                        //                           a[index],
                        //                           style: TextStyle(
                        //                               color: Color(0xff58585b),
                        //                               fontFamily: 'GSANSB',
                        //                               fontSize: 14),
                        //                         ),
                        //                         subtitle: Text(
                        //                           max_num[index] +
                        //                               "명 모집   /" +
                        //                               date_time_list[index],
                        //                           style: TextStyle(
                        //                               color: Color(0xff9f9f9f),
                        //                               fontFamily: 'GSANSM',
                        //                               fontSize: 12.0),
                        //                         ),
                        //                         trailing: Column(
                        //                           children: [
                        //                             Padding(
                        //                               padding:
                        //                                   EdgeInsets.fromLTRB(
                        //                                       0, 20, 0, 0),
                        //                               child: Text(
                        //                                 c[index],
                        //                                 style: TextStyle(
                        //                                     color: Color(
                        //                                         0xff9f9f9f),
                        //                                     fontFamily:
                        //                                         'GSANSM',
                        //                                     fontSize: 12.0),
                        //                               ),
                        //                             ),
                        //                             // Text(
                        //                             //   person_num[index]
                        //                             //           .toString() +
                        //                             //       "/" +
                        //                             //       max_num[index],
                        //                             //   style: TextStyle(
                        //                             //       color:
                        //                             //           Color(0xff9f9f9f),
                        //                             //       fontFamily: 'GSANSM',
                        //                             //       fontSize: 12.0),
                        //                             // ),
                        //                           ],
                        //                         )),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ));
                        //       },
                        //       separatorBuilder:
                        //           (BuildContext context, int index) {
                        //         return Container(
                        //           height: 10,
                        //           color: Colors.grey[100],
                        //         );
                        //       },
                        //       itemCount: a.length);
                        // } else {
                        //   return Container(
                        //     color: Colors.grey[100],
                        //     child: Center(
                        //       child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Icon(
                        //               Icons.error_outline,
                        //               size: 50,
                        //               color: Colors.grey[500],
                        //             ),
                        //             SizedBox(
                        //               height: 10,
                        //             ),
                        //             Text(
                        //               '등록된',
                        //               style: TextStyle(
                        //                   fontFamily: 'GSANSM',
                        //                   fontSize: 12,
                        //                   color: Colors.grey[600]),
                        //             ),
                        //             Text(
                        //               '모임이 없습니다.',
                        //               style: TextStyle(
                        //                   fontFamily: 'GSANSM',
                        //                   fontSize: 12,
                        //                   color: Colors.grey[600]),
                        //             )
                        //           ]),
                        //     ),
                        //   );
                        // }
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (userAccount_.grade != "NomalUser") {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return Gathering(club_uid: club_name, club_name: club_uid);
            }));
          } else {
            _showDialog_error(context);
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
                  fontFamily: 'GSANSM', fontSize: 14, color: Colors.white),
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
