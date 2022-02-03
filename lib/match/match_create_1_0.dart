import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/animated_toggle.dart';

class MatchCreate extends StatefulWidget {
  const MatchCreate({ Key? key }) : super(key: key);

  @override
  _MatchCreateState createState() => _MatchCreateState();
}

class _MatchCreateState extends State<MatchCreate> {
  late UserAccountInfo user_account_info_;
  late FocusNode currentFocus = FocusNode();

  TextEditingController matchName = TextEditingController();
  TextEditingController playerCount = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController password = TextEditingController();

  int _toggleValue = 0;
  int matchTypeVisible = 0;
  int _toggleSingleTypeValue = 0;
  bool _subTypeVisible = true;
  bool _masterJoinState = false;

  var playerValue = "5";
  List<String> playerCntList = ["5", "6", "7", "8", "9", "10", "11", "12", "13"];

  //광고
  // AdmobBannerSize? bannerSize;
  // late AdmobInterstitial interstitialAd;
  // late AdmobReward rewardAd;
  
  @override
  void initState() {
    super.initState();
    currentFocus = FocusNode();

    //광고
    // bannerSize = AdmobBannerSize.BANNER;
    // interstitialAd = AdmobInterstitial(
    //   adUnitId: 'ca-app-pub-3940256099942544/1033173712',      
    // );

    // rewardAd = AdmobReward(adUnitId: 'ca-app-pub-3940256099942544/5224354917',
    //   listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
    //     if (event == AdmobAdEvent.closed) {
    //       // rewardAd.load();
    //       // createMatch();
    //     }
    //   },
    // );

    // interstitialAd.load();
    // rewardAd.load();
  }

  void createMatch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User user = FirebaseAuth.instance.currentUser!;
    String _matchName = matchName.text;
    String _pwd = password.text;
    int _playerCount = int.parse(playerValue);
    String _date = FieldValue.serverTimestamp().toString();
    int _matchTypes = _toggleValue;
    int _matchSubTypes = _toggleSingleTypeValue;
    String _types = '';

    Map<String, dynamic> master = {
      'uid': user.uid,
      'nickname': user_account_info_.nickname,
      'joinState' : _masterJoinState,
      'fcm_token' : ''
    };
    
    List<String> member_uid = [];    
    List<String> member_nickname = []; 
    List<int> member_idx = []; 
    List<String> member_fcm_token = [];

    Map<String, String> game_score = Map();

    if(_matchTypes == 0) {
      for(int i = 1; i <= _playerCount * 2; i++) {
        String game_str = 'GAME ' + i.toString();
        game_score[game_str] = '0:0';
      }      
    } else if(_matchTypes == 1) {

    } else if(_matchTypes == 2) {
      for(int i = 1; i <= _playerCount; i++) {
        String game_str = 'GAME ' + i.toString();
        game_score[game_str] = '0:0';
      } 
    }

    Map<String, bool> game_isEdit = Map();
    if(_matchTypes == 0) {
      for(int i = 1; i <= _playerCount * 2; i++) {
        String game_str = 'GAME ' + i.toString();
        game_isEdit[game_str] = true;
      }      
    } else if(_matchTypes == 1) {

    } else if(_matchTypes == 2) {
      for(int i = 1; i <= _playerCount; i++) {
        String game_str = 'GAME ' + i.toString();
        game_isEdit[game_str] = true;
      }  
    }

