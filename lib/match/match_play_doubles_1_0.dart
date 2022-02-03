import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/home.dart';
import 'package:snstennis/match/match_double_table.dart';
import 'package:snstennis/match/match_kdk_table_view.dart';
import 'package:snstennis/match/match_record.dart';
import 'package:snstennis/match/match_tab_page_1_0.dart';

class MatchPlayDoubles extends StatefulWidget {
  const MatchPlayDoubles({ Key? key, required this.matchUid, required this.prevPage }) : super(key: key);

  final String matchUid;
  final String prevPage;

  @override
  //_MatchPlayDoublesState createState() => _MatchPlayDoublesState(matchUid);
  _MatchPlayDoublesState createState() => _MatchPlayDoublesState(matchUid, prevPage);
}

class GameDoubles {
  int game_idx = 0;
  String game_title = '';
  List<int> player_idx = [];
  List<String> player_uid = [];
  List<String> player_nickname = [];
  List<int> score = [];
  bool isEdit = true;
  String match = '';
  String edit = '';

  GameDoubles();
}

class _MatchPlayDoublesState extends State<MatchPlayDoubles> {
  _MatchPlayDoublesState(this.matchUid, this.prevPage);
  final String matchUid;
  final String prevPage;

  Map matchInfo = Map();
  Map rankInfo = Map();

  int match_state = 0;
  late UserAccountInfo user_account_info_;
  List<String> score_check_text = ['', '승리한 팀의 점수는 6점이 되어야 합니다.'];
  late List<Map<String, String>> table;
  late List<Map<String, String>> editTable;
  List<GameDoubles> gameDoublesList = [];

  late Timer _tableTimer;

  List<DataRow> _getNumberRow() {
    List<DataRow> data = [];
    List<Map<String, dynamic>> data_temp = [];

    for(int i = 0; i < matchInfo['player_cnt']; i++) {
      data_temp.add(
        {
          'number' :  matchInfo['member_idx'][i],
          'nickname' : Text( matchInfo['member_nickname'][i].toString(), style: TextStyle(fontFamily: 'GSANSM', fontSize: 13) )
        }
      );
    }

    data_temp.sort((a, b) => a['number'].compareTo(b['number']));

    for(int i = 0; i < matchInfo['player_cnt']; i++) {
      List<DataCell> cells = [];
      String rank = 'No.' + data_temp[i]['number'].toString();
      cells.add(DataCell(Container( child: Text(rank, style: TextStyle(fontFamily: 'GSANSM', fontSize: 13),))));
      cells.add(DataCell(Container( child: data_temp[i]['nickname'])));

      data.add(DataRow(cells: cells));
    }    

    return data;
  }

  void _checkMatchEndState() async{
    CollectionReference ref = FirebaseFirestore.instance.collection('Match');
    DocumentSnapshot snapshot = await ref.doc(matchUid).get();
    var data = snapshot.data() as Map;
    List<bool> game_state = [];

    bool match_state = false;
    int confirm_count = 0;

    for(int i = 1; i <= matchInfo['game_isEdit'].length; i++) {
      String game_name = 'GAME ' + i.toString();

      if(data['game_isEdit'][game_name] == true) {
        break;
      } else {
        confirm_count++;
      }
    }

    if(confirm_count == data['player_cnt']) {
      await FirebaseFirestore.instance.collection('Match').doc(matchUid).set({
        //'matchState' : FieldValue.increment(1)
        'matchState' : 3
      }, SetOptions(merge: true));
    }
  }
  
