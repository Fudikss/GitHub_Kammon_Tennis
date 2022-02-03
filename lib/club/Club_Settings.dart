import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/first_screen_1_0.dart';

class ClubSettings extends StatefulWidget {
  final String club_name;
  final String club_uid;
  const ClubSettings(
      {Key? key, required this.club_uid, required this.club_name})
      : super(key: key);

  @override
  _ClubSettingsState createState() => _ClubSettingsState(club_uid, club_name);
}

final area = [
  "강원도",
  "경상남도",
  "경상북도",
  "경기도",
  "광주광역시",
  "대구광역시",
  "대전광역시",
  "부산광역시",
  "서울특별시",
  "울산광역시",
  "인천광역시",
  "전라남도",
  "전라북도",
  "제주도",
  "충청남도",
  "충청북도",
];

String clubname = "";
String clubintro = "";
String clubuser = "";
String clubarea = "";

///
/// SelectBox 초기값
///
var _selectedValue = "강원도";

String change_club_are = "";

FirebaseFirestore firestore = FirebaseFirestore.instance;

User user = FirebaseAuth.instance.currentUser!;

final formKey = new GlobalKey<FormState>();
late UserAccountInfo user_account_info_;
void validateAndSave() {
  final form = formKey.currentState;
  if (form!.validate()) {
    form.save();
    print("success $clubname, $clubintro");
  } else {
    print("failed");
  }
}

class _ClubSettingsState extends State<ClubSettings> {
  String name = "";
  String club_uid = '';

  String club_image_url = "";

  String change_club_name = "";
  String change_club_intro = "";
  String change_club_area = "";
  String change_image_url = "";

  String area_condition = "";

  // List member_uid_list = [];

  bool check_member = false;

  //String my_uid = "";

  _ClubSettingsState(this.club_uid, this.name);

  Future _get_member_list() async {
    // member_uid_list.clear();
    DocumentReference doc_ref = firestore
        .collection("Club")
        .doc(name)
        .collection("ClubMember")
        .doc("MemberList");

    DocumentSnapshot data = await doc_ref.get();

    Map<String, dynamic> data_map = data.data() as Map<String, dynamic>;

    // for(int i = 0; i < data_map["ClubMember"].length; i++){

    // }

    if (data_map["ClubMember"].length == 1) {
      print("실행됨");
      check_member = true;
    }
    print("check_member의 값" + check_member.toString());
  }

  ///
  /// 이미지 기능 함수
  ///
  File? _imageFile = null;