    if(_masterJoinState) {
      member_uid.add(user.uid);
      member_nickname.add(user_account_info_.nickname);
      member_idx.add(0);
      member_fcm_token.add('');

      List<Map<String, dynamic>> player_score = [{
      'GAME 1': '0:0', 
      'GAME 2': '0:0', 
      'GAME 3': '0:0', 
      'GAME 4': '0:0', 
      'Confirm GAME 1': '0:0', 
      'Confirm GAME 2': '0:0', 
      'Confirm GAME 3': '0:0', 
      'Confirm GAME 4': '0:0', 
      }];
    
      List<Map<String, dynamic>> record = [{
        'uid' : user.uid,
        //'nickname' : user_account_info_.id,
        'nickname' : user_account_info_.nickname,
        'win' : 0, 
        'draw' : 0, 
        'loss' : 0,
        'rank' : '0',
        'win_point' : 0,
        'loss_point' : 0
      }];
      
      var docid = firestore.collection('Match').doc();
      docid.set({
        'types': _matchTypes,
        'name': _matchName,
        'password': _pwd,
        'player_cnt': _playerCount,
        'player_cur': 1,
        'master': master,
        'member_uid': member_uid,
        'member_nickname': member_nickname,
        'member_idx': member_idx,
        'member_fcm_token': member_fcm_token,
        'reg_date': Timestamp.now(),
        'matchState': 1,
        'game_cur' : 1,
        'game_score' : game_score, 
        'game_isEdit' : game_isEdit,
        'player_score' : player_score 
      });

      var docRecord = firestore.collection('Match').doc(docid.id).collection('Record').doc('RecordList');
      docRecord.set({ 'List' : record});
    } else {
      var docid = firestore.collection('Match').doc();
      docid.set({
        'types': _matchTypes,
        'name': _matchName,
        'password': _pwd,
        'player_cnt': _playerCount,
        'player_cur': 0,
        'master': master,
        'member_uid': member_uid,
        'member_nickname': member_nickname,
        'member_idx': member_idx,
        'member_fcm_token': member_fcm_token,
        'reg_date': Timestamp.now(),
        'matchState': 1,
        'game_cur' : 1,
        'game_score' : game_score, 
        'game_isEdit' : game_isEdit,
        'player_score' : [] 
      });

      var docRecord = firestore.collection('Match').doc(docid.id).collection('Record').doc('RecordList');
      docRecord.set({ 'List' : []});
    }  

    Navigator.of(context).pop();
//    Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    user_account_info_ = Provider.of<UserAccountInfo>(context, listen: false);
    String str = user_account_info_.nickname.toString();

    bool isGameName = false;
    bool isPassword = false;
    