  void _getRank() async{
    int max_game_cnt = 4;
    
    var score_list = matchInfo['player_score'] as List<dynamic>;
    var user_uid = matchInfo['member_uid'] as List<dynamic>;
    var user_nick = matchInfo['member_nickname'] as List<dynamic>;
    
    Map<String, dynamic> score_player;
    Map<String, dynamic> record_player;

    CollectionReference ref = FirebaseFirestore.instance.collection('Match');
    DocumentSnapshot snapshot = await ref.doc(matchUid).collection('Record').doc('RecordList').get();

    var data = snapshot.data() as Map;
    var record_list = data['List'] as List<dynamic>;
    for(int i = 0; i < matchInfo['player_cnt']; i++) {
      MatchRecord record = MatchRecord(0, 0, 0, 0, 0, '', 0, 0);
      record_player = record_list[i] as Map<String, dynamic>;
      score_player = score_list[i] as Map<String, dynamic>;

      int win = 0;
      int draw = 0;
      int loss = 0;
      int win_point = 0;
      int loss_point = 0;
      int dist = win_point - loss_point;

      String game_name = '';
      String game_name_prefix = 'Confirm GAME ';
      for(int j = 1; j <= max_game_cnt; j++) {
        game_name = game_name_prefix + j.toString();
        String score = score_player[game_name];

        if(score.contains(':') == true) {
          if(score != '0:0') {
            List<String> score_sep = score.split(':');
            if(int.parse(score_sep[0]) > int.parse(score_sep[1])) {
              win++;
              win_point += int.parse(score_sep[0]);
              loss_point += int.parse(score_sep[1]);
            } else if(int.parse(score_sep[0]) == int.parse(score_sep[1])) {
              draw++;            
            } else if(int.parse(score_sep[0]) < int.parse(score_sep[1])) {
              loss++;
              win_point += int.parse(score_sep[0]);
              loss_point += int.parse(score_sep[1]);
            }
          }
        }
      }

      record_player['idx'] = i;
      record_player['win'] = win;
      record_player['draw'] = draw;
      record_player['loss'] = loss;
      record_player['win_point'] = win_point;
      record_player['loss_point'] = loss_point;

      dist = win_point - loss_point;

      record_player['dist'] = dist;
    }

    var record_list_tmp = List.from(record_list);

    record_list_tmp.sort((a, b) {
      int cmp = b['win'].compareTo(a['win']);
      if(cmp != 0) {
        return cmp;
      } else {
        return b['dist'].compareTo(a['dist']);
      }
    });

    for(int i = 0; i < record_list_tmp.length; i++) {
      int k = i + 1;
      int idx = record_list_tmp[i]['idx'];
      record_list[idx]['rank'] = '$k'.toString();
    }

    await FirebaseFirestore.instance.collection('Match').doc(matchUid).collection('Record').doc('RecordList').set({
      'List' : record_list,
    }, SetOptions(merge: true));
  }

  void _confirmScore(int idx) async{
    gameDoublesList[idx].isEdit = false;
    
    await FirebaseFirestore.instance.collection('Match').doc(matchUid).set({
        'game_isEdit': {gameDoublesList[idx].game_title : false},
    }, SetOptions(merge: true)).then((value) => _getRank());

    int team1_score = gameDoublesList[idx].score[0];
    int team2_score = gameDoublesList[idx].score[1];

    if( team1_score > team2_score) {
      _updateMatchRecord(1, idx);
    } else if(team1_score < team2_score) {
      _updateMatchRecord(2, idx);
    } else if(team1_score == team2_score) {
      _updateMatchRecord(3, idx);
    }

    _checkMatchEndState();
  }

  void _insertConfirmScore(String score, int game_cnt) async {
    String game_name = gameDoublesList[game_cnt].game_title;
    var players_score = matchInfo['player_score'] as List<dynamic>;
    List<dynamic> player_score = [];
    String player_game_name = '';
    String gmae_name_prefix = '';

    gameDoublesList[game_cnt].isEdit = false;
    
    FirebaseFirestore.instance.collection('Match').doc(matchUid).set({
        'game_isEdit': {gameDoublesList[game_cnt].game_title : false},
    }, SetOptions(merge: true));

    gmae_name_prefix = 'Confirm GAME ';

    for(int i = 0; i < gameDoublesList[game_cnt].player_idx.length; i++) {
      player_score.add(players_score[gameDoublesList[game_cnt].player_idx[i]] as Map<String, dynamic>);
    }

    List<String> player_game_idx = gameDoublesList[game_cnt].edit.split(':');    

    player_game_name = gmae_name_prefix + player_game_idx[0].toString();
    player_score[0][player_game_name] = score;

    player_game_name = gmae_name_prefix + player_game_idx[1].toString();
    player_score[1][player_game_name] = score;

    List<String> value = score.split(':');
    String reverse_score  = value[1] + ':' + value[0];

    player_game_name = gmae_name_prefix + player_game_idx[2].toString();
    player_score[2][player_game_name] = reverse_score;

    player_game_name = gmae_name_prefix + player_game_idx[3].toString();
    player_score[3][player_game_name] = reverse_score;

    await FirebaseFirestore.instance.collection('Match').doc(matchUid).set({
        'game_score': {game_name : score},
        'player_score' : players_score
    }, SetOptions(merge: true)).then((value) => _confirmScore(game_cnt));
  }

  Future<Map<dynamic, dynamic>> _getRankData() async{
    var data;
    
      CollectionReference ref = FirebaseFirestore.instance.collection('Match');
      DocumentSnapshot snapshot = await ref.doc(matchUid).collection('Record').doc('RecordList').get();

      data = snapshot.data() as Map;
      rankInfo = data;
    return data;
  }

