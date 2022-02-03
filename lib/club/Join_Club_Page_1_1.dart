import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:date_format/date_format.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/Join_Nomal_Post.dart';
import 'package:snstennis/club/Join_Notice_Post.dart';
import 'package:snstennis/hamburger.dart';

class JoinClubPage extends StatefulWidget {
  final String club_uid;
  final String club_name;
  const JoinClubPage(
      {Key? key, required this.club_uid, required this.club_name})
      : super(key: key);

  @override
  _JoinClubPageState createState() => _JoinClubPageState(club_uid, club_name);
}

class _JoinClubPageState extends State<JoinClubPage> {
  String name = "";
  String club_uid = '';
  late User user;

  late bool join_check = false;

  Future _get_WaitMemberList() async {
    print("_get_WaitMemberList 실행");
    List member_list = [];
    late bool check;
    CollectionReference refWait_Club = FirebaseFirestore.instance
        .collection("Club")
        .doc(club_uid)
        .collection("ClubMember");

    DocumentSnapshot snapshot_Wait_Membet_List =
        await refWait_Club.doc("WaitJoinClub").get();

    if (snapshot_Wait_Membet_List["WaitJoinClub"].length != 0) {
      for (int i = 0;
          i < snapshot_Wait_Membet_List["WaitJoinClub"].length;
          i++) {
        member_list
            .add(snapshot_Wait_Membet_List["WaitJoinClub"][i]["UserUID"]);
      }

      for (int i = 0; i < member_list.length; i++) {
        if (user.uid == member_list[i]) {
          // this.join_check = true;
          check = true;
          print("성공함수실행");
        }
      }
    } else {
      // setState(() {
      //   join_check = false;
      //   print("실패함수실행");
      // });
      check = false;
      print("실패함수실행");
    }
  }

  void change_State() {
    setState(() {
      print("state실행");
      this.join_check;
    });
  }

  _JoinClubPageState(this.club_uid, this.name);

