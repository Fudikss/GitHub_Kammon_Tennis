import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:date_format/date_format.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/club_drawer_1_0.dart';
import 'package:snstennis/club/first_screen_1_0.dart';
import 'package:snstennis/home.dart';
import 'package:snstennis/instant/instant_main.dart';
import 'package:snstennis/market/Market_Main_Page.dart';

import 'package:video_compress/video_compress.dart';

///
/// 일반게시글 클래스
///
class Nomal extends StatefulWidget {
  final String club_name;
  final String club_real_uid;

  const Nomal({Key? key, required this.club_name, required this.club_real_uid})
      : super(key: key);

  @override
  _NomalState createState() => _NomalState(club_name, club_real_uid);
}

class _NomalState extends State<Nomal> {
  User user = FirebaseAuth.instance.currentUser!;

  ///
  /// 클럽 게시글 데이터
  ///
  String club_write_title = "";
  String club_write_intro = "";
  String club_write_tag = "";

  final formKey = new GlobalKey<FormState>();
  String name = "";
  String real_uid = "";

  int _selectedNaviIndex = 2;

  late int nomal_leng;

  _NomalState(this.name, this.real_uid);

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print("success $club_write_title, $club_write_intro, $club_write_tag");
    } else {
      print("failed");
    }
  }

  //List<bool> isSelected = [true, false];

  //String access = "NoticePost";

  List clubpostinfo = [];

  File? _imageFile = null;

  File? _videoFile = null;

  String fileName = "";

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      Navigator.of(this.context)..pop();
    } else {
      return;
    }
  }

  Future pickVideo() async {
    final pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
      // await VideoCompress.setLogLevel(0);
      // final MediaInfo? info = await VideoCompress.compressVideo(
      //     _videoFile!.path,
      //     quality: VideoQuality.MediumQuality,
      //     deleteOrigin: false,
      //     includeAudio: true);

      Navigator.of(this.context)..pop();
    } else {
      return;
    }
  }

  Future uploadImageToFirebase(BuildContext context, String club_uid) async {
    fileName = basename(_imageFile!.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("ClubProfile")
        .child(club_uid)
        .child("NomalPostImage")
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

  Future uploadVideoToFirebase(BuildContext context, String club_uid) async {
    fileName = basename(_videoFile!.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("ClubProfile")
        .child(club_uid)
        .child("NoticePostImage")
        .child('/$fileName');

    // await VideoCompress.setLogLevel(0);
    // final MediaInfo? info = await VideoCompress.compressVideo(fileName,
    //     quality: VideoQuality.MediumQuality,
    //     deleteOrigin: false,
    //     includeAudio: true);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'video/mp4',
        customMetadata: {'picked-file-path': fileName});
    firebase_storage.UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask = ref.putFile(io.File(_videoFile!.path), metadata);

    firebase_storage.UploadTask task = await Future.value(uploadTask);
    Future.value(uploadTask)
        .then((value) => {print("Upload file path ${value.ref.fullPath}")})
        .onError((error, stackTrace) =>
            {print("Upload file path error ${error.toString()} ")});
  }

  // Future _get_Nomal_Post_leng() async {
  //   CollectionReference refWait_nomal_post = FirebaseFirestore.instance
  //       .collection("Club")
  //       .doc(real_uid)
  //       .collection("Post");
  //   DocumentSnapshot snapshot_nomal_post_leng =
  //       await refWait_nomal_post.doc("NomalPost").get();

  //   nomal_leng = snapshot_nomal_post_leng["NomalPost"].length;
  // }

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
        resizeToAvoidBottomInset: false,
        endDrawer: Drawer(
            child: ClubDrawer(
          club_uid: real_uid,
          club_name: name,
        )),
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
        body: Container(
            child: Form(
          key: formKey,
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
                height: 50,
                width: MediaQuery.of(context).size.width,
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
                          labelText: "일반게시물 제목 입력",
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
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          filled: true,
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Failed Club_write_title' : null,
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
                  height: 200,
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

                      hintText: '일반게시글 내용 입력',
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
                    validator: (value) =>
                        value!.isEmpty ? 'Failed Club write Intro' : null,
                    onSaved: (value) => club_write_intro = value!,
                  ),
                ),
              ),
              Container(
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: _imageFile != null
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: AlertDialog(
                                          actions: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  child: Text(
                                                    "이미지",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 14,
                                                        fontFamily: 'GSANSM'),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                      fixedSize: Size(80, 20),
                                                      primary: Colors.white,
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5))),
                                                  onPressed: () {
                                                    setState(() {
                                                      _imageFile = null;
                                                    });
                                                    pickImage();
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                ElevatedButton(
                                                  child: Text(
                                                    "비디오",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 14,
                                                        fontFamily: 'GSANSM'),
                                                  ),
                                                  style: ElevatedButton.styleFrom(
                                                      fixedSize: Size(80, 20),
                                                      primary: Colors.white,
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5))),
                                                  onPressed: () {
                                                    // pickVideo();
                                                    _showDialog(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Image.file(_imageFile!)
                                // Container(),
                                )
                            : ElevatedButton(
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.grey,
                                  size: 50,
                                ),
                                onPressed: () {
                                  // _showDialog(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        actions: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                child: Text(
                                                  "이미지",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 14,
                                                      fontFamily: 'GSANSM'),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    fixedSize: Size(80, 20),
                                                    primary: Colors.white,
                                                    side: BorderSide(
                                                        width: 1,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                                onPressed: () {
                                                  pickImage();
                                                },
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              ElevatedButton(
                                                child: Text(
                                                  "비디오",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 14,
                                                      fontFamily: 'GSANSM'),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    fixedSize: Size(80, 20),
                                                    primary: Colors.white,
                                                    side: BorderSide(
                                                        width: 1,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5))),
                                                onPressed: () {
                                                  // pickVideo();
                                                  _showDialog(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }, //pickImage,
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      //Navigator.pop(context);
                      validateAndSave();
                      // uploadImageToFirebase(context);

                      if (_imageFile != null) {
                        String url = "";

                        uploadImageToFirebase(context, real_uid);

                        Timer(Duration(milliseconds: 2500), () async {
                          final ref = firebase_storage.FirebaseStorage.instance
                              .ref()
                              .child("ClubProfile")
                              .child(real_uid)
                              .child("NomalPostImage")
                              .child(fileName);

                          url = await ref.getDownloadURL();

                          try {
                            var docid = FirebaseFirestore.instance
                                .collection("Club")
                                .doc(real_uid)
                                .collection("Post")
                                .doc("NomalPost")
                                .collection("NomalPostComment")
                                .doc();

                            clubpostinfo.add({
                              "ClubPostTitle": club_write_title,
                              "ClubPostIntro": club_write_intro,
                              // "ClubPostTag": club_write_tag,
                              'ClubPostImage': url,
                              "NickName": userAccount_.nickname,
                              "UserUID": user.uid,
                              "DateTime": formatDate(DateTime.now(),
                                  [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                              "KeyNumber": "0",
                              "CommentID": docid.id,
                              "Profile_image": userAccount_.profile_image
                            });

                            FirebaseFirestore.instance
                                .collection("Club")
                                .doc(real_uid)
                                .collection("Post")
                                .doc("NomalPost")
                                .update({
                              "NomalPost": FieldValue.arrayUnion(clubpostinfo),
                            });

                            // docid.set({"ChatList": []});
                            docid.set({});

                            clubpostinfo.clear();

                            Navigator.pop(context);
                          } catch (e) {
                            print(e);
                          }
                        });
                      } else {
                        try {
                          var docid = FirebaseFirestore.instance
                              .collection("Club")
                              .doc(real_uid)
                              .collection("Post")
                              .doc("NomalPost")
                              .collection("NomalPostComment")
                              .doc();

                          clubpostinfo.add({
                            "ClubPostTitle": club_write_title,
                            "ClubPostIntro": club_write_intro,
                            // "ClubPostTag": club_write_tag,
                            'ClubPostImage': "",
                            "NickName": userAccount_.nickname,
                            "UserUID": user.uid,
                            "DateTime": formatDate(DateTime.now(),
                                [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                            "KeyNumber": "0",
                            "CommentID": docid.id,
                            "Profile_image": userAccount_.profile_image
                          });

                          FirebaseFirestore.instance
                              .collection("Club")
                              .doc(real_uid)
                              .collection("Post")
                              .doc("NomalPost")
                              .update({
                            "NomalPost": FieldValue.arrayUnion(clubpostinfo),
                          });

                          // docid.set({"ChatList": []});
                          docid.set({});

                          clubpostinfo.clear();

                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                        }
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
                      "게시글 등록",
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

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "준비중 입니다!!",
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
              fontFamily: 'GSANSM'),
        ),
        content: Text(
          "추후 추가 예정입니다!!",
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
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(80, 20),
                  primary: Colors.white,
                  side: BorderSide(
                      width: 1, color: Theme.of(context).primaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
          //   style: ElevatedButton.styleFrom(
          //       fixedSize: Size(80, 20),
          //       primary: Colors.white,
          //       side:
          //           BorderSide(width: 1, color: Theme.of(context).primaryColor),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(5))),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      );
    },
  );
}









//1.0.0.+7
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'dart:io' as io;
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:date_format/date_format.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/club/club_drawer_1_0.dart';
// import 'package:snstennis/club/first_screen_1_0.dart';
// import 'package:snstennis/home.dart';
// import 'package:snstennis/instant/instant_main.dart';
// import 'package:snstennis/market/Market_Main_Page.dart';

// ///
// /// 일반게시글 클래스
// ///
// class Nomal extends StatefulWidget {
//   final String club_name;
//   final String club_real_uid;

//   const Nomal({Key? key, required this.club_name, required this.club_real_uid})
//       : super(key: key);

//   @override
//   _NomalState createState() => _NomalState(club_name, club_real_uid);
// }

// class _NomalState extends State<Nomal> {
//   User user = FirebaseAuth.instance.currentUser!;

//   ///
//   /// 클럽 게시글 데이터
//   ///
//   String club_write_title = "";
//   String club_write_intro = "";
//   String club_write_tag = "";

//   final formKey = new GlobalKey<FormState>();
//   String name = "";
//   String real_uid = "";

//   int _selectedNaviIndex = 2;

//   late int nomal_leng;

//   _NomalState(this.name, this.real_uid);

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

//   File? _imageFile = null;

//   String fileName = "";

//   final picker = ImagePicker();

//   Future pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//     setState(() {
//       _imageFile = File(pickedFile!.path);
//     });
//   }

//   Future uploadImageToFirebase(BuildContext context) async {
//     fileName = basename(_imageFile!.path);
//     firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
//         .ref()
//         .child('ClubPostImage')
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

//   Future _get_Nomal_Post_leng() async {
//     CollectionReference refWait_nomal_post = FirebaseFirestore.instance
//         .collection("Club")
//         .doc(real_uid)
//         .collection("Post");
//     DocumentSnapshot snapshot_nomal_post_leng =
//         await refWait_nomal_post.doc("NomalPost").get();

//     nomal_leng = snapshot_nomal_post_leng["NomalPost"].length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     UserAccountInfo userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);

//     _get_Nomal_Post_leng();

//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         endDrawer: Drawer(
//             child: ClubDrawer(
//           club_uid: real_uid,
//           club_name: name,
//         )),
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Color(0xFFFFFFFF),
//           iconTheme: IconThemeData(color: Colors.grey),
//           automaticallyImplyLeading: false,
//           title: SvgPicture.asset(
//             'assets/images/SVG/LOGO_KAMMON_small.svg',
//             width: 110,
//           ),
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
//         body: Container(
//             child: Form(
//           key: formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               SizedBox(
//                 height: 20,
//               ),

//               ///
//               /// 각각 텍스트 필드 박스 크기 조정 필요
//               ///
//               Container(
//                 height: 50,
//                 width: MediaQuery.of(context).size.width,
//                 child: Row(children: [
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                       child: TextFormField(
//                         style: TextStyle(
//                             fontFamily: 'GSANSM',
//                             fontSize: 14,
//                             color: Colors.black),
//                         obscureText: false,
//                         decoration: InputDecoration(
//                           labelText: "일반게시물 제목 입력",
//                           labelStyle: TextStyle(
//                               fontFamily: 'GSANSM',
//                               fontSize: 14,
//                               color: Color(0xff9f9f9f)),
//                           fillColor: Colors.white,
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Color(0xFFDBE2E7),
//                               width: 0.8,
//                             ),
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(8),
//                               bottomRight: Radius.circular(8),
//                               topLeft: Radius.circular(8),
//                               topRight: Radius.circular(8),
//                             ),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Color(0xFFDBE2E7),
//                               width: 0.8,
//                             ),
//                             borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(8),
//                               bottomRight: Radius.circular(8),
//                               topLeft: Radius.circular(8),
//                               topRight: Radius.circular(8),
//                             ),
//                           ),
//                           filled: true,
//                         ),
//                         validator: (value) =>
//                             value!.isEmpty ? 'Failed Club_write_title' : null,
//                         onSaved: (value) => club_write_title = value!,
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   height: 200,
//                   child: TextFormField(
//                     maxLines: 40,
//                     keyboardType: TextInputType.multiline,
//                     //expands: true,
//                     obscureText: false,
//                     style: TextStyle(
//                         fontFamily: 'GSANSM',
//                         fontSize: 14,
//                         color: Colors.black),
//                     decoration: InputDecoration(
//                       contentPadding: new EdgeInsets.symmetric(
//                           vertical: 10.0, horizontal: 10.0),

//                       hintText: '일반게시글 내용 입력',
//                       hintStyle: TextStyle(
//                           fontFamily: 'GSANSM',
//                           fontSize: 14,
//                           color: Color(0xff9f9f9f)),
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.grey.shade300,
//                             width: 0.8,
//                           ),
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(5))),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Colors.grey.shade300,
//                             width: 0.8,
//                           ),
//                           borderRadius:
//                               const BorderRadius.all(Radius.circular(5))),
//                       //filled: true,
//                     ),
//                     validator: (value) =>
//                         value!.isEmpty ? 'Failed Club write Intro' : null,
//                     onSaved: (value) => club_write_intro = value!,
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 100,
//                 child: Stack(
//                   children: <Widget>[
//                     Container(
//                       height: double.infinity,
//                       width: double.infinity,
//                       margin: const EdgeInsets.only(
//                           left: 10.0, right: 10.0, top: 10.0),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(30.0),
//                         child: _imageFile != null
//                             ? Image.file(_imageFile!)
//                             : ElevatedButton(
//                                 child: Icon(
//                                   Icons.add_a_photo,
//                                   color: Colors.grey,
//                                   size: 50,
//                                 ),
//                                 onPressed: () {
//                                   _showDialog(context);
//                                 }, // pickImage,
//                                 style: ButtonStyle(
//                                   backgroundColor:
//                                       MaterialStateProperty.all(Colors.white),
//                                 ),
//                               ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       //Navigator.pop(context);
//                       validateAndSave();
//                       // uploadImageToFirebase(context);
//                       try {
//                         ///
//                         /// 비효율적이라 개선해야함
//                         ///
//                         clubpostinfo.add({
//                           "ClubPostTitle": club_write_title,
//                           "ClubPostIntro": club_write_intro,
//                           // "ClubPostTag": club_write_tag,
//                           'ClubPostImage': fileName,
//                           "NickName": userAccount_.nickname,
//                           "UserUID": user.uid,
//                           "DateTime": formatDate(
//                               DateTime.now(), [yyyy, ".", mm, '.', dd]),
//                           "KeyNumber": nomal_leng.toString()
//                         });

//                         FirebaseFirestore.instance
//                             .collection("Club")
//                             .doc(real_uid)
//                             .collection("Post")
//                             .doc("NomalPost")
//                             .update({
//                           "NomalPost": FieldValue.arrayUnion(clubpostinfo),
//                         });
//                         clubpostinfo.clear();

//                         Navigator.pop(context);
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
//                       "게시글 등록",
//                       style: TextStyle(
//                           fontFamily: 'GSANSB',
//                           fontSize: 16,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )),
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

// void _showDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("준비중 입니다!!"),
//         content: Text("추후 추가 예정입니다!!"),
//         actions: <Widget>[
//           ElevatedButton(
//             child: Text("OK"),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
