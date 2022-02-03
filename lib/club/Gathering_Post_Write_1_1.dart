import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/club_drawer_1_0.dart';
import 'package:snstennis/club/first_screen_1_0.dart';
import 'package:snstennis/home.dart';
import 'package:snstennis/instant/instant_main.dart';
import 'package:snstennis/market/Market_Main_Page.dart';

///
/// 모임 클래스
///
class Gathering extends StatefulWidget {
  final String club_name;
  final String club_uid;
  const Gathering({Key? key, required this.club_uid, required this.club_name})
      : super(key: key);

  @override
  _GatheringState createState() => _GatheringState(club_uid, club_name);
}

class _GatheringState extends State<Gathering> {
  ///
  /// 클럽 게시글 데이터
  ///
  String club_write_title = "";
  String club_write_intro = "";
  String club_write_tag = "";
  String club_write_max_number = "";

  final formKey = new GlobalKey<FormState>();
  String name = "";
  String club_uid;
  int _selectedNaviIndex = 1;

  _GatheringState(this.club_uid, this.name);

  User user = FirebaseAuth.instance.currentUser!;

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print(
          "success $club_write_title, $club_write_intro, $club_write_max_number");
    } else {
      print("failed");
    }
  }

  //List<bool> isSelected = [true, false];

  //String access = "NoticePost";

  List clubpostinfo = [];

  @override
  Widget build(BuildContext context) {
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                "글 작성을 취소하시겠습니까?",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontFamily: 'GSANSM'),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      child: Text(
                        "계속 작성",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                            fontFamily: 'GSANSM'),
                      ),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(95, 20),
                          primary: Colors.white,
                          side: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    OutlinedButton(
                      child: Text(
                        "취소",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                            fontFamily: 'GSANSM'),
                      ),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(95, 20),
                          primary: Colors.white,
                          side: BorderSide(
                              width: 1, color: Theme.of(context).primaryColor),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (BuildContext context) {
                        //   return MarketMainPage(item_id: user_account_info_.marketChatItem,);
                        // }));
                        Navigator.of(context)..pop()..pop();
                      },
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
      child: Scaffold(
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
          title:
              // Image.asset(
              //   'assets/images/PNG/logo2.png',
              //   width: 110,
              // ),
              SvgPicture.asset(
            'assets/images/SVG/LOGO_horizontal.svg',
            width: 110,
          ),
          leading: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                      "글 작성을 취소하시겠습니까?",
                      style: TextStyle(
                          fontFamily: 'GSANSM',
                          fontSize: 16,
                          color: Colors.grey[700]),
                    ),
                    actions: <Widget>[
                      OutlinedButton(
                        child: Text(
                          "계속 작성하기",
                          style: TextStyle(fontFamily: 'GSANSM', fontSize: 14),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      OutlinedButton(
                        child: Text(
                          "취소하기",
                          style: TextStyle(fontFamily: 'GSANSM', fontSize: 14),
                        ),
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(
                          //   builder: (BuildContext context) {
                          //   return MarketMainPage(item_id: user_account_info_.marketChatItem,);
                          // }));
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
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),

                ///
                /// 각각 텍스트 필드 박스 크기 조정 필요
                ///
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextFormField(
                          style: TextStyle(
                              fontFamily: 'GSANSM',
                              fontSize: 14,
                              color: Colors.black),
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: "모임 제목 입력",
                            labelStyle: TextStyle(
                                fontFamily: 'GSANSM',
                                fontSize: 14,
                                color: Color(0xff9f9f9f)),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFDBE2E7),
                                width: 0.8,
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
                                width: 0.8,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0.8),
                                bottomRight: Radius.circular(0.8),
                                topLeft: Radius.circular(0.8),
                                topRight: Radius.circular(0.8),
                              ),
                            ),
                            filled: true,
                          ),
                          validator: (value) =>
                              value!.isEmpty ? '제목이 없습니다' : null,
                          onSaved: (value) => club_write_title = value!,
                        ),
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: TextFormField(
                      maxLines: 40,
                      keyboardType: TextInputType.multiline,
                      //expands: true,
                      obscureText: false,
                      style: TextStyle(
                          fontFamily: 'GSANSM',
                          fontSize: 14,
                          color: Colors.black),
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        hintText: '모임 내용 입력',
                        hintStyle: TextStyle(
                            fontFamily: 'GSANSM',
                            fontSize: 14,
                            color: Color(0xff9f9f9f)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 0.8,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 0.8,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        //filled: true,
                      ),
                      validator: (value) => value!.isEmpty ? '내용이 없습니다.' : null,
                      onSaved: (value) => club_write_intro = value!,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontFamily: 'GSANSM',
                              fontSize: 14,
                              color: Colors.black),
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: "모임 인원 입력",
                            labelStyle: TextStyle(
                                fontFamily: 'GSANSM',
                                fontSize: 14,
                                color: Color(0xff9f9f9f)),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFDBE2E7),
                                width: 0.8,
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
                                width: 0.8,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0.8),
                                bottomRight: Radius.circular(0.8),
                                topLeft: Radius.circular(0.8),
                                topRight: Radius.circular(0.8),
                              ),
                            ),
                            filled: true,
                          ),
                          validator: (value) =>
                              value!.isEmpty ? '인원이 없습니다.' : null,
                          onSaved: (value) => club_write_max_number = value!,
                        ),
                      ),
                    ),
                  ]),
                ),
                // SizedBox(
                //   height: 10.0,
                // ),
                // Container(
                //   height: 100,
                //   width: MediaQuery.of(context).size.width,
                //   child: Row(children: [
                //     Expanded(
                //       child: Padding(
                //         padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                //         child: TextFormField(
                //           decoration: InputDecoration(
                //             labelText: "모집 내용 입력",
                //             fillColor: Colors.white,
                //             labelStyle:
                //                 TextStyle(color: Colors.grey, fontSize: 15),
                //             enabledBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                 color: Color(0xFFDBE2E7),
                //                 width: 2,
                //               ),
                //               borderRadius: BorderRadius.only(
                //                 bottomLeft: Radius.circular(8),
                //                 bottomRight: Radius.circular(8),
                //                 topLeft: Radius.circular(8),
                //                 topRight: Radius.circular(8),
                //               ),
                //             ),
                //             focusedBorder: OutlineInputBorder(
                //               borderSide: BorderSide(
                //                 color: Color(0xFFDBE2E7),
                //                 width: 2,
                //               ),
                //               borderRadius: BorderRadius.only(
                //                 bottomLeft: Radius.circular(8),
                //                 bottomRight: Radius.circular(8),
                //                 topLeft: Radius.circular(8),
                //                 topRight: Radius.circular(8),
                //               ),
                //             ),
                //             filled: true,
                //           ),
                //           validator: (value) =>
                //               value!.isEmpty ? 'Failed Club_write_intro' : null,
                //           onSaved: (value) => club_write_intro = value!,
                //         ),
                //       ),
                //     ),
                //   ]),
                // ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigator.pop(context);
                        validateAndSave();

                        List gathering_post_data = [];
                        try {
                          var docid = FirebaseFirestore.instance
                              .collection("Club")
                              .doc(name)
                              .collection("Post")
                              .doc("GatheringPost")
                              .collection("GatheringPostList")
                              .doc();

                          clubpostinfo.add({
                            "ClubPostTitle": club_write_title,
                            "ClubPostIntro": club_write_intro,
                            "DateTime": formatDate(
                                DateTime.now(), [yyyy, ".", mm, '.', dd]),
                            "GatheringMaster": user.uid,
                            "NickName": userAccount_.nickname,
                            "PersonNumber": 1,
                            "MaxNumber": club_write_max_number,
                            "GatheringPostJoinList": docid.id
                          });

                          FirebaseFirestore.instance
                              .collection("Club")
                              .doc(name)
                              .collection("Post")
                              .doc("GatheringPost")
                              .update({
                            "GatheringPost":
                                FieldValue.arrayUnion(clubpostinfo),
                          });

                          gathering_post_data = [
                            {
                              "User": "${user.uid}",
                              "State": "주최자",
                              "NickName": userAccount_.nickname,
                              "Profile_image": userAccount_.profile_image,
                              "Participation": "운영진",
                              "Guest": "0",
                              "Grade": userAccount_.grade
                            }
                          ];

                          FirebaseFirestore.instance
                              .collection("Club")
                              .doc(name)
                              .collection("Post")
                              .doc("GatheringPost")
                              .collection("GatheringPostList")
                              .doc(docid.id)
                              .set({
                            club_write_title:
                                FieldValue.arrayUnion(gathering_post_data)
                          });

                          ///
                          /// GatheringPost 생성하면서 FireStore 모임 모집 DB를 만들어야한다.
                          ///
                          clubpostinfo.clear();

                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Color(0xffe9394f),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color(0xffe9394f),
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(50)),
                          elevation: 0),
                      child: Text(
                        "모집글 등록",
                        style: TextStyle(
                            fontFamily: 'GSANSB',
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                        offset: Offset(0.0, 0.75))
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
                      if (_selectedNaviIndex == 0) {
                        print(_selectedNaviIndex);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Home();
                        }));
                      }
                      if (_selectedNaviIndex == 1) {
                        print(_selectedNaviIndex);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return InstantPLay();
                        }));
                      }
                      if (_selectedNaviIndex == 2) {
                        print(_selectedNaviIndex);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return FirstScreen();
                        }));
                      }
                      if (_selectedNaviIndex == 3) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return MarketMainPage(
                              item_id: userAccount_.marketChatItem);
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
                          style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
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
                          style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
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
      ),
    );
  }
}