  String fileName = "";

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
    //final List<XFile>? images = await picker.pickMultiImage();
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      return;
    }
  }

  Future uploadImageToFirebase(BuildContext context, String doc_path) async {
    fileName = basename(_imageFile!.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('ClubProfile')
        .child(doc_path)
        .child('/$fileName');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    firebase_storage.UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask = ref.putFile(io.File(_imageFile!.path), metadata);

    firebase_storage.UploadTask task = await Future.value(uploadTask);
    Future.value(uploadTask)
        .then((value) => {print("Upload file path ${value.ref.fullPath}")})
        .onError((error, stackTrace) =>
            {print("Upload file path error ${error.toString()} ")});
  }

  Widget edit_Club_Profile() {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("Club")
                    .doc(name)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error!");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container();
                  } else {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;

                    String club_title = "";
                    String club_intro = "";
                    // String club_main_image = "";
                    String club_area = "";

                    // String title_condition = "";
                    // String intro_condition = "";

                    club_title = data["ClubName"];
                    club_intro = data["ClubIntro"];
                    club_image_url = data["ClubMainImage"];
                    club_area = data["ClubArea"];

                    clubarea = data["ClubArea"];

                    // _selectedValue = club_area;

                    // title_condition = data["ClubName"];
                    // intro_condition = data["ClubIntro"];
                    area_condition = data["ClubArea"];

                    return Container(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                child: Text(
                                  "클럽설정 변경",
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: Color(0xffe83a4f),
                                    fontFamily: 'GSANSB',
                                  ),
                                )),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      '클럽명',
                                      style: TextStyle(
                                          color: Color(0xff58585b),
                                          fontSize: 16,
                                          fontFamily: 'GSANSB'),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 180,
                                    height: 30,
                                    child: TextFormField(
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              new EdgeInsets.symmetric(
                                                  vertical: 0.0,
                                                  horizontal: 10.0),
                                          hintText: club_title,
                                          hintStyle: TextStyle(
                                              fontFamily: 'GSANSM',
                                              fontSize: 12,
                                              color: Color(0xff9f9f9f)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                          //filled: true,
                                        ),
                                        // validator: (value) => value!.isEmpty
                                        //     ? clubname = club_title
                                        //     : null,
                                        onSaved: (value) =>
                                            value == club_title || value == ""
                                                ? clubname = club_title
                                                : clubname = value!),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          '클럽소개',
                                          style: TextStyle(
                                              color: Color(0xff58585b),
                                              fontSize: 16,
                                              fontFamily: 'GSANSB'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 180,
                                    height: 100,
                                    child: TextFormField(
                                        maxLines: 20,
                                        keyboardType: TextInputType.multiline,
                                        //expands: true,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              new EdgeInsets.symmetric(
                                                  vertical: 5.0,
                                                  horizontal: 10.0),
                                          hintText: club_intro,
                                          hintStyle: TextStyle(
                                              fontFamily: 'GSANSM',
                                              fontSize: 12,
                                              color: Color(0xff9f9f9f)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                          //filled: true,
                                        ),
                                        // validator: (value) => value!.isEmpty
                                        //     ? clubintro = club_intro
                                        //     : null,
                                        onSaved: (value) =>
                                            value! == club_intro || value == ""
                                                ? clubintro = club_intro
                                                : clubintro = value),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: Column(children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        '지역',
                                        style: TextStyle(
                                            color: Color(0xff58585b),
                                            fontSize: 16,
                                            fontFamily: 'GSANSB'),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      height: 50,
                                      child: Column(
                                        children: [
                                          DropdownButton(
                                            isExpanded: false,
                                            value: _selectedValue,
                                            items: area.map(
                                              (value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'GSANSM'),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedValue =
                                                    value.toString();
                                                change_club_area =
                                                    _selectedValue;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ]),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 105,
                                  ),
                                  Text(
                                    "변경 전 : " + club_area,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'GMARKETSANSM'),
                                  ),
                                ],
                              )
                            ])),
                            // Container(
                            //   child: Row(
                            //     children: [
                            //       SizedBox(
                            //         width: 100,
                            //         child: Text(
                            //           '지역',
                            //           style: TextStyle(
                            //               color: Color(0xff58585b),
                            //               fontSize: 16,
                            //               fontFamily: 'GSANSB'),
                            //           textAlign: TextAlign.left,
                            //         ),
                            //       ),
                            //       SizedBox(
                            //         width: 100,
                            //         height: 50,
                            //         child: Column(
                            //           children: [
                            //             //SingleChildScrollView(
                            //             //child:
                            //             DropdownButton(
                            //               isExpanded: false,
                            //               value: _selectedValue,
                            //               items: area.map(
                            //                 (value) {
                            //                   return DropdownMenuItem(
                            //                     value: value,
                            //                     child: Text(
                            //                       value,
                            //                       style: TextStyle(
                            //                           fontSize: 14,
                            //                           fontFamily:
                            //                               'GMARKETSANSM'),
                            //                     ),
                            //                   );
                            //                 },
                            //               ).toList(),
                            //               onChanged: (value) {
                            //                 // if (value == "서울") {
                            //                 //   setState(() {
                            //                 //     clubarea = value.toString();
                            //                 //   });
                            //                 // } else {
                            //                 //   setState(() {
                            //                 //     // _selectedValue =
                            //                 //     //     value.toString();
                            //                 //     clubarea = value.toString();
                            //                 //     print(clubarea);
                            //                 //   });
                            //                 // }
                            //                 setState(() {
                            //                   _selectedValue = value.toString();

                            //                   change_club_area = _selectedValue;
                            //                 });
                            //               },
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       SizedBox(
                            //         width: 10,
                            //       ),
                            //       Text(
                            //         "변경 전 : " + club_area,
                            //         style: TextStyle(
                            //             fontSize: 14,
                            //             fontFamily: 'GMARKETSANSM'),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0) // POINT
                                          ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                        child: club_image_url != ""
                                            ? GestureDetector(
                                                onTap: () {
                                                  pickImage();
                                                },
                                                child: _imageFile == null
                                                    ? Image.network(
                                                        club_image_url)
                                                    : Image.file(_imageFile!))
                                            : GestureDetector(
                                                child: Center(
                                                  child: TextButton.icon(
                                                      onPressed: () {
                                                        // _showDialog(context);
                                                        pickImage();
                                                      },
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .white)),
                                                      icon: Icon(
                                                        Icons.add,
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                      label: Text(
                                                        "이미지 불러오기",
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey.shade300,
                                                          fontSize: 16.0,
                                                          fontFamily:
                                                              'GMARKETSANSM',
                                                        ),
                                                      )),
                                                ),
                                              )),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }),
            SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: 180,
                height: 30,
                child: Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      validateAndSave();

                      try {
                        // validateAndSave();
                        String url = "";

                        if (_imageFile != null) {
                          uploadImageToFirebase(this.context, name);

                          Timer(Duration(milliseconds: 3000), () async {
                            final ref = firebase_storage
                                .FirebaseStorage.instance
                                .ref()
                                .child("ClubProfile")
                                .child(name);

                            url = await ref.child(fileName).getDownloadURL();

                            await firestore
                                .collection("Club")
                                .doc(name)
                                .update({
                              "ClubName": clubname,
                              "ClubIntro": clubintro,
                              "ClubArea": change_club_area == area_condition ||
                                      _selectedValue == "강원도"
                                  ? clubarea
                                  : change_club_area,
                              "ClubMainImage": url
                            });
                          });
                          Navigator.of(this.context)..pop()..pop()..pop();
                        } else {
                          await firestore.collection("Club").doc(name).update({
                            "ClubName": clubname,
                            "ClubIntro": clubintro,
                            "ClubArea": change_club_area == area_condition ||
                                    _selectedValue == "강원도"
                                ? clubarea
                                : change_club_area,
                            "ClubMainImage": club_image_url
                          });
                          Navigator.of(this.context)..pop()..pop()..pop();
                        }
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
                      "클럽설정 변경완료",
                      style: TextStyle(
                          fontFamily: 'GSANSB',
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                if (check_member) {
                  _showDialog_club_delete(this.context, name);
                } else {
                  _showDialog_club_delete_error(this.context);
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
                "클럽 삭제",
                style: TextStyle(
                    fontFamily: 'GSANSB', fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _get_member_list();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //endDrawer: Drawer(child: HamburgerMenu()),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
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
            child: Column(
              children: [
                edit_Club_Profile(),
              ],
            ),
          ),
        ));
  }
}