  List<DataRow> _getRankRow() {
    List<DataRow> data = [];
    List<Map<String, dynamic>> data_temp = [];
    int count = matchInfo['player_cnt'];

    for(int i = 0; i < count; i++) {
      var dist = rankInfo['List'][i]['win_point'] - rankInfo['List'][i]['loss_point'];
      data_temp.add(
        {
          'nick' : SizedBox(
            width: 80,
            child:
              Align(alignment: Alignment.centerLeft, 
                child: Text(
                  matchInfo['member_nickname'][i].toString(), 
                  maxLines: 1, 
                  softWrap: false, 
                  overflow: TextOverflow.ellipsis, 
                  style: TextStyle(fontSize: 12, fontFamily: 'GSANSM')),
              )
              
          ),
          'win' : Text(rankInfo['List'][i]['win'].toString(), style: TextStyle(fontSize: 12, fontFamily: 'GSANSM')),
          'dist' : Text(dist.toString(), style: TextStyle(fontSize: 12, fontFamily: 'GSANSM')),
          'rank' : int.parse(rankInfo['List'][i]['rank']),
        }
      );
    }
    
    data_temp.sort((a, b) => a['rank'].compareTo(b['rank']));

    for(int i = 0; i < count; i++) {
      List<DataCell> cells = [];

      String rank = data_temp[i]['rank'].toString() + '위';
      // if(rank.compareTo('1위') == 0) {
      //   cells.add(DataCell(Container( child: Container(child: Image.asset('assets/images/PNG/gold.png'),))));
      // } else if(rank.compareTo('2위') == 0) {
      //   cells.add(DataCell(Container( child: Container(child: Image.asset('assets/images/PNG/silver.png'),))));
      // } else if(rank.compareTo('3위') == 0) {
        
      //   cells.add(DataCell(Container( child: Container(child: Image.asset('assets/images/PNG/bronze.png'),))));
      // } else {
      //   cells.add(DataCell(Container( child: Text(rank, style: TextStyle(fontSize: 12, fontFamily: 'GSANSM')))));
      // }
      if(rank.compareTo('1위') == 0) {
        cells.add(DataCell(Container( child: Container(child: SvgPicture.asset('assets/images/SVG/TROPHY_gold.svg'), width: 35, alignment: Alignment.centerLeft,))));
      } else if(rank.compareTo('2위') == 0) {
        cells.add(DataCell(Container( child: Container(child: SvgPicture.asset('assets/images/SVG/TROPHY_silver.svg'), width: 35, alignment: Alignment.centerLeft))));
      } else if(rank.compareTo('3위') == 0) {
        
        cells.add(DataCell(Container( child: Container(child: SvgPicture.asset('assets/images/SVG/TROPHY_bronze.svg'), width: 35, alignment: Alignment.centerLeft))));
      } else {
        cells.add(DataCell(Container( child: Text(rank, style: TextStyle(fontSize: 12, fontFamily: 'GSANSM')))));
      }
      cells.add(DataCell(Container( child: data_temp[i]['nick'])));
      cells.add(DataCell(Container( child: data_temp[i]['win'])));
      cells.add(DataCell(Container( child: data_temp[i]['dist'])));

      data.add(DataRow(cells: cells));
    }    

    return data;
  }

  void _insertScore(String score, int game_cnt, int state) async{    
    String game_name = gameDoublesList[game_cnt].game_title;
    var players_score = matchInfo['player_score'] as List<dynamic>;
    List<dynamic> player_score = [];
    String player_game_name = '';
    String game_name_prefix = '';
    
    if(state == 0) {
      game_name_prefix = 'GAME ';
    } else {
      game_name_prefix = 'Confirm GAME ';
    }

    player_game_name = game_name_prefix + (game_cnt + 1).toString();
    if(matchInfo['game_isEdit'][player_game_name] == true) {
      for(int i = 0; i < gameDoublesList[game_cnt].player_idx.length; i++) {
        player_score.add(players_score[gameDoublesList[game_cnt].player_idx[i]] as Map<String, dynamic>);
      }

      List<String> player_game_idx = gameDoublesList[game_cnt].edit.split(':');    

      player_game_name = game_name_prefix + player_game_idx[0].toString();
      player_score[0][player_game_name] = score;

      player_game_name = game_name_prefix + player_game_idx[1].toString();
      player_score[1][player_game_name] = score;

      List<String> value = score.split(':');
      String reverse_score  = value[1] + ':' + value[0];

      player_game_name = game_name_prefix + player_game_idx[2].toString();
      player_score[2][player_game_name] = reverse_score;

      player_game_name = game_name_prefix + player_game_idx[3].toString();
      player_score[3][player_game_name] = reverse_score;

      await FirebaseFirestore.instance.collection('Match').doc(matchUid).set({
          'game_score': {game_name : score},
          'player_score' : players_score
      }, SetOptions(merge: true));
    }  
  }

