import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/profile.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/first_screen_1_0.dart';
import 'package:snstennis/instant/instant_main.dart';
import 'package:snstennis/market/Market_Main_Page.dart';
import 'package:snstennis/match/match_play_doubles_1_0.dart';
import 'package:snstennis/match/match_play_single_kdk_1_0.dart';
import 'package:snstennis/match/match_tab_page_1_0.dart';

class UserRecord {
  int win = 0;
  int draw = 0;
  int lose = 0;

  UserRecord();
}

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedNaviIndex = 0;
  UserRecord record = UserRecord();
  User? curUser = FirebaseAuth.instance.currentUser;
  double _win_width = 0.0;
  double _draw_width = 0.0;
  double _lose_width = 0.0;
  bool isMember = false;

  late Timer _rateTimer;

  late File profileImage;
  
  Widget _getEndList() {
    int lastGame = 0;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Match').orderBy('reg_date', descending: true,).where('matchState', isEqualTo: 3).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasError) {
          Center(
            child: Text('Something went wrong')
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, idx) {
              DocumentSnapshot data = snapshot.data!.docs[idx];  
              List member = data['member_uid'] as List;
              isMember = member.contains(curUser!.uid);
              if(isMember) {lastGame++;}
              if(isMember && lastGame < 4) {
                return Padding(
                  padding: EdgeInsets.all(0),
                  child: GestureDetector(
                    onTap: () {
                      if(data['types'] == 0) {
                        Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MatchPlaySingleKDK(
                                    matchUid: snapshot.data!.docs[idx].id, prevPage: 'home',
                        )));
                      }
                      else if(data['types'] == 2) {
                        Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MatchPlayDoubles(
                                    matchUid: snapshot.data!.docs[idx].id, prevPage: 'home',
                        )));
                      }
                    },
                    child: 
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                        decoration: BoxDecoration(
                          //color: Theme.of(context).primaryColorLight,
                          color: Colors.white,
                          border: Border.all(color: Theme.of(context).primaryColorLight, width: 0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: 
                          Column(
                            children: [
                              Padding(padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                                child: 
                                  Row(
                                    children: [
                                      Text(data['name'], 
                                        style: Theme.of(context).textTheme.subtitle1, 
                                        textAlign: TextAlign.start,),
                                    ],
                                  ),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
                                child: 
                                  Row(
                                    children: [
                                      Expanded(
                                      flex: 5,
                                      child: 
                                        Text(
                                        '게임방장 : ' + data['master']['nickname'].toString(),
                                        style: Theme.of(context).textTheme.subtitle2
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child:
                                          Text(
                                            data['player_cur'].toString() + '/' + data['player_cnt'].toString(),
                                            textAlign: TextAlign.end,
                                            style: Theme.of(context).textTheme.subtitle2
                                          )
                                      ),
                                    ],
                                  )
                              ),
                            ]
                          ),
                      ),
                  ),
                );
              } else {
                return Container(height: 0,);
              }
            },
            //itemCount: 3,
            itemCount: snapshot.data!.docs.length,
          );
        }
      }
    );
  }

  Widget _userClub() {    
    return Container(
      //height: 400,
      child : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 20, 5),
            child:
              Row(    
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '최근 경기 결과보기' , style: Theme.of(context).textTheme.headline2,
                  ),
                ], 
              ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child:
              Container(
                //color: Colors.grey,
                height: 270,
                child: _getEndList()
              )
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          //   child:
          //     Container(
          //       color: Colors.deepOrange,
          //       height: 240,
          //       child: Text('광고')
          //     )
          // ),
        ]
      )
    );
  }

  Widget _userInfo(UserAccountInfo userInfo) {
    // return InkWell(
    //   onTap: () {
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (BuildContext context) => Profile(),
    //       ),
    //     );
    //   },
    //   child: 
        return Container(
          child :
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child:
                Row(    
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => Profile(),
                          ),
                        );
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                        width: 40, height: 40,
                        child: 
                          userInfo.profile_image == '' ?
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child:
                              SvgPicture.asset('assets/images/SVG/profile_pink.svg', width: 40,)
                          ) :
                          CircleAvatar(
                            backgroundColor: Colors.white,
                              radius: 120,
                              backgroundImage: NetworkImage(userInfo.profile_image)
                          ),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        userInfo.nickname, 
                        style: Theme.of(context).textTheme.headline1,
                        //style: TextStyle(fontSize: 11, fontFamily: 'GSANSB', color: Theme.of(context).primaryColor),
                      ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                          Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => Profile(),
                          ),
                        );
                      }, 
                      color: Colors.grey[500],
                      iconSize: 30,
                      icon: Icon(Icons.settings)
                    )
                    
                  ], 
                )
            )
        );
    //);
  }

  Future<Map<dynamic, dynamic>> _getUserRecord(String userid) async{
    var data;
    if( userid != '' ) {
      CollectionReference refUsers = FirebaseFirestore.instance.collection('Users');
      DocumentSnapshot snapshotUsers = await refUsers.doc(userid).get();

      data = snapshotUsers.data();

      record.win = data['match_win'];
      record.draw = data['match_draw'];
      record.lose = data['match_loss'];
    }    

    return data;
  }
  
  Widget _winrateCircles(double rate, int win, int draw, int lose) {
    Map<String, double> dataMap = {
      "lose": lose * 1.0,
      "draw": draw * 1.0,
      "win": win * 1.0,
    };
    List<Color> colorList = [
      Colors.red.shade200,
      Colors.white,
      Colors.blue
    ];    

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double devratio = MediaQuery.of(context).devicePixelRatio;
    final chart = PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 0),
      colorList: colorList,
      chartRadius: width / 3.0,
      initialAngleInDegree: 90.0,
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: false,        
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: false,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    );

    double radiusCenterX = 0.85;
    double radiusCenterY = -0.5;
    double out_size = width / 3.0;
    double in_size = width / 5.0;
    //double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          top: 10 + 14,
          left: width - 160,
          child: Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Colors.white//Color(0xFFF9bec3)
                ],
                stops: [0, 1],
                begin: Alignment(1, 0),
                end: Alignment(-0.5, 0.5),
              ),
              shape: BoxShape.circle,
            ),
          )
        ),
        Positioned(
          top: 10 + 17,
          left: width - 157,
          child: Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              //color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
          )
        ),
        Positioned(
          top: 10 + 20,
          left: width - 154,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            shape: BoxShape.circle,
          ),)
        ),
        Positioned(
          top: 40,
          left: width - 154,
          child: Container(
            width: 80,
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('나의 승률',style: 
              TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 8,
                fontFamily: 'GSANSM',
                fontWeight: FontWeight.w900,
              ),)
              ],
            ),
          )
        ),
        Positioned(
          top: 55,
          left: width - 154,
          child: 
            Container(
              width: 80,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(rate.toInt().toString(), 
                    style: 
                      TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 32,
                        fontFamily: 'GSANSB',
                      ),
                  ),
                ],
              )                
            ),
        ),
        Positioned(
          top: 80,
          left: width - 90,
          child: 
            Text('%', 
            style: 
              TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontFamily: 'GSANSB',
                fontWeight: FontWeight.w900
              ),
          ),
        ),
      ],
    );
  }

  Widget _recordText(int win, int draw, int lose) {
    return Container(
      //color: Colors.amberAccent,
      width: 180,
      height: 90,
      child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  win.toString(), 
                  style: 
                    TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'GSANSB',
                    ),
                ),
                Text('승', 
                  style: 
                    TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'GSANSB',
                    ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child:
                    Stack(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xfff599a1),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                          child: AnimatedContainer(
                            //width: win / (win + lose + draw) * 100,
                            width: _win_width,
                            duration: Duration(milliseconds: 1000),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                        )
                      ]
                    )
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  draw.toString(), 
                  style: 
                    TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'GSANSB',
                    ),
                ),
                Text('무', 
                  style: 
                    TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'GSANSB',
                    ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child:
                    Stack(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xfff599a1),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                          child: AnimatedContainer(
                            //width: draw / (win + lose + draw) * 100,
                            width: _draw_width,
                            duration: Duration(milliseconds: 1000),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                        )
                      ]
                    )
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  lose.toString(), 
                  style: 
                    TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'GSANSB',
                    ),
                ),
                Text('패', 
                  style: 
                    TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'GSANSB',
                    ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child:
                    Stack(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xfff599a1),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                          child: AnimatedContainer(
                            //width: lose / (win + lose + draw) * 100,
                            width: _lose_width,
                            duration: Duration(milliseconds: 1000),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                        )
                      ]
                    )
                )
              ],
            ),
          ],
        )
    );
  }
  
  Widget _userRecordPanel(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 170,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          FutureBuilder(
            future: _getUserRecord(curUser!.uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData == false) {
                  return Container();
                }
                else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Error: ${snapshot.error}',
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                } else {
                  double rate;
                  double sum = (record.win.toDouble() + record.draw.toDouble() + record.lose.toDouble());
                  if(sum == 0) {
                    rate = 0.0;
                  }
                  else {
                    rate = record.win.toDouble() / (record.win.toDouble() + record.draw.toDouble() + record.lose.toDouble()) * 100;
                  }    
                  return Container(
                    //color: Colors.grey,
                    child:
                      Stack(
                        children: [                          
                          _winrateCircles(rate, record.win, record.draw, record.lose),
                          Align(
                            alignment: Alignment(-0.9, -0.4),
                            child:
                              _recordText(record.win, record.draw, record.lose),
                          ),            
                        ],
                      )
                      
                  );
                }
            }
          ),
          Align(
            alignment: Alignment(-0.0, 0.85),
            child: 
              Container(
              //color: Colors.lime,
              width: 130, height: 26,
              child: 
                OutlinedButton(
                  onPressed: () {
                    //interstitialAd.show();
                    //rewardAd.show();
                                        
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => MatchTabPage(),
                      ),
                    );
                  },          
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(side: BorderSide(
                      color: Colors.blue,
                      width: 1,
                      style: BorderStyle.solid
                    ), borderRadius: BorderRadius.circular(50)),
                    elevation: 1
                  ),              
                  child: 
                    Text('대진표 바로가기', 
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'GSANSB',
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor
                      ),
                    ),                      
                )
            )
          ),
        ],
      )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //광고
    //bannerSize = AdmobBannerSize.BANNER;
    

    _rateTimer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        if(record.win + record.lose + record.draw != 0) {
        _win_width = record.win / (record.win + record.lose + record.draw) * 100;
        _draw_width = record.draw / (record.win + record.lose + record.draw) * 100;
        _lose_width = record.lose / (record.win + record.lose + record.draw) * 100;
      }
      });
      
    });
  }

  Future<Map<dynamic, dynamic>> _getMarketChat(String userId) async {
    var data;
    CollectionReference refmarket = FirebaseFirestore.instance.collection('Users');
    DocumentSnapshot snapshotMarket = await refmarket.doc(userId).collection('TotalMarketChat').doc('MarketChat').get();
    data = snapshotMarket.data();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    UserAccountInfo userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        //SystemNavigator.pop();
        //return true;
        return await showDialog(
          context: context, 
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('종료하시겠습니까?', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontFamily: 'GSANSM'),),
              actions: [
                OutlinedButton(onPressed: () {
                  SystemNavigator.pop();
                }, child: Text('확인', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontFamily: 'GSANSM'),)),
                OutlinedButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text('취소', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontFamily: 'GSANSM'),))
              ],
            );
          }
        );
      },
      child: Scaffold(
        //endDrawer: Drawer(child:HamburgerMenu()),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          iconTheme: IconThemeData(color: Colors.grey),
          automaticallyImplyLeading: false,
          title: 
            SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: 
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    _userInfo(userAccount_),
                    _userRecordPanel(context),
                    _userClub()
                  ],
                )
              )
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
              backgroundColor: Colors.white,
              elevation: 3,
              selectedItemColor: Theme.of(context).primaryColor,
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
                        return MarketMainPage(item_id: userAccount_.marketChatItem);
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
      
      )
    );

    // return Scaffold(
    //   endDrawer: Drawer(child:HamburgerMenu()),
    //   backgroundColor: Colors.white,
    //   appBar: AppBar(
    //     backgroundColor: Color(0xFFFFFFFF),
    //     iconTheme: IconThemeData(color: Colors.grey),
    //     automaticallyImplyLeading: false,
    //     title: 
    //       SvgPicture.asset('assets/images/SVG/LOGO_horizontal.svg', width: 110,),
    //     actions: [],
    //     centerTitle: true,
    //     elevation: 0,
    //   ),
    //   body: SafeArea(
    //     child: SingleChildScrollView(
    //       child: 
    //         Padding(
    //           padding: EdgeInsets.all(20),
    //           child: Column(
    //             children: [
    //               SizedBox(height: 30,),
    //               _userInfo(userAccount_),
    //               _userRecordPanel(context),
    //               _userClub()
    //             ],
    //           )
    //         )
    //     )
    //   ),
    //   bottomNavigationBar: SizedBox(
    //     height: 60,
    //     child: Container(
    //       decoration: BoxDecoration(
    //         boxShadow: <BoxShadow>[
    //           BoxShadow(
    //               color: Colors.black54,
    //               blurRadius: 5.0,
    //               offset: Offset(0.0, 0.75)
    //           )
    //         ],
    //       ),
    //       child: BottomNavigationBar(
    //         type: BottomNavigationBarType.fixed,
    //         //backgroundColor: Colors.grey[300],
    //         backgroundColor: Colors.white,
    //         elevation: 3,
    //         selectedItemColor: Theme.of(context).primaryColor,
    //         //selectedItemColor: Colors.grey[800],
    //         currentIndex: _selectedNaviIndex,
    //         onTap: (int index) {
    //           _selectedNaviIndex = index;
    //           setState(() {
    //             if(_selectedNaviIndex == 0) { 
    //               print(_selectedNaviIndex);
    //               Navigator.push(context, MaterialPageRoute(
    //                   builder: (BuildContext context){
    //                     return Home();
    //                   }
    //               ));
    //             }
    //             if(_selectedNaviIndex == 1) { 
    //               print(_selectedNaviIndex);
    //               Navigator.push(context, MaterialPageRoute(
    //                   builder: (BuildContext context){
    //                     return InstantPLay();
    //                   }
    //               ));
    //             }
    //             if(_selectedNaviIndex == 2) { 
    //               print(_selectedNaviIndex);
    //               Navigator.push(context, MaterialPageRoute(
    //                   builder: (BuildContext context){
    //                     return FirstScreen();
    //                   }
    //               ));
    //             }
    //             if(_selectedNaviIndex == 3) { 
    //               Navigator.push(context, MaterialPageRoute(
    //                 builder: (BuildContext context){
    //                   return MarketMainPage(item_id: userAccount_.marketChatItem);
    //                 }
    //               ));
    //             }
    //           });
    //         },
    //         items: [
    //           BottomNavigationBarItem(
    //             title: Text('홈', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
    //             icon: SvgPicture.asset('assets/images/SVG/home.svg', width: 23,),
    //             activeIcon: SvgPicture.asset('assets/images/SVG/home_selected.svg', width: 23,),
    //           ),
    //           BottomNavigationBarItem(
    //             title: Text('벙개', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
    //             icon: SvgPicture.asset('assets/images/SVG/light.svg', width: 23,),
    //             activeIcon: SvgPicture.asset('assets/images/SVG/light_selected.svg', width: 23,),
    //           ),
    //           BottomNavigationBarItem(
    //             title: Text('클럽', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
    //             icon: SvgPicture.asset('assets/images/SVG/club.svg', width: 23,),
    //             activeIcon: SvgPicture.asset('assets/images/SVG/club_selected.svg', width: 23,),
    //           ),
    //           BottomNavigationBarItem(
    //             title: Text('중고장터', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
    //             icon: SvgPicture.asset('assets/images/SVG/basket.svg', width: 23,),
    //             activeIcon: SvgPicture.asset('assets/images/SVG/basket_selected.svg', width: 23,),
    //           ),
    //           BottomNavigationBarItem(
    //             title: Text('더보기', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
    //             icon: SvgPicture.asset('assets/images/SVG/more.svg', width: 23,),
    //             activeIcon: SvgPicture.asset('assets/images/SVG/more_selected.svg', width: 23,),
    //           ),
    //         ],
    //       )
    //     )
    //   ),
    // );
  }
}