  Widget _noticeBorad() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '공지사항',
                style: TextStyle(
                    fontFamily: 'GSANSB',
                    color: Color(0xff58585b),
                    fontSize: 16),
              ),
              Text(
                '더보기',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'GSANSM', fontSize: 12.0),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Club")
                    .doc(club_uid)
                    .collection("Post")
                    .doc("NoticePost")
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
                    List a = [];
                    List b = [];
                    List key_num = [];
                    List date_time = [];

                    List revers_title = [];
                    List revers_Nick = [];
                    List revers_key_num = [];
                    List revers_date_time = [];

                    if (data["NoticePost"].length != 0) {
                      for (int i = 0; i < data["NoticePost"].length; i++) {
                        a.add(data["NoticePost"][i]["ClubPostTitle"]);
                        b.add(data["NoticePost"][i]["NickName"]);
                        date_time.add(data["NoticePost"][i]["DateTime"]);
                        key_num.add(data["NoticePost"][i]["KeyNumber"]);
                      }

                      revers_title = List.of(a.reversed);
                      revers_Nick = List.of(b.reversed);
                      revers_date_time = List.of(date_time.reversed);
                      revers_key_num = List.of(key_num.reversed);

                      return ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5)),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return JoinNoticePost(
                                        index: int.parse(revers_key_num[index]),
                                        club_name: name,
                                        club_uid: club_uid,
                                      );
                                    }));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          revers_date_time[index],
                                          style: TextStyle(
                                              fontFamily: 'GSANSM',
                                              color: Color(0xff58585b),
                                              fontSize: 14),
                                        ),
                                        Text(revers_title[index],
                                            style: TextStyle(
                                                fontFamily: 'GSANSM',
                                                color: Color(0xff58585b),
                                                fontSize: 14)),
                                        Text(
                                          revers_Nick[index],
                                          style: TextStyle(
                                              fontFamily: 'GSANSM',
                                              color: Color(0xff9f9f9f),
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(height: 1);
                          },
                          itemCount: a.length);
                    } else {
                      return Container(child: Text('\n등록된 글이 없습니다.'));
                    }
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget _normalBoard() {
    return Container(
      height: 100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '게시판',
                style: TextStyle(
                    fontFamily: 'GSANSB',
                    color: Color(0xff58585b),
                    fontSize: 16),
              ),
              Text(
                '더보기',
                style: TextStyle(
                    color: Colors.black, fontFamily: 'GSANSM', fontSize: 12.0),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 60,
            child: StreamBuilder<DocumentSnapshot>(
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
                    List a = [];
                    List b = [];
                    List date_time = [];

                    List revers_title = [];
                    List revers_Nick = [];
                    List revers_date_time = [];

                    if (data["NomalPost"].length != 0) {
                      for (int i = 0; i < data["NomalPost"].length; i++) {
                        a.add(data["NomalPost"][i]["ClubPostTitle"]);
                        b.add(data["NomalPost"][i]["NickName"]);
                        date_time.add(data["NomalPost"][i]["DateTime"]);
                      }

                      revers_title = List.of(a.reversed);
                      revers_Nick = List.of(b.reversed);
                      revers_date_time = List.of(date_time.reversed);

                      return ListView.separated(
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5)),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return JoinNomalPost(
                                        index: index,
                                        club_name: name,
                                        club_uid: club_uid,
                                      );
                                    }));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          revers_date_time[index],
                                          style: TextStyle(
                                              fontFamily: 'GSANSM',
                                              color: Color(0xff58585b),
                                              fontSize: 14),
                                        ),
                                        Text(revers_title[index],
                                            style: TextStyle(
                                                fontFamily: 'GSANSM',
                                                color: Color(0xff58585b),
                                                fontSize: 14)),
                                        Text(
                                          revers_Nick[index],
                                          style: TextStyle(
                                              fontFamily: 'GSANSM',
                                              color: Color(0xff9f9f9f),
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(height: 1);
                          },
                          itemCount: a.length);
                    } else {
                      return Container(child: Text('\n등록된 글이 없습니다.'));
                    }
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget _bottomButton() {
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);

    print(join_check);
    if (join_check == false) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: ElevatedButton(
              onPressed: () async {
                List total_data = [
                  {
                    "UserUID": user.uid,
                    "DateTime":
                        formatDate(DateTime.now(), [yyyy, ".", mm, '.', dd]),
                    "WaitUserName": userAccount_.nickname
                  }
                ];

                try {
                  await FirebaseFirestore.instance
                      .collection("Club")
                      .doc(club_uid)
                      .collection("ClubMember")
                      .doc("WaitJoinClub")
                      .update({
                    "WaitJoinClub": FieldValue.arrayUnion(total_data),
                  });

                  setState(() {
                    this.join_check = true;
                  });

                  Navigator.of(context)..pop()..pop()..pop()..pop();
                } catch (e) {
                  print(e);
                }
              },
              style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Color(0xffe9394f),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(50)),
                  elevation: 1),
              child: Text(
                "가입하기",
                style: TextStyle(
                  fontFamily: 'GSANSB',
                  fontSize: 16,
                ),
              )),
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: ElevatedButton(
              onPressed: () async {
                _showDialog(context);
              },
              style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Color(0xffe9394f),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(50)),
                  elevation: 1),
              child: Text(
                "가입승인 대기중",
                style: TextStyle(
                  fontFamily: 'GSANSB',
                  fontSize: 16,
                ),
              )),
        ),
      );
    }
  }

  Widget bottom_change_button() {
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);
    return Container(
      child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("Club")
            .doc(club_uid)
            .collection("ClubMember")
            .doc("WaitJoinClub")
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            List member_list = [];
            bool check = false;

            if (data["WaitJoinClub"].length != 0) {
              for (int i = 0; i < data["WaitJoinClub"].length; i++) {
                member_list.add(data["WaitJoinClub"][i]["UserUID"]);
              }

              for (int i = 0; i < member_list.length; i++) {
                if (user.uid == member_list[i]) {
                  check = true;
                  print("성공함수실행");
                }
              }
            }

            if (check == false) {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: ElevatedButton(
                      onPressed: () async {
                        List total_data = [
                          {
                            "UserUID": user.uid,
                            "DateTime": formatDate(
                                DateTime.now(), [yyyy, ".", mm, '.', dd]),
                            "WaitUserName": userAccount_.nickname
                          }
                        ];

                        try {
                          await FirebaseFirestore.instance
                              .collection("Club")
                              .doc(club_uid)
                              .collection("ClubMember")
                              .doc("WaitJoinClub")
                              .update({
                            "WaitJoinClub": FieldValue.arrayUnion(total_data),
                          });

                          _showJoinToast("가입신청이 완료 되었습니다!!");
                          Navigator.of(context)..pop()..pop()..pop();
                        } catch (e) {
                          print(e);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Color(0xffe9394f),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(50)),
                          elevation: 1),
                      child: Text(
                        "가입하기",
                        style: TextStyle(
                          fontFamily: 'GSANSB',
                          fontSize: 16,
                        ),
                      )),
                ),
              );
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: ElevatedButton(
                      onPressed: () async {
                        _showDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Color(0xffe9394f),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(50)),
                          elevation: 1),
                      child: Text(
                        "가입승인 대기중",
                        style: TextStyle(
                          fontFamily: 'GSANSB',
                          fontSize: 16,
                        ),
                      )),
                ),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserAccountInfo userAccount_ =
        Provider.of<UserAccountInfo>(context, listen: false);

    _get_WaitMemberList();

    user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: Drawer(child: HamburgerMenu()),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        title: SvgPicture.asset(
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
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                child: Text(
                  name,
                  style: TextStyle(
                      fontFamily: 'GSANSB',
                      fontSize: 20.0,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                color: Theme.of(context).primaryColorLight,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: Column(
                  children: [
                    _noticeBorad(),
                    SizedBox(
                      height: 40,
                    ),
                    _normalBoard(),
                    SizedBox(
                      height: 40,
                    ),
                    // _bottomButton(),
                    bottom_change_button(),
                  ],
                ),
              )
            ]),
          ),
        ),
      )),
    );
  }
}