  void _updateMatchRecord(int result, int idx) async {
    for(int i = 0; i < gameDoublesList[idx].player_uid.length; i++) {
      if(result == 1 && gameDoublesList[idx].player_uid[i] != '#') {
        if(i < 2) {
          await FirebaseFirestore.instance.collection('Users').doc(gameDoublesList[idx].player_uid[i]).update({
            'match_win': FieldValue.increment(1),
          }).then((value) => print('ok'));
        } else if(i > 1) {
          await FirebaseFirestore.instance.collection('Users').doc(gameDoublesList[idx].player_uid[i]).update({
            'match_loss': FieldValue.increment(1),
          }).then((value) => print('ok'));
        }
      } else if(result == 2 && gameDoublesList[idx].player_uid[i] != '#') {
        if(i < 2) {
          await FirebaseFirestore.instance.collection('Users').doc(gameDoublesList[idx].player_uid[i]).update({
            'match_loss': FieldValue.increment(1),
          }).then((value) => print('ok'));
        } else if(i > 1) {
          await FirebaseFirestore.instance.collection('Users').doc(gameDoublesList[idx].player_uid[i]).update({
            'match_win': FieldValue.increment(1),
          }).then((value) => print('ok'));
        }
      } else if(result == 3 && gameDoublesList[idx].player_uid[i] != '#') {
        await FirebaseFirestore.instance.collection('Users').doc(gameDoublesList[idx].player_uid[i]).update({
          'match_draw': FieldValue.increment(1),
        }).then((value) => print('ok'));
      }
    }
  }
  
