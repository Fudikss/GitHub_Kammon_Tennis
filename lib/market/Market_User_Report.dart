import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/market/Market_Main_Page.dart';

class MarketUserReport extends StatefulWidget {
  final String prev_problem_user_uid;
  final String prev_problem_user_nick_name;
  final String prev_reporter_user_uid;
  final String prev_reporter_user_nick_name;
  final String path_chat_room;

  const MarketUserReport(
      {Key? key,
      required this.prev_problem_user_uid,
      required this.prev_problem_user_nick_name,
      required this.prev_reporter_user_uid,
      required this.prev_reporter_user_nick_name,
      required this.path_chat_room
      })
      : super(key: key);

  @override
  _MarketUserReportState createState() => _MarketUserReportState(
      prev_problem_user_uid,
      prev_problem_user_nick_name,
      prev_reporter_user_uid,
      prev_reporter_user_nick_name,
      path_chat_room);
}

class _MarketUserReportState extends State<MarketUserReport> {
  String problem_user_uid = "";
  String problem_user_nick_name = "";
  String reporter_user_uid = "";
  String reporter_user_nick_name = "";
  String pathChatRoom = '';

  List report_user_list_id = [];

  List report_user_list = [];

  User user1 = FirebaseAuth.instance.currentUser!;

  bool report_check = false;

  late UserAccountInfo userAccount_;

  List other_report_list = [];

  _MarketUserReportState(this.problem_user_uid, this.problem_user_nick_name,
      this.reporter_user_uid, this.reporter_user_nick_name, this.pathChatRoom);

  Future _get_report_item_id() async {
    //report_user_list.clear();
    DocumentReference ref = FirebaseFirestore.instance
        .collection("Users")
        .doc(user1.uid)
        .collection("Report")
        .doc("ReportList");

    DocumentSnapshot snapshot = await ref.get();

    if (snapshot["UserReportList"].length != 0) {
      for (int i = 0; i < snapshot["UserReportList"].length; i++) {
        report_user_list.add(snapshot["UserReportList"][i]);
      }

      for (int i = 0; i < report_user_list.length; i++) {
        if (report_user_list[i] == problem_user_uid)
          setState(() {
            report_check = true;
          });
      }
    }
  }

