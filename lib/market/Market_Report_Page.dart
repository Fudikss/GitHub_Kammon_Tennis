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

class MarketReport extends StatefulWidget {
  final String nickname;
  final String uid;
  final String item_uid;
  const MarketReport(
      {Key? key,
      required this.nickname,
      required this.uid,
      required this.item_uid})
      : super(key: key);

  @override
  _MarketReportState createState() =>
      _MarketReportState(nickname, uid, item_uid);
}

class _MarketReportState extends State<MarketReport> {
  bool selected = false;

  String problem_nickname = "";
  String problem_uid = "";
  String problem_item_id = "";

  User user1 = FirebaseAuth.instance.currentUser!;

  _MarketReportState(this.problem_nickname, this.problem_uid, this.problem_item_id);

    void _showTextReportDialog(BuildContext context, int check, String report_nickname) {
      UserAccountInfo userAccount_ = Provider.of(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        switch (check) {
          case 1:
            return AlertDialog(
              title: Text("신고"),
              content: Text("허위 및 악의적인 신고는 계정 정지 또는 삭제의 이유가 될 수 있습니다.\n\n판매금지 품목으로 신고하시겠습니까?"),
              actions: <Widget>[
                OutlinedButton(
                  child: Text("신고하기"),
                  onPressed: () async {
                    List<dynamic> reportList = [];
                    List<dynamic> reportUserList = [];

                    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
                    DocumentSnapshot snapshot = await ref.doc(user1.uid).collection('Report').doc('ReportList').get();
                    var data;    
                    data = snapshot.data() as Map;
                    reportList = data['MarketReportList'] as List<dynamic>;
                    reportUserList = data['UserReportList'] as List<dynamic>;
                    bool isReport = false;
                    reportList.forEach((element) {
                      if(problem_item_id == element) {
                        isReport = true;
                      }
                    });

                    if(isReport) {
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: Text('이미 신고한 게시글입니다.'),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context)..pop()..pop()..pop();
                                  }, 
                                  child: 
                                    Text('확인')
                                )  
                              ],
                            );                                
                          } 
                        );
                    } else {
                      reportList.add(problem_item_id);

                      FirebaseFirestore.instance
                        .collection("Users")
                        .doc(user1.uid)
                        .collection('Report')
                        .doc('ReportList')
                        .set({
                          "MarketReportList": reportList,
                          "UserReportList": reportUserList
                        });

                        FirebaseFirestore.instance
                            .collection("MarketReport")
                            .doc()
                            .set({
                          "ReporterUID": user1.uid,
                          "ReporterNickName": report_nickname,
                          "ProblemUID": problem_uid,
                          "ProblemNickName": problem_nickname,
                          "DateTime": formatDate(DateTime.now(),
                              [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                          "reason": "판매금지 품목입니다",
                          "ItemID": problem_item_id,
                        });

                        FirebaseFirestore.instance.collection('Market').doc(problem_item_id).update({
                          'reportCount': FieldValue.increment(1),
                        }).then((value) => print('ok'));

                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: Text('신고가 접수되었습니다.'),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context)..pop()..pop()..pop()..pop();
                                  }, 
                                  child: 
                                    Text('확인')
                                )  
                              ],
                            );                                
                          } 
                        );
                    }
                  },
                ),
                OutlinedButton(
                  child: Text("나가기"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          case 2:
            return AlertDialog(
              title: Text("신고"),
              content: Text("허위 및 악의적인 신고는 계정 정지 또는 삭제의 이유가 될 수 있습니다.\n\n중고거래 게시글이 아닙니까?"),
              actions: <Widget>[
                OutlinedButton(
                  child: Text("신고하기"),
                  onPressed: () async {
                    List<dynamic> reportList = [];
                    List<dynamic> reportUserList = [];

                    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
                    DocumentSnapshot snapshot = await ref.doc(user1.uid).collection('Report').doc('ReportList').get();
                    var data;    
                    data = snapshot.data() as Map;
                    reportList = data['MarketReportList'] as List<dynamic>;
                    reportUserList = data['UserReportList'] as List<dynamic>;
                    bool isReport = false;
                    reportList.forEach((element) {
                      if(problem_item_id == element) {
                        isReport = true;
                      }
                    });

                    if(isReport) {
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: Text('이미 신고한 게시글입니다.'),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context)..pop()..pop()..pop();
                                  }, 
                                  child: 
                                    Text('확인')
                                )  
                              ],
                            );                                
                          } 
                        );
                    } else {
                      reportList.add(problem_item_id);

                      FirebaseFirestore.instance
                        .collection("Users")
                        .doc(user1.uid)
                        .collection('Report')
                        .doc('ReportList')
                        .set({
                          "MarketReportList": reportList,
                          "UserReportList": reportUserList
                        });

                        FirebaseFirestore.instance
                            .collection("MarketReport")
                            .doc()
                            .set({
                          "ReporterUID": user1.uid,
                          "ReporterNickName": report_nickname,
                          "ProblemUID": problem_uid,
                          "ProblemNickName": problem_nickname,
                          "DateTime": formatDate(DateTime.now(),
                              [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                          "reason": "중고거래 게시글이 아닙니다.",
                          "ItemID": problem_item_id,
                        });

                        FirebaseFirestore.instance.collection('Market').doc(problem_item_id).update({
                          'reportCount': FieldValue.increment(1),
                        }).then((value) => print('ok'));

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
                                    //           MaterialPageRoute(builder:
                                    //               (BuildContext context) {
                                    //         return MarketMainPage(item_id: userAccount_.marketChatItem,);
                                    //       }));
                                  }, 
                                  child: 
                                    Text('확인')
                                )  
                              ],
                            );                                
                          } 
                        );
                    }
                  },
                ),
                OutlinedButton(
                  child: Text("나가기"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );

          case 3:
            return AlertDialog(
              title: Text("신고"),
              content: Text("허위 및 악의적인 신고는 계정 정지 또는 삭제의 이유가 될 수 있습니다.\n\n전문 판매업자로 신고하시겠습니까?"),
              actions: <Widget>[
                OutlinedButton(
                  child: Text("신고하기"),
                  onPressed: () async {
                    List<dynamic> reportList = [];
                    List<dynamic> reportUserList = [];

                    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
                    DocumentSnapshot snapshot = await ref.doc(user1.uid).collection('Report').doc('ReportList').get();
                    var data;    
                    data = snapshot.data() as Map;
                    reportList = data['MarketReportList'] as List<dynamic>;
                    reportUserList = data['UserReportList'] as List<dynamic>;
                    bool isReport = false;
                    reportList.forEach((element) {
                      if(problem_item_id == element) {
                        isReport = true;
                      }
                    });

                    if(isReport) {
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: Text('이미 신고한 게시글입니다.'),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context)..pop()..pop()..pop();
                                  }, 
                                  child: 
                                    Text('확인')
                                )  
                              ],
                            );                                
                          } 
                        );
                    } else {
                      reportList.add(problem_item_id);

                      FirebaseFirestore.instance
                        .collection("Users")
                        .doc(user1.uid)
                        .collection('Report')
                        .doc('ReportList')
                        .set({
                          "MarketReportList": reportList,
                          "UserReportList": reportUserList
                        });

                        FirebaseFirestore.instance
                            .collection("MarketReport")
                            .doc()
                            .set({
                          "ReporterUID": user1.uid,
                          "ReporterNickName": report_nickname,
                          "ProblemUID": problem_uid,
                          "ProblemNickName": problem_nickname,
                          "DateTime": formatDate(DateTime.now(),
                              [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                          "reason": "전문 판매업자 같습니다.",
                          "ItemID": problem_item_id,
                        });

                        FirebaseFirestore.instance.collection('Market').doc(problem_item_id).update({
                          'reportCount': FieldValue.increment(1),
                        }).then((value) => print('ok'));

                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: Text('신고가 접수되었습니다.'),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context)..pop()..pop()..pop()..pop();
                                  }, 
                                  child: 
                                    Text('확인')
                                )  
                              ],
                            );                                
                          } 
                        );
                    }
                  },
                ),
                OutlinedButton(
                  child: Text("나가기"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );

          case 4:
            return AlertDialog(
              title: Text("신고"),
              content: Text("허위 및 악의적인 신고는 계정 정지 또는 삭제의 이유가 될 수 있습니다.\n\n사기글 품목으로 신고하시겠습니까?"),
              actions: <Widget>[
                OutlinedButton(
                  child: Text("신고하기"),
                  onPressed: () async {
                    List<dynamic> reportList = [];
                    List<dynamic> reportUserList = [];

                    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
                    DocumentSnapshot snapshot = await ref.doc(user1.uid).collection('Report').doc('ReportList').get();
                    var data;    
                    data = snapshot.data() as Map;
                    reportList = data['MarketReportList'] as List<dynamic>;
                    reportUserList = data['UserReportList'] as List<dynamic>;
                    bool isReport = false;
                    reportList.forEach((element) {
                      if(problem_item_id == element) {
                        isReport = true;
                      }
                    });

                    if(isReport) {
                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: Text('이미 신고한 게시글입니다.'),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context)..pop()..pop()..pop();
                                  }, 
                                  child: 
                                    Text('확인')
                                )  
                              ],
                            );                                
                          } 
                        );
                    } else {
                      reportList.add(problem_item_id);

                      FirebaseFirestore.instance
                        .collection("Users")
                        .doc(user1.uid)
                        .collection('Report')
                        .doc('ReportList')
                        .set({
                          "MarketReportList": reportList,
                          "UserReportList": reportUserList
                        });

                        FirebaseFirestore.instance
                            .collection("MarketReport")
                            .doc()
                            .set({
                          "ReporterUID": user1.uid,
                          "ReporterNickName": report_nickname,
                          "ProblemUID": problem_uid,
                          "ProblemNickName": problem_nickname,
                          "DateTime": formatDate(DateTime.now(),
                              [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                          "reason": "사기 글 입니다.",
                          "ItemID": problem_item_id,
                        });

                        FirebaseFirestore.instance.collection('Market').doc(problem_item_id).update({
                          'reportCount': FieldValue.increment(1),
                        }).then((value) => print('ok'));

                        showDialog(
                          context: context, 
                          builder: (context) {
                            return AlertDialog(
                              title: Text('신고가 접수되었습니다.'),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context)..pop()..pop()..pop()..pop();
                                  }, 
                                  child: 
                                    Text('확인')
                                )  
                              ],
                            );                                
                          } 
                        );
                    }
                  },
                ),
                OutlinedButton(
                  child: Text("나가기"),
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

  // void _showTextReportDialog(BuildContext context, int check, String report_nickname) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       switch (check) {
  //         case 1:
  //           return AlertDialog(
  //             title: Text("신고"),
  //             content: Text("허위 및 악의적인 신고는 계정 정지 또는 삭제의 이유가 될 수 있습니다.\n\n판매금지 품목으로 신고하시겠습니까?"),
  //             actions: <Widget>[
  //               OutlinedButton(
  //                 child: Text("신고하기"),
  //                 onPressed: () async {
  //                   List<dynamic> reportList = [];

  //                   CollectionReference ref = FirebaseFirestore.instance.collection('Users');
  //                   DocumentSnapshot snapshot = await ref.doc(user1.uid).collection('Report').doc('ReportList').get();
  //                   var data;    
  //                   data = snapshot.data() as Map;
  //                   reportList = data['ReportItem'] as List<dynamic>;
  //                   bool isReport = false;
  //                   reportList.forEach((element) {
  //                     if(problem_item_id == element) {
  //                       isReport = true;
  //                     }
  //                   });

  //                   if(isReport) {
  //                       showDialog(
  //                         context: context, 
  //                         builder: (context) {
  //                           return AlertDialog(
  //                             title: Text('이미 신고한 게시글입니다.'),
  //                             actions: [
  //                               OutlinedButton(
  //                                 onPressed: () {
  //                                   Navigator.of(context)..pop()..pop()..pop();
  //                                 }, 
  //                                 child: 
  //                                   Text('확인')
  //                               )  
  //                             ],
  //                           );                                
  //                         } 
  //                       );
  //                   } else {
  //                     reportList.add(problem_item_id);

  //                     FirebaseFirestore.instance
  //                       .collection("Users")
  //                       .doc(user1.uid)
  //                       .collection('Report')
  //                       .doc('ReportList')
  //                       .set({
  //                         "ReportItem": reportList
  //                       });

  //                       FirebaseFirestore.instance
  //                           .collection("MarketReport")
  //                           .doc()
  //                           .set({
  //                         "ReporterUID": user1.uid,
  //                         "ReporterNickName": report_nickname,
  //                         "ProblemUID": problem_uid,
  //                         "ProblemNickName": problem_nickname,
  //                         "DateTime": formatDate(DateTime.now(),
  //                             [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
  //                         "reason": "판매금지 품목입니다",
  //                         "ItemID": problem_item_id,
  //                       });

  //                       FirebaseFirestore.instance.collection('Market').doc(problem_item_id).update({
  //                         'reportCount': FieldValue.increment(1),
  //                       }).then((value) => print('ok'));

  //                       showDialog(
  //                         context: context, 
  //                         builder: (context) {
  //                           return AlertDialog(
  //                             title: Text('신고가 접수되었습니다.'),
  //                             actions: [
  //                               OutlinedButton(
  //                                 onPressed: () {
  //                                   Navigator.of(context)..pop()..pop()..pop()..pop();
  //                                 }, 
  //                                 child: 
  //                                   Text('확인')
  //                               )  
  //                             ],
  //                           );                                
  //                         } 
  //                       );
  //                   }
  //                     // FirebaseFirestore.instance
  //                     //     .collection("MarketReport")
  //                     //     .doc()
  //                     //     .set({
  //                     //   "ReporterUID": user1.uid,
  //                     //   "ReporterNickName": report_nickname,
  //                     //   "ProblemUID": problem_uid,
  //                     //   "ProblemNickName": problem_nickname,
  //                     //   "DateTime": formatDate(DateTime.now(),
  //                     //       [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
  //                     //   "reason": "판매금지 품목입니다",
  //                     //   "ItemID": problem_item_id,
  //                     // });
  //                     //Navigator.of(context)..pop()..pop()..pop();
  //                 },
  //               ),
  //               OutlinedButton(
  //                 child: Text("나가기"),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //         case 2:
  //           return AlertDialog(
  //             title: Text("신고"),
  //             content: Text("중고거래 게시글이 아닙니까?"),
  //             actions: <Widget>[
  //               ElevatedButton(
  //                 child: Text("신고하기"),
  //                 onPressed: () async {
  //                   try {
  //                     FirebaseFirestore.instance
  //                         .collection("MarketReport")
  //                         .doc()
  //                         .set({
  //                       "ReporterUID": user1.uid,
  //                       "ReporterNickName": report_nickname,
  //                       "ProblemUID": problem_uid,
  //                       "ProblemNickName": problem_nickname,
  //                       "DateTime": formatDate(DateTime.now(),
  //                           [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
  //                       "reason": "중고거래 게시글이 아닙니다",
  //                       "ItemID": problem_item_id,
  //                     });
  //                     Navigator.of(context)..pop()..pop()..pop();
  //                   } catch (e) {
  //                     print(e);
  //                   }
  //                 },
  //               ),
  //               ElevatedButton(
  //                 child: Text("나가기"),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );

  //         case 3:
  //           return AlertDialog(
  //             title: Text("신고"),
  //             content: Text("전문 판매업자로 신고하시겠습니까?"),
  //             actions: <Widget>[
  //               ElevatedButton(
  //                 child: Text("신고하기"),
  //                 onPressed: () async {
  //                   try {
  //                     FirebaseFirestore.instance
  //                         .collection("MarketReport")
  //                         .doc()
  //                         .set({
  //                       "ReporterUID": user1.uid,
  //                       "ReporterNickName": report_nickname,
  //                       "ProblemUID": problem_uid,
  //                       "ProblemNickName": problem_nickname,
  //                       "DateTime": formatDate(DateTime.now(),
  //                           [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
  //                       "reason": "전문 판매업자 같습니다",
  //                       "ItemID": problem_item_id,
  //                     });
  //                     Navigator.of(context)..pop()..pop()..pop();
  //                   } catch (e) {
  //                     print(e);
  //                   }
  //                 },
  //               ),
  //               ElevatedButton(
  //                 child: Text("나가기"),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );

  //         case 4:
  //           return AlertDialog(
  //             title: Text("신고"),
  //             content: Text("사기 글 품목으로 신고하시겠습니까?"),
  //             actions: <Widget>[
  //               ElevatedButton(
  //                 child: Text("신고하기"),
  //                 onPressed: () async {
  //                   try {
  //                     FirebaseFirestore.instance
  //                         .collection("MarketReport")
  //                         .doc()
  //                         .set({
  //                       "ReporterUID": user1.uid,
  //                       "ReporterNickName": report_nickname,
  //                       "ProblemUID": problem_uid,
  //                       "ProblemNickName": problem_nickname,
  //                       "DateTime": formatDate(DateTime.now(),
  //                           [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
  //                       "reason": "사기 글입니다",
  //                       "ItemID": problem_item_id,
  //                     });
  //                     Navigator.of(context)..pop()..pop()..pop();
  //                   } catch (e) {
  //                     print(e);
  //                   }
  //                 },
  //               ),
  //               ElevatedButton(
  //                 child: Text("나가기"),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           );
  //       }
  //       return Text("실패");
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {

    String terms = '제 12조 (게시물 또는 콘텐츠)\n'
    '①회사는 서비스 내에 회원이 매칭할 수 있는 콘텐츠를 용도별로 구분하여 제공하며 각 콘텐츠의 용도에 대하여 서비스를 통해 공지합니다. 단, 콘텐츠 이름만으로 그 용도가 명확하게 인지되는 경우에는 별도로 공지하지 않을 수 있습니다.\n'
    '②회사는 회원에 대해 회사정책에 따라 회원별로 구분하여 이용시간, 이용횟수, 서비스 메뉴 등을 세분하여 이용(새로운 기능 및 서비스 등)에 차등을 둘 수 있습니다.\n'
    '③회사는 회원이 서비스 내에 게시하거나 전달하는 모든 내용물(회원간 전달 포함)이 다음 각 호에 해당한다고 판단될 경우 사전 통보 없이 게시 중단, 이동, 삭제 등의 조치를 취할 수 있고, 필요하다고 판단되는 경우 해당 회원의 서비스 이용 자격을 제한하거나 정지, 상실시킬 수 있습니다. 또한 신고가 접수 된 게시물은 GMT+9 (한국시간)기준 평일, 월~금 18:00 일괄 검토하여 이용약관 제 12조에 따라 처리됩니다.\n'
    '1. 회사, 다른 회원 또는 제3자에 대한 인신공격, 비방, 욕설, 명예훼손 내용이 포함된 경우\n'
    '2. 공공질서 및 미풍양속에 위반되는 내용을 유포하는 경우\n'
    '3. 위법행위, 범죄행위와 결부되는 내용인 경우'
    '4. 회사, 다른 회원 또는 제3자의 저작권이나 초상권 등 기타 권리를 침해하는 내용일 경우'
    '5. 회사의 운영진, 직원 또는 관계자를 사칭하는 게시물인 경우'
    '6. 회사가 승인하지 않은 광고, 홍보물을 게시한 경우'
    '7. 타인에게 불쾌감을 주거나 회원간 분쟁을 야기하는 내용으로서, 이러한 분쟁으로 회사의 업무가 방해되거나 방해되리라고 판단되는 경우'
    '8. 제1항에서 지정한 용도에 맞지 않는 내용을 게시한 경우'
    '9. 기타 관계법령에 위배되거나, 회사에서 정한 매칭 원칙에 어긋나는 경우'
    '10. 다른 회원의 신고가 접수된 경우'
    '11. 다른 회원의 신고가 접수되어 신고내용이 위 각 호에 해당하는 경우';

    UserAccountInfo userAccount_ = Provider.of(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        title:
            SvgPicture.asset(
          'assets/images/SVG/LOGO_KAMMON_small.svg',
          width: 110,
        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                    child: Text(
                      "게시글을 신고하는 이유를 선택해주세요",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'GSANSB',
                          fontSize: 15.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: Column(
                      children: [
                        Divider(
                            thickness: 1.5,
                            height: 1.5,
                            color: Colors.grey[200]
                        ),
                        ListTile(
                          onTap: () {
                            _showTextReportDialog(context, 1, userAccount_.nickname);
                          },
                          title: Text(
                            "판매금지 품목입니다",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'GSANSM',
                                fontSize: 14.0),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black,
                            size: 30.0,
                          )
                        ),
                        Divider(
                          thickness: 1.5,
                          height: 1.5,
                          color: Colors.grey[200]
                        ),
                        ListTile(
                          onTap: () {
                            _showTextReportDialog(
                                context, 2, userAccount_.nickname);
                          },
                          title: Text(
                            "중고거래 게시글이 아닙니다",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'GSANSM',
                                fontSize: 14.0),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black,
                            size: 30.0,
                          )
                        ),
                        Divider(
                          thickness: 1.5,
                          height: 1.5,
                          color: Colors.grey[200]
                        ),
                        ListTile(
                          onTap: () {
                            _showTextReportDialog(
                                context, 3, userAccount_.nickname);
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
                          )
                        ),
                        Divider(
                          thickness: 1.5,
                          height: 1.5,
                          color: Colors.grey[200]
                        ),
                        ListTile(
                          onTap: () {
                            _showTextReportDialog(
                                context, 4, userAccount_.nickname);
                          },
                          title: Text(
                            "사기 글입니다",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'GSANSM',
                                fontSize: 14.0),
                          ),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black,
                            size: 30.0,
                          )
                        ),
                        Divider(
                          thickness: 1.5,
                          height: 1.5,
                          color: Colors.grey[200]
                        ),
                      ],
                    ),
                  )
                  
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Text('신고가 접수된 글은 한국시간 기준 월요일 ~ 금요일 18:00에 일괄적으로 검토하여 이용약관에 따라 처리됩니다.',
                        style: TextStyle(
                          height: 2.0,
                          color: Colors.grey[600],
                          fontFamily: 'GSANSM',
                          fontSize: 12.0)
                      ),
                      SizedBox(height: 20,),
                      Text(terms,
                        style: TextStyle(
                          height: 2.0,
                          color: Colors.grey[600],
                          fontFamily: 'GSANSM',
                          fontSize: 12.0),
                      ),
                    ],
                  )
                )
              ),
            ),
            SizedBox(height: 20,),
          ],
        )
      ),
    );
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: AppBar(
    //     backgroundColor: Color(0xFFFFFFFF),
    //     iconTheme: IconThemeData(color: Colors.grey),
    //     title:
    //         SvgPicture.asset(
    //       'assets/images/SVG/LOGO_KAMMON_small.svg',
    //       width: 110,
    //     ),
    //     actions: [],
    //     centerTitle: true,
    //     elevation: 0,
    //   ),
    //   body: SafeArea(
    //     child: Container(
    //       //color: Colors.amberAccent,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
    //           Padding(
    //             padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
    //             child: Text(
    //               "게시글을 신고하는 이유를 선택해주세요",
    //               style: TextStyle(
    //                   color: Colors.black,
    //                   fontFamily: 'GSANSB',
    //                   fontSize: 15.0),
    //             ),
    //           ),
    //           Container(
    //             color: Colors.amberAccent,
    //             // width: MediaQuery.of(context).size.width,
    //             // height: MediaQuery.of(context).size.height - 300,
    //             child: Expanded(
    //               child: Padding(
    //                 padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
    //                 child: ListView(
    //                   physics: NeverScrollableScrollPhysics(),
    //                   children: [
    //                     Divider(
    //                         thickness: 1.5,
    //                         height: 1.5,
    //                         color: Colors.grey[200]),
    //                     ListTile(
    //                         onTap: () {
    //                           _showTextReportDialog(
    //                               context, 1, userAccount_.nickname);
    //                         },
    //                         title: Text(
    //                           "판매금지 품목입니다",
    //                           style: TextStyle(
    //                               color: Colors.black,
    //                               fontFamily: 'GSANSM',
    //                               fontSize: 14.0),
    //                         ),
    //                         trailing: Icon(
    //                           Icons.keyboard_arrow_right,
    //                           color: Colors.black,
    //                           size: 30.0,
    //                         )),
    //                     Divider(
    //                         thickness: 1.5,
    //                         height: 1.5,
    //                         color: Colors.grey[200]),
    //                     ListTile(
    //                         onTap: () {
    //                           _showTextReportDialog(
    //                               context, 2, userAccount_.nickname);
    //                         },
    //                         title: Text(
    //                           "중고거래 게시글이 아닙니다",
    //                           style: TextStyle(
    //                               color: Colors.black,
    //                               fontFamily: 'GSANSM',
    //                               fontSize: 14.0),
    //                         ),
    //                         trailing: Icon(
    //                           Icons.keyboard_arrow_right,
    //                           color: Colors.black,
    //                           size: 30.0,
    //                         )),
    //                     Divider(
    //                         thickness: 1.5,
    //                         height: 1.5,
    //                         color: Colors.grey[200]),
    //                     ListTile(
    //                         onTap: () {
    //                           _showTextReportDialog(
    //                               context, 3, userAccount_.nickname);
    //                         },
    //                         title: Text(
    //                           "전문 판매업자 같습니다",
    //                           style: TextStyle(
    //                               color: Colors.black,
    //                               fontFamily: 'GSANSM',
    //                               fontSize: 14.0),
    //                         ),
    //                         trailing: Icon(
    //                           Icons.keyboard_arrow_right,
    //                           color: Colors.black,
    //                           size: 30.0,
    //                         )),
    //                     Divider(
    //                         thickness: 1.5,
    //                         height: 1.5,
    //                         color: Colors.grey[200]),
    //                     ListTile(
    //                         onTap: () {
    //                           _showTextReportDialog(
    //                               context, 4, userAccount_.nickname);
    //                         },
    //                         title: Text(
    //                           "사기 글입니다",
    //                           style: TextStyle(
    //                               color: Colors.black,
    //                               fontFamily: 'GSANSM',
    //                               fontSize: 14.0),
    //                         ),
    //                         trailing: Icon(
    //                           Icons.keyboard_arrow_right,
    //                           color: Colors.black,
    //                           size: 30.0,
    //                         )),
    //                     Divider(
    //                         thickness: 1.5,
    //                         height: 1.5,
    //                         color: Colors.grey[200]),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Expanded(
    //             child: SingleChildScrollView(
    //               child: Container(
    //                 //color: Colors.lightBlue,
    //                 child: Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
    //                   child: Column(
    //                     children: [
    //                       Text('신고가 접수된 글은 한국시간 기준 월요일 ~ 금요일 18:00에 일괄적으로 검토하여 이용약관에 따라 처리됩니다.',
    //                         style: TextStyle(
    //                           height: 2.0,
    //                           color: Colors.grey[600],
    //                           fontFamily: 'GSANSM',
    //                           fontSize: 12.0)
    //                       ),
    //                       SizedBox(height: 20,),
    //                       Text(terms,
    //                         style: TextStyle(
    //                           height: 2.0,
    //                           color: Colors.grey[600],
    //                           fontFamily: 'GSANSM',
    //                           fontSize: 12.0),
    //                       ),
    //                     ],
    //                   )
    //                 )
    //               ),
    //             ),
    //           )
              

    //           // Padding(
    //           //     padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
    //           //     child: Column(
    //           //       crossAxisAlignment: CrossAxisAlignment.start,
    //           //       children: [
    //           //         Text(
    //           //           "게시글을 신고하는 이유를 선택해주세요",
    //           //           style: TextStyle(
    //           //               color: Colors.black,
    //           //               fontFamily: 'GSANSB',
    //           //               fontSize: 15.0),
    //           //         ),
    //           //         SizedBox(
    //           //           height: 30,
    //           //         ),
    //           //         Divider(
    //           //             thickness: 1.5, height: 1.5, color: Colors.grey[200]),
    //           //         Padding(
    //           //           padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
    //           //           child: TextButton(
    //           //               onPressed: () {},
    //           //               child: Text(
    //           //                 "판매금지 품목입니다",
    //           //                 style: TextStyle(
    //           //                     color: Colors.black,
    //           //                     fontFamily: 'GSANSM',
    //           //                     fontSize: 14.0),
    //           //               )),
    //           //         ),
    //           //         Divider(
    //           //             thickness: 1.5, height: 1.5, color: Colors.grey[200]),
    //           //         Padding(
    //           //           padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
    //           //           child: TextButton(
    //           //               onPressed: () {},
    //           //               child: Text(
    //           //                 "중고거래 게시글이 아닙니다",
    //           //                 style: TextStyle(
    //           //                     color: Colors.black,
    //           //                     fontFamily: 'GSANSM',
    //           //                     fontSize: 14.0),
    //           //               )),
    //           //         ),
    //           //         Divider(
    //           //             thickness: 1.5, height: 1.5, color: Colors.grey[200]),
    //           //         Padding(
    //           //             padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
    //           //             child: Row(
    //           //               children: [
    //           //                 TextButton(
    //           //                     onPressed: () {},
    //           //                     child: Text(
    //           //                       "전문 판매업자 같습니다",
    //           //                       style: TextStyle(
    //           //                           color: Colors.black,
    //           //                           fontFamily: 'GSANSM',
    //           //                           fontSize: 14.0),
    //           //                     )),
    //           //                 SizedBox(
    //           //                   width: 120,
    //           //                 ),
    //           //                 Icon(
    //           //                   Icons.keyboard_arrow_right,
    //           //                   color: Colors.black,
    //           //                   size: 30.0,
    //           //                 )
    //           //               ],
    //           //             )),
    //           //         Divider(
    //           //             thickness: 1.5, height: 1.5, color: Colors.grey[200]),
    //           //         Padding(
    //           //             padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
    //           //             child: Row(
    //           //               children: [
    //           //                 TextButton(
    //           //                     onPressed: () {},
    //           //                     child: Text(
    //           //                       "사기 글입니다",
    //           //                       style: TextStyle(
    //           //                           color: Colors.black,
    //           //                           fontFamily: 'GSANSM',
    //           //                           fontSize: 14.0),
    //           //                     )),
    //           //                 SizedBox(
    //           //                   width: 200,
    //           //                 ),
    //           //                 Icon(
    //           //                   Icons.keyboard_arrow_right,
    //           //                   color: Colors.black,
    //           //                   size: 30.0,
    //           //                 )
    //           //               ],
    //           //             )),
    //           //         Divider(
    //           //             thickness: 1.5, height: 1.5, color: Colors.grey[200]),
    //           //       ],
    //           //     )
    //           //     )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

// void _showTextReportDialog(BuildContext context, int check) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       switch (check) {
//         case 1:
//           return AlertDialog(
//             title: Text("신고"),
//             content: Text("판매금지 품목으로 신고하시겠습니까?"),
//             actions: <Widget>[
//               ElevatedButton(
//                 child: Text("나가기"),
//                 onPressed: () async {
//                   FirebaseFirestore.instance
//                       .collection("MarketReport")
//                       .doc()
//                       .set({
//                         "신고자" : 
//                       });
//                 },
//               ),
//               ElevatedButton(
//                 child: Text("나가기"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//       }
//       return Text("실패");
//     },
//   );
// }