  Widget _resultPage() {
    int idx = 0;
    for(int i = 0; i < matchInfo['player_cnt']; i++) {
      if(user_account_info_.uid == matchInfo['member_uid'][i]) {
        idx = i;
        break;
      }
    }
    
    return Container(
      margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
      child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 90,
              height: 30,
              child: 
                ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        insetPadding: EdgeInsets.all(10),
                        children: [
                          Stack(
                            overflow: Overflow.visible,
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                //color: Colors.amberAccent,
                                width: double.infinity,
                                //height: 200,                              
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: 
                                  Column(
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: 
                                          SingleChildScrollView(
                                            child: 
                                              DataTable(
                                                columns: <DataColumn>[
                                                  DataColumn(
                                                    label: Text('번 호', style: Theme.of(context).textTheme.headline2),
                                                  ),
                                                  DataColumn(
                                                    label: Text('닉네임', style: Theme.of(context).textTheme.headline2),
                                                  ),
                                                ], 
                                                rows: 
                                                  _getNumberRow(),
                                              ),
                                          )
                                          
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => MatchKDKTableView(),
                                          ),);
                                        },
                                        child: 
                                          SvgPicture.asset('assets/images/SVG/kdk.svg', width: 200),
                                      ),
                                      Center(child:
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(80, 20), 
                  primary: Colors.white,
                  side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                child: 
                  Text('확인', style: TextStyle(fontFamily: 'GSANSM', fontSize: 14, color: Theme.of(context).primaryColor),)
              ))
                                    ],
                                )                                
                              ),
                            ],
                          )
                        ],
                      );
                    }
                  );
                }, 
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(120, 30), 
                  primary: Colors.white,
                  side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                child: 
                  Text('대진표',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'GSANSB',
                      color: Theme.of(context).primaryColor
                    ),
                  ),
              ),
            ),
            SizedBox(
              width: 90,
              height: 30,
              child: 
                ElevatedButton(
                  onPressed: () {
                    bool sort = true;
                    int _currentSortColumn = 0;
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          backgroundColor: Colors.grey[200],
                          insetPadding: EdgeInsets.all(5),
                          children: [
                            FutureBuilder(
                              future: _getRankData(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData == false) {
                                  return Container(
                                    color: Colors.grey[200],
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.width,                        
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: 
                                      Center(child: 
                                        Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment(0, 0),
                                              child: 
                                                Text('순위 가져오는 중...', 
                                                  style: TextStyle(color: Colors.grey[700], fontFamily: 'GSANSM', fontSize: 16)
                                            )),
                                            Align(
                                              alignment: Alignment(0, 0),
                                              child: SizedBox(
                                                width: 150,
                                                height: 150,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 10,
                                                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColorLight),
                                                ) 
                                              ),
                                            ),
                                          ],
                                        )
                                        
                                      )
                                  );
                                } else if (snapshot.hasError) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Error: ${snapshot.error}',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    color: Colors.grey[200],
                                    width: double.infinity,  
                                    //height: MediaQuery.of(context).size.width,                       
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: 
                                      Column(
                                        children: [
                                          DataTable(
                                            sortAscending: sort,
                                            sortColumnIndex: 0,
                                            columns: <DataColumn>[
                                              DataColumn(
                                                label: Text('순위', style: TextStyle(fontSize: 12, fontFamily: 'GSANSM')),
                                              ),
                                              DataColumn(
                                                label: Text('닉네임', style: TextStyle(fontSize: 12, fontFamily: 'GSANSM')),
                                              ),
                                              DataColumn(
                                                label: Text('승', style: TextStyle(fontSize: 12, fontFamily: 'GSANSM')),
                                              ),
                                              DataColumn(
                                                label: Text('득실', style: TextStyle(fontSize: 12, fontFamily: 'GSANSM')),
                                              ),                                                
                                            ], 
                                            rows: 
                                              _getRankRow(),
                                          ),
                                          Center(child:
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(80, 20), 
                  primary: Colors.white,
                  side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                child: 
                  Text('확인', style: TextStyle(fontFamily: 'GSANSM', fontSize: 14, color: Theme.of(context).primaryColor),)
              ))
                                        ],
                                      )
                                  );
                                }
                              }
                            )
                          ],
                        );
                      }
                    );
                  }, 
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(120, 30), 
                    primary: Colors.white,
                    side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    )
                  ),
                  child: 
                    Text('순위',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'GSANSB',
                        color: Theme.of(context).primaryColor
                      ),
                    ),
                )
            ),
          ],
        )
      // child: 
      
    );
  }

  Widget _gamePanel(TextEditingController score_input1, TextEditingController score_input2, int index, Color panelColor) {
    String buttonStr = '';
    String textColor = '';
    late Color buttonColor;
    if(gameDoublesList[index].isEdit == true)
    {
      buttonStr = '점수확정';
      buttonColor = Color(0xFF424242);
    }
    else
    {
      buttonStr = 'DONE';    
      buttonColor = Colors.white;
    }
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20, 5, 20, 5),            
          decoration: BoxDecoration(
            color: Colors.white,
            border: 
              Border.all(color: Color(0xffe9394f), width: 1),
            borderRadius: BorderRadius.all(
              Radius.circular(5)
            )
          ),
          child: 
            Column(
              children: [
                SizedBox(height: 10,),
                Text(
                    gameDoublesList[index].game_title, 
                    style: Theme.of(context).textTheme.headline2
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: () { 
                    if(gameDoublesList[index].isEdit == true) {
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          //score_check_idx = 0;
                          return SimpleDialog(insetPadding: EdgeInsets.all(5),
                            title: Text("점수 입력 - ${gameDoublesList[index].game_title}", style: TextStyle(fontFamily: 'GSANSM', fontSize: 16),),
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: 
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: 
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                        child: 
                                          Row(                     
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 4,
                                                child:
                                                  Column(
                                                    children: [
                                                      Text('${gameDoublesList[index].player_nickname[0]}', textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'GSANSM',
                                                          fontSize: 12,
                                                          color: Color(0xff9f9f9f)
                                                        ),
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Text('${gameDoublesList[index].player_nickname[1]}', textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'GSANSM',
                                                          fontSize: 12,
                                                          color: Color(0xff9f9f9f)
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: 
                                                  TextFormField(
                                                    controller: score_input1,
                                                    keyboardType: TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 22),
                                                    decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFDBE2E7),
                                                          width: 2,
                                                        ),
                                                        borderRadius: BorderRadius.only(
                                                          bottomLeft: Radius.circular(8),
                                                          bottomRight: Radius.circular(8),
                                                          topLeft: Radius.circular(8),
                                                          topRight: Radius.circular(8),
                                                        ),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFDBE2E7),
                                                          width: 2,
                                                        ),
                                                        borderRadius: BorderRadius.only(
                                                          bottomLeft: Radius.circular(8),
                                                          bottomRight: Radius.circular(8),
                                                          topLeft: Radius.circular(8),
                                                          topRight: Radius.circular(8),
                                                        ),
                                                      )
                                                    )
                                                  ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: 
                                                  Center(child: Text(' : ', style: TextStyle(fontSize: 20),)),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: 
                                                  TextFormField(
                                                    controller: score_input2,
                                                    keyboardType: TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(fontSize: 22),
                                                    decoration: InputDecoration(
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFDBE2E7),
                                                          width: 2,
                                                        ),
                                                        borderRadius: BorderRadius.only(
                                                          bottomLeft: Radius.circular(8),
                                                          bottomRight: Radius.circular(8),
                                                          topLeft: Radius.circular(8),
                                                          topRight: Radius.circular(8),
                                                        ),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Color(0xFFDBE2E7),
                                                          width: 2,
                                                        ),
                                                        borderRadius: BorderRadius.only(
                                                          bottomLeft: Radius.circular(8),
                                                          bottomRight: Radius.circular(8),
                                                          topLeft: Radius.circular(8),
                                                          topRight: Radius.circular(8),
                                                        ),
                                                      )
                                                    )
                                                  ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: 
                                                  Column(
                                                    children: [
                                                      Text('${gameDoublesList[index].player_nickname[2]}', textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'GSANSM',
                                                          fontSize: 12,
                                                          color: Colors.grey[700]
                                                        ),
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Text('${gameDoublesList[index].player_nickname[3]}', textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'GSANSM',
                                                          fontSize: 12,
                                                          color: Colors.grey[700]
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              ),
                                            ],
                                          ),
                                      ),
                                      SizedBox(height: 20,),
                                      Text(score_check_text[1], style: TextStyle(color: Theme.of(context).primaryColor),),
                                      SizedBox(height: 20,),
                                      OutlinedButton(
                                        onPressed: () {
                                          String score = score_input1.text + ':' + score_input2.text;
                                          if( -1 < int.parse(score_input1.text) && int.parse(score_input1.text) < 7 &&
                                              -1 < int.parse(score_input2.text) && int.parse(score_input2.text) < 7) {
                                            if( int.parse(score_input1.text) == int.parse(score_input2.text) ) {   
                                              Future.delayed(Duration(milliseconds: 500), () {
                                                _insertScore(score, index, 0);
                                                Navigator.pop(context, true);
                                              });                              
                                            } else{
                                              if( int.parse(score_input1.text)  == 6 || int.parse(score_input2.text) == 6) {
                                                  Future.delayed(Duration(milliseconds: 500), () {
                                                  _insertScore(score, index, 0);
                                                  Navigator.pop(context, true);
                                                });                              
                                              }
                                            }
                                          }
                                        }, 
                                        child: 
                                          Text('점수입력', style: TextStyle(fontFamily: 'GSANSM', fontSize: 16, color: Theme.of(context).primaryColor))
                                      )  
                                    ],
                                  ),
                              ))
                            ],
                          );
                        }
                      );                    
                    }
                    else {
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('이미 확정된 점수 입니다.'),
                            actions: [
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
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
                    child: 
                      Row(                     
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child:
                              Column(
                                children: [
                                  Text('${gameDoublesList[index].player_nickname[0]}', textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'GSANSM',
                                      color: Colors.grey[700],
                                      fontSize: 14
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text('${gameDoublesList[index].player_nickname[1]}', textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'GSANSM',
                                      color: Colors.grey[700],
                                      fontSize: 14
                                    ),
                                  ),
                                ],
                              )
                          ),
                          Expanded(
                            flex: 1,
                            child:
                              Container(
                                width: 10,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: 
                                  Text('${gameDoublesList[index].score[0]}', textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 26,color: Colors.grey[700]),),
                              )
                              
                          ),
                          Expanded(
                            flex: 2,
                            child: 
                              Center(child: Text(' : ', style: TextStyle(fontSize: 20),)),
                          ),
                          Expanded(
                            flex: 1,
                            child:
                              Container(
                                width: 10,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: 
                                  Text('${gameDoublesList[index].score[1]}', textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 26,color: Colors.grey[700]),),
                              )
                              
                          ),       
                          Expanded(
                            flex: 3,
                            child: 
                              Column(
                                children: [
                                  Text('${gameDoublesList[index].player_nickname[2]}', textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'GSANSM',
                                      color: Colors.grey[700],
                                      fontSize: 14
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Text('${gameDoublesList[index].player_nickname[3]}', textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'GSANSM',
                                      color: Colors.grey[700],
                                      fontSize: 14
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                ),
                SizedBox(height: 15,),
                SizedBox(
                  width: 100,
                  height: 25,
                  child: 
                    ElevatedButton(
                      onPressed: () {
                        if(gameDoublesList[index].isEdit == true) {
                          showDialog(
                            context: context, 
                            builder: (BuildContext context) {
                              String score = gameDoublesList[index].score[0].toString() + ':' + gameDoublesList[index].score[1].toString();
                              if(score == '0:0') {
                                return AlertDialog(
                                  title: Text('점수를 먼저 입력하세요.'),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      }, 
                                      child:  
                                        Text('확인')
                                    )
                                  ],
                                );
                              } else {
                                return AlertDialog(
                                  title: Text('점수 확정을 하면 다시 수정이 불가능합니다.\n확정하시겠습니까?'),
                                  actions: [
                                    OutlinedButton(
                                      onPressed: () {
                                        String score = gameDoublesList[index].score[0].toString() + ':' + gameDoublesList[index].score[1].toString();
                                        {
                                          if( gameDoublesList[index].score[0] == gameDoublesList[index].score[1] ) {
                                            _insertConfirmScore(score, index);
                                            Navigator.pop(context, true);
                                          } else{
                                            if( gameDoublesList[index].score[0] == 6 || gameDoublesList[index].score[1] == 6 ) {
                                              _insertConfirmScore(score, index);
                                              Navigator.pop(context, true);
                                            }
                                          }
                                        }                                    
                                        //_confirmScore(index);
                                      }, 
                                      child: 
                                        Text('확인')
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      }, 
                                      child: 
                                        Text('취소')
                                    )    
                                  ],
                                );
                              }                                  
                            } 
                          );
                        } else {
                          showDialog(
                            context: context, 
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('이미 확정된 점수 입니다.'),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
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
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(120, 20), 
                        primary: panelColor,
                        //primary: Colors.white,
                        side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                        )
                      ),
                      child: 
                        Text(buttonStr,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'GSANSM',
                            color: buttonColor
                          ),
                        ),
                    ),
                ),
                SizedBox(height: 10,)
              ]
            ),
        )
      ]
    );
  }

  Widget _displayGameList(BuildContext context) {
    TextEditingController score_input1 = TextEditingController();
    TextEditingController score_input2 = TextEditingController();

    return Container(
      width: MediaQuery.of(context).size.width,
      child: 
        ListView.builder(
          itemCount: gameDoublesList.length,
          itemBuilder: (context, index) {
            if(matchInfo['game_isEdit']['GAME ' + (index+1).toString()] == false) {
              return _gamePanel(score_input1, score_input2, index, Theme.of(context).primaryColor);
            } else {
              return _gamePanel(score_input1, score_input2, index, Colors.white);
            }
          },
        )
    );
  }

  Widget _matchInfo() {
    String subType = '';    
    subType = 'KDK';
    
    return Container(
      //color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: 100,
      margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
      padding: EdgeInsets.all(10), 
      decoration: BoxDecoration(
        color: Colors.white,
        border: 
          Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.all(
          Radius.circular(5)
        )
      ),     
      child: 
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child:
                Text(matchInfo['name'], 
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 22,
                    fontFamily: 'GSANSB',
                  ),
                ),),
            Expanded(
              flex: 1,
              child: 
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('복식', 
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 22,
                        fontFamily: 'GSANSM',
                      ),
                    ),
                    Text(subType, 
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 22,
                        fontFamily: 'GSANSM',
                      ),
                    ),
                  ]
                ))
          ],
        ),
    );
  }

  List<GameDoubles> _makeGameList(Map<dynamic, dynamic> matchInfo) {
    List<GameDoubles> list = [];

    for(int i = 0; i < matchInfo['player_cnt']; i++) {
      GameDoubles game = GameDoubles();
      game.game_idx = i + 1;
      game.game_title = 'GAME ' + game.game_idx.toString();
      String match = table[i][game.game_title] as String;
      String edit = editTable[i][game.game_title] as String;
      game.match = match;
      game.edit = edit;

      List<String> team = [];
      team = match.split(':');
      var teamplayer = { 0 : team[0].split(','), 1 : team[1].split(',')};

      List<int> idx = [int.parse(teamplayer[0]![0]), int.parse(teamplayer[0]![1])];
      List<int> value1 = [];
      List<int> value2 = [];

      for(int j = 0; j < matchInfo['player_cnt']; j++) {
        if(matchInfo['member_idx'][j] == idx[0]) {
          value1.add(j);
          break;
        }
      }

      for(int j = 0; j < matchInfo['player_cnt']; j++) {
        if(matchInfo['member_idx'][j] == idx[1]) {
          value1.add(j);
          break;
        }
      }
      game.player_idx.add(value1[0]);
      game.player_idx.add(value1[1]);
      
      idx = [int.parse(teamplayer[1]![0]), int.parse(teamplayer[1]![1])];
      for(int j = 0; j < matchInfo['player_cnt']; j++) {
        if(matchInfo['member_idx'][j] == idx[0]) {
          value2.add(j);
          break;
        }
      }

      for(int j = 0; j < matchInfo['player_cnt']; j++) {
        if(matchInfo['member_idx'][j] == idx[1]) {
          value2.add(j);
          break;
        }
      }
      game.player_idx.add(value2[0]);
      game.player_idx.add(value2[1]);
      
      for(int k = 0; k < game.player_idx.length; k++) {
        game.player_uid.add(matchInfo['member_uid'][game.player_idx[k]]);
        game.player_nickname.add(matchInfo['member_nickname'][game.player_idx[k]]);
      }
    
      String score = matchInfo['game_score'][game.game_title];
      List<String> score_temp = score.split(':');
      game.score.add(int.parse(score_temp[0]));
      game.score.add(int.parse(score_temp[1]));

      game.isEdit = matchInfo['game_isEdit'][game.game_title];

      list.add(game);
    }

    return list;
  }

  @override
  void initState() {
    super.initState();

    _tableTimer = Timer(Duration(milliseconds: 200), () {
      showDialog(
        context: context, 
        builder: (BuildContext context) {
          return SimpleDialog(
            insetPadding: EdgeInsets.all(10),
            children: [
              Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    //color: Colors.amberAccent,
                    width: double.infinity,
                    //height: 200,                              
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: 
                      Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: 
                              SingleChildScrollView(
                                child: 
                                  DataTable(
                                    columns: <DataColumn>[
                                      DataColumn(
                                        label: Text('번 호', style: Theme.of(context).textTheme.headline2),
                                      ),
                                      DataColumn(
                                        label: Text('닉네임', style: Theme.of(context).textTheme.headline2),
                                      ),
                                    ], 
                                    rows: 
                                      _getNumberRow(),
                                  ),
                              )
                              
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => MatchKDKTableView(),
                              ),);
                            },
                            child: 
                              Image.asset('assets/images/PNG/kdk.png', width: 200),
                          ),
                          OutlinedButton(
                            onPressed: () {Navigator.pop(context, true);}, 
                            style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.blue,
                                width: 1,
                                style: BorderStyle.solid
                              ), borderRadius: BorderRadius.circular(5)),
                              elevation: 0
                            ),
                            child: 
                              Text('확인')
                          )
                        ],
                    )                                
                  ),
                ],
              )
            ],
          );
        }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    user_account_info_ = Provider.of<UserAccountInfo>(context, listen: false);
    
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/PNG/background.jpg'), fit: BoxFit.cover
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //endDrawer: MatchDrawer(),
      
      appBar: AppBar(
        //backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        title: 
          //Image.asset('assets/images/PNG/logo2.png', width: 110,),
          SvgPicture.asset('assets/images/SVG/LOGO_horizontal_white.svg', width: 110,),
        leading: IconButton(
            onPressed: () {
              if(prevPage.compareTo('home') == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Home(),
                  ),
                );
              } else if(prevPage.compareTo('wait_list') == 0){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => MatchTabPage(),
                  ),
                );
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(          
          child: StreamBuilder<DocumentSnapshot> (
            stream: FirebaseFirestore.instance.collection('Match').doc(matchUid).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if(snapshot.hasError) {
                  return Center(child: Text('Error!!'),);
              }
              if(snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              else {
                matchInfo = snapshot.data!.data() as Map<String, dynamic>;
                List<int> playerIdx = [];
                match_state = matchInfo['matchState'];
                if(matchInfo['matchState'] == 1) {
                  switch (matchInfo['player_cnt']) {
                    case 5:
                      playerIdx = [1, 2, 3, 4, 5];
                    break;
                    case 6:
                      playerIdx = [1, 2, 3, 4, 5, 6];                          
                    break;
                    case 7:
                      playerIdx = [1, 2, 3, 4, 5, 6, 7];                            
                    break;
                    case 8:
                      playerIdx = [1, 2, 3, 4, 5, 6, 7, 8];
                    break;
                    case 9:
                      playerIdx = [1, 2, 3, 4, 5, 6, 7, 8, 9];
                    break;
                    case 10:
                      playerIdx = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
                    break;
                    case 11:
                      playerIdx = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
                    break;
                    case 12:
                      playerIdx = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
                    break;
                    case 13:
                      playerIdx = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];
                    break;
                    case 14:
                      playerIdx = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14];
                    break;
                    case 15:
                      playerIdx = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
                    break;
                    case 16:
                      playerIdx = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
                    break; 
                  }

                  playerIdx.shuffle();
                  FirebaseFirestore.instance.collection('Match').doc(matchUid).set({
                    'member_idx': playerIdx
                  }, SetOptions(merge: true));

                  FirebaseFirestore.instance.collection('Match').doc(matchUid).update({
                    'matchState': 2,
                  }).then((value) => print('ok'));
                } else if(matchInfo['matchState'] == 2 || matchInfo['matchState'] == 3) {
                  MatchDoubleKDKTable matchDoubleKdk = MatchDoubleKDKTable(matchInfo['player_cnt']);
                  table = matchDoubleKdk.makeTable(matchInfo['player_cnt']);
                  editTable = matchDoubleKdk.makeEditTable(matchInfo['player_cnt']);
                  gameDoublesList = _makeGameList(matchInfo);

                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(height: 30,),
                      Container(
                        //flex: 20,
                        child: 
                          _matchInfo(),
                      ),
                      Container(
                        //flex: 10,
                        child: 
                          _resultPage(),
                      ),
                      Expanded(
                        flex: 70,
                        child: 
                          _displayGameList(context),
                      ),
                    ],
                  );
                }
                return Container();
              }
            }
          ),
        )
      ),
      ),
    );
  }
}