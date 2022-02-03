import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/club_drawer_1_0.dart';
import 'package:snstennis/club/first_screen_1_0.dart';
import 'package:snstennis/home.dart';
import 'package:snstennis/instant/instant_main.dart';
import 'package:snstennis/market/Market_Main_Page.dart';

class JoinNomalPost extends StatefulWidget {
  final int index;
  final String club_name;
  final String club_uid;

  const JoinNomalPost(
      {Key? key,
      required this.index,
      required this.club_uid,
      required this.club_name})
      : super(key: key);

  @override
  _JoinNomalPostState createState() =>
      _JoinNomalPostState(index, club_name, club_uid);
}

class _JoinNomalPostState extends State<JoinNomalPost> {
  int post_index;
  String name = "";
  String club_uid = '';
  int _selectedNaviIndex = 2;
  late User user;

  _JoinNomalPostState(this.post_index, this.name, this.club_uid);

  String post_title_name = "";
  late String key_number;

  Widget _comment_stream() {
    return SafeArea(
      child: Container(
        height: 180,
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Club")
              .doc(club_uid)
              .collection("Post")
              .doc("NomalPost")
              .collection("NomalPostComment")
              .doc("NomalComment")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Error!");
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              Map<String, dynamic> comment_data =
                  snapshot.data!.data() as Map<String, dynamic>;

              List comment_title = [];
              List comment_datetime = [];
              List comment_nickname = [];

              if (comment_data[key_number] != null) {
                for (int i = 0; i < comment_data[key_number].length; i++) {
                  comment_title.add(comment_data[key_number][i]["Comment"]);
                  comment_datetime.add(comment_data[key_number][i]["DateTime"]);
                  comment_nickname.add(comment_data[key_number][i]["NickName"]);
                }
                return Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Container(
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return SingleChildScrollView(
                            child: Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListTile(
                                  leading: Text(comment_nickname[index]),
                                  title: Text(comment_title[index]),
                                  trailing: Text(comment_datetime[index]),
                                  dense: true,
                                  onTap: () {},
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 1,
                          );
                        },
                        itemCount: comment_title.length,
                      ),
                    ),
                  ),
                );
              } else {
                return Container(child: Text('\n등록된 댓글이 없습니다.'));
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserAccountInfo userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
    return Scaffold(
      endDrawer: Drawer(
          child: ClubDrawer(
        club_uid: name,
        club_name: club_uid,
      )),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/SVG/LOGO_KAMMON_small.svg',
          width: 110,
        ),
        //SvgPicture.asset('assets/images/SVG/logo.svg', width: 150,),
        leading: IconButton(
          onPressed: () {
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
        color: Color(0xFFFFFFFF),
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Club")
                    .doc(club_uid)
                    .collection("Post")
                    .doc("NomalPost")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error!");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    String a = "";
                    String b = "";

                    key_number = data["NomalPost"][post_index]["KeyNumber"];

                    a = data["NomalPost"][post_index]["ClubPostTitle"];
                    b = data["NomalPost"][post_index]["ClubPostIntro"];

                    post_title_name = a;
                    return Container(
                        child: Column(children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                          width: 350,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                              width: 2,
                              color: Colors.grey.shade400,
                            )),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Text(
                              a,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'GSANSM',
                              ),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Container(
                            width: 350,
                            height: 25,
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                width: 1,
                                color: Colors.grey.shade600,
                              )),
                            ),
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      'https://www.edmundsgovtech.com/wp-content/uploads/2020/01/default-picture_0_0.png',
                                      //Image.network('gs://commontest-c3dc8.appspot.com/Users/KakaoTalk_20210822_005858328.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    ///
                                    /// 작성한 회원의 사진과 이름 출력 부분
                                    ///
                                    a,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'GSANSM',
                                    ),
                                  ),
                                ]))),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: 350,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Color(0xffFBD6C2),
                          borderRadius: BorderRadius.circular(5),
                          // border: Border.all(
                          //     color: Colors.grey
                          // ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Text(
                            b,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'GSANSM',
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ]));
                  }
                },
              ),
              _comment_stream(),
            ],
          ),
        ),
      ))),
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
