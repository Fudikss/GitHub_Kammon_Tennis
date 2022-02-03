import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snstennis/account/my_page.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/first_screen_1_0.dart';
import 'package:snstennis/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/instant/instant_main.dart';
import 'package:snstennis/market/Market_Main_Page.dart';
import 'package:snstennis/match/enter_game_splash.dart';
import 'package:snstennis/match/match_create_1_0.dart';
import 'package:snstennis/match/match_wait.dart';


class MatchWaitList extends StatefulWidget {
  const MatchWaitList({ Key? key }) : super(key: key);

  @override
  _MatchWaitListState createState() => _MatchWaitListState();
}

class _MatchWaitListState extends State<MatchWaitList> {
  late UserAccountInfo user_account_info_;
  late User? curUser = FirebaseAuth.instance.currentUser;
  bool isMember = false;
  TextEditingController input_pwd = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int _selectedNaviIndex = 0;
  bool enterance_state = false;

  void addMember(String match_id) async{
    CollectionReference ref = FirebaseFirestore.instance.collection('Match');
    DocumentSnapshot snapshot = await ref.doc(match_id).get();
    //User? user = FirebaseAuth.instance.currentUser;

    firestore.collection('Match').doc(match_id).update({
      'player_cur': FieldValue.increment(1),
    }).then((value) => print('ok'));

    List<dynamic> uid_list = [];
    List<dynamic> nickname_list = [];
    List<dynamic> idx_list = [];
    List<dynamic> token_list = [];
    List<dynamic> member_score_list = [];
    List<dynamic> record_list = [];

    var data;    
    data = snapshot.data() as Map;

    uid_list = data['member_uid'] as List<dynamic>;
    uid_list.add(curUser!.uid);

    nickname_list = data['member_nickname'] as List<dynamic>;
    nickname_list.add(user_account_info_.nickname);

    idx_list = data['member_idx'] as List<dynamic>;
    idx_list.add(0);

    token_list = data['member_fcm_token'] as List<dynamic>;
    token_list.add(' ');

    var score = data['player_score'] as List<dynamic>;
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

    var docId = firestore.collection('Match').doc(match_id);
    docId.set({
      'member_uid': uid_list,
      'member_nickname': nickname_list,
      'member_idx': idx_list,
      'member_fcm_token': token_list,
      'player_score' : score,
    }, SetOptions(merge: true));

    snapshot = await ref.doc(match_id).collection('Record').doc('RecordList').get();
    data = snapshot.data() as Map;

    record_list = data['List'];

    record_list.add({
      'uid' : curUser!.uid,
      //'nickname' : user_account_info_.id,
      'nickname' : user_account_info_.nickname,
      'win' : 0, 
      'draw' : 0, 
      'loss' : 0,
      'rank' : '0',
      'win_point' : 0,
      'loss_point' : 0
    });

    var docRecord = firestore.collection('Match').doc(match_id).collection('Record').doc('RecordList');
    docRecord.set({ 'List' : record_list}).then((value) => null);    
  }

