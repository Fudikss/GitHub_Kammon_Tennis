import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/match/match_edit.dart';
import 'package:snstennis/match/match_tab_page_1_0.dart';
import 'package:snstennis/match/start_game.dart';

class MatchWait extends StatefulWidget {
  MatchWait({Key? key, required this.match_uid, required this.master_uid}) : super(key: key);

  final String match_uid;
  final String master_uid;
  @override
  _MatchWaitState createState() => _MatchWaitState(match_uid, master_uid);
}

class _MatchWaitState extends State<MatchWait> {
  _MatchWaitState(this.match_uid, this.master_uid);
  final scaffoldkey = GlobalKey<ScaffoldState>();

  final String match_uid;
  User? user = FirebaseAuth.instance.currentUser;
  var isMember = false;
  late final String master_uid;
  late UserAccountInfo user_account_info_;

  TextEditingController input_id = TextEditingController();
  Map<String, dynamic> data = Map();
  var max_player = 0;
  var cur_player = 0;
  var matchType = 0;

  @override
  void initState() {
    super.initState();
  }

  void _insertUserJoinMatch() async{
    CollectionReference ref = FirebaseFirestore.instance.collection('Match');
    DocumentSnapshot snapshot = await ref.doc(match_uid).get();
    var data = snapshot.data() as Map;

    for(int i = 0; i < data['player_cnt']; i++) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(data['member_uid'][i])
          .update({
        "join_match_list": FieldValue.arrayUnion([match_uid])
      });
    }
  }

  void startMatch() {
    if (master_uid != user!.uid) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("방장만 시작이 가능합니다."),
              actions: <Widget>[
                OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('확인'))
              ],
            );
          });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor,
            title: Center(child: Text("\nLET'S COMON !", style: TextStyle(color: Colors.white),)),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 10
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                      height:20,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StartGame(matchUid: match_uid, prevPage: 'wait_list', matchType: matchType, )
                            )
                          );
                        },
                        style: OutlinedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(side: BorderSide(
                              color: Colors.blue,
                              width: 1,
                              style: BorderStyle.solid
                            ), borderRadius: BorderRadius.circular(5)),
                          elevation: 1
                        ),
                        child: Text('OK', style: TextStyle(fontFamily: 'GSANSB', fontSize: 12))
                      )
                    ),
                    SizedBox(
                      height: 20,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(side: BorderSide(
                            color: Colors.blue,
                            width: 1,
                            style: BorderStyle.solid
                          ), borderRadius: BorderRadius.circular(5)),
                          elevation: 1
                        ),
                        child: Text('NO', style: TextStyle(fontFamily: 'GSANSB', fontSize: 12),)
                      ),
                    ), 
                    SizedBox(
                      width: 30,
                    ),                     
                  ],
                )
              ],
            ),
          );
        });
    }
  }

  Future<List<dynamic>> getData(String match_uid, String category) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('Match');
    DocumentSnapshot snapshot = await ref.doc(match_uid).get();

    var data = snapshot.data() as Map;
    var ls = data[category] as List<dynamic>;

    return ls;
  }

  void addMember(String id) async {
    bool existMember = false;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Users')
        .where('id', isEqualTo: id)
        .get();

    List<QueryDocumentSnapshot> docs = snapshot.docs;
    
    var doc;
    for (doc in docs) {
      if (doc.data() != null) {
        existMember = true;
      }
    }

    List<dynamic> uid_list = [];
    List<dynamic> nickname_list = [];
    List<dynamic> idx_list = [];
    List<dynamic> token_list = [];
    List<dynamic> member_score_list = [];
    List<dynamic> record_list = [];

    CollectionReference ref = FirebaseFirestore.instance.collection('Match');
    DocumentSnapshot snapshotd = await ref.doc(match_uid).get();
    User? user = FirebaseAuth.instance.currentUser;

    firestore.collection('Match').doc(match_uid).update({
      'player_cur': FieldValue.increment(1),
    }).then((value) => print('ok'));
    
    var data;    
    data = snapshotd.data() as Map;

    uid_list = data['member_uid'] as List<dynamic>;
    nickname_list = data['member_nickname'] as List<dynamic>;
    idx_list = data['member_idx'] as List<dynamic>;
    token_list = data['member_fcm_token'] as List<dynamic>;
    var score = data['player_score'] as List<dynamic>;

    idx_list.add(0);
    token_list.add(' ');
    
    score.add({
      'GAME 1': '0:0',
      'GAME 2': '0:0', 
      'GAME 3': '0:0', 
      'GAME 4': '0:0', 
      'Confirm GAME 1': '0:0', 
      'Confirm GAME 2': '0:0', 
      'Confirm GAME 3': '0:0', 
      'Confirm GAME 4': '0:0', 
      });
    
    if (existMember) {      //존재하는 사용자일 경우
      uid_list.add(doc.id);
      nickname_list.add(doc.data()['nickname']);
    }
    else {                  //존재하지 않는 사용자일 경우
      uid_list.add('#');
      nickname_list.add(id);      
    }

    var docId = firestore.collection('Match').doc(match_uid);
    docId.set({
      'member_uid': uid_list,
      'member_nickname': nickname_list,
      'member_idx': idx_list,
      'member_fcm_token': token_list,
      'player_score' : score,
    }, SetOptions(merge: true));

    snapshotd = await ref.doc(match_uid).collection('Record').doc('RecordList').get();
    data = snapshotd.data() as Map;

    record_list = data['List'];

    if(existMember) {
      record_list.add({
        'uid' : doc.id,
        'nickname' : doc.data()['nickname'],
        'win' : 0, 
        'draw' : 0, 
        'loss' : 0,
        'rank' : '0',
        'win_point' : 0,
        'loss_point' : 0
      });
    } else {
      record_list.add({
        'uid' : '#',
        'nickname' : id,
        'win' : 0, 
        'draw' : 0, 
        'loss' : 0,
        'rank' : '0',
        'win_point' : 0,
        'loss_point' : 0
      });
    }

    var docRecord = firestore.collection('Match').doc(match_uid).collection('Record').doc('RecordList');
    docRecord.set({ 'List' : record_list});
  }

  void addMatchMemberDlg() {
    input_id.clear();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('사용자 추가'),
            content: TextField(
              controller: input_id,
            ),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () {
                  if(input_id.text != '') {
                    addMember(input_id.text);
                    Navigator.of(context).pop();
                  } else {
                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('닉네임을 입력하세요'),
                        actions: [

                        ],
                      );
                    });
                  }                  
                },
                child: Text("추가하기"),
              ),
            ],
          );
        });
  }

  void deleteMatch() async {
    await FirebaseFirestore.instance.collection('Match').doc(match_uid).collection('Record').doc('RecordList').delete();
    await FirebaseFirestore.instance.collection('Match').doc(match_uid).delete();
  }

  Widget  _matchInfo() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Match').doc(match_uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(snapshot.hasData) {
          var name;                          
          name = snapshot.data!.get('name');
          max_player = snapshot.data!.get('player_cnt');
          cur_player = snapshot.data!.get('player_cur');
          //master_uid = snapshot.data!.get('master.uid');
          matchType = snapshot.data!.get('types');
          return Container(
            child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    //color: Colors.blueGrey[100],
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Align(
                          //   alignment: Alignment(-1, 0),
                            //child: 
                            Text(name, style: TextStyle(fontSize: 22, fontFamily: 'GSANSB', color: Colors.grey[700])),
                          //),
                          user_account_info_.uid == master_uid ?
                          Container(
                            //color: Colors.blueGrey[300],
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // TextButton(
                                //   onPressed: () {
                                //     Navigator.of(context).push(
                                //       MaterialPageRoute(
                                //         builder: (context) => MatchEdit(matchUid: match_uid, title: name, playerCnt: max_player, type: matchType, masterJoinState: snapshot.data!.get('master.joinState'),)
                                //       )
                                //     );
                                //   },
                                //   child: Text('수정', style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[600]),)
                                // ),
                                // SizedBox(
                                //   width: 40,
                                //   height: 25,
                                //   child: TextButton(
                                //     onPressed: () {
                                //       showDialog(
                                //         context: context, 
                                //         builder: (BuildContext context) {
                                //           return AlertDialog(
                                //             title: Text('정말 삭제하시겠습니까?', style: TextStyle(fontFamily: 'GSANSM', fontSize: 16, color: Colors.grey[600])),
                                //             actions: <Widget>[
                                //               OutlinedButton(
                                //                 onPressed: () {
                                //                   deleteMatch();
                                //                   Navigator.of(context).push(
                                //                     MaterialPageRoute(
                                //                       builder: (BuildContext context) => MatchTabPage(),
                                //                     ),
                                //                   );
                                //                 },
                                //                 child: Text("확인"),
                                //               ),
                                //               OutlinedButton(
                                //                 onPressed: () {
                                //                   Navigator.of(context).pop();
                                //                 },
                                //                 child: Text("취소"),
                                //               ),
                                //             ],
                                //           );
                                //         }
                                //       );
                                //     },
                                //     style: OutlinedButton.styleFrom(
                                //       primary: Theme.of(context).primaryColor,
                                //       backgroundColor: Colors.white,
                                //       shape: RoundedRectangleBorder(side: BorderSide(
                                //         color: Theme.of(context).primaryColor,
                                //         width: 1,
                                //         style: BorderStyle.solid
                                //       ), 
                                //       borderRadius: BorderRadius.circular(20)),
                                //       elevation: 0
                                //     ),
                                //     child: Text('삭제', style: TextStyle(fontSize: 8, fontFamily: 'GSANSB', color: Theme.of(context).primaryColor),)
                                //   ),
                                // ),
                              ],
                            )
                          )
                          :
                          Container()
                        ]
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  //   child: Align(
                  //     alignment: Alignment(-1, 0),
                  //     child: Text(name, style: TextStyle(fontSize: 22, fontFamily: 'GSANSB', color: Colors.grey[700]))
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 50,
                                child: 
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: 
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                  EdgeInsets.fromLTRB(0, 0, 5, 0),
                                                child: Text(
                                                  '총 참가인원 >',
                                                  style: TextStyle(fontSize: 13, fontFamily: 'GSANSB', color: Colors.grey[600])
                                                ),
                                              ),
                                              Text(
                                                max_player.toString(),
                                                style: TextStyle(fontSize: 13, fontFamily: 'GSANSB', color: Colors.grey[600])
                                              )
                                            ],
                                          ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: 
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                  EdgeInsets.fromLTRB(0, 0, 5, 0),
                                                child: Text(
                                                  '현재 참가인원 >',
                                                  style: TextStyle(fontSize: 13, fontFamily: 'GSANSB', color: Colors.grey[600])
                                                ),
                                              ),
                                              Text(
                                                cur_player.toString(),
                                                style: TextStyle(fontSize: 13, fontFamily: 'GSANSB', color: Colors.grey[600])
                                              )
                                            ],
                                          ),
                                      )
                                    ],
                                  ),
                              ),
                              SizedBox(width: 80,),
                              Expanded(
                                flex: 50,
                                child: 
                                  OutlinedButton(
                                    onPressed: () {
                                      if (master_uid.toString() == user!.uid.toString()) {
                                        if (cur_player < max_player) {
                                          addMatchMemberDlg();
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('인원이 다 찼습니다.'),
                                                  actions: <Widget>[
                                                    OutlinedButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text("확인"),
                                                    ),
                                                  ],
                                                );
                                              });
                                        }
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('방장만 가능합니다.'),
                                                actions: <Widget>[
                                                  OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text("확인"),
                                                  )
                                                ],
                                              );
                                            });
                                      }                                             
                                    },
                                    style: OutlinedButton.styleFrom(
                                      primary: Colors.white,
                                      backgroundColor: Colors.grey[350],
                                      shape: RoundedRectangleBorder(side: BorderSide(
                                        color: Colors.blue,
                                        width: 1,
                                        style: BorderStyle.solid
                                      ), 
                                      borderRadius: BorderRadius.circular(10)),
                                      elevation: 3
                                    ),
                                    child: Text('인원추가',
                                    style: TextStyle(color: Colors.grey[700], fontFamily: 'GSANSB'),),)
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  )
                ],
              ),
          );
        } else {
          return Container();
        }
      }
    );
  }

  Widget _playerInfo() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Match').doc(match_uid).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          var d;
          d = snapshot.data!.get('member_nickname');
          return ListView.separated(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            itemCount: d.length,
            itemBuilder: (_, int index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: 
                        Row(
                          children: [
                            Text(
                              d[index], 
                              style: TextStyle(
                                color: Colors.grey[700], 
                                fontFamily: 'GSANSM'),
                            ),
                          ],
                        ),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, idx) {
              return Container(height: 5, color: Colors.white,);
            }, 
          );
        } else {
          return Container();
        }
      }
    );
  }

  Widget _bottomButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: 
        Padding(
          padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
          child: 
            OutlinedButton(
              onPressed: () {
                if (max_player <= cur_player) {
                  startMatch();
                } 
                else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("모집이 완료되지 않았습니다.", style: TextStyle(fontFamily: 'GSANSM', fontSize: 16),),
                        actions: <Widget>[
                          OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('확인'))
                        ],
                      );
                    });
                }                 
              },          
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(side: BorderSide(
                  color: Colors.blue,
                  width: 1,
                  style: BorderStyle.solid
                ), borderRadius: BorderRadius.circular(50)),
                elevation: 3
              ),
              child: 
                Text('GAME START', 
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'GSANSB',
                    fontWeight: FontWeight.w700
                  ),
                ),
            ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    user_account_info_ = Provider.of<UserAccountInfo>(context, listen: false);
    CollectionReference matchRef = FirebaseFirestore.instance.collection('Match');

    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Colors.white,
      //endDrawer: Drawer(child:HamburgerMenu()),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        title: 
          SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
          //SvgPicture.asset('assets/images/SVG/logo.svg', width: 150,),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MatchTabPage()
                )
              );
            },
            icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          user_account_info_.uid == master_uid ?
          TextButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('정말 삭제하시겠습니까?', style: TextStyle(fontFamily: 'GSANSM', fontSize: 16, color: Colors.grey[600])),
                      actions: <Widget>[
                        OutlinedButton(
                          onPressed: () {
                            deleteMatch();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => MatchTabPage(),
                              ),
                            );
                          },
                          child: Text("확인"),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("취소"),
                        ),
                      ],
                    );
                  }
                );
              },
              child: Text(
                "게시글 삭제",
                style: TextStyle(color: Colors.black, fontFamily: "GSANSM"),
              )
          )
          :
          Container()
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body:
        SafeArea(
          child: 
            SingleChildScrollView(
              child: 
                Container(
                  width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height * 1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: 
                    Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            //flex: 20,
                            //height: MediaQuery.of(context).size.height * 0.2,
                            child: 
                              Padding(
                                padding: EdgeInsets.fromLTRB(15, 20, 5, 0),
                                child: Align(
                                  alignment: Alignment(-1, 0),
                                  child: 
                                    _matchInfo()
                                ),
                              ),
                          ),
                          Container(
                            //flex: 60,
                            //height: 300,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: 
                              _playerInfo()
                          ),
                          Container(
                            //flex: 20,
                            //height: MediaQuery.of(context).size.height * 0.2,
                            child: 
                              _bottomButton()
                          ),
                        ]
                      ),
                    ),
                )
            )
        ),
    );
  }
}