//1.0.0+7
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:date_format/date_format.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/club/club_drawer_1_0.dart';
// import 'package:snstennis/club/first_screen_1_0.dart';
// import 'package:snstennis/home.dart';
// import 'package:snstennis/instant/instant_main.dart';
// import 'package:snstennis/market/Market_Main_Page.dart';

// ///
// /// 모임 클래스
// ///
// class Gathering extends StatefulWidget {
//   final String club_name;
//   final String club_uid;
//   const Gathering({Key? key, required this.club_uid, required this.club_name})
//       : super(key: key);

//   @override
//   _GatheringState createState() => _GatheringState(club_uid, club_name);
// }

// class _GatheringState extends State<Gathering> {
//   ///
//   /// 클럽 게시글 데이터
//   ///
//   String club_write_title = "";
//   String club_write_intro = "";
//   String club_write_tag = "";

//   final formKey = new GlobalKey<FormState>();
//   String name = "";
//   String club_uid;
//   int _selectedNaviIndex = 2;

//   _GatheringState(this.club_uid, this.name);

//   User user = FirebaseAuth.instance.currentUser!;

//   void validateAndSave() {
//     final form = formKey.currentState;
//     if (form!.validate()) {
//       form.save();
//       print("success $club_write_title, $club_write_intro, $club_write_tag");
//     } else {
//       print("failed");
//     }
//   }