void _showDialog_club_delete_error(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "클럽 삭제 실패",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "현재 클럽에 회원이 존재합니다",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              "나가기",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontFamily: 'GSANSM'),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                fixedSize: Size(80, 20),
                primary: Colors.white,
                side:
                    BorderSide(width: 1, color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
          ),
        ],
      );
    },
  );
}

void _showDialog_club_delete(BuildContext context, String club_uid) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "클럽 삭제",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "해당 클럽을 삭제하시겠습니까?",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(
                  "삭제",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontFamily: 'GSANSM'),
                ),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(user.uid)
                      .update({
                    "JoinClub": FieldValue.arrayRemove([club_uid])
                  });

                  FirebaseFirestore.instance
                      .collection("ChatRoom")
                      .doc("ChatRoom")
                      .delete();

                  FirebaseFirestore.instance
                      .collection("ClubMember")
                      .doc("MemberList")
                      .delete();

                  FirebaseFirestore.instance
                      .collection("ClubMember")
                      .doc("WaitJoinClub")
                      .delete();

                  FirebaseFirestore.instance
                      .collection("Post")
                      .doc("GatheringPost")
                      .collection("GatheringPostList")
                      .doc("GatheringJoinList")
                      .delete();

                  FirebaseFirestore.instance
                      .collection("Post")
                      .doc("GatheringPost")
                      .delete();

                  FirebaseFirestore.instance
                      .collection("Post")
                      .doc("NomalPost")
                      .collection("NomalPostComment")
                      .doc("NomalComment")
                      .delete();

                  FirebaseFirestore.instance
                      .collection("Post")
                      .doc("NomalPost")
                      .delete();

                  FirebaseFirestore.instance
                      .collection("Post")
                      .doc("NoticePost")
                      .collection("NoticePostComment")
                      .doc("NoticeComment")
                      .delete();

                  FirebaseFirestore.instance
                      .collection("Post")
                      .doc("NoticePost")
                      .delete();

                  FirebaseFirestore.instance
                      .collection("Club")
                      .doc(club_uid)
                      .delete();

                  //Navigator.of(context).popUntil((route) => route.isFirst);

                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return FirstScreen();
                  }));
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(80, 20),
                    primary: Colors.white,
                    side: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
              SizedBox(
                width: 40,
              ),
              ElevatedButton(
                child: Text(
                  "취소",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontFamily: 'GSANSM'),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(80, 20),
                    primary: Colors.white,
                    side: BorderSide(
                        width: 1, color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            ],
          )
        ],
      );
    },
  );
}








