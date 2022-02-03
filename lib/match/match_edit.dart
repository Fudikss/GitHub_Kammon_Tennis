import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/animated_toggle.dart';

class MatchEdit extends StatefulWidget {
  const MatchEdit({ Key? key, required this.matchUid, required this.title, required this.playerCnt, required this.type, required this.masterJoinState }) : super(key: key);
  final String matchUid;
  final String title;
  final int playerCnt;
  final int type;
  final bool masterJoinState;
  

  @override
  _MatchEditState createState() => _MatchEditState(matchUid, title, playerCnt.toString(), type, masterJoinState);
}

class _MatchEditState extends State<MatchEdit> {
  _MatchEditState(this.matchUid, this.title, this.playerValue, this.type, this.masterJoinState);
  String matchUid;
  String title;
  var playerCnt;
  int type;
  var playerValue;
  bool masterJoinState;
  
  List<String> playerCntList = ["5", "6", "7", "8", "9", "10", "11", "12", "13"];

  int _toggleValue = 0;

  TextEditingController matchName = TextEditingController();
  //TextEditingController playerCount = TextEditingController();
  Map matchData = Map();

  late UserAccountInfo user_account_info_;

  @override
  void initState() {
    super.initState();    
  }

  void editMatch() async {
    Map<String, dynamic> master = {
      'uid': user_account_info_.uid,
      'nickname': user_account_info_.nickname,
      'joinState' : masterJoinState,
      'fcm_token' : ''
    };

    Map<String, String> game_score = Map();
    Map<String, bool> game_isEdit = Map();

    int playerCount = int.parse(playerValue);

    if(type == 0) {
      for(int i = 1; i <= playerCount * 2; i++) {
        String game_str = 'GAME ' + i.toString();
        game_score[game_str] = '0:0';
      }      
    } else if(type == 1) {

    } else if(type == 2) {
      for(int i = 1; i <= playerCount; i++) {
        String game_str = 'GAME ' + i.toString();
        game_score[game_str] = '0:0';
      } 
    }

    if(type == 0) {
      for(int i = 1; i <= playerCount * 2; i++) {
        String game_str = 'GAME ' + i.toString();
        game_isEdit[game_str] = true;
      }      
    } else if(type == 1) {

    } else if(type == 2) {
      for(int i = 1; i <= playerCount; i++) {
        String game_str = 'GAME ' + i.toString();
        game_isEdit[game_str] = true;
      }  
    }

    

    // if(matchName.text == '') {
    //   matchName.text = title;
    // }
    // FirebaseFirestore.instance.collection('Match').doc(matchUid).update({
    //   'name' : matchName.text,
    //   'player_cnt' : int.parse(playerValue),
    //   'types' : _toggleValue,
    //   'master' : master
    // });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    user_account_info_ = Provider.of<UserAccountInfo>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        title: 
          SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
        leading: IconButton(
          onPressed: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => MatchTabPage()
            //   )
            // );
            Navigator.of(context).pop();
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
            child: Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Row(
                    children: [ 
                      Text(
                        '게임 수정',
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
                              hintText: title,
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
                      )
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
                                  items: playerCntList.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Center(child: Text(value)),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      playerValue = newValue!;
                                      //FocusScope.of(context).requestFocus(currentFocus);
                                    });
                                  },
                                ),
                            )
                        ),
                        SizedBox(width: 10,)
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
                                    //matchTypeVisible = 1;
                                  } else {
                                    _toggleValue = value;
                                    //matchTypeVisible = 0;
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Checkbox(
                        //   activeColor: Theme.of(context).primaryColor,
                        //   value: masterJoinState, 
                        //   onChanged: (value) {
                        //     setState(() {
                        //       masterJoinState = value!;
                        //     });
                        //   }
                        // ),
                        //Text('게임방장도 게임에 참여합니다.', style: TextStyle(fontFamily: 'GSANSM', fontSize: 14, color: Colors.grey[600]),)
                        Text('방장의 게임 참여 여부는 수정되지 않습니다.', style: TextStyle(fontFamily: 'GSANSM', fontSize: 14, color: Colors.grey[600]),)
                      ],
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        child: 
                          Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: OutlinedButton(
                              onPressed: () {
                                editMatch();
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
                                  Text('게임 수정하기', 
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'GSANSM',
                                      //fontWeight: FontWeight.w700
                                    ),
                                  ),
                            )
                          )
                    )
                ],
              )
            )
          )
        )
      ),
    );
  }
}