//   //List<bool> isSelected = [true, false];

//   //String access = "NoticePost";

//   List clubpostinfo = [];

//   @override
//   Widget build(BuildContext context) {
//     UserAccountInfo userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
//     return Scaffold(
//         endDrawer: Drawer(
//             child: ClubDrawer(
//           club_uid: name,
//           club_name: club_uid,
//         )),
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Color(0xFFFFFFFF),
//           iconTheme: IconThemeData(color: Colors.grey),
//           automaticallyImplyLeading: false,
//           title:
//               // Image.asset(
//               //   'assets/images/PNG/logo2.png',
//               //   width: 110,
//               // ),
//               SvgPicture.asset(
//             'assets/images/SVG/LOGO_KAMMON_small.svg',
//             width: 110,
//           ),
//           leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             icon: Icon(Icons.arrow_back_ios),
//           ),
//           actions: [],
//           centerTitle: true,
//           elevation: 0,
//         ),
//         body: Form(
//           key: formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(
//                   height: 20,
//                 ),

//                 ///
//                 /// 각각 텍스트 필드 박스 크기 조정 필요
//                 ///
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: 50,
//                   child: Row(children: [
//                     Expanded(
//                       child: Padding(
//                         padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                         child: TextFormField(
//                           style: TextStyle(
//                               fontFamily: 'GSANSM',
//                               fontSize: 14,
//                               color: Colors.black),
//                           obscureText: false,
//                           decoration: InputDecoration(
//                             labelText: "모집 제목 입력",
//                             labelStyle: TextStyle(
//                                 fontFamily: 'GSANSM',
//                                 fontSize: 14,
//                                 color: Color(0xff9f9f9f)),
//                             fillColor: Colors.white,
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Color(0xFFDBE2E7),
//                                 width: 0.8,
//                               ),
//                               borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(8),
//                                 bottomRight: Radius.circular(8),
//                                 topLeft: Radius.circular(8),
//                                 topRight: Radius.circular(8),
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Color(0xFFDBE2E7),
//                                 width: 0.8,
//                               ),
//                               borderRadius: BorderRadius.only(
//                                 bottomLeft: Radius.circular(0.8),
//                                 bottomRight: Radius.circular(0.8),
//                                 topLeft: Radius.circular(0.8),
//                                 topRight: Radius.circular(0.8),
//                               ),
//                             ),
//                             filled: true,
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Failed Club_write_title' : null,
//                           onSaved: (value) => club_write_title = value!,
//                         ),
//                       ),
//                     ),
//                   ]),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     height: 200,
//                     child: TextFormField(
//                       maxLines: 40,
//                       keyboardType: TextInputType.multiline,
//                       //expands: true,
//                       obscureText: false,
//                       style: TextStyle(
//                           fontFamily: 'GSANSM',
//                           fontSize: 14,
//                           color: Colors.black),
//                       decoration: InputDecoration(
//                         contentPadding: new EdgeInsets.symmetric(
//                             vertical: 10.0, horizontal: 10.0),
//                         hintText: '모집 내용 입력',
//                         hintStyle: TextStyle(
//                             fontFamily: 'GSANSM',
//                             fontSize: 14,
//                             color: Color(0xff9f9f9f)),
//                         enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Colors.grey.shade300,
//                               width: 0.8,
//                             ),
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(5))),
//                         focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Colors.grey.shade300,
//                               width: 0.8,
//                             ),
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(5))),
//                         //filled: true,
//                       ),
//                       validator: (value) =>
//                           value!.isEmpty ? 'Failed Club write Intro' : null,
//                       onSaved: (value) => club_write_intro = value!,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(40, 50, 40, 0),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         //Navigator.pop(context);
//                         validateAndSave();