///
/// 가입되어 있지 않는 회원 공지사항 리스트뷰
///
class ClubWriteList extends StatefulWidget {
  final String main_name;
  final String club_uid;
  const ClubWriteList(
      {Key? key, required this.club_uid, required this.main_name})
      : super(key: key);

  @override
  _ClubWriteListState createState() => _ClubWriteListState(club_uid, main_name);
}

class _ClubWriteListState extends State<ClubWriteList> {
  String club_name = "";
  String club_uid = '';

  _ClubWriteListState(this.club_uid, this.club_name);

  String _profileImageURL = "";

  ///
  /// 이미지 URL 가져오는 비동기 함수
  ///
  Future<String> _imageToStorage(Map<String, dynamic> data) async {
    var storageReference = FirebaseStorage.instance
        .ref()
        .child("ClubProfile/${data["ClubMainImage"]}");

    var downLoadURL = await storageReference.getDownloadURL();
    String url = downLoadURL.toString();
    print(url);

    return _profileImageURL = url.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 80,
      child: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Club")
                  .doc(club_uid)
                  .collection("Post")
                  .doc("NoticePost")
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
                  List a = [];
                  List b = [];

                  if (data["NoticePost"] != null) {
                    for (int i = 0; i < data["NoticePost"].length; i++) {
                      a.add(data["NoticePost"][i]["ClubPostTitle"]);
                      b.add(data["NoticePost"][i]["ClubPostIntro"]);
                    }

                    //_imageToStorage(data);

                    return Column(
                      children: [
                        /*Image.network(_profileImageURL,
                        width: 300,
                        height: 400,
                        fit: BoxFit.cover,),*/
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Container(
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(5)),
                                  child: ListTile(
                                    /* leading: CircleAvatar(
                                      ///
                                      /// 이미지 출력 함수 구현 해야함
                                      ///
                                    ),*/

                                    title: Text(a[index]),
                                    trailing: Text(b[index]),
                                    //trailing: Text(),
                                    onTap: () {
                                      print(index);
                                      // Navigator.push(context, MaterialPageRoute(
                                      //     builder: (BuildContext context){
                                      //       return ClubPost(index: index, club_name: club_name, club_uid: ,);
                                      //     }));
                                    },
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Container(height: 7);
                              },
                              itemCount: a.length,
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                }
              }),
        ],
      ),
    );
  }
}

///
/// 가입되어 있지 않는 회원 일반게시글 리스트뷰
///
class NomalPostListview extends StatefulWidget {
  final String main_name;
  final String club_uid;
  const NomalPostListview(
      {Key? key, required this.club_uid, required this.main_name})
      : super(key: key);

  @override
  _NomalPostListviewState createState() =>
      _NomalPostListviewState(club_uid, main_name);
}

class _NomalPostListviewState extends State<NomalPostListview> {
  String club_name = "";
  String club_uid = '';

  _NomalPostListviewState(this.club_uid, this.club_name);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 100,
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
                  List a = [];
                  List b = [];

                  if (data["NomalPost"] != null) {
                    for (int i = 0; i < data["NomalPost"].length; i++) {
                      a.add(data["NomalPost"][i]["ClubPostTitle"]);
                      b.add(data["NomalPost"][i]["ClubPostIntro"]);
                    }

                    //_imageToStorage(data);

                    return Column(
                      children: [
                        /*Image.network(_profileImageURL,
                      width: 300,
                      height: 400,
                      fit: BoxFit.cover,),*/
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red[100],
                                      borderRadius: BorderRadius.circular(5)),
                                  child: ListTile(
                                    /*leading: CircleAvatar(
                                    ///
                                    /// 이미지 출력 함수 구현 해야함
                                    ///
                                  ),*/

                                    title: Text(a[index]),
                                    trailing: Text(b[index]),
                                    //trailing: Text(),
                                    onTap: () {
                                      // Navigator.push(context, MaterialPageRoute(
                                      //     builder: (BuildContext context){
                                      //       return NomalPost(index: index, club_name: club_name,);
                                      //     }));
                                    },
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Container(
                                  height: 7,
                                );
                              },
                              itemCount: a.length,
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                }
              }),
        ],
      ),
    );
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "승인 대기",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "신청 승인 대기중입니다.",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        actions: <Widget>[
          Center(
            child: ElevatedButton(
              child: Text(
                "나가기",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontFamily: 'GSANSM'),
              ),
              onPressed: () {
                Navigator.of(context)..pop();
              },
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(80, 20),
                  primary: Colors.white,
                  side: BorderSide(
                      width: 1, color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
          ),
          // ElevatedButton(
          //   child: Text(
          //     "나가기",
          //     style: TextStyle(
          //         color: Theme.of(context).primaryColor,
          //         fontSize: 14,
          //         fontFamily: 'GSANSM'),
          //   ),
          //   onPressed: () {
          //     Navigator.of(context)..pop();
          //   },
          //   style: ElevatedButton.styleFrom(
          //       fixedSize: Size(80, 20),
          //       primary: Colors.white,
          //       side:
          //           BorderSide(width: 1, color: Theme.of(context).primaryColor),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(5))),
          // ),
        ],
      );
    },
  );
}