    return WillPopScope(
      onWillPop: () async{
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("게임 생성을 취소하시겠습니까?", style: TextStyle(fontFamily: 'GSANSM', fontSize: 16, color: Colors.grey[700]),),
              actions: <Widget>[
                OutlinedButton(
                  child: Text("계속하기", style: TextStyle(fontFamily: 'GSANSM', fontSize: 14),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                OutlinedButton(
                  child: Text("취소하기", style: TextStyle(fontFamily: 'GSANSM', fontSize: 14),),
                  onPressed: () {
                    Navigator.of(context)..pop()..pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          iconTheme: IconThemeData(color: Colors.grey),
          automaticallyImplyLeading: false,
          title: 
            SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
          leading: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text("글 작성을 취소하시겠습니까?", style: TextStyle(fontFamily: 'GSANSM', fontSize: 16, color: Colors.grey[700]),),
                    actions: <Widget>[
                      OutlinedButton(
                        child: Text("계속 작성하기", style: TextStyle(fontFamily: 'GSANSM', fontSize: 14),),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      OutlinedButton(
                        child: Text("취소하기", style: TextStyle(fontFamily: 'GSANSM', fontSize: 14),),
                        onPressed: () {
                          Navigator.of(context)..pop()..pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: 
                Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: 
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        Row(
                          children: [ 
                            Text(
                              '게임 생성',
                              style: TextStyle(fontSize: 20, fontFamily: 'GSANSB', color: Colors.grey[700],),
                            ),
                          ]
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 1,
                              child: 
                                Text('게임명', style: TextStyle(color: Colors.grey[600],fontSize: 18 ,fontFamily: 'GSANSM'), textAlign: TextAlign.start,),
                            ),
                            Expanded(
                              flex: 3,
                              child: 
                                TextFormField(
                                  controller: matchName,
                                  decoration: InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                                    hintText: '게임명 입력...',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 2,
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(10))                                      
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 2,
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(10))
                                    ),
                                  ),
                                ),
                            ),
                            SizedBox(width: 10,)
                            //TextFormField()
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 1,
                              child: 
                                Text('인원수', style: TextStyle(color: Colors.grey[600],fontSize: 18 ,fontFamily: 'GSANSM'), textAlign: TextAlign.start,),
                            ),
                            Expanded(
                              flex: 3,
                              child: 
                                DropdownButtonHideUnderline(
                                  child: 
                                    DropdownButton<String>(
                                      isExpanded: false,
                                      value: playerValue,
                                      items: playerCntList
                                          .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Center(child: Text(value)),
                                            );
                                          }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          playerValue = newValue!;
                                          FocusScope.of(context).requestFocus(currentFocus);
                                          //FocusScopeNode currentFocus = FocusScope.of(context);
                                          //currentFocus.unfocus();
                                        });
                                      },
                                    ),
                                )
                            ),
                            SizedBox(width: 10,)
                            //TextFormField()
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 1,
                              child: 
                                Text('비밀번호', style: TextStyle(color: Colors.grey[600],fontSize: 18 ,fontFamily: 'GSANSM'), textAlign: TextAlign.start,),
                            ),
                            Expanded(
                              flex: 3,
                              child: 
                                TextFormField(
                                  controller: password,
                                  keyboardType: TextInputType.number,
                                  focusNode: currentFocus,
                                  decoration: InputDecoration(
                                    contentPadding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                                    hintText: '숫자 4자리를 입력하세요.',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 2,
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(10))                                      
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 2,
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(10))
                                    ),
                                  ),
                                ),
                            ),  
                          ],
                        ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedToggle(
                                  values: ['단식', '복식'],
                                  onToggleCallback: (value) {
                                    setState(() {
                                      if(value > 0) {
                                        _toggleValue = 2;
                                        matchTypeVisible = 1;
                                      } else {
                                        _toggleValue = value;
                                        matchTypeVisible = 0;
                                      }
                                    });
                                  },
                                  buttonColor: const Color(0xffe9394f),
                                  backgroundColor: const Color(0xFFFFCDD2),
                                  textColor: const Color(0xFFFFFFFF),
                                ),
                              ]
                          )                          
                        ),
                        //SizedBox(height: 50,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                              activeColor: Theme.of(context).primaryColor,
                              value: _masterJoinState, 
                              onChanged: (value) {
                                setState(() {
                                  _masterJoinState = value!;
                                });
                              }
                            ),
                            Text('게임방장도 게임에 참여합니다.', style: TextStyle(fontFamily: 'GSANSM', fontSize: 14, color: Colors.grey[600]),)
                          ],
                        ),                      
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: 
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: 
                                OutlinedButton(
                                  onPressed: () async{
                                    if(int.parse(playerValue) < 5) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("참여인원이 5명 이상이어야 가능합니다."),
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
                                    else {
                                      //interstitialAd.show();
    
                                      
                                      if(matchName.text == '') { 
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("게임명을 입력하세요."),
                                              actions: <Widget>[
                                                OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text('확인'))
                                              ],
                                            );
                                          });
                                      } else if(password.text == '' || password.text.length != 4) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("4자리 비밀번호를 입력하세요."),
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
                                        createMatch();
                                      }
    
                                      
                                      // if(matchName.text != '') {
                                      //   createMatch();
                                      // } else {
                                      //   showDialog(
                                      //   context: context,
                                      //   builder: (BuildContext context) {
                                      //     return AlertDialog(
                                      //       title: Text("게임명을 입력하세요."),
                                      //       actions: <Widget>[
                                      //         OutlinedButton(
                                      //             onPressed: () {
                                      //               Navigator.of(context).pop();
                                      //             },
                                      //             child: Text('확인'))
                                      //       ],
                                      //     );
                                      //   });
                                      // }
                                      // if(password.text != '' || password.text.length != 4) {
                                      //   showDialog(
                                      //     context: context,
                                      //     builder: (BuildContext context) {
                                      //       return AlertDialog(
                                      //         title: Text("4자리 비밀번호를 입력하세요."),
                                      //         actions: <Widget>[
                                      //           OutlinedButton(
                                      //               onPressed: () {
                                      //                 Navigator.of(context).pop();
                                      //               },
                                      //               child: Text('확인'))
                                      //         ],
                                      //       );
                                      //     });
                                      // }
    
    
    
    
                                      // rewardAd.show();
                                      // createMatch();
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
                                    Text('새 게임 만들기', 
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'GSANSM',
                                        //fontWeight: FontWeight.w700
                                      ),
                                    ),
                                ),
                            )
                        )
                      ],
                    ),
                ),
            ),
          ),
        ),
      ),
    );
  }
}