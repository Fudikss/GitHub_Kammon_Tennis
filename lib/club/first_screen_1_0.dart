import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/club/ClubMainPage_1_2.dart';
import 'package:snstennis/club/Club_Create_1_2.dart';
import 'package:snstennis/club/Search_Club.dart';
import 'package:snstennis/home.dart';
import 'package:snstennis/instant/instant_main.dart';
import 'package:snstennis/market/Market_Main_Page.dart';

import 'Club_Main_Page.dart';

import 'Winter.dart';

class ClubInfo {
  String uid = '';
  String name = '';
  String intro = '';
  String image_url = "";
  ClubInfo();
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int _selectedNaviIndex = 2;
  late UserAccountInfo user_account_info_;
  late User user;
  List<ClubInfo> clubList = [];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<Map<dynamic, dynamic>> _getData(String userid) async {
    var clubid;
    var data;

    CollectionReference refUsers =
        FirebaseFirestore.instance.collection('Users');
    CollectionReference refClub = FirebaseFirestore.instance.collection('Club');
    DocumentSnapshot snapshotUsers = await refUsers.doc(userid).get();
    clubid = snapshotUsers.data();

    clubList.clear();

    if (clubid['JoinClub'].length != 0) {
      for (int i = 0; i < clubid['JoinClub'].length; i++) {
        DocumentSnapshot snapshotClub =
            await refClub.doc(clubid['JoinClub'][i]).get();
        data = snapshotClub.data();
        ClubInfo info = ClubInfo();
        info.uid = clubid['JoinClub'][i];
        info.name = data['ClubName'];
        info.intro = data['ClubIntro'];
        info.image_url = data['ClubMainImage'];
        clubList.add(info);
      }

      return data;
    } else {
      data = Map();
      return data;
    }
  }

  Widget _myClubList() {
    return Container(
      //color: Colors.amberAccent,
      width: MediaQuery.of(context).size.width,
      height: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              '마이클럽',
              style: TextStyle(
                  fontFamily: 'GSANSB', fontSize: 16, color: Color(0xff58585b)),
            ),
          ),
          Expanded(
              flex: 50,
              child: FutureBuilder(
                  future: _getData(user.uid),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData == false) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(fontSize: 15),
                        ),
                      );
                    } else {
                      if (clubList.length == 0) {
                        return Container(
                            child: Center(child: Text('가입한 클럽이 없습니다.')));
                      } else {
                        return Container(
                            //color: Colors.deepOrange,
                            child: ListView.separated(
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return ClubMainPage(
                                            club_uid: clubList[index].uid,
                                            club_name: clubList[index].name,
                                            image_url:
                                                clubList[index].image_url,
                                            club_intro: clubList[index].intro,
                                            // clubList[index].image_url,
                                          );
                                        }));
                                      },
                                      child: Container(
                                        //height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              width: 0.8),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Text(
                                                clubList[index].name,
                                                style: TextStyle(
                                                    color: Colors.grey[700],
                                                    fontFamily: 'GSANSB'),
                                              ),
                                            )
                                          ],
                                        ),
                                      ));
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Container(
                                      height: 5,
                                    ),
                                  );
                                },
                                itemCount: clubList.length));
                      }
                    }
                  }))
        ],
      ),
    );
  }

  Widget _popularClubList() {
    return Container(
      //color: Colors.amberAccent,
      width: MediaQuery.of(context).size.width,
      height: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '인기클럽',
            style: TextStyle(
                fontFamily: 'GSANSB', fontSize: 16, color: Color(0xff58585b)),
          ),
          //_getJoinClubList(user.uid)
        ],
      ),
    );
  }

  Widget _clubMenu() {
    return Container(
      //color: Colors.blueGrey,
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return ClubCreate();
              }));
            },
            child: SvgPicture.asset(
              'assets/images/SVG/club_create.svg',
              width: 140,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return SearchClub();
                // return Winter();
              }));
            },
            child: SvgPicture.asset(
              'assets/images/SVG/club_search.svg',
              width: 140,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user_account_info_ = Provider.of<UserAccountInfo>(context, listen: false);
    user = FirebaseAuth.instance.currentUser!;

    return WillPopScope(
        onWillPop: () async {
          return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    '종료하시겠습니까?',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontFamily: 'GSANSM'),
                  ),
                  actions: [
                    OutlinedButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: Text(
                          '확인',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontFamily: 'GSANSM'),
                        )),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '취소',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontFamily: 'GSANSM'),
                        ))
                  ],
                );
              });
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          //endDrawer: Drawer(child: HamburgerMenu()),
          appBar: AppBar(
            backgroundColor: Color(0xFFFFFFFF),
            iconTheme: IconThemeData(color: Colors.grey),
            title: SvgPicture.asset(
              'assets/images/SVG/LOGO_KAMMON_small.svg',
              width: 110,
            ),
            automaticallyImplyLeading: false,
            actions: [],
            centerTitle: true,
            elevation: 0,
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Container(
                //color: Colors.amberAccent,
                child: Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  _myClubList(),
                  _clubMenu(),
                  _popularClubList()
                ],
              ),
            )),
          )),
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
                    //backgroundColor: Colors.grey[300],
                    backgroundColor: Colors.white,
                    elevation: 3,
                    selectedItemColor: Theme.of(context).primaryColor,
                    //selectedItemColor: Colors.grey[800],
                    currentIndex: _selectedNaviIndex,
                    onTap: (int index) {
                      _selectedNaviIndex = index;
                      setState(() {
                        if (_selectedNaviIndex == 0) {
                          print(_selectedNaviIndex);
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return Home();
                          }));
                        }
                        if (_selectedNaviIndex == 1) {
                          print(_selectedNaviIndex);
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return InstantPLay();
                          }));
                        }
                        if (_selectedNaviIndex == 2) {
                          print(_selectedNaviIndex);
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return FirstScreen();
                          }));
                        }
                        if (_selectedNaviIndex == 3) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return MarketMainPage(
                                item_id: user_account_info_.marketChatItem);
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
                            style:
                                TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
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
                            style:
                                TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
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
        ));
  }
}