void _showJoinToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Color(0xffe9394f),
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      fontSize: 15.0);
}









//1.0.0.+7
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';

// import 'package:date_format/date_format.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/club/Join_Nomal_Post.dart';
// import 'package:snstennis/club/Join_Notice_Post.dart';
// import 'package:snstennis/hamburger.dart';

// class JoinClubPage extends StatefulWidget {
//   final String club_uid;
//   final String club_name;
//   const JoinClubPage(
//       {Key? key, required this.club_uid, required this.club_name})
//       : super(key: key);

//   @override
//   _JoinClubPageState createState() => _JoinClubPageState(club_uid, club_name);
// }

// class _JoinClubPageState extends State<JoinClubPage> {
//   String name = "";
//   String club_uid = '';
//   late User user;

//   late bool join_check = false;

//   Future _get_WaitMemberList() async {
//     print("_get_WaitMemberList 실행");
//     List member_list = [];
//     late bool check;
//     CollectionReference refWait_Club = FirebaseFirestore.instance
//         .collection("Club")
//         .doc(club_uid)
//         .collection("ClubMember");

//     DocumentSnapshot snapshot_Wait_Membet_List =
//         await refWait_Club.doc("WaitJoinClub").get();

//     if (snapshot_Wait_Membet_List["WaitJoinClub"].length != 0) {
//       for (int i = 0;
//           i < snapshot_Wait_Membet_List["WaitJoinClub"].length;
//           i++) {
//         member_list
//             .add(snapshot_Wait_Membet_List["WaitJoinClub"][i]["UserUID"]);
//       }

//       for (int i = 0; i < member_list.length; i++) {
//         if (user.uid == member_list[i]) {
//           // this.join_check = true;
//           check = true;
//           print("성공함수실행");
//         }
//       }
//     } else {
//       // setState(() {
//       //   join_check = false;
//       //   print("실패함수실행");
//       // });
//       check = false;
//       print("실패함수실행");
//     }
//   }

//   void change_State() {
//     setState(() {
//       print("state실행");
//       this.join_check;
//     });
//   }

//   _JoinClubPageState(this.club_uid, this.name);

