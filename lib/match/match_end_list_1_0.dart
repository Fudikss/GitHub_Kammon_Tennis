import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/first_screen_1_0.dart';
import 'package:snstennis/home.dart';
import 'package:snstennis/instant/instant_main.dart';
import 'package:snstennis/market/Market_Main_Page.dart';
import 'package:snstennis/match/match_play_doubles_1_0.dart';
import 'package:snstennis/match/match_play_single_kdk_1_0.dart';

class MatchEndList extends StatefulWidget {
  const MatchEndList({ Key? key }) : super(key: key);
  
  @override
  _MatchEndListState createState() => _MatchEndListState();
}

class _MatchEndListState extends State<MatchEndList> {
  int _selectedNaviIndex = 0;
  User? cur_user = FirebaseAuth.instance.currentUser;
  List<String> join_list = [];
  bool isMember = false;
  List<dynamic>game_list = [];
  UserAccountInfo userAccount = UserAccountInfo();

  void _getJoinMatchList() async{
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
    DocumentSnapshot snapshot = await ref.doc(cur_user!.uid).get();

    var data = snapshot.data() as Map;

    for(int i = 0; i < data['join_match_list'].length; i++) {
      join_list.add(data['join_match_list'][i]);
    }
  }

  Widget _getEndList() {
    _getJoinMatchList();
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Match').orderBy('reg_date', descending: true).where('matchState', isEqualTo: 3).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasError) {
          Center(
            child: Text('Something went wrong')
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          //return ListView.separated(
          return ListView.builder(
            itemBuilder: (BuildContext context, idx) {
              DocumentSnapshot data = snapshot.data!.docs[idx];
              
              List member = data['member_uid'] as List;

              isMember = member.contains(cur_user!.uid);
              if(isMember) {
                return Padding(padding: EdgeInsets.all(0),
                  child: GestureDetector(
                    onTap: () {
                      if(data['types'] == 0) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MatchPlaySingleKDK(
                                      matchUid: snapshot.data!.docs[idx].id, prevPage: 'end_list',
                        )));
                      } else if(data['types'] == 2) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MatchPlayDoubles(
                                      matchUid: snapshot.data!.docs[idx].id, prevPage: 'end_list',
                        )));
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
                        child: 
                          Column(
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
                                        '???????????? : ' + data['master']['nickname'].toString(),
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
                            ]
                          ),
                      ),
                  ),
                );
              } else {
                return Container(height: 0,);
              }
            },
            itemCount: snapshot.data!.docs.length,
          );
        }
      }
    );
  }

  @override
  void initState() {
    super.initState();

    //bannerSize = AdmobBannerSize.BANNER;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    UserAccountInfo userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: 
        SafeArea(
          child: 
            Container(
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
                                '?????? ??????', style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          ),
                      ),
                      Expanded(
                        flex: 80,
                        child: _getEndList()
                      ),
                    ],
                  )
                )
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
                      return MarketMainPage(item_id: userAccount_.marketChatItem);
                    }
                  ));
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                title: Text('???', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
                icon: SvgPicture.asset('assets/images/SVG/home.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/home_selected.svg', width: 23,),
              ),
              BottomNavigationBarItem(
                title: Text('??????', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
                icon: SvgPicture.asset('assets/images/SVG/light.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/light_selected.svg', width: 23,),
              ),
              BottomNavigationBarItem(
                title: Text('??????', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
                icon: SvgPicture.asset('assets/images/SVG/club.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/club_selected.svg', width: 23,),
              ),
              BottomNavigationBarItem(
                title: Text('????????????', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
                icon: SvgPicture.asset('assets/images/SVG/basket.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/basket_selected.svg', width: 23,),
              ),
              BottomNavigationBarItem(
                title: Text('?????????', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
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