  void checkPwdDialog(DocumentSnapshot data, String doc_id, String userIdString) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("비밀번호 입력"),
            content: TextField(
              controller: input_pwd,
              keyboardType: TextInputType.number,
            ),
            actions: <Widget>[
              OutlinedButton(
                onPressed: () {
                  String input = input_pwd.text;
                  if (data['password'].compareTo(input) != 0) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('비밀번호가 맞지 않습니다.'),
                            actions: <Widget>[
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("닫기"),
                              )
                            ],
                          );
                        });
                    input_pwd.text = '';
                  } else {
                    addMember(doc_id);
                    
                    //Navigator.pop(context);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EnterGameSplash(matchUid: doc_id, masterUid: data['master']['uid'],)
                      ));

                    input_pwd.text = '';
                  }
                },
                child: Text("확인"),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("취소"),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();

    //bannerSize = AdmobBannerSize.BANNER;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    user_account_info_ = Provider.of<UserAccountInfo>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => MatchCreate(),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
        child: Icon(
          Icons.add,
          color: Color(0xFFFFFFFF),
          size: 40,
        ),
      ),
      body: 
        SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1,
            child: 
              Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 8,
                      child:
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                          child: Align(
                            alignment: Alignment(-1, 0),
                            child: Text(
                              '대기 게임',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                        ),
                    ),
                    Expanded(
                      flex: 80,
                      child:
                        StreamBuilder<QuerySnapshot> (
                          stream: FirebaseFirestore.instance.collection('Match').orderBy('reg_date', descending: true).where('matchState', isEqualTo: 1).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if(snapshot.hasError) {
                              Center(
                                child: Text('Something went wrong')
                              );
                            }
                            if(snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            else {
                              return ListView.builder(
                                itemBuilder: (BuildContext context, idx) {
                                  DocumentSnapshot data = snapshot.data!.docs[idx];
                                  return Padding(padding: EdgeInsets.all(0),
                                      child: 
                                        GestureDetector(
                                          onTap: () {
                                            var member = data['member_nickname'];
                                            var memberIter = member.iterator;

                                            isMember = false;
                                            var master = data['master'];
                                            if(master['uid'] == curUser!.uid) {
                                              isMember = true;
                                            }

                                            while (memberIter.moveNext()) {
                                              if (memberIter.current == user_account_info_.nickname) {
                                                isMember = true;
                                              }

                                              print(memberIter.current);
                                            }

                                            if (!isMember) {
                                              int cur_player = data['player_cur'];
                                              int max_player = data['player_cnt'];
                                              if (cur_player < max_player) {
                                                checkPwdDialog(
                                                    data,
                                                    data.id,
                                                    user_account_info_.nickname);
                                              } else if (cur_player >= max_player) {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                      context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "모집이 완료된 match입니다."),
                                                      actions: <Widget>[
                                                        OutlinedButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text("확인"),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                              }
                                            } else {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) => MatchWait(match_uid:data.id, master_uid: data['master']['uid'],)
                                                  )
                                              );
                                            }
                                          },
                                          child: 
                                            Container(
                                              margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                              decoration: BoxDecoration(
                                                //color: Theme.of(context).primaryColorLight,
                                                color: Colors.white,
                                                border: Border.all(color: Theme.of(context).primaryColorLight, width: 0.8),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                                    child: 
                                                      Row(
                                                        children: [
                                                          Text(data['name'], 
                                                            style: Theme.of(context).textTheme.subtitle1, 
                                                            textAlign: TextAlign.start,),
                                                        ],
                                                      ),
                                                  ),
                                                  Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                                                    child: 
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                          flex: 7,
                                                          child: 
                                                            Text(
                                                            '게임방장 : ' + data['master']['nickname'].toString(),
                                                            style: Theme.of(context).textTheme.subtitle2,                                                              
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child:
                                                              Text(
                                                                data['player_cur'].toString() + '/' + data['player_cnt'].toString(),
                                                                textAlign: TextAlign.end,
                                                                style: Theme.of(context).textTheme.subtitle2,
                                                              )
                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                        )
                                  );
                                }, 
                                itemCount: snapshot.data!.docs.length
                              );
                            }
                          }
                        )
                    ),
                  ],
                ),
              ),
          )
        ),
        bottomNavigationBar: SizedBox(
        height: 60,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black54,
                  blurRadius: 5.0,
                  offset: Offset(0.0, 0.75)
              )
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
                if(_selectedNaviIndex == 0) { 
                  print(_selectedNaviIndex);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context){
                        return Home();
                      }
                  ));
                }
                if(_selectedNaviIndex == 1) { 
                  print(_selectedNaviIndex);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context){
                        return InstantPLay();
                      }
                  ));
                }
                if(_selectedNaviIndex == 2) { 
                  print(_selectedNaviIndex);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context){
                        return FirstScreen();
                      }
                  ));
                }
                if(_selectedNaviIndex == 3) { 
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return MarketMainPage(item_id: user_account_info_.marketChatItem);
                    }
                  ));
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                title: Text('홈', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
                icon: SvgPicture.asset('assets/images/SVG/home.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/home_selected.svg', width: 23,),
              ),
              BottomNavigationBarItem(
                title: Text('벙개', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
                icon: SvgPicture.asset('assets/images/SVG/light.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/light_selected.svg', width: 23,),
              ),
              BottomNavigationBarItem(
                title: Text('클럽', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
                icon: SvgPicture.asset('assets/images/SVG/club.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/club_selected.svg', width: 23,),
              ),
              BottomNavigationBarItem(
                title: Text('중고장터', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
                icon: SvgPicture.asset('assets/images/SVG/basket.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/basket_selected.svg', width: 23,),
              ),
              BottomNavigationBarItem(
                title: Text('더보기', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
                icon: SvgPicture.asset('assets/images/SVG/more.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/more_selected.svg', width: 23,),
              ),
            ],
          )
        )
      ),
    );
  }
}