  Future _getOtherReportList() async {
    DocumentReference ref = FirebaseFirestore.instance.collection("MarketChatRoom").doc(pathChatRoom);
    DocumentSnapshot snapshot = await ref.get();
    other_report_list = snapshot['OtherReport'];
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("신고된 사용자"),
          content: Text("이미 신고된 사용자입니다"),
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

  void _showTextReportDialog(
      BuildContext context, int check, String reporter_nickname) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        switch (check) {
          case 1:
            return AlertDialog(
              title: Text("신고"),
              content: Text("전문 판매업자로 신고하시겠습니까?"),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("신고하기"),
                  onPressed: () async {
                    if (report_check != true) {
                      try {
                        _getOtherReportList().then((value) => {
                          FirebaseFirestore.instance
                            .collection("MarketUserReport")
                            .doc()
                            .set({
                              "ProblemUID": problem_user_uid,
                              "ReporterNickName": reporter_user_nick_name,
                              "ReporterUID": user1.uid,
                              "DateTime": formatDate(DateTime.now(),[yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                              "reason": "전문 판매업자입니다",
                            }),

                            FirebaseFirestore.instance
                              .collection("Users")
                              .doc(user1.uid)
                              .collection("Report")
                              .doc("ReportList")
                              .update({
                                "UserReportList": FieldValue.arrayUnion([problem_user_uid]),
                              }),

                            FirebaseFirestore.instance.collection('Users').doc(problem_user_uid).update({
                              'reportCount': FieldValue.increment(1),
                            }).then((value) => print('ok')),
                            
                          if(other_report_list.length == 0) {
                            other_report_list.add(userAccount_.uid)
                          } else {
                            for(int i = 0; i < other_report_list.length; i++) {
                              if(other_report_list[i] != userAccount_.uid)
                              {
                                other_report_list.add(userAccount_.uid)
                              }
                            }
                          },
                          FirebaseFirestore.instance.collection('MarketChatRoom').doc(pathChatRoom).update({'OtherReport' : other_report_list}),

                          showDialog(
                            context: context, 
                            builder: (context) {
                              return AlertDialog(
                                title: Text('신고가 접수되었습니다.'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context)..pop()..pop()..pop()..pop();
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (BuildContext context) {
                                      //   return MarketRequestPage(parentAction: (int value) {2;},);
                                      // }));
                                    }, 
                                    child: 
                                      Text('확인')
                                  )  
                                ],
                              );                                
                            } 
                          )
                        });
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      _showDialog(context);
                    }
                  },
                ),
                ElevatedButton(
                  child: Text("취소"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          case 2:
            return AlertDialog(
              title: Text("신고"),
              content: Text("비매너 사용자로 신고하시겠습니까?"),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("신고하기"),
                  onPressed: () async {
                    if (report_check != true) {
                      try {
                        _getOtherReportList().then((value) => {
                          FirebaseFirestore.instance
                            .collection("MarketUserReport")
                            .doc()
                            .set({
                              "ProblemUID": problem_user_uid,
                              "ReporterNickName": reporter_user_nick_name,
                              "ReporterUID": user1.uid,
                              "DateTime": formatDate(DateTime.now(),[yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                              "reason": "비매너 사용자입니다.",
                            }),

                            FirebaseFirestore.instance
                              .collection("Users")
                              .doc(user1.uid)
                              .collection("Report")
                              .doc("ReportList")
                              .update({
                                "UserReportList": FieldValue.arrayUnion([problem_user_uid]),
                              }),

                            FirebaseFirestore.instance.collection('Users').doc(problem_user_uid).update({
                              'reportCount': FieldValue.increment(1),
                            }).then((value) => print('ok')),
                            
                          if(other_report_list.length == 0) {
                            other_report_list.add(userAccount_.uid)
                          } else {
                            for(int i = 0; i < other_report_list.length; i++) {
                              if(other_report_list[i] != userAccount_.uid)
                              {
                                other_report_list.add(userAccount_.uid)
                              }
                            }
                          },
                          FirebaseFirestore.instance.collection('MarketChatRoom').doc(pathChatRoom).update({'OtherReport' : other_report_list}),

                          showDialog(
                            context: context, 
                            builder: (context) {
                              return AlertDialog(
                                title: Text('신고가 접수되었습니다.'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context)..pop()..pop()..pop()..pop();
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (BuildContext context) {
                                      //   return MarketRequestPage(parentAction: (int value) {2;},);
                                      // }));
                                    }, 
                                    child: 
                                      Text('확인')
                                  )  
                                ],
                              );                                
                            } 
                          )
                        });
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      _showDialog(context);
                    }
                  },
                ),
                ElevatedButton(
                  child: Text("취소"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );

          case 3:
            return AlertDialog(
              title: Text("신고"),
              content: Text("욕설 및 성희롱으로 신고하시겠습니까?"),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("신고하기"),
                  onPressed: () async {
                    if (report_check != true) {
                      try {
                        _getOtherReportList().then((value) => {
                          FirebaseFirestore.instance
                            .collection("MarketUserReport")
                            .doc()
                            .set({
                              "ProblemUID": problem_user_uid,
                              "ReporterNickName": reporter_user_nick_name,
                              "ReporterUID": user1.uid,
                              "DateTime": formatDate(DateTime.now(),[yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                              "reason": "욕설 및 성희롱 신고 대상자입니다.",
                            }),

                            FirebaseFirestore.instance
                              .collection("Users")
                              .doc(user1.uid)
                              .collection("Report")
                              .doc("ReportList")
                              .update({
                                "UserReportList": FieldValue.arrayUnion([problem_user_uid]),
                              }),

                            FirebaseFirestore.instance.collection('Users').doc(problem_user_uid).update({
                              'reportCount': FieldValue.increment(1),
                            }).then((value) => print('ok')),
                            
                          if(other_report_list.length == 0) {
                            other_report_list.add(userAccount_.uid)
                          } else {
                            for(int i = 0; i < other_report_list.length; i++) {
                              if(other_report_list[i] != userAccount_.uid)
                              {
                                other_report_list.add(userAccount_.uid)
                              }
                            }
                          },
                          FirebaseFirestore.instance.collection('MarketChatRoom').doc(pathChatRoom).update({'OtherReport' : other_report_list}),

                          showDialog(
                            context: context, 
                            builder: (context) {
                              return AlertDialog(
                                title: Text('신고가 접수되었습니다.'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context)..pop()..pop()..pop()..pop();
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (BuildContext context) {
                                      //   return MarketRequestPage(parentAction: (int value) {2;},);
                                      // }));
                                    }, 
                                    child: 
                                      Text('확인')
                                  )  
                                ],
                              );                                
                            } 
                          )
                        });
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      _showDialog(context);
                    }
                  },
                ),
                ElevatedButton(
                  child: Text("취소"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );

          case 4:
            return AlertDialog(
              title: Text("신고"),
              content: Text("거래 및 환불 분쟁신고하시겠습니까?"),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("신고하기"),
                  onPressed: () async {
                    if (report_check != true) {
                      try {
                        _getOtherReportList().then((value) => {
                          FirebaseFirestore.instance
                            .collection("MarketUserReport")
                            .doc()
                            .set({
                              "ProblemUID": problem_user_uid,
                              "ReporterNickName": reporter_user_nick_name,
                              "ReporterUID": user1.uid,
                              "DateTime": formatDate(DateTime.now(),[yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                              "reason": "거래 및 환불 분쟁 신고 대상자입니다.",
                            }),

                            FirebaseFirestore.instance
                              .collection("Users")
                              .doc(user1.uid)
                              .collection("Report")
                              .doc("ReportList")
                              .update({
                                "UserReportList": FieldValue.arrayUnion([problem_user_uid]),
                              }),

                            FirebaseFirestore.instance.collection('Users').doc(problem_user_uid).update({
                              'reportCount': FieldValue.increment(1),
                            }).then((value) => print('ok')),
                            
                          if(other_report_list.length == 0) {
                            other_report_list.add(userAccount_.uid)
                          } else {
                            for(int i = 0; i < other_report_list.length; i++) {
                              if(other_report_list[i] != userAccount_.uid)
                              {
                                other_report_list.add(userAccount_.uid)
                              }
                            }
                          },
                          FirebaseFirestore.instance.collection('MarketChatRoom').doc(pathChatRoom).update({'OtherReport' : other_report_list}),

                          showDialog(
                            context: context, 
                            builder: (context) {
                              return AlertDialog(
                                title: Text('신고가 접수되었습니다.'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context)..pop()..pop()..pop()..pop();
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (BuildContext context) {
                                      //   return MarketRequestPage(parentAction: (int value) {2;},);
                                      // }));
                                    }, 
                                    child: 
                                      Text('확인')
                                  )  
                                ],
                              );                                
                            } 
                          )
                        });
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      _showDialog(context);
                    }
                  },
                ),
                ElevatedButton(
                  child: Text("취소"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );

          case 5:
            return AlertDialog(
              title: Text("신고"),
              content: Text("사기 사용자로 신고하시겠습니까?"),
              actions: <Widget>[
                ElevatedButton(
                  child: Text("신고하기"),
                  onPressed: () async {
                    if (report_check != true) {
                      try {
                        _getOtherReportList().then((value) => {
                          FirebaseFirestore.instance
                            .collection("MarketUserReport")
                            .doc()
                            .set({
                              "ProblemUID": problem_user_uid,
                              "ReporterNickName": reporter_user_nick_name,
                              "ReporterUID": user1.uid,
                              "DateTime": formatDate(DateTime.now(),[yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                              "reason": "사기 판매자입니다.",
                            }),

                            FirebaseFirestore.instance
                              .collection("Users")
                              .doc(user1.uid)
                              .collection("Report")
                              .doc("ReportList")
                              .update({
                                "UserReportList": FieldValue.arrayUnion([problem_user_uid]),
                              }),

                            FirebaseFirestore.instance.collection('Users').doc(problem_user_uid).update({
                              'reportCount': FieldValue.increment(1),
                            }).then((value) => print('ok')),
                            
                          if(other_report_list.length == 0) {
                            other_report_list.add(userAccount_.uid)
                          } else {
                            for(int i = 0; i < other_report_list.length; i++) {
                              if(other_report_list[i] != userAccount_.uid)
                              {
                                other_report_list.add(userAccount_.uid)
                              }
                            }
                          },
                          FirebaseFirestore.instance.collection('MarketChatRoom').doc(pathChatRoom).update({'OtherReport' : other_report_list}),

                          showDialog(
                            context: context, 
                            builder: (context) {
                              return AlertDialog(
                                title: Text('신고가 접수되었습니다.'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context)..pop()..pop()..pop()..pop();
                                      // Navigator.push(context,
                                      //     MaterialPageRoute(builder: (BuildContext context) {
                                      //   return MarketRequestPage(parentAction: (int value) {2;},);
                                      // }));
                                    }, 
                                    child: 
                                      Text('확인')
                                  )  
                                ],
                              );                                
                            } 
                          )
                        });
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      _showDialog(context);
                    }
                  },
                ),
                ElevatedButton(
                  child: Text("취소"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
        }
        return Text("실패");
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _get_report_item_id();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userAccount_ = Provider.of(context, listen: false);
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
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                child: Text(
                  "사용자를 신고하는 이유를 선택해주세요",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'GSANSB',
                      fontSize: 15.0),
                ),
              ),
              Container(
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height - 300,
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Divider(
                            thickness: 1.5,
                            height: 1.5,
                            color: Colors.grey[200]),
                        ListTile(
                            onTap: () {
                              _showTextReportDialog(
                                  context, 1, userAccount_.nickname);
                            },
                            title: Text(
                              "전문 판매업자 같습니다",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'GSANSM',
                                  fontSize: 14.0),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black,
                              size: 30.0,
                            )),
                        Divider(
                            thickness: 1.5,
                            height: 1.5,
                            color: Colors.grey[200]),
                        ListTile(
                            onTap: () {
                              _showTextReportDialog(
                                  context, 2, userAccount_.nickname);
                            },
                            title: Text(
                              "비매너 사용자입니다",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'GSANSM',
                                  fontSize: 14.0),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black,
                              size: 30.0,
                            )),
                        Divider(
                            thickness: 1.5,
                            height: 1.5,
                            color: Colors.grey[200]),
                        ListTile(
                            onTap: () {
                              _showTextReportDialog(
                                  context, 3, userAccount_.nickname);
                            },
                            title: Text(
                              "욕설 및 성희롱을 합니다",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'GSANSM',
                                  fontSize: 14.0),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black,
                              size: 30.0,
                            )),
                        Divider(
                            thickness: 1.5,
                            height: 1.5,
                            color: Colors.grey[200]),
                        ListTile(
                            onTap: () {
                              _showTextReportDialog(
                                  context, 4, userAccount_.nickname);
                            },
                            title: Text(
                              "거래 및 환불 분쟁 신고",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'GSANSM',
                                  fontSize: 14.0),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black,
                              size: 30.0,
                            )),
                        Divider(
                            thickness: 1.5,
                            height: 1.5,
                            color: Colors.grey[200]),
                        ListTile(
                            onTap: () {
                              _showTextReportDialog(
                                  context, 5, userAccount_.nickname);
                            },
                            title: Text(
                              "사기 사용자 입니다",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'GSANSM',
                                  fontSize: 14.0),
                            ),
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.black,
                              size: 30.0,
                            )),
                        Divider(
                            thickness: 1.5,
                            height: 1.5,
                            color: Colors.grey[200]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