//   Widget _noticeBorad() {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 100,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '공지사항',
//                 style: TextStyle(
//                     fontFamily: 'GSANSB',
//                     color: Color(0xff58585b),
//                     fontSize: 16),
//               ),
//               Text(
//                 '더보기',
//                 style: TextStyle(
//                     color: Colors.black, fontFamily: 'GSANSM', fontSize: 12.0),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             height: 60,
//             child: StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("Club")
//                     .doc(club_uid)
//                     .collection("Post")
//                     .doc("NoticePost")
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<DocumentSnapshot> snapshot) {
//                   if (snapshot.hasError) {
//                     return Text("Error!");
//                   } else if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   } else {
//                     Map<String, dynamic> data =
//                         snapshot.data!.data() as Map<String, dynamic>;
//                     List a = [];
//                     List b = [];
//                     List key_num = [];
//                     List date_time = [];

//                     List revers_title = [];
//                     List revers_Nick = [];
//                     List revers_key_num = [];
//                     List revers_date_time = [];

//                     if (data["NoticePost"].length != 0) {
//                       for (int i = 0; i < data["NoticePost"].length; i++) {
//                         a.add(data["NoticePost"][i]["ClubPostTitle"]);
//                         b.add(data["NoticePost"][i]["NickName"]);
//                         date_time.add(data["NoticePost"][i]["DateTime"]);
//                         key_num.add(data["NoticePost"][i]["KeyNumber"]);
//                       }

//                       revers_title = List.of(a.reversed);
//                       revers_Nick = List.of(b.reversed);
//                       revers_date_time = List.of(date_time.reversed);
//                       revers_key_num = List.of(key_num.reversed);

//                       return ListView.separated(
//                           itemBuilder: (BuildContext context, int index) {
//                             return Container(
//                                 height: 35,
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey[200],
//                                     borderRadius: BorderRadius.circular(5)),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(context, MaterialPageRoute(
//                                         builder: (BuildContext context) {
//                                       return JoinNoticePost(
//                                         index: int.parse(revers_key_num[index]),
//                                         club_name: name,
//                                         club_uid: club_uid,
//                                       );
//                                     }));
//                                   },
//                                   child: Padding(
//                                     padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           revers_date_time[index],
//                                           style: TextStyle(
//                                               fontFamily: 'GSANSM',
//                                               color: Color(0xff58585b),
//                                               fontSize: 14),
//                                         ),
//                                         Text(revers_title[index],
//                                             style: TextStyle(
//                                                 fontFamily: 'GSANSM',
//                                                 color: Color(0xff58585b),
//                                                 fontSize: 14)),
//                                         Text(
//                                           revers_Nick[index],
//                                           style: TextStyle(
//                                               fontFamily: 'GSANSM',
//                                               color: Color(0xff9f9f9f),
//                                               fontSize: 12),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ));
//                           },
//                           separatorBuilder: (BuildContext context, int index) {
//                             return Container(height: 1);
//                           },
//                           itemCount: a.length);
//                     } else {
//                       return Container(child: Text('\n등록된 글이 없습니다.'));
//                     }
//                   }
//                 }),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _normalBoard() {
//     return Container(
//       height: 100,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 '게시판',
//                 style: TextStyle(
//                     fontFamily: 'GSANSB',
//                     color: Color(0xff58585b),
//                     fontSize: 16),
//               ),
//               Text(
//                 '더보기',
//                 style: TextStyle(
//                     color: Colors.black, fontFamily: 'GSANSM', fontSize: 12.0),
//               ),
//             ],
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             height: 60,
//             child: StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("Club")
//                     .doc(club_uid)
//                     .collection("Post")
//                     .doc("NomalPost")
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<DocumentSnapshot> snapshot) {
//                   if (snapshot.hasError) {
//                     return Text("Error!");
//                   } else if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   } else {
//                     Map<String, dynamic> data =
//                         snapshot.data!.data() as Map<String, dynamic>;
//                     List a = [];
//                     List b = [];
//                     List date_time = [];

//                     List revers_title = [];
//                     List revers_Nick = [];
//                     List revers_date_time = [];

//                     if (data["NomalPost"].length != 0) {
//                       for (int i = 0; i < data["NomalPost"].length; i++) {
//                         a.add(data["NomalPost"][i]["ClubPostTitle"]);
//                         b.add(data["NomalPost"][i]["NickName"]);
//                         date_time.add(data["NomalPost"][i]["DateTime"]);
//                       }

//                       revers_title = List.of(a.reversed);
//                       revers_Nick = List.of(b.reversed);
//                       revers_date_time = List.of(date_time.reversed);

//                       return ListView.separated(
//                           itemBuilder: (BuildContext context, int index) {
//                             return Container(
//                                 height: 35,
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey[200],
//                                     borderRadius: BorderRadius.circular(5)),
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(context, MaterialPageRoute(
//                                         builder: (BuildContext context) {
//                                       return JoinNomalPost(
//                                         index: index,
//                                         club_name: name,
//                                         club_uid: club_uid,
//                                       );
//                                     }));
//                                   },
//                                   child: Padding(
//                                     padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           revers_date_time[index],
//                                           style: TextStyle(
//                                               fontFamily: 'GSANSM',
//                                               color: Color(0xff58585b),
//                                               fontSize: 14),
//                                         ),
//                                         Text(revers_title[index],
//                                             style: TextStyle(
//                                                 fontFamily: 'GSANSM',
//                                                 color: Color(0xff58585b),
//                                                 fontSize: 14)),
//                                         Text(
//                                           revers_Nick[index],
//                                           style: TextStyle(
//                                               fontFamily: 'GSANSM',
//                                               color: Color(0xff9f9f9f),
//                                               fontSize: 12),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ));
//                           },
//                           separatorBuilder: (BuildContext context, int index) {
//                             return Container(height: 1);
//                           },
//                           itemCount: a.length);
//                     } else {
//                       return Container(child: Text('\n등록된 글이 없습니다.'));
//                     }
//                   }
//                 }),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _bottomButton() {
//     UserAccountInfo userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);

//     print(join_check);
//     if (join_check == false) {
//       return Container(
//         width: MediaQuery.of(context).size.width,
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
//           child: ElevatedButton(
//               onPressed: () async {
//                 List total_data = [
//                   {
//                     "UserUID": user.uid,
//                     "DateTime":
//                         formatDate(DateTime.now(), [yyyy, ".", mm, '.', dd]),
//                     "WaitUserName": userAccount_.nickname
//                   }
//                 ];

//                 try {
//                   await FirebaseFirestore.instance
//                       .collection("Club")
//                       .doc(club_uid)
//                       .collection("ClubMember")
//                       .doc("WaitJoinClub")
//                       .update({
//                     "WaitJoinClub": FieldValue.arrayUnion(total_data),
//                   });

//                   setState(() {
//                     this.join_check = true;
//                   });

//                   Navigator.of(context)..pop()..pop()..pop()..pop();
//                 } catch (e) {
//                   print(e);
//                 }
//               },
//               style: OutlinedButton.styleFrom(
//                   primary: Colors.white,
//                   backgroundColor: Color(0xffe9394f),
//                   shape: RoundedRectangleBorder(
//                       side: BorderSide(
//                           color: Theme.of(context).primaryColor,
//                           width: 1,
//                           style: BorderStyle.solid),
//                       borderRadius: BorderRadius.circular(50)),
//                   elevation: 1),
//               child: Text(
//                 "가입하기",
//                 style: TextStyle(
//                   fontFamily: 'GSANSB',
//                   fontSize: 16,
//                 ),
//               )),
//         ),
//       );
//     } else {
//       return Container(
//         width: MediaQuery.of(context).size.width,
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
//           child: ElevatedButton(
//               onPressed: () async {
//                 _showDialog(context);
//               },
//               style: OutlinedButton.styleFrom(
//                   primary: Colors.white,
//                   backgroundColor: Color(0xffe9394f),
//                   shape: RoundedRectangleBorder(
//                       side: BorderSide(
//                           color: Theme.of(context).primaryColor,
//                           width: 1,
//                           style: BorderStyle.solid),
//                       borderRadius: BorderRadius.circular(50)),
//                   elevation: 1),
//               child: Text(
//                 "가입승인 대기중",
//                 style: TextStyle(
//                   fontFamily: 'GSANSB',
//                   fontSize: 16,
//                 ),
//               )),
//         ),
//       );
//     }
//   }

//   Widget bottom_change_button() {
//     UserAccountInfo userAccount_ =
//         Provider.of<UserAccountInfo>(context, listen: false);
//     return Container(
//       child: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection("Club")
//             .doc(club_uid)
//             .collection("ClubMember")
//             .doc("WaitJoinClub")
//             .get(),
//         builder:
//             (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (snapshot.hasData == false) {
//             return Container();
//           } else if (snapshot.hasError) {
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 style: TextStyle(fontSize: 15),
//               ),
//             );
//           } else {
//             Map<String, dynamic> data =
//                 snapshot.data!.data() as Map<String, dynamic>;

//             List member_list = [];
//             bool check = false;

//             if (data["WaitJoinClub"].length != 0) {
//               for (int i = 0; i < data["WaitJoinClub"].length; i++) {
//                 member_list.add(data["WaitJoinClub"][i]["UserUID"]);
//               }

//               for (int i = 0; i < member_list.length; i++) {
//                 if (user.uid == member_list[i]) {
//                   check = true;
//                   print("성공함수실행");
//                 }
//               }
//             }

//             if (check == false) {
//               return Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
//                   child: ElevatedButton(
//                       onPressed: () async {
//                         List total_data = [
//                           {
//                             "UserUID": user.uid,
//                             "DateTime": formatDate(
//                                 DateTime.now(), [yyyy, ".", mm, '.', dd]),
//                             "WaitUserName": userAccount_.nickname
//                           }
//                         ];

//                         try {
//                           await FirebaseFirestore.instance
//                               .collection("Club")
//                               .doc(club_uid)
//                               .collection("ClubMember")
//                               .doc("WaitJoinClub")
//                               .update({
//                             "WaitJoinClub": FieldValue.arrayUnion(total_data),
//                           });

//                           _showJoinToast("가입신청이 완료 되었습니다!!");
//                           Navigator.of(context)..pop()..pop()..pop();
//                         } catch (e) {
//                           print(e);
//                         }
//                       },
//                       style: OutlinedButton.styleFrom(
//                           primary: Colors.white,
//                           backgroundColor: Color(0xffe9394f),
//                           shape: RoundedRectangleBorder(
//                               side: BorderSide(
//                                   color: Theme.of(context).primaryColor,
//                                   width: 1,
//                                   style: BorderStyle.solid),
//                               borderRadius: BorderRadius.circular(50)),
//                           elevation: 1),
//                       child: Text(
//                         "가입하기",
//                         style: TextStyle(
//                           fontFamily: 'GSANSB',
//                           fontSize: 16,
//                         ),
//                       )),
//                 ),
//               );
//             } else {
//               return Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
//                   child: ElevatedButton(
//                       onPressed: () async {
//                         _showDialog(context);
//                       },
//                       style: OutlinedButton.styleFrom(
//                           primary: Colors.white,
//                           backgroundColor: Color(0xffe9394f),
//                           shape: RoundedRectangleBorder(
//                               side: BorderSide(
//                                   color: Theme.of(context).primaryColor,
//                                   width: 1,
//                                   style: BorderStyle.solid),
//                               borderRadius: BorderRadius.circular(50)),
//                           elevation: 1),
//                       child: Text(
//                         "가입승인 대기중",
//                         style: TextStyle(
//                           fontFamily: 'GSANSB',
//                           fontSize: 16,
//                         ),
//                       )),
//                 ),
//               );
//             }
//           }
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     UserAccountInfo userAccount_ =
//         Provider.of<UserAccountInfo>(context, listen: false);

//     _get_WaitMemberList();

//     user = FirebaseAuth.instance.currentUser!;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       endDrawer: Drawer(child: HamburgerMenu()),
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFFFFFF),
//         iconTheme: IconThemeData(color: Colors.grey),
//         automaticallyImplyLeading: false,
//         title: SvgPicture.asset(
//           'assets/images/PNG/LOGO_KAMMON_small.svg',
//           width: 110,
//         ),
//         //SvgPicture.asset('assets/images/SVG/logo.svg', width: 150,),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: Icon(Icons.arrow_back_ios),
//         ),
//         actions: [],
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SafeArea(
//           child: SingleChildScrollView(
//         child: Container(
//           color: Color(0xFFFFFFFF),
//           child: Padding(
//             padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               SizedBox(
//                 height: 50,
//               ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
//                 child: Text(
//                   name,
//                   style: TextStyle(
//                       fontFamily: 'GSANSB',
//                       fontSize: 20.0,
//                       color: Theme.of(context).primaryColor),
//                 ),
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 150,
//                 color: Theme.of(context).primaryColorLight,
//               ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
//                 child: Column(
//                   children: [
//                     _noticeBorad(),
//                     SizedBox(
//                       height: 40,
//                     ),
//                     _normalBoard(),
//                     SizedBox(
//                       height: 40,
//                     ),
//                     // _bottomButton(),
//                     bottom_change_button(),
//                   ],
//                 ),
//               )
//             ]),
//           ),
//         ),
//       )),
//     );
//   }
// }

// ///
// /// 가입되어 있지 않는 회원 공지사항 리스트뷰
// ///
// class ClubWriteList extends StatefulWidget {
//   final String main_name;
//   final String club_uid;
//   const ClubWriteList(
//       {Key? key, required this.club_uid, required this.main_name})
//       : super(key: key);

//   @override
//   _ClubWriteListState createState() => _ClubWriteListState(club_uid, main_name);
// }

// class _ClubWriteListState extends State<ClubWriteList> {
//   String club_name = "";
//   String club_uid = '';

//   _ClubWriteListState(this.club_uid, this.club_name);

//   String _profileImageURL = "";

//   ///
//   /// 이미지 URL 가져오는 비동기 함수
//   ///
//   Future<String> _imageToStorage(Map<String, dynamic> data) async {
//     var storageReference = FirebaseStorage.instance
//         .ref()
//         .child("ClubProfile/${data["ClubMainImage"]}");

//     var downLoadURL = await storageReference.getDownloadURL();
//     String url = downLoadURL.toString();
//     print(url);

//     return _profileImageURL = url.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: 80,
//       child: Column(
//         children: [
//           StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection("Club")
//                   .doc(club_uid)
//                   .collection("Post")
//                   .doc("NoticePost")
//                   .snapshots(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<DocumentSnapshot> snapshot) {
//                 if (snapshot.hasError) {
//                   return Text("Error!");
//                 } else if (snapshot.connectionState ==
//                     ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else {
//                   Map<String, dynamic> data =
//                       snapshot.data!.data() as Map<String, dynamic>;
//                   List a = [];
//                   List b = [];

//                   if (data["NoticePost"] != null) {
//                     for (int i = 0; i < data["NoticePost"].length; i++) {
//                       a.add(data["NoticePost"][i]["ClubPostTitle"]);
//                       b.add(data["NoticePost"][i]["ClubPostIntro"]);
//                     }

//                     //_imageToStorage(data);

//                     return Column(
//                       children: [
//                         /*Image.network(_profileImageURL,
//                         width: 300,
//                         height: 400,
//                         fit: BoxFit.cover,),*/
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                           child: Container(
//                             height: 250,
//                             width: MediaQuery.of(context).size.width,
//                             child: ListView.separated(
//                               scrollDirection: Axis.vertical,
//                               shrinkWrap: true,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.red[100],
//                                       borderRadius: BorderRadius.circular(5)),
//                                   child: ListTile(
//                                     /* leading: CircleAvatar(
//                                       ///
//                                       /// 이미지 출력 함수 구현 해야함
//                                       ///
//                                     ),*/

//                                     title: Text(a[index]),
//                                     trailing: Text(b[index]),
//                                     //trailing: Text(),
//                                     onTap: () {
//                                       print(index);
//                                       // Navigator.push(context, MaterialPageRoute(
//                                       //     builder: (BuildContext context){
//                                       //       return ClubPost(index: index, club_name: club_name, club_uid: ,);
//                                       //     }));
//                                     },
//                                   ),
//                                 );
//                               },
//                               separatorBuilder:
//                                   (BuildContext context, int index) {
//                                 return Container(height: 7);
//                               },
//                               itemCount: a.length,
//                             ),
//                           ),
//                         )
//                       ],
//                     );
//                   } else {
//                     return Container();
//                   }
//                 }
//               }),
//         ],
//       ),
//     );
//   }
// }

// ///
// /// 가입되어 있지 않는 회원 일반게시글 리스트뷰
// ///
// class NomalPostListview extends StatefulWidget {
//   final String main_name;
//   final String club_uid;
//   const NomalPostListview(
//       {Key? key, required this.club_uid, required this.main_name})
//       : super(key: key);

//   @override
//   _NomalPostListviewState createState() =>
//       _NomalPostListviewState(club_uid, main_name);
// }

// class _NomalPostListviewState extends State<NomalPostListview> {
//   String club_name = "";
//   String club_uid = '';

//   _NomalPostListviewState(this.club_uid, this.club_name);

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       flex: 100,
//       child: Column(
//         children: [
//           StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection("Club")
//                   .doc(club_uid)
//                   .collection("Post")
//                   .doc("NomalPost")
//                   .snapshots(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<DocumentSnapshot> snapshot) {
//                 if (snapshot.hasError) {
//                   return Text("Error!");
//                 } else if (snapshot.connectionState ==
//                     ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else {
//                   Map<String, dynamic> data =
//                       snapshot.data!.data() as Map<String, dynamic>;
//                   List a = [];
//                   List b = [];

//                   if (data["NomalPost"] != null) {
//                     for (int i = 0; i < data["NomalPost"].length; i++) {
//                       a.add(data["NomalPost"][i]["ClubPostTitle"]);
//                       b.add(data["NomalPost"][i]["ClubPostIntro"]);
//                     }

//                     //_imageToStorage(data);

//                     return Column(
//                       children: [
//                         /*Image.network(_profileImageURL,
//                       width: 300,
//                       height: 400,
//                       fit: BoxFit.cover,),*/
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                           child: Container(
//                             height: 170,
//                             width: MediaQuery.of(context).size.width,
//                             child: ListView.separated(
//                               scrollDirection: Axis.vertical,
//                               shrinkWrap: true,
//                               itemBuilder: (BuildContext context, int index) {
//                                 return Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.red[100],
//                                       borderRadius: BorderRadius.circular(5)),
//                                   child: ListTile(
//                                     /*leading: CircleAvatar(
//                                     ///
//                                     /// 이미지 출력 함수 구현 해야함
//                                     ///
//                                   ),*/

//                                     title: Text(a[index]),
//                                     trailing: Text(b[index]),
//                                     //trailing: Text(),
//                                     onTap: () {
//                                       // Navigator.push(context, MaterialPageRoute(
//                                       //     builder: (BuildContext context){
//                                       //       return NomalPost(index: index, club_name: club_name,);
//                                       //     }));
//                                     },
//                                   ),
//                                 );
//                               },
//                               separatorBuilder:
//                                   (BuildContext context, int index) {
//                                 return Container(
//                                   height: 7,
//                                 );
//                               },
//                               itemCount: a.length,
//                             ),
//                           ),
//                         )
//                       ],
//                     );
//                   } else {
//                     return Container();
//                   }
//                 }
//               }),
//         ],
//       ),
//     );
//   }
// }

// void _showDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("승인 대기"),
//         content: Text("신청 승인 대기중입니다."),
//         actions: <Widget>[
//           ElevatedButton(
//             child: Text("나가기"),
//             onPressed: () {
//               Navigator.of(context)..pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

// void _showJoinToast(String message) {
//   Fluttertoast.showToast(
//       msg: message,
//       backgroundColor: Color(0xffe9394f),
//       textColor: Colors.white,
//       toastLength: Toast.LENGTH_LONG,
//       gravity: ToastGravity.BOTTOM,
//       fontSize: 15.0);
// }