//1.0.0.+7
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:snstennis/account/my_page.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/club/first_screen_1_0.dart';
// import 'package:snstennis/home.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:snstennis/instant/instant_main.dart';
// import 'package:snstennis/market/Market_Main_Page.dart';
// import 'package:snstennis/match/match_create_1_0.dart';
// import 'package:snstennis/match/match_wait.dart';


// class MatchWaitList extends StatefulWidget {
//   const MatchWaitList({ Key? key }) : super(key: key);

//   @override
//   _MatchWaitListState createState() => _MatchWaitListState();
// }

// class _MatchWaitListState extends State<MatchWaitList> {
//   late UserAccountInfo user_account_info_;
//   late User? curUser = FirebaseAuth.instance.currentUser;
//   bool isMember = false;
//   TextEditingController input_pwd = TextEditingController();
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   int _selectedNaviIndex = 0;
//   bool enterance_state = false;

//   void addMember(String match_id) async{
//     CollectionReference ref = FirebaseFirestore.instance.collection('Match');
//     DocumentSnapshot snapshot = await ref.doc(match_id).get();
//     //User? user = FirebaseAuth.instance.currentUser;

//     firestore.collection('Match').doc(match_id).update({
//       'player_cur': FieldValue.increment(1),
//     }).then((value) => print('ok'));

//     List<dynamic> uid_list = [];
//     List<dynamic> nickname_list = [];
//     List<dynamic> idx_list = [];
//     List<dynamic> token_list = [];
//     List<dynamic> member_score_list = [];
//     List<dynamic> record_list = [];

//     var data;    
//     data = snapshot.data() as Map;

//     uid_list = data['member_uid'] as List<dynamic>;
//     uid_list.add(curUser!.uid);

//     nickname_list = data['member_nickname'] as List<dynamic>;
//     nickname_list.add(user_account_info_.nickname);

//     idx_list = data['member_idx'] as List<dynamic>;
//     idx_list.add(0);

//     token_list = data['member_fcm_token'] as List<dynamic>;
//     token_list.add(' ');

//     var score = data['player_score'] as List<dynamic>;
//     score.add({
//       'GAME 1': '0:0',
//       'GAME 2': '0:0', 
//       'GAME 3': '0:0', 
//       'GAME 4': '0:0', 
//       'Confirm GAME 1': '0:0', 
//       'Confirm GAME 2': '0:0', 
//       'Confirm GAME 3': '0:0', 
//       'Confirm GAME 4': '0:0', 
//     });

//     var docId = firestore.collection('Match').doc(match_id);
//     docId.set({
//       'member_uid': uid_list,
//       'member_nickname': nickname_list,
//       'member_idx': idx_list,
//       'member_fcm_token': token_list,
//       'player_score' : score,
//     }, SetOptions(merge: true));

//     snapshot = await ref.doc(match_id).collection('Record').doc('RecordList').get();
//     data = snapshot.data() as Map;

//     record_list = data['List'];

//     record_list.add({
//       'uid' : curUser!.uid,
//       //'nickname' : user_account_info_.id,
//       'nickname' : user_account_info_.nickname,
//       'win' : 0, 
//       'draw' : 0, 
//       'loss' : 0,
//       'rank' : '0',
//       'win_point' : 0,
//       'loss_point' : 0
//     });

//     var docRecord = firestore.collection('Match').doc(match_id).collection('Record').doc('RecordList');
//     docRecord.set({ 'List' : record_list}).then((value) => null);    
//   }

//   void checkPwdDialog(DocumentSnapshot data, String doc_id, String userIdString) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("비밀번호 입력"),
//             content: TextField(
//               controller: input_pwd,
//               keyboardType: TextInputType.number,
//             ),
//             actions: <Widget>[
//               OutlinedButton(
//                 onPressed: () {
//                   String input = input_pwd.text;
//                   if (data['password'].compareTo(input) != 0) {
//                     showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text('비밀번호가 맞지 않습니다.'),
//                             actions: <Widget>[
//                               OutlinedButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text("닫기"),
//                               )
//                             ],
//                           );
//                         });
//                     input_pwd.text = '';
//                   } else {
//                     addMember(doc_id);
                    
//                     Navigator.pop(context);