//                         List gathering_post_data = [];
//                         try {
//                           ///
//                           /// 해당 작성자 uid를 넣어야함
//                           ///
//                           clubpostinfo.add({
//                             "ClubPostTitle": club_write_title,
//                             "ClubPostIntro": club_write_intro,
//                             "DateTime": formatDate(
//                                 DateTime.now(), [yyyy, ".", mm, '.', dd]),
//                             "GatheringMaster": user.uid,
//                             "NickName": userAccount_.nickname
//                           });

//                           FirebaseFirestore.instance
//                               .collection("Club")
//                               .doc(name)
//                               .collection("Post")
//                               .doc("GatheringPost")
//                               .update({
//                             "GatheringPost":
//                                 FieldValue.arrayUnion(clubpostinfo),
//                           });

//                           gathering_post_data = [
//                             {
//                               "User": "${user.uid}",
//                               "State": "주최자",
//                               "NickName": userAccount_.nickname
//                             }
//                           ];

//                           FirebaseFirestore.instance
//                               .collection("Club")
//                               .doc(name)
//                               .collection("Post")
//                               .doc("GatheringPost")
//                               .collection("GatheringPostList")
//                               .doc("GatheringJoinList")
//                               .update({
//                             club_write_title:
//                                 FieldValue.arrayUnion(gathering_post_data)
//                           });

//                           ///
//                           /// GatheringPost 생성하면서 FireStore 모임 모집 DB를 만들어야한다.
//                           ///
//                           clubpostinfo.clear();

//                           Navigator.pop(context);
//                         } catch (e) {
//                           print(e);
//                         }
//                       },
//                       style: OutlinedButton.styleFrom(
//                           primary: Colors.white,
//                           backgroundColor: Color(0xffe9394f),
//                           shape: RoundedRectangleBorder(
//                               side: BorderSide(
//                                   color: Color(0xffe9394f),
//                                   width: 1,
//                                   style: BorderStyle.solid),
//                               borderRadius: BorderRadius.circular(50)),
//                           elevation: 0),
//                       child: Text(
//                         "모집글 등록",
//                         style: TextStyle(
//                             fontFamily: 'GSANSB',
//                             fontSize: 16,
//                             color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
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
//                       return MarketMainPage(item_id: userAccount_.marketChatItem);
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
//       ),);
//   }
// }