//1.0.0.+7
// import 'dart:async';
// import 'dart:io' as io;
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:snstennis/account/user_account_info.dart';

// class ClubSettings extends StatefulWidget {
//   final String club_name;
//   final String club_uid;
//   const ClubSettings(
//       {Key? key, required this.club_uid, required this.club_name})
//       : super(key: key);

//   @override
//   _ClubSettingsState createState() => _ClubSettingsState(club_uid, club_name);
// }

// final area = [
//   "서울",
//   "강원도",
//   "경기도",
//   "충청남도",
//   "충청북도",
//   "전라남도",
//   "전라북도",
//   "경상북도",
//   "경상남도",
//   "제주도",
//   "부산광역시",
//   "울산광역시",
//   "인천광역시",
//   "광주광역시",
//   "대구광역시",
//   "대전광역시"
// ];

// String clubname = "";
// String clubintro = "";
// String clubuser = "";
// String clubarea = "";

// ///
// /// SelectBox 초기값
// ///
// var _selectedValue = "서울";

// String change_club_are = "";

// FirebaseFirestore firestore = FirebaseFirestore.instance;

// final formKey = new GlobalKey<FormState>();
// late UserAccountInfo user_account_info_;
// void validateAndSave() {
//   final form = formKey.currentState;
//   if (form!.validate()) {
//     form.save();
//     print("success $clubname, $clubintro");
//   } else {
//     print("failed");
//   }
// }

// class _ClubSettingsState extends State<ClubSettings> {
//   String name = "";
//   String club_uid = '';

//   String club_image_url = "";

//   String change_club_name = "";
//   String change_club_intro = "";
//   String change_club_area = "";
//   String change_image_url = "";

//   String area_condition = "";

//   //String my_uid = "";

//   _ClubSettingsState(this.club_uid, this.name);

//   ///
//   /// 이미지 기능 함수
//   ///
//   File? _imageFile = null;

//   String fileName = "";

//   final picker = ImagePicker();