//                     // Navigator.of(context).push(
//                     //   MaterialPageRoute(
//                     //     builder: (context) => EnterGame(match_uid: doc_id,)
//                     //   ));

//                     input_pwd.text = '';
//                   }
//                 },
//                 child: Text("확인"),
//               ),
//               OutlinedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text("취소"),
//               )
//             ],
//           );
//         });
//   }

//   @override
//   void initState() {
//     super.initState();

//     //bannerSize = AdmobBannerSize.BANNER;
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     user_account_info_ = Provider.of<UserAccountInfo>(context, listen: false);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (BuildContext context) => MatchCreate(),
//             ),
//           );
//         },
//         backgroundColor: Theme.of(context).primaryColor,
//         elevation: 4,
//         child: Icon(
//           Icons.add,
//           color: Color(0xFFFFFFFF),
//           size: 40,
//         ),
//       ),
//       body: 
//         SafeArea(
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height * 1,
//             child: 
//               Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Expanded(
//                       flex: 8,
//                       child:
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
//                           child: Align(
//                             alignment: Alignment(-1, 0),
//                             child: Text(
//                               '대기 게임',
//                               style: Theme.of(context).textTheme.headline2,
//                             ),
//                           ),
//                         ),
//                     ),
//                     Expanded(
//                       flex: 80,
//                       child:
//                         StreamBuilder<QuerySnapshot> (
//                           stream: FirebaseFirestore.instance.collection('Match').orderBy('reg_date', descending: true).where('matchState', isEqualTo: 1).snapshots(),
//                           builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                             if(snapshot.hasError) {
//                               Center(
//                                 child: Text('Something went wrong')
//                               );
//                             }
//                             if(snapshot.connectionState == ConnectionState.waiting) {
//                               return Center(child: CircularProgressIndicator());
//                             }
//                             else {
//                               return ListView.builder(
//                                 itemBuilder: (BuildContext context, idx) {
//                                   DocumentSnapshot data = snapshot.data!.docs[idx];
//                                   return Padding(padding: EdgeInsets.all(0),
//                                       child: 
//                                         GestureDetector(
//                                           onTap: () {
//                                             var member = data['member_nickname'];
//                                             var memberIter = member.iterator;

//                                             isMember = false;
//                                             var master = data['master'];
//                                             if(master['uid'] == curUser!.uid) {
//                                               isMember = true;
//                                             }

//                                             while (memberIter.moveNext()) {
//                                               if (memberIter.current == user_account_info_.nickname) {
//                                                 isMember = true;
//                                               }

//                                               print(memberIter.current);
//                                             }