//1.0.0.+7
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/match/match_tab_page_1_0.dart';
// import 'package:snstennis/match/start_game.dart';

// class MatchWait extends StatefulWidget {
//   MatchWait({Key? key, required this.match_uid}) : super(key: key);

//   final String match_uid;
//   @override
//   _MatchWaitState createState() => _MatchWaitState(match_uid);
// }

// class _MatchWaitState extends State<MatchWait> {
//   _MatchWaitState(this.match_uid);
//   final scaffoldkey = GlobalKey<ScaffoldState>();

//   final String match_uid;
//   User? user = FirebaseAuth.instance.currentUser;
//   var isMember = false;
//   String master_uid = '';
//   late UserAccountInfo user_account_info_;

//   TextEditingController input_id = TextEditingController();
//   Map<String, dynamic> data = Map();
//   var max_player = 0;
//   var cur_player = 0;
//   var matchType = 0;

//   @override
//   void initState() {
//     super.initState();
//   }

//   void _insertUserJoinMatch() async{
//     CollectionReference ref = FirebaseFirestore.instance.collection('Match');
//     DocumentSnapshot snapshot = await ref.doc(match_uid).get();
//     var data = snapshot.data() as Map;

//     for(int i = 0; i < data['player_cnt']; i++) {
//       await FirebaseFirestore.instance
//           .collection("Users")
//           .doc(data['member_uid'][i])
//           .update({
//         "join_match_list": FieldValue.arrayUnion([match_uid])
//       });
//     }
//   }

//   void startMatch() {
//     if (master_uid != user!.uid) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text("방장만 시작이 가능합니다."),
//               actions: <Widget>[
//                 OutlinedButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('확인'))
//               ],
//             );
//           });
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             backgroundColor: Theme.of(context).primaryColor,
//             title: Center(child: Text("\nLET'S COMON !", style: TextStyle(color: Colors.white),)),
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 SizedBox(
//                   height: 10
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     SizedBox(
//                       width: 30,
//                     ),
//                     SizedBox(
//                       height:20,
//                       child: OutlinedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();

//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (context) => StartGame(matchUid: match_uid, prevPage: 'wait_list', matchType: matchType, )
//                             )
//                           );
//                         },
//                         style: OutlinedButton.styleFrom(
//                             primary: Theme.of(context).primaryColor,
//                             backgroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(side: BorderSide(
//                               color: Colors.blue,
//                               width: 1,
//                               style: BorderStyle.solid
//                             ), borderRadius: BorderRadius.circular(5)),
//                           elevation: 1
//                         ),
//                         child: Text('OK', style: TextStyle(fontFamily: 'GSANSB', fontSize: 12))
//                       )
//                     ),
//                     SizedBox(
//                       height: 20,
//                       child: OutlinedButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         style: OutlinedButton.styleFrom(
//                           primary: Theme.of(context).primaryColor,
//                           backgroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(side: BorderSide(
//                             color: Colors.blue,
//                             width: 1,
//                             style: BorderStyle.solid
//                           ), borderRadius: BorderRadius.circular(5)),
//                           elevation: 1
//                         ),
//                         child: Text('NO', style: TextStyle(fontFamily: 'GSANSB', fontSize: 12),)
//                       ),
//                     ), 
//                     SizedBox(
//                       width: 30,
//                     ),                     
//                   ],
//                 )
//               ],
//             ),
//           );
//         });
//     }
//   }

//   Future<List<dynamic>> getData(String match_uid, String category) async {
//     CollectionReference ref = FirebaseFirestore.instance.collection('Match');
//     DocumentSnapshot snapshot = await ref.doc(match_uid).get();

//     var data = snapshot.data() as Map;
//     var ls = data[category] as List<dynamic>;

//     return ls;
//   }

//   void addMember(String id) async {
//     bool existMember = false;
//     FirebaseFirestore firestore = FirebaseFirestore.instance;
//     QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
//         .instance
//         .collection('Users')
//         .where('id', isEqualTo: id)
//         .get();

//     List<QueryDocumentSnapshot> docs = snapshot.docs;
    
//     var doc;
//     for (doc in docs) {
//       if (doc.data() != null) {
//         existMember = true;
//       }
//     }

//     List<dynamic> uid_list = [];
//     List<dynamic> nickname_list = [];
//     List<dynamic> idx_list = [];
//     List<dynamic> token_list = [];
//     List<dynamic> member_score_list = [];
//     List<dynamic> record_list = [];

//     CollectionReference ref = FirebaseFirestore.instance.collection('Match');
//     DocumentSnapshot snapshotd = await ref.doc(match_uid).get();
//     User? user = FirebaseAuth.instance.currentUser;

//     firestore.collection('Match').doc(match_uid).update({
//       'player_cur': FieldValue.increment(1),
//     }).then((value) => print('ok'));
    
//     var data;    
//     data = snapshotd.data() as Map;

//     uid_list = data['member_uid'] as List<dynamic>;
//     nickname_list = data['member_nickname'] as List<dynamic>;
//     idx_list = data['member_idx'] as List<dynamic>;
//     token_list = data['member_fcm_token'] as List<dynamic>;
//     var score = data['player_score'] as List<dynamic>;

//     idx_list.add(0);
//     token_list.add(' ');
    
//     score.add({
//       'GAME 1': '0:0',
//       'GAME 2': '0:0', 
//       'GAME 3': '0:0', 
//       'GAME 4': '0:0', 
//       'Confirm GAME 1': '0:0', 
//       'Confirm GAME 2': '0:0', 
//       'Confirm GAME 3': '0:0', 
//       'Confirm GAME 4': '0:0', 
//       });
    
//     if (existMember) {      //존재하는 사용자일 경우
//       uid_list.add(doc.id);
//       nickname_list.add(doc.data()['nickname']);
//     }
//     else {                  //존재하지 않는 사용자일 경우
//       uid_list.add('#');
//       nickname_list.add(id);      
//     }

//     var docId = firestore.collection('Match').doc(match_uid);
//     docId.set({
//       'member_uid': uid_list,
//       'member_nickname': nickname_list,
//       'member_idx': idx_list,
//       'member_fcm_token': token_list,
//       'player_score' : score,
//     }, SetOptions(merge: true));

//     snapshotd = await ref.doc(match_uid).collection('Record').doc('RecordList').get();
//     data = snapshotd.data() as Map;

//     record_list = data['List'];

//     if(existMember) {
//       record_list.add({
//         'uid' : doc.id,
//         'nickname' : doc.data()['nickname'],
//         'win' : 0, 
//         'draw' : 0, 
//         'loss' : 0,
//         'rank' : '0',
//         'win_point' : 0,
//         'loss_point' : 0
//       });
//     } else {
//       record_list.add({
//         'uid' : '#',
//         'nickname' : id,
//         'win' : 0, 
//         'draw' : 0, 
//         'loss' : 0,
//         'rank' : '0',
//         'win_point' : 0,
//         'loss_point' : 0
//       });
//     }

//     var docRecord = firestore.collection('Match').doc(match_uid).collection('Record').doc('RecordList');
//     docRecord.set({ 'List' : record_list});
//   }

//   void addMatchMemberDlg() {
//     input_id.clear();
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('사용자 추가'),
//             content: TextField(
//               controller: input_id,
//             ),
//             actions: <Widget>[
//               OutlinedButton(
//                 onPressed: () {
//                   if(input_id.text != '') {
//                     addMember(input_id.text);
//                     Navigator.of(context).pop();
//                   } else {
//                     showDialog(context: context, builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('닉네임을 입력하세요'),
//                         actions: [

//                         ],
//                       );
//                     });
//                   }                  
//                 },
//                 child: Text("추가하기"),
//               ),
//             ],
//           );
//         });
//   }

//   Widget  _matchInfo() {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('Match').doc(match_uid).snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if(snapshot.hasData) {
//           var name;                          
//           name = snapshot.data!.get('name');
//           max_player = snapshot.data!.get('player_cnt');
//           cur_player = snapshot.data!.get('player_cur');
//           master_uid = snapshot.data!.get('master.uid');
//           matchType = snapshot.data!.get('types');
//           return Container(
//             child: 
//               Column(
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
//                     child: Align(
//                       alignment: Alignment(-1, 0),
//                       child: Text(name,
//                         style: TextStyle(fontSize: 22, fontFamily: 'GSANSB', color: Colors.grey[700]))),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 flex: 50,
//                                 child: 
//                                   Column(
//                                     mainAxisSize: MainAxisSize.max,
//                                     children: [
//                                       Padding(
//                                         padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                                         child: 
//                                           Row(
//                                             children: [
//                                               Padding(
//                                                 padding:
//                                                   EdgeInsets.fromLTRB(0, 0, 5, 0),
//                                                 child: Text(
//                                                   '총 참가인원 >',
//                                                   style: TextStyle(fontSize: 13, fontFamily: 'GSANSB', color: Colors.grey[600])
//                                                 ),
//                                               ),
//                                               Text(
//                                                 max_player.toString(),
//                                                 style: TextStyle(fontSize: 13, fontFamily: 'GSANSB', color: Colors.grey[600])
//                                               )
//                                             ],
//                                           ),
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                                         child: 
//                                           Row(
//                                             children: [
//                                               Padding(
//                                                 padding:
//                                                   EdgeInsets.fromLTRB(0, 0, 5, 0),
//                                                 child: Text(
//                                                   '현재 참가인원 >',
//                                                   style: TextStyle(fontSize: 13, fontFamily: 'GSANSB', color: Colors.grey[600])
//                                                 ),
//                                               ),
//                                               Text(
//                                                 cur_player.toString(),
//                                                 style: TextStyle(fontSize: 13, fontFamily: 'GSANSB', color: Colors.grey[600])
//                                               )
//                                             ],
//                                           ),
//                                       )
//                                     ],
//                                   ),
//                               ),
//                               SizedBox(width: 80,),
//                               Expanded(
//                                 flex: 50,
//                                 child: 
//                                   OutlinedButton(
//                                     onPressed: () {
//                                       if (master_uid.toString() == user!.uid.toString()) {
//                                         if (cur_player < max_player) {
//                                           addMatchMemberDlg();
//                                         } else {
//                                           showDialog(
//                                               context: context,
//                                               builder: (BuildContext context) {
//                                                 return AlertDialog(
//                                                   title: Text('인원이 다 찼습니다.'),
//                                                   actions: <Widget>[
//                                                     OutlinedButton(
//                                                       onPressed: () {
//                                                         Navigator.of(context).pop();
//                                                       },
//                                                       child: Text("확인"),
//                                                     ),
//                                                   ],
//                                                 );
//                                               });
//                                         }
//                                       } else {
//                                         showDialog(
//                                             context: context,
//                                             builder: (BuildContext context) {
//                                               return AlertDialog(
//                                                 title: Text('방장만 가능합니다.'),
//                                                 actions: <Widget>[
//                                                   OutlinedButton(
//                                                     onPressed: () {
//                                                       Navigator.of(context).pop();
//                                                     },
//                                                     child: Text("확인"),
//                                                   )
//                                                 ],
//                                               );
//                                             });
//                                       }                                             
//                                     },
//                                     style: OutlinedButton.styleFrom(
//                                       primary: Colors.white,
//                                       backgroundColor: Colors.grey[350],
//                                       shape: RoundedRectangleBorder(side: BorderSide(
//                                         color: Colors.blue,
//                                         width: 1,
//                                         style: BorderStyle.solid
//                                       ), 
//                                       borderRadius: BorderRadius.circular(10)),
//                                       elevation: 3
//                                     ),
//                                     child: Text('인원추가',
//                                     style: TextStyle(color: Colors.grey[700], fontFamily: 'GSANSB'),),)
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     )
//                   )
//                 ],
//               ),
//           );
//         } else {
//           return Container();
//         }
//       }
//     );
//   }

//   Widget _playerInfo() {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance.collection('Match').doc(match_uid).snapshots(),
//       builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasData) {
//           var d;
//           d = snapshot.data!.get('member_nickname');
//           return ListView.separated(
//             scrollDirection: Axis.vertical,
//             shrinkWrap: true,
//             padding: const EdgeInsets.all(20),
//             itemCount: d.length,
//             itemBuilder: (_, int index) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Colors.red[100],
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
//                       child: 
//                         Row(
//                           children: [
//                             Text(
//                               d[index], 
//                               style: TextStyle(
//                                 color: Colors.grey[700], 
//                                 fontFamily: 'GSANSM'),
//                             ),
//                           ],
//                         ),
//                     )
//                   ],
//                 ),
//               );
//             },
//             separatorBuilder: (BuildContext context, idx) {
//               return Container(height: 5, color: Colors.white,);
//             }, 
//           );
//         } else {
//           return Container();
//         }
//       }
//     );
//   }

//   Widget _bottomButton() {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       child: 
//         Padding(
//           padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
//           child: 
//             OutlinedButton(
//               onPressed: () {
//                 if (max_player <= cur_player) {
//                   startMatch();
//                 } 
//                 else {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text("모집이 완료되지 않았습니다."),
//                         actions: <Widget>[
//                           OutlinedButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text('확인'))
//                         ],
//                       );
//                     });
//                 }                 
//               },          
//               style: OutlinedButton.styleFrom(
//                 primary: Colors.white,
//                 backgroundColor: Theme.of(context).primaryColor,
//                 shape: RoundedRectangleBorder(side: BorderSide(
//                   color: Colors.blue,
//                   width: 1,
//                   style: BorderStyle.solid
//                 ), borderRadius: BorderRadius.circular(50)),
//                 elevation: 3
//               ),
//               child: 
//                 Text('GAME START', 
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontFamily: 'GSANSB',
//                     fontWeight: FontWeight.w700
//                   ),
//                 ),
//             ),
//         )
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     user_account_info_ = Provider.of<UserAccountInfo>(context, listen: false);
//     CollectionReference matchRef = FirebaseFirestore.instance.collection('Match');

//     return Scaffold(
//       key: scaffoldkey,
//       backgroundColor: Colors.white,
//       //endDrawer: Drawer(child:HamburgerMenu()),
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFFFFFF),
//         iconTheme: IconThemeData(color: Colors.grey),
//         automaticallyImplyLeading: false,
//         title: 
//           SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
//           //SvgPicture.asset('assets/images/SVG/logo.svg', width: 150,),
//         leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => MatchTabPage()
//                 )
//               );
//             },
//             icon: Icon(Icons.arrow_back_ios),
//         ),
//         actions: [
          
//         ],
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: 
        
//         SafeArea(
//           child: 
//             SingleChildScrollView(
//               child: 
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   //height: MediaQuery.of(context).size.height * 1,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                   ),
//                   child: 
//                     Padding(padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Container(
//                             //flex: 20,
//                             //height: MediaQuery.of(context).size.height * 0.2,
//                             child: 
//                               Padding(
//                                 padding: EdgeInsets.fromLTRB(15, 20, 5, 0),
//                                 child: Align(
//                                   alignment: Alignment(-1, 0),
//                                   child: 
//                                     _matchInfo()
//                                 ),
//                               ),
//                           ),
//                           Container(
//                             //flex: 60,
//                             //height: 300,
//                             height: MediaQuery.of(context).size.height * 0.5,
//                             child: 
//                               _playerInfo()
//                           ),
//                           Container(
//                             //flex: 20,
//                             //height: MediaQuery.of(context).size.height * 0.2,
//                             child: 
//                               _bottomButton()
//                           ),
//                         ]
//                       ),
//                     ),
//                 )
//             )
//         ),
//     );
//   }
// }