//   Future pickImage() async {
//     final pickedFile =
//         await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
//     //final List<XFile>? images = await picker.pickMultiImage();
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     } else {
//       return;
//     }
//   }

//   Future uploadImageToFirebase(BuildContext context, String doc_path) async {
//     fileName = basename(_imageFile!.path);
//     firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
//         .ref()
//         .child('ClubProfile')
//         .child(doc_path)
//         .child('/$fileName');

//     final metadata = firebase_storage.SettableMetadata(
//         contentType: 'image/jpeg',
//         customMetadata: {'picked-file-path': fileName});
//     firebase_storage.UploadTask uploadTask;
//     //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
//     uploadTask = ref.putFile(io.File(_imageFile!.path), metadata);

//     firebase_storage.UploadTask task = await Future.value(uploadTask);
//     Future.value(uploadTask)
//         .then((value) => {print("Upload file path ${value.ref.fullPath}")})
//         .onError((error, stackTrace) =>
//             {print("Upload file path error ${error.toString()} ")});
//   }

//   Widget edit_Club_Profile() {
//     print("호출됨");
//     return Container(
//       child: Padding(
//         padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             FutureBuilder(
//                 future: FirebaseFirestore.instance
//                     .collection("Club")
//                     .doc(name)
//                     .get(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<DocumentSnapshot> snapshot) {
//                   if (snapshot.hasError) {
//                     return Text("Error!");
//                   } else if (snapshot.connectionState ==
//                       ConnectionState.waiting) {
//                     return Container();
//                   } else {
//                     Map<String, dynamic> data =
//                         snapshot.data!.data() as Map<String, dynamic>;

//                     String club_title = "";
//                     String club_intro = "";
//                     // String club_main_image = "";
//                     String club_area = "";

//                     // String title_condition = "";
//                     // String intro_condition = "";

//                     club_title = data["ClubName"];
//                     club_intro = data["ClubIntro"];
//                     club_image_url = data["ClubMainImage"];
//                     club_area = data["ClubArea"];

//                     clubarea = data["ClubArea"];

//                     // _selectedValue = club_area;

//                     // title_condition = data["ClubName"];
//                     // intro_condition = data["ClubIntro"];
//                     area_condition = data["ClubArea"];

//                     return Container(
//                       child: Form(
//                         key: formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                                 padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
//                                 child: Text(
//                                   "클럽설정 변경",
//                                   style: TextStyle(
//                                     fontSize: 24.0,
//                                     color: Color(0xffe83a4f),
//                                     fontFamily: 'GSANSB',
//                                   ),
//                                 )),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Container(
//                               child: Row(
//                                 children: [
//                                   SizedBox(
//                                     width: 100,
//                                     child: Text(
//                                       '클럽명',
//                                       style: TextStyle(
//                                           color: Color(0xff58585b),
//                                           fontSize: 16,
//                                           fontFamily: 'GSANSB'),
//                                       textAlign: TextAlign.left,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width:
//                                         MediaQuery.of(context).size.width - 180,
//                                     height: 30,
//                                     child: TextFormField(
//                                         obscureText: false,
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                               new EdgeInsets.symmetric(
//                                                   vertical: 0.0,
//                                                   horizontal: 10.0),
//                                           hintText: club_title,
//                                           hintStyle: TextStyle(
//                                               fontFamily: 'GSANSM',
//                                               fontSize: 12,
//                                               color: Color(0xff9f9f9f)),
//                                           enabledBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                 color: Colors.grey.shade300,
//                                                 width: 2,
//                                               ),
//                                               borderRadius:
//                                                   const BorderRadius.all(
//                                                       Radius.circular(5))),
//                                           focusedBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                 color: Colors.grey.shade300,
//                                                 width: 2,
//                                               ),
//                                               borderRadius:
//                                                   const BorderRadius.all(
//                                                       Radius.circular(5))),
//                                           //filled: true,
//                                         ),
//                                         // validator: (value) => value!.isEmpty
//                                         //     ? clubname = club_title
//                                         //     : null,
//                                         onSaved: (value) =>
//                                             value == club_title || value == ""
//                                                 ? clubname = club_title
//                                                 : clubname = value!),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Container(
//                               child: Row(
//                                 children: [
//                                   SizedBox(
//                                     width: 100,
//                                     height: 100,
//                                     child: Align(
//                                       alignment: Alignment.topLeft,
//                                       child: Padding(
//                                         padding: EdgeInsets.only(top: 10),
//                                         child: Text(
//                                           '클럽소개',
//                                           style: TextStyle(
//                                               color: Color(0xff58585b),
//                                               fontSize: 16,
//                                               fontFamily: 'GSANSB'),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width:
//                                         MediaQuery.of(context).size.width - 180,
//                                     height: 100,
//                                     child: TextFormField(
//                                         maxLines: 20,
//                                         keyboardType: TextInputType.multiline,
//                                         //expands: true,
//                                         obscureText: false,
//                                         decoration: InputDecoration(
//                                           contentPadding:
//                                               new EdgeInsets.symmetric(
//                                                   vertical: 5.0,
//                                                   horizontal: 10.0),
//                                           hintText: club_intro,
//                                           hintStyle: TextStyle(
//                                               fontFamily: 'GSANSM',
//                                               fontSize: 12,
//                                               color: Color(0xff9f9f9f)),
//                                           enabledBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                 color: Colors.grey.shade300,
//                                                 width: 2,
//                                               ),
//                                               borderRadius:
//                                                   const BorderRadius.all(
//                                                       Radius.circular(5))),
//                                           focusedBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                 color: Colors.grey.shade300,
//                                                 width: 2,
//                                               ),
//                                               borderRadius:
//                                                   const BorderRadius.all(
//                                                       Radius.circular(5))),
//                                           //filled: true,
//                                         ),
//                                         // validator: (value) => value!.isEmpty
//                                         //     ? clubintro = club_intro
//                                         //     : null,
//                                         onSaved: (value) =>
//                                             value! == club_intro || value == ""
//                                                 ? clubintro = club_intro
//                                                 : clubintro = value),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Container(
//                               child: Row(
//                                 children: [
//                                   SizedBox(
//                                     width: 100,
//                                     child: Text(
//                                       '지역',
//                                       style: TextStyle(
//                                           color: Color(0xff58585b),
//                                           fontSize: 16,
//                                           fontFamily: 'GSANSB'),
//                                       textAlign: TextAlign.left,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 100,
//                                     height: 50,
//                                     child: Column(
//                                       children: [
//                                         //SingleChildScrollView(
//                                         //child:
//                                         DropdownButton(
//                                           isExpanded: false,
//                                           value: _selectedValue,
//                                           items: area.map(
//                                             (value) {
//                                               return DropdownMenuItem(
//                                                 value: value,
//                                                 child: Text(
//                                                   value,
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       fontFamily:
//                                                           'GSANSM'),
//                                                 ),
//                                               );
//                                             },
//                                           ).toList(),
//                                           onChanged: (value) {
//                                             // if (value == "서울") {
//                                             //   setState(() {
//                                             //     clubarea = value.toString();
//                                             //   });
//                                             // } else {
//                                             //   setState(() {
//                                             //     // _selectedValue =
//                                             //     //     value.toString();
//                                             //     clubarea = value.toString();
//                                             //     print(clubarea);
//                                             //   });
//                                             // }
//                                             setState(() {
//                                               _selectedValue = value.toString();

//                                               change_club_area = _selectedValue;
//                                             });
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(
//                                     "변경 전 : " + club_area,
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         fontFamily: 'GSANSM'),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width,
//                               height: 200,
//                               child: Stack(
//                                 children: <Widget>[
//                                   Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     height: 200,
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         width: 2,
//                                         color: Colors.grey.shade300,
//                                       ),
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(5.0) // POINT
//                                           ),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     height: 200,
//                                     alignment: Alignment.center,
//                                     child: ClipRRect(
//                                         child: club_image_url != ""
//                                             ? GestureDetector(
//                                                 onTap: () {
//                                                   pickImage();
//                                                 },
//                                                 child: _imageFile == null
//                                                     ? Image.network(
//                                                         club_image_url)
//                                                     : Image.file(_imageFile!))
//                                             : GestureDetector(
//                                                 child: Center(
//                                                   child: TextButton.icon(
//                                                       onPressed: () {
//                                                         // _showDialog(context);
//                                                         pickImage();
//                                                       },
//                                                       style: ButtonStyle(
//                                                           backgroundColor:
//                                                               MaterialStateProperty
//                                                                   .all(Colors
//                                                                       .white)),
//                                                       icon: Icon(
//                                                         Icons.add,
//                                                         color: Colors
//                                                             .grey.shade300,
//                                                       ),
//                                                       label: Text(
//                                                         "이미지 불러오기",
//                                                         style: TextStyle(
//                                                           color: Colors
//                                                               .grey.shade300,
//                                                           fontSize: 16.0,
//                                                           fontFamily:
//                                                               'GSANSM',
//                                                         ),
//                                                       )),
//                                                 ),
//                                               )),
//                                   )
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   }
//                 }),
//             SizedBox(
//               height: 20,
//             ),
//             Center(
//               child: SizedBox(
//                 width: 180,
//                 height: 30,
//                 child: Container(
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       validateAndSave();

//                       try {
//                         // validateAndSave();
//                         String url = "";

//                         if (_imageFile != null) {
//                           uploadImageToFirebase(this.context, name);

//                           Timer(Duration(milliseconds: 3000), () async {
//                             final ref = firebase_storage
//                                 .FirebaseStorage.instance
//                                 .ref()
//                                 .child("ClubProfile")
//                                 .child(name);

//                             url = await ref.child(fileName).getDownloadURL();

//                             await firestore
//                                 .collection("Club")
//                                 .doc(name)
//                                 .update({
//                               "ClubName": clubname,
//                               "ClubIntro": clubintro,
//                               "ClubArea": change_club_area == area_condition ||
//                                       _selectedValue == "서울"
//                                   ? clubarea
//                                   : change_club_area,
//                               "ClubMainImage": url
//                             });
//                           });
//                           Navigator.of(this.context)..pop()..pop()..pop();
//                         } else {
//                           await firestore.collection("Club").doc(name).update({
//                             "ClubName": clubname,
//                             "ClubIntro": clubintro,
//                             "ClubArea": change_club_area == area_condition ||
//                                     _selectedValue == "서울"
//                                 ? clubarea
//                                 : change_club_area,
//                             "ClubMainImage": club_image_url
//                           });
//                           Navigator.of(this.context)..pop()..pop()..pop();
//                         }
//                       } catch (e) {
//                         print(e);
//                       }
//                     },
//                     style: OutlinedButton.styleFrom(
//                         primary: Colors.white,
//                         backgroundColor: Color(0xffe9394f),
//                         shape: RoundedRectangleBorder(
//                             side: BorderSide(
//                                 color: Color(0xffe9394f),
//                                 width: 1,
//                                 style: BorderStyle.solid),
//                             borderRadius: BorderRadius.circular(50)),
//                         elevation: 0),
//                     child: Text(
//                       "클럽설정 변경완료",
//                       style: TextStyle(
//                           fontFamily: 'GSANSB',
//                           fontSize: 16,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         //endDrawer: Drawer(child: HamburgerMenu()),
//         backgroundColor: Colors.white,
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           backgroundColor: Color(0xFFFFFFFF),
//           iconTheme: IconThemeData(color: Colors.grey),
//           automaticallyImplyLeading: false,
//           title: SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
//           //SvgPicture.asset('assets/images/SVG/logo.svg', width: 150,),
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
//         body: SafeArea(
//           child: Column(
//             children: [
//               edit_Club_Profile(),
//             ],
//           ),
//         ));
//   }
// }