//                                             if (!isMember) {
//                                               int cur_player = data['player_cur'];
//                                               int max_player = data['player_cnt'];
//                                               if (cur_player < max_player) {
//                                                 checkPwdDialog(
//                                                     data,
//                                                     data.id,
//                                                     user_account_info_.nickname);
//                                               } else if (cur_player >= max_player) {
//                                                 showDialog(
//                                                   context: context,
//                                                   builder: (BuildContext
//                                                       context) {
//                                                     return AlertDialog(
//                                                       title: Text(
//                                                           "모집이 완료된 match입니다."),
//                                                       actions: <Widget>[
//                                                         OutlinedButton(
//                                                           onPressed: () {
//                                                             Navigator.pop(context);
//                                                           },
//                                                           child: Text("확인"),
//                                                         ),
//                                                       ],
//                                                     );
//                                                   });
//                                               }
//                                             } else {
//                                               Navigator.of(context).push(
//                                                   MaterialPageRoute(
//                                                       builder: (context) => MatchWait(match_uid:data.id,)
//                                                   )
//                                               );
//                                             }
//                                           },
//                                           child: 
//                                             Container(
//                                               margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
//                                               decoration: BoxDecoration(
//                                                 //color: Theme.of(context).primaryColorLight,
//                                                 color: Colors.white,
//                                                 border: Border.all(color: Theme.of(context).primaryColorLight, width: 0.8),
//                                                 borderRadius: BorderRadius.circular(10),
//                                               ),
//                                               child: Column(
//                                                 children: [
//                                                   Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
//                                                     child: 
//                                                       Row(
//                                                         children: [
//                                                           Text(data['name'], 
//                                                             style: Theme.of(context).textTheme.subtitle1, 
//                                                             textAlign: TextAlign.start,),
//                                                         ],
//                                                       ),
//                                                   ),
//                                                   Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
//                                                     child: 
//                                                       Row(
//                                                         children: [
//                                                           Expanded(
//                                                           flex: 7,
//                                                           child: 
//                                                             Text(
//                                                             '게임방장 : ' + data['master']['nickname'].toString(),
//                                                             style: Theme.of(context).textTheme.subtitle2,                                                              
//                                                             ),
//                                                           ),
//                                                           Expanded(
//                                                             flex: 3,
//                                                             child:
//                                                               Text(
//                                                                 data['player_cur'].toString() + '/' + data['player_cnt'].toString(),
//                                                                 textAlign: TextAlign.end,
//                                                                 style: Theme.of(context).textTheme.subtitle2,
//                                                               )
//                                                           ),
//                                                         ],
//                                                       )
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                         )
//                                   );
//                                 }, 
//                                 itemCount: snapshot.data!.docs.length
//                               );
//                             }
//                           }
//                         )
//                     ),
//                   ],
//                 ),
//               ),
//           )
//         ),
//         bottomNavigationBar: SizedBox(
//         height: 60,
//         child: Container(
//           decoration: BoxDecoration(
//             boxShadow: <BoxShadow>[
//               BoxShadow(
//                   color: Colors.black54,
//                   blurRadius: 5.0,
//                   offset: Offset(0.0, 0.75)
//               )
//             ],
//           ),
//           child: BottomNavigationBar(
//             type: BottomNavigationBarType.fixed,
//             //backgroundColor: Colors.grey[300],
//             backgroundColor: Colors.white,
//             elevation: 3,
//             selectedItemColor: Theme.of(context).primaryColor,
//             //selectedItemColor: Colors.grey[800],
//             currentIndex: _selectedNaviIndex,
//             onTap: (int index) {
//               _selectedNaviIndex = index;
//               setState(() {
//                 if(_selectedNaviIndex == 0) { 
//                   print(_selectedNaviIndex);
//                   Navigator.push(context, MaterialPageRoute(
//                       builder: (BuildContext context){
//                         return Home();
//                       }
//                   ));
//                 }
//                 if(_selectedNaviIndex == 1) { 
//                   print(_selectedNaviIndex);
//                   Navigator.push(context, MaterialPageRoute(
//                       builder: (BuildContext context){
//                         return InstantPLay();
//                       }
//                   ));
//                 }
//                 if(_selectedNaviIndex == 2) { 
//                   print(_selectedNaviIndex);
//                   Navigator.push(context, MaterialPageRoute(
//                       builder: (BuildContext context){
//                         return FirstScreen();
//                       }
//                   ));
//                 }
//                 if(_selectedNaviIndex == 3) { 
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (BuildContext context){
//                       return MarketMainPage(item_id: user_account_info_.marketChatItem);
//                     }
//                   ));
//                 }
//               });
//             },
//             items: [
//               BottomNavigationBarItem(
//                 title: Text('홈', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
//                 icon: SvgPicture.asset('assets/images/SVG/home.svg', width: 23,),
//                 activeIcon: SvgPicture.asset('assets/images/SVG/home_selected.svg', width: 23,),
//               ),
//               BottomNavigationBarItem(
//                 title: Text('벙개', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
//                 icon: SvgPicture.asset('assets/images/SVG/light.svg', width: 23,),
//                 activeIcon: SvgPicture.asset('assets/images/SVG/light_selected.svg', width: 23,),
//               ),
//               BottomNavigationBarItem(
//                 title: Text('클럽', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
//                 icon: SvgPicture.asset('assets/images/SVG/club.svg', width: 23,),
//                 activeIcon: SvgPicture.asset('assets/images/SVG/club_selected.svg', width: 23,),
//               ),
//               BottomNavigationBarItem(
//                 title: Text('중고장터', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
//                 icon: SvgPicture.asset('assets/images/SVG/basket.svg', width: 23,),
//                 activeIcon: SvgPicture.asset('assets/images/SVG/basket_selected.svg', width: 23,),
//               ),
//               BottomNavigationBarItem(
//                 title: Text('더보기', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
//                 icon: SvgPicture.asset('assets/images/SVG/more.svg', width: 23,),
//                 activeIcon: SvgPicture.asset('assets/images/SVG/more_selected.svg', width: 23,),
//               ),
//             ],
//           )
//         )
//       ),
//     );
//   }
// }