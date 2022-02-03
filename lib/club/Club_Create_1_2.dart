import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';

// import 'Club_splash.dart';

class ClubCreate extends StatefulWidget {
  const ClubCreate({Key? key}) : super(key: key);

  @override
  _ClubCreateState createState() => _ClubCreateState();
}

class _ClubCreateState extends State<ClubCreate> {
  ///
  /// SelectBox에 등록할 데이터
  ///
  final area = [
    "지역선택",
    "강원도",
    "경상남도",
    "경상북도",
    "경기도",
    "광주광역시",
    "대구광역시",
    "대전광역시",
    "부산광역시",
    "서울특별시",
    "세종특별자치시",
    "울산광역시",
    "인천광역시",
    "전라남도",
    "전라북도",
    "제주도",
    "충청남도",
    "충청북도",
  ];

  ///
  /// SelectBox 초기값
  ///
  var _selectedValue = '지역선택';

  ///
  /// 클럽생성 데이터 목록
  ///
  String clubname = "";
  String clubintro = "";
  String clubuser = "";
  String clubarea = "지역선택";

  ///
  /// 입력받은 클럽 이름을 FireStore에 배열에 삽입하기위하여 List형 변수 선언
  ///
  List testlist = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  FocusNode _club_name = FocusNode();
  FocusNode _club_intro = FocusNode();

  ///
  /// 이미지 기능 함수
  ///
  File? _imageFile = null;

  File? _imageFile1 = null;

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

  @override
  Widget build(BuildContext context) {
    user_account_info_ = Provider.of<UserAccountInfo>(context, listen: false);
    User user = FirebaseAuth.instance.currentUser!;
    FocusScopeNode currentFocus = FocusScope.of(context);
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
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
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          //endDrawer: Drawer(child: HamburgerMenu()),
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xFFFFFFFF),
            iconTheme: IconThemeData(color: Colors.grey),
            automaticallyImplyLeading: false,
            title: SvgPicture.asset(
              'assets/images/SVG/LOGO_KAMMON_small.svg',
              width: 110,
            ),
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
          body: GestureDetector(
            onTap: () {
              currentFocus.unfocus();
            },
            child: SafeArea(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                            child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                    child: Text(
                                      "클럽생성",
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
                                          '클럽이름',
                                          style: TextStyle(
                                              color: Color(0xff58585b),
                                              fontSize: 16,
                                              fontFamily: 'GSANSB'),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                140,
                                        height: 30,
                                        child: TextFormField(
                                          focusNode: _club_name,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                new EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 10.0),
                                            hintText: '이름을 입력해주세요.',
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
                                          validator: (value) => value!.isEmpty
                                              ? 'Failed ClubName'
                                              : null,
                                          onSaved: (value) {
                                            clubname = value!;
                                          },
                                          textInputAction: TextInputAction.next,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
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
                                            MediaQuery.of(context).size.width -
                                                140,
                                        // width: 200,
                                        height: 100,
                                        child: TextFormField(
                                          focusNode: _club_intro,
                                          maxLines: 20,
                                          keyboardType: TextInputType.multiline,
                                          //expands: true,
                                          obscureText: false,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                new EdgeInsets.symmetric(
                                                    vertical: 5.0,
                                                    horizontal: 10.0),
                                            hintText: '나의 클럽을 소개해주세요.',
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
                                          validator: (value) => value!.isEmpty
                                              ? 'Failed Club Intro'
                                              : null,
                                          onSaved: (value) =>
                                              clubintro = value!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          '지역선택',
                                          style: TextStyle(
                                              color: Color(0xff58585b),
                                              fontSize: 16,
                                              fontFamily: 'GSANSB'),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 50,
                                        child: Row(
                                          children: [
                                            //SingleChildScrollView(
                                            //child:
                                            DropdownButton(
                                              onTap: () {
                                                FocusScopeNode currentFocus =
                                                    FocusScope.of(context);
                                                if (!currentFocus
                                                    .hasPrimaryFocus) {
                                                  currentFocus.unfocus();
                                                }
                                              },
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
                                                  clubarea = value.toString();
                                                  print(clubarea);
                                                });
                                              },
                                            ),
                                            //)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                    child: Row(children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        '대표사진',
                                        style: TextStyle(
                                            color: Color(0xff58585b),
                                            fontSize: 16,
                                            fontFamily: 'GSANSB'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 140,
                                    // width: 200,
                                    height: 150,
                                    // height: 100,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              140,
                                          // width: 200,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2,
                                              color: Colors.grey.shade300,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0) // POINT
                                                ),
                                          ), //
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              140,
                                          // height: 100,
                                          height: 150,
                                          alignment: Alignment.center,
                                          child: ClipRRect(
                                              child: _imageFile != null
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        // setState(() {
                                                        //   _imageFile = null;
                                                        // });
                                                        // _imageFile = null;
                                                        // pickImage();

                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              content: Text(
                                                                '변경 및 삭제 하시겠습니까?',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'GSANSM'),
                                                              ),
                                                              actions: <Widget>[
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      child:
                                                                          Text(
                                                                        "변경",
                                                                        style: TextStyle(
                                                                            color: Theme.of(context)
                                                                                .primaryColor,
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'GSANSM'),
                                                                      ),
                                                                      style: ElevatedButton.styleFrom(
                                                                          fixedSize: Size(
                                                                              80,
                                                                              20),
                                                                          primary: Colors
                                                                              .white,
                                                                          side: BorderSide(
                                                                              width: 1,
                                                                              color: Theme.of(context).primaryColor),
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                                      onPressed:
                                                                          () {
                                                                        _imageFile =
                                                                            null;
                                                                        pickImage().then((value) =>
                                                                            Navigator.of(context).pop());
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    ElevatedButton(
                                                                      child:
                                                                          Text(
                                                                        "삭제",
                                                                        style: TextStyle(
                                                                            color: Theme.of(context)
                                                                                .primaryColor,
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'GSANSM'),
                                                                      ),
                                                                      style: ElevatedButton.styleFrom(
                                                                          fixedSize: Size(
                                                                              80,
                                                                              20),
                                                                          primary: Colors
                                                                              .white,
                                                                          side: BorderSide(
                                                                              width: 1,
                                                                              color: Theme.of(context).primaryColor),
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _imageFile =
                                                                              null;
                                                                        });

                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                    SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    ElevatedButton(
                                                                      child:
                                                                          Text(
                                                                        "취소",
                                                                        style: TextStyle(
                                                                            color: Theme.of(context)
                                                                                .primaryColor,
                                                                            fontSize:
                                                                                16,
                                                                            fontFamily:
                                                                                'GSANSM'),
                                                                      ),
                                                                      style: ElevatedButton.styleFrom(
                                                                          fixedSize: Size(
                                                                              80,
                                                                              20),
                                                                          primary: Colors
                                                                              .white,
                                                                          side: BorderSide(
                                                                              width: 1,
                                                                              color: Theme.of(context).primaryColor),
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Image.file(
                                                          _imageFile!))
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
                                                              color: Colors.grey
                                                                  .shade300,
                                                            ),
                                                            label: Text(
                                                              "이미지 불러오기",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                fontSize: 16.0,
                                                                fontFamily:
                                                                    'GSANSM',
                                                              ),
                                                            )),
                                                      ),
                                                    )),
                                        )
                                      ],
                                    ),
                                  )
                                ])),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: SizedBox(
                                    width: 180,
                                    height: 30,
                                    child: Container(
                                      //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          ///
                                          /// 각각 클럽명, 클럽 소개, 지역, 이미지를 등록하지않으면 클럽생성 제한 조건문을 걸어야한다.
                                          ///
                                          //Navigator.pop(context);
                                          if (_selectedValue != '지역선택' &&
                                              clubname != "" &&
                                              clubintro != "") {
                                            validateAndSave();
                                            try {
                                              ///
                                              /// 선택한 이미지 FireStore 및 Storage에 업로드
                                              ///

                                              String doc_image_path = "";

                                              String url = "";
                                              var docid = firestore
                                                  .collection('Club')
                                                  .doc();

                                              if (_imageFile != null) {
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return SplashScreen(
                                                      prev_image_path:
                                                          docid.toString(),
                                                      prev_clubname: clubname,
                                                      prev_clubintro: clubintro,
                                                      prev_clubarea: clubarea,
                                                      prev_imageFile:
                                                          _imageFile,
                                                      prev_account_nick_name:
                                                          user_account_info_
                                                              .nickname);
                                                }));
                                              } else {
                                                docid.set({
                                                  'ClubName': clubname,
                                                  'ClubIntro': clubintro,
                                                  'ClubArea': clubarea,
                                                  'ClubMember': [user.uid],
                                                  'ClubMainImage': "",
                                                  'ClubUID': docid.id,
                                                  'MemberCount': 1
                                                });

                                                var docid2 = firestore
                                                    .collection('Club')
                                                    .doc(docid.id)
                                                    .collection("ClubMember")
                                                    .doc("MemberList")
                                                    .set({
                                                  'ClubMember': [
                                                    {
                                                      "UserID": user.uid,
                                                      "NickName":
                                                          user_account_info_
                                                              .nickname,
                                                      "Grade": "Master"
                                                    }
                                                  ],
                                                });

                                                var docid3 = firestore
                                                    .collection('Club')
                                                    .doc(docid.id)
                                                    .collection('ClubMember')
                                                    .doc('WaitJoinClub')
                                                    .set({'WaitJoinClub': []});

                                                var docid4 = firestore
                                                    .collection('Club')
                                                    .doc(docid.id)
                                                    .collection('Post')
                                                    .doc('GatheringPost')
                                                    .set({});

                                                var docid5 = firestore
                                                    .collection('Club')
                                                    .doc(docid.id)
                                                    .collection('Post')
                                                    .doc('NomalPost')
                                                    .set({'NomalPost': []});

                                                var docid6 = firestore
                                                    .collection('Club')
                                                    .doc(docid.id)
                                                    .collection('Post')
                                                    .doc('NoticePost')
                                                    .set({'NoticePost': []});

                                                var docid7 = firestore
                                                    .collection('Club')
                                                    .doc(docid.id)
                                                    .collection('Post')
                                                    .doc('GatheringPost')
                                                    .collection(
                                                        'GatheringPostList')
                                                    .doc('GatheringJoinList')
                                                    .set({});

                                                var docid8 = firestore
                                                    .collection('Club')
                                                    .doc(docid.id)
                                                    .collection('Post')
                                                    .doc('NomalPost')
                                                    .collection(
                                                        'NomalPostComment')
                                                    .doc('NomalComment')
                                                    .set({});

                                                var docid9 = firestore
                                                    .collection('Club')
                                                    .doc(docid.id)
                                                    .collection('Post')
                                                    .doc('NoticePost')
                                                    .collection(
                                                        'NoticePostComment')
                                                    .doc('NoticeComment')
                                                    .set({});

                                                var docid10 = firestore
                                                    .collection('Club')
                                                    .doc(docid.id)
                                                    .collection('Post')
                                                    .doc('GatheringPost')
                                                    .set({'GatheringPost': []});

                                                var docid11 = firestore
                                                    .collection('Club')
                                                    .doc(docid.id)
                                                    .collection('ChatRoom')
                                                    .doc('ChatRoom')
                                                    .set({'ChatRoom': []});

                                                //var doi

                                                testlist.add(docid.id);

                                                ///
                                                /// 창설한 사용자의 클럽 가입 목록 추가
                                                ///
                                                firestore
                                                    .collection('Users')
                                                    .doc(user.uid)
                                                    .update({
                                                  "JoinClub":
                                                      FieldValue.arrayUnion(
                                                          testlist),
                                                });

                                                testlist.clear();

                                                Navigator.pop(context);
                                              }
                                            } catch (e) {
                                              print(e);
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  //title: Text("지역이 선택되지 않았습니다."),
                                                  content: Text(
                                                    "지역이 선택되지 않았습니다.",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 16,
                                                        fontFamily: 'GSANSM'),
                                                  ),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      child: Text(
                                                        "확인",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                'GSANSM'),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                          fixedSize:
                                                              Size(80, 20),
                                                          primary: Colors.white,
                                                          side: BorderSide(
                                                              width: 1,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5))),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }

                                          // testlist.clear();

                                          // Navigator.pop(context);
                                        },
                                        style: OutlinedButton.styleFrom(
                                            primary: Colors.white,
                                            backgroundColor: Color(0xffe9394f),
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Color(0xffe9394f),
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            elevation: 0),
                                        child: Text(
                                          "클럽 만들기",
                                          style: TextStyle(
                                              fontFamily: 'GSANSB',
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                        ))))),
          )),
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
          ElevatedButton(
            child: Text(
              "나가기",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontFamily: 'GSANSM'),
            ),
            style: ElevatedButton.styleFrom(
                fixedSize: Size(80, 20),
                primary: Colors.white,
                side:
                    BorderSide(width: 1, color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class SplashScreen extends StatefulWidget {
  final String prev_image_path;
  final String prev_clubname;
  final String prev_clubintro;
  final String prev_clubarea;
  final File? prev_imageFile;
  final String prev_account_nick_name;

  const SplashScreen(
      {Key? key,
      required this.prev_image_path,
      required this.prev_clubname,
      required this.prev_clubintro,
      required this.prev_clubarea,
      required this.prev_imageFile,
      required this.prev_account_nick_name})
      : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState(
      prev_image_path,
      prev_clubname,
      prev_clubintro,
      prev_clubarea,
      prev_imageFile,
      prev_account_nick_name);
}

class _SplashScreenState extends State<SplashScreen> {
  String image_path = "";
  String club_name = "";
  String club_intro = "";
  String club_area = "";
  File? _imagefile = null;
  String nick_name = "";

  String fileName = "";

  Future uploadImageToFirebase(
      BuildContext context, String doc_path, File _imageFile) async {
    fileName = basename(_imageFile.path);
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
    uploadTask = ref.putFile(io.File(_imageFile.path), metadata);

    firebase_storage.UploadTask task = await Future.value(uploadTask);
    Future.value(uploadTask)
        .then((value) => {print("Upload file path ${value.ref.fullPath}")})
        .onError((error, stackTrace) =>
            {print("Upload file path error ${error.toString()} ")});
  }

  UserAccountInfo userInfo = UserAccountInfo();
  User user = FirebaseAuth.instance.currentUser!;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  _SplashScreenState(this.image_path, this.club_name, this.club_intro,
      this.club_area, this._imagefile, this.nick_name);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String doc_image_path = "";

    String url = "";

    var docid = firestore.collection('Club').doc();

    doc_image_path = docid.id;

    uploadImageToFirebase(this.context, doc_image_path, _imagefile!);

    Timer(Duration(milliseconds: 5000), () async {
      List testlist = [];

      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("ClubProfile")
          .child(doc_image_path);

      url = await ref.child(fileName).getDownloadURL();

      docid.set({
        'ClubName': club_name,
        'ClubIntro': club_intro,
        'ClubArea': club_area,
        'ClubMember': [user.uid],
        'ClubMainImage': url,
        'ClubUID': docid.id,
        'MemberCount': 1
      });

      var docid2 = firestore
          .collection('Club')
          .doc(docid.id)
          .collection("ClubMember")
          .doc("MemberList")
          .set({
        'ClubMember': [
          {"UserID": user.uid, "NickName": nick_name, "Grade": "Master"}
        ],
      });

      var docid3 = firestore
          .collection('Club')
          .doc(docid.id)
          .collection('ClubMember')
          .doc('WaitJoinClub')
          .set({'WaitJoinClub': []});

      var docid4 = firestore
          .collection('Club')
          .doc(docid.id)
          .collection('Post')
          .doc('GatheringPost')
          .set({});

      var docid5 = firestore
          .collection('Club')
          .doc(docid.id)
          .collection('Post')
          .doc('NomalPost')
          .set({'NomalPost': []});

      var docid6 = firestore
          .collection('Club')
          .doc(docid.id)
          .collection('Post')
          .doc('NoticePost')
          .set({'NoticePost': []});

      var docid7 = firestore
          .collection('Club')
          .doc(docid.id)
          .collection('Post')
          .doc('GatheringPost')
          .collection('GatheringPostList')
          .doc('GatheringJoinList')
          .set({});

      var docid8 = firestore
          .collection('Club')
          .doc(docid.id)
          .collection('Post')
          .doc('NomalPost')
          .collection('NomalPostComment')
          .doc('NomalComment')
          .set({});

      var docid9 = firestore
          .collection('Club')
          .doc(docid.id)
          .collection('Post')
          .doc('NoticePost')
          .collection('NoticePostComment')
          .doc('NoticeComment')
          .set({});

      var docid10 = firestore
          .collection('Club')
          .doc(docid.id)
          .collection('Post')
          .doc('GatheringPost')
          .set({'GatheringPost': []});

      var docid11 = firestore
          .collection('Club')
          .doc(docid.id)
          .collection('ChatRoom')
          .doc('ChatRoom')
          .set({'ChatRoom': []});

      ///
      /// 임시 모임글 생성
      ///
      var docid12 = firestore.collection("Gathering").doc(docid.id).set({
        "Gathering_ID": [],
      });

      //var doi

      testlist.add(docid.id);

      ///
      /// 창설한 사용자의 클럽 가입 목록 추가
      ///
      firestore.collection('Users').doc(user.uid).update({
        "JoinClub": FieldValue.arrayUnion(testlist),
      });

      testlist.clear();

      Navigator.of(this.context)..pop()..pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
              child: Stack(
            children: [
              Align(
                alignment: Alignment(0.0, 0.0),
                child: SvgPicture.asset(
                  'assets/images/SVG/LOGO_KAMMON_small.svg',
                  width: 110,
                ),
              ),
              Align(
                alignment: Alignment(0.0, 0.0),
                child: SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColorLight),
                    )),
              ),
            ],
          )),
        ));
  }
}

//1.0.0.+7
// import 'dart:async';
// import 'dart:io' as io;
// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/hamburger.dart';

// class ClubCreate extends StatefulWidget {
//   const ClubCreate({Key? key}) : super(key: key);

//   @override
//   _ClubCreateState createState() => _ClubCreateState();
// }

// class _ClubCreateState extends State<ClubCreate> {
//   ///
//   /// SelectBox에 등록할 데이터
//   ///
//   final area = [
//     "서울",
//     "강원도",
//     "경기도",
//     "충청남도",
//     "충청북도",
//     "전라남도",
//     "전라북도",
//     "경상북도",
//     "경상남도",
//     "제주도",
//     "부산광역시",
//     "울산광역시",
//     "인천광역시",
//     "광주광역시",
//     "대구광역시",
//     "대전광역시"
//   ];

//   ///
//   /// SelectBox 초기값
//   ///
//   var _selectedValue = '서울';

//   ///
//   /// 클럽생성 데이터 목록
//   ///
//   String clubname = "";
//   String clubintro = "";
//   String clubuser = "";
//   String clubarea = "서울";

//   ///
//   /// 입력받은 클럽 이름을 FireStore에 배열에 삽입하기위하여 List형 변수 선언
//   ///
//   List testlist = [];

//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   final formKey = new GlobalKey<FormState>();
//   late UserAccountInfo user_account_info_;
//   void validateAndSave() {
//     final form = formKey.currentState;
//     if (form!.validate()) {
//       form.save();
//       print("success $clubname, $clubintro");
//     } else {
//       print("failed");
//     }
//   }

//   ///
//   /// 이미지 기능 함수
//   ///
//   File? _imageFile = null;

//   String fileName = "";

//   final picker = ImagePicker();

//   // Future pickImage() async {
//   //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);

//   //   setState(() {
//   //     _imageFile = File(pickedFile!.path);
//   //   });
//   // }

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

//   // Future uploadImageToFirebase(BuildContext context) async {
//   //   fileName = basename(_imageFile!.path);
//   //   firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
//   //       .ref()
//   //       .child('ClubProfile')
//   //       .child('/$fileName');

//   //   final metadata = firebase_storage.SettableMetadata(
//   //       contentType: 'image/jpeg',
//   //       customMetadata: {'picked-file-path': fileName});
//   //   firebase_storage.UploadTask uploadTask;
//   //   //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
//   //   uploadTask = ref.putFile(io.File(_imageFile!.path), metadata);

//   //   firebase_storage.UploadTask task = await Future.value(uploadTask);
//   //   Future.value(uploadTask)
//   //       .then((value) => {print("Upload file path ${value.ref.fullPath}")})
//   //       .onError((error, stackTrace) =>
//   //           {print("Upload file path error ${error.toString()} ")});
//   // }

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

//   @override
//   Widget build(BuildContext context) {
//     user_account_info_ = Provider.of<UserAccountInfo>(context, listen: false);
//     User user = FirebaseAuth.instance.currentUser!;
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         //endDrawer: Drawer(child: HamburgerMenu()),
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Color(0xFFFFFFFF),
//           iconTheme: IconThemeData(color: Colors.grey),
//           automaticallyImplyLeading: false,
//           title: SvgPicture.asset(
//             'assets/images/SVG/LOGO_KAMMON_small.svg',
//             width: 120,
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
//         body: SafeArea(
//             child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height * 1,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                 ),
//                 child: Form(
//                     key: formKey,
//                     child: SingleChildScrollView(
//                         child: Padding(
//                       padding: EdgeInsets.fromLTRB(30, 5, 30, 0),
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                                 padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
//                                 child: Text(
//                                   "MY CLUB",
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
//                                     width: 200,
//                                     height: 30,
//                                     child: TextFormField(
//                                       obscureText: false,
//                                       decoration: InputDecoration(
//                                         contentPadding:
//                                             new EdgeInsets.symmetric(
//                                                 vertical: 0.0,
//                                                 horizontal: 10.0),
//                                         hintText: '이름을 입력해주세요.',
//                                         hintStyle: TextStyle(
//                                             fontFamily: 'GSANSM',
//                                             fontSize: 12,
//                                             color: Color(0xff9f9f9f)),
//                                         enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color: Colors.grey.shade300,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 const BorderRadius.all(
//                                                     Radius.circular(5))),
//                                         focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color: Colors.grey.shade300,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 const BorderRadius.all(
//                                                     Radius.circular(5))),
//                                         //filled: true,
//                                       ),
//                                       validator: (value) => value!.isEmpty
//                                           ? 'Failed ClubName'
//                                           : null,
//                                       onSaved: (value) => clubname = value!,
//                                     ),
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
//                                     width: 200,
//                                     height: 100,
//                                     child: TextFormField(
//                                       maxLines: 20,
//                                       keyboardType: TextInputType.multiline,
//                                       //expands: true,
//                                       obscureText: false,
//                                       decoration: InputDecoration(
//                                         contentPadding:
//                                             new EdgeInsets.symmetric(
//                                                 vertical: 5.0,
//                                                 horizontal: 10.0),
//                                         hintText: '나의 클럽을 소개해주세요.',
//                                         hintStyle: TextStyle(
//                                             fontFamily: 'GSANSM',
//                                             fontSize: 12,
//                                             color: Color(0xff9f9f9f)),
//                                         enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color: Colors.grey.shade300,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 const BorderRadius.all(
//                                                     Radius.circular(5))),
//                                         focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color: Colors.grey.shade300,
//                                               width: 2,
//                                             ),
//                                             borderRadius:
//                                                 const BorderRadius.all(
//                                                     Radius.circular(5))),
//                                         //filled: true,
//                                       ),
//                                       validator: (value) => value!.isEmpty
//                                           ? 'Failed Club Intro'
//                                           : null,
//                                       onSaved: (value) => clubintro = value!,
//                                     ),
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
//                                     width: 200,
//                                     height: 50,
//                                     child: Row(
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
//                                             setState(() {
//                                               _selectedValue = value.toString();
//                                               clubarea = value.toString();
//                                               print(clubarea);
//                                             });
//                                           },
//                                         ),
//                                         //)
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Container(
//                                 child: Row(children: [
//                               SizedBox(
//                                 width: 100,
//                                 height: 100,
//                                 child: Padding(
//                                   padding: EdgeInsets.only(top: 10),
//                                   child: Text(
//                                     '대표이미지',
//                                     style: TextStyle(
//                                         color: Color(0xff58585b),
//                                         fontSize: 16,
//                                         fontFamily: 'GSANSB'),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 200,
//                                 height: 100,
//                                 child: Stack(
//                                   children: <Widget>[
//                                     Container(
//                                       width: 200,
//                                       height: 100,
//                                       decoration: BoxDecoration(
//                                         border: Border.all(
//                                           width: 2,
//                                           color: Colors.grey.shade300,
//                                         ),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(5.0) // POINT
//                                             ),
//                                       ), //
//                                     ),
//                                     Container(
//                                       width: 200,
//                                       height: 100,
//                                       alignment: Alignment.center,
//                                       child: ClipRRect(
//                                           child: _imageFile != null
//                                               ? Image.file(_imageFile!)
//                                               : GestureDetector(
//                                                   child: Center(
//                                                     child: TextButton.icon(
//                                                         onPressed: () {
//                                                           // _showDialog(context);
//                                                           pickImage();
//                                                         },
//                                                         style: ButtonStyle(
//                                                             backgroundColor:
//                                                                 MaterialStateProperty
//                                                                     .all(Colors
//                                                                         .white)),
//                                                         icon: Icon(
//                                                           Icons.add,
//                                                           color: Colors
//                                                               .grey.shade300,
//                                                         ),
//                                                         label: Text(
//                                                           "이미지 불러오기",
//                                                           style: TextStyle(
//                                                             color: Colors
//                                                                 .grey.shade300,
//                                                             fontSize: 16.0,
//                                                             fontFamily:
//                                                                 'GSANSM',
//                                                           ),
//                                                         )),
//                                                   ),
//                                                 )),
//                                     )
//                                   ],
//                                 ),
//                               )
//                             ])),
//                             SizedBox(
//                               height: 70,
//                             ),
//                             Center(
//                               child: SizedBox(
//                                 width: 180,
//                                 height: 30,
//                                 child: Container(
//                                   //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                   child: ElevatedButton(
//                                     // onPressed: () {
//                                     //   ///
//                                     //   /// 각각 클럽명, 클럽 소개, 지역, 이미지를 등록하지않으면 클럽생성 제한 조건문을 걸어야한다.
//                                     //   ///
//                                     //   //Navigator.pop(context);
//                                     //   validateAndSave();
//                                     //   try {
//                                     //     ///
//                                     //     /// 선택한 이미지 FireStore 및 Storage에 업로드
//                                     //     ///
//                                     //     uploadImageToFirebase(context);

//                                     //     ///
//                                     //     /// Club Collection에 document 및 필드 추가
//                                     //     ///
//                                     //     var docid =
//                                     //         firestore.collection('Club').doc();
//                                     //     docid.set({
//                                     //       'ClubName': clubname,
//                                     //       'ClubIntro': clubintro,
//                                     //       'ClubArea': clubarea,
//                                     //       'ClubMember': [user.uid],
//                                     //       'ClubMainImage': fileName,
//                                     //       'ClubUID': docid.id,
//                                     //     });

//                                     //     var docid2 = firestore
//                                     //         .collection('Club')
//                                     //         .doc(docid.id)
//                                     //         .collection("ClubMember")
//                                     //         .doc("MemberList")
//                                     //         .set({
//                                     //       'ClubMember': [
//                                     //         {
//                                     //           "UserID": user.uid,
//                                     //           "NickName":
//                                     //               user_account_info_.nickname,
//                                     //           "Grade": "Master"
//                                     //         }
//                                     //       ],
//                                     //     });

//                                     //     var docid3 = firestore
//                                     //         .collection('Club')
//                                     //         .doc(docid.id)
//                                     //         .collection('ClubMember')
//                                     //         .doc('WaitJoinClub')
//                                     //         .set({'WaitJoinClub': []});

//                                     //     var docid4 = firestore
//                                     //         .collection('Club')
//                                     //         .doc(docid.id)
//                                     //         .collection('Post')
//                                     //         .doc('GatheringPost')
//                                     //         .set({});

//                                     //     var docid5 = firestore
//                                     //         .collection('Club')
//                                     //         .doc(docid.id)
//                                     //         .collection('Post')
//                                     //         .doc('NomalPost')
//                                     //         .set({'NomalPost': []});

//                                     //     var docid6 = firestore
//                                     //         .collection('Club')
//                                     //         .doc(docid.id)
//                                     //         .collection('Post')
//                                     //         .doc('NoticePost')
//                                     //         .set({'NoticePost': []});

//                                     //     var docid7 = firestore
//                                     //         .collection('Club')
//                                     //         .doc(docid.id)
//                                     //         .collection('Post')
//                                     //         .doc('GatheringPost')
//                                     //         .collection('GatheringPostList')
//                                     //         .doc('GatheringJoinList')
//                                     //         .set({});

//                                     //     var docid8 = firestore
//                                     //         .collection('Club')
//                                     //         .doc(docid.id)
//                                     //         .collection('Post')
//                                     //         .doc('NomalPost')
//                                     //         .collection('NomalPostComment')
//                                     //         .doc('NomalComment')
//                                     //         .set({});

//                                     //     var docid9 = firestore
//                                     //         .collection('Club')
//                                     //         .doc(docid.id)
//                                     //         .collection('Post')
//                                     //         .doc('NoticePost')
//                                     //         .collection('NoticePostComment')
//                                     //         .doc('NoticeComment')
//                                     //         .set({});

//                                     //     var docid10 = firestore
//                                     //         .collection('Club')
//                                     //         .doc(docid.id)
//                                     //         .collection('Post')
//                                     //         .doc('GatheringPost')
//                                     //         .set({'GatheringPost': []});

//                                     //     var docid11 = firestore
//                                     //         .collection('Club')
//                                     //         .doc(docid.id)
//                                     //         .collection('ChatRoom')
//                                     //         .doc('ChatRoom')
//                                     //         .set({'ChatRoom': []});

//                                     //     //var doi

//                                     //     testlist.add(docid.id);

//                                     //     ///
//                                     //     /// 창설한 사용자의 클럽 가입 목록 추가
//                                     //     ///
//                                     //     firestore
//                                     //         .collection('Users')
//                                     //         .doc(user.uid)
//                                     //         .update({
//                                     //       "JoinClub":
//                                     //           FieldValue.arrayUnion(testlist),
//                                     //     });
//                                     //   } catch (e) {
//                                     //     print(e);
//                                     //   }
//                                     //   testlist.clear();

//                                     //   Navigator.pop(context);
//                                     // },
//                                     onPressed: () {
//                                       ///
//                                       /// 각각 클럽명, 클럽 소개, 지역, 이미지를 등록하지않으면 클럽생성 제한 조건문을 걸어야한다.
//                                       ///
//                                       //Navigator.pop(context);
//                                       validateAndSave();
//                                       try {
//                                         ///
//                                         /// 선택한 이미지 FireStore 및 Storage에 업로드
//                                         ///

//                                         String doc_image_path = "";

//                                         String url = "";
//                                         var docid =
//                                             firestore.collection('Club').doc();

//                                         if (_imageFile != null) {
//                                           doc_image_path = docid.id;

//                                           uploadImageToFirebase(
//                                               context, doc_image_path);

//                                           Timer(Duration(milliseconds: 3000),
//                                               () async {
//                                             final ref = firebase_storage
//                                                 .FirebaseStorage.instance
//                                                 .ref()
//                                                 .child("ClubProfile")
//                                                 .child(doc_image_path);

//                                             url = await ref
//                                                 .child(fileName)
//                                                 .getDownloadURL();

//                                             docid.set({
//                                               'ClubName': clubname,
//                                               'ClubIntro': clubintro,
//                                               'ClubArea': clubarea,
//                                               'ClubMember': [user.uid],
//                                               'ClubMainImage': url,
//                                               'ClubUID': docid.id,
//                                             });

//                                             var docid2 = firestore
//                                                 .collection('Club')
//                                                 .doc(docid.id)
//                                                 .collection("ClubMember")
//                                                 .doc("MemberList")
//                                                 .set({
//                                               'ClubMember': [
//                                                 {
//                                                   "UserID": user.uid,
//                                                   "NickName": user_account_info_
//                                                       .nickname,
//                                                   "Grade": "Master"
//                                                 }
//                                               ],
//                                             });

//                                             var docid3 = firestore
//                                                 .collection('Club')
//                                                 .doc(docid.id)
//                                                 .collection('ClubMember')
//                                                 .doc('WaitJoinClub')
//                                                 .set({'WaitJoinClub': []});

//                                             var docid4 = firestore
//                                                 .collection('Club')
//                                                 .doc(docid.id)
//                                                 .collection('Post')
//                                                 .doc('GatheringPost')
//                                                 .set({});

//                                             var docid5 = firestore
//                                                 .collection('Club')
//                                                 .doc(docid.id)
//                                                 .collection('Post')
//                                                 .doc('NomalPost')
//                                                 .set({'NomalPost': []});

//                                             var docid6 = firestore
//                                                 .collection('Club')
//                                                 .doc(docid.id)
//                                                 .collection('Post')
//                                                 .doc('NoticePost')
//                                                 .set({'NoticePost': []});

//                                             var docid7 = firestore
//                                                 .collection('Club')
//                                                 .doc(docid.id)
//                                                 .collection('Post')
//                                                 .doc('GatheringPost')
//                                                 .collection('GatheringPostList')
//                                                 .doc('GatheringJoinList')
//                                                 .set({});

//                                             var docid8 = firestore
//                                                 .collection('Club')
//                                                 .doc(docid.id)
//                                                 .collection('Post')
//                                                 .doc('NomalPost')
//                                                 .collection('NomalPostComment')
//                                                 .doc('NomalComment')
//                                                 .set({});

//                                             var docid9 = firestore
//                                                 .collection('Club')
//                                                 .doc(docid.id)
//                                                 .collection('Post')
//                                                 .doc('NoticePost')
//                                                 .collection('NoticePostComment')
//                                                 .doc('NoticeComment')
//                                                 .set({});

//                                             var docid10 = firestore
//                                                 .collection('Club')
//                                                 .doc(docid.id)
//                                                 .collection('Post')
//                                                 .doc('GatheringPost')
//                                                 .set({'GatheringPost': []});

//                                             var docid11 = firestore
//                                                 .collection('Club')
//                                                 .doc(docid.id)
//                                                 .collection('ChatRoom')
//                                                 .doc('ChatRoom')
//                                                 .set({'ChatRoom': []});

//                                             //var doi

//                                             testlist.add(docid.id);

//                                             ///
//                                             /// 창설한 사용자의 클럽 가입 목록 추가
//                                             ///
//                                             firestore
//                                                 .collection('Users')
//                                                 .doc(user.uid)
//                                                 .update({
//                                               "JoinClub": FieldValue.arrayUnion(
//                                                   testlist),
//                                             });

//                                             testlist.clear();

//                                             Navigator.pop(context);
//                                           });
//                                         } else {
//                                           docid.set({
//                                             'ClubName': clubname,
//                                             'ClubIntro': clubintro,
//                                             'ClubArea': clubarea,
//                                             'ClubMember': [user.uid],
//                                             'ClubMainImage': "https://firebasestorage.googleapis.com/v0/b/snstennis-6da56.appspot.com/o/camera.png?alt=media&token=85bc2548-ec16-4da4-a6e4-e2ae5830078b",
//                                             'ClubUID': docid.id,
//                                           });

//                                           var docid2 = firestore
//                                               .collection('Club')
//                                               .doc(docid.id)
//                                               .collection("ClubMember")
//                                               .doc("MemberList")
//                                               .set({
//                                             'ClubMember': [
//                                               {
//                                                 "UserID": user.uid,
//                                                 "NickName": user_account_info_
//                                                     .nickname,
//                                                 "Grade": "Master"
//                                               }
//                                             ],
//                                           });

//                                           var docid3 = firestore
//                                               .collection('Club')
//                                               .doc(docid.id)
//                                               .collection('ClubMember')
//                                               .doc('WaitJoinClub')
//                                               .set({'WaitJoinClub': []});

//                                           var docid4 = firestore
//                                               .collection('Club')
//                                               .doc(docid.id)
//                                               .collection('Post')
//                                               .doc('GatheringPost')
//                                               .set({});

//                                           var docid5 = firestore
//                                               .collection('Club')
//                                               .doc(docid.id)
//                                               .collection('Post')
//                                               .doc('NomalPost')
//                                               .set({'NomalPost': []});

//                                           var docid6 = firestore
//                                               .collection('Club')
//                                               .doc(docid.id)
//                                               .collection('Post')
//                                               .doc('NoticePost')
//                                               .set({'NoticePost': []});

//                                           var docid7 = firestore
//                                               .collection('Club')
//                                               .doc(docid.id)
//                                               .collection('Post')
//                                               .doc('GatheringPost')
//                                               .collection('GatheringPostList')
//                                               .doc('GatheringJoinList')
//                                               .set({});

//                                           var docid8 = firestore
//                                               .collection('Club')
//                                               .doc(docid.id)
//                                               .collection('Post')
//                                               .doc('NomalPost')
//                                               .collection('NomalPostComment')
//                                               .doc('NomalComment')
//                                               .set({});

//                                           var docid9 = firestore
//                                               .collection('Club')
//                                               .doc(docid.id)
//                                               .collection('Post')
//                                               .doc('NoticePost')
//                                               .collection('NoticePostComment')
//                                               .doc('NoticeComment')
//                                               .set({});

//                                           var docid10 = firestore
//                                               .collection('Club')
//                                               .doc(docid.id)
//                                               .collection('Post')
//                                               .doc('GatheringPost')
//                                               .set({'GatheringPost': []});

//                                           var docid11 = firestore
//                                               .collection('Club')
//                                               .doc(docid.id)
//                                               .collection('ChatRoom')
//                                               .doc('ChatRoom')
//                                               .set({'ChatRoom': []});

//                                           //var doi

//                                           testlist.add(docid.id);

//                                           ///
//                                           /// 창설한 사용자의 클럽 가입 목록 추가
//                                           ///
//                                           firestore
//                                               .collection('Users')
//                                               .doc(user.uid)
//                                               .update({
//                                             "JoinClub":
//                                                 FieldValue.arrayUnion(testlist),
//                                           });

//                                           testlist.clear();

//                                           Navigator.pop(context);
//                                         }
//                                         } catch (e) {
//                                         print(e);
//                                       }
//                                     },
//                                     style: OutlinedButton.styleFrom(
//                                         primary: Colors.white,
//                                         backgroundColor: Color(0xffe9394f),
//                                         shape: RoundedRectangleBorder(
//                                             side: BorderSide(
//                                                 color: Color(0xffe9394f),
//                                                 width: 1,
//                                                 style: BorderStyle.solid),
//                                             borderRadius:
//                                                 BorderRadius.circular(50)),
//                                         elevation: 0),
//                                     child: Text(
//                                       "클럽 생성",
//                                       style: TextStyle(
//                                           fontFamily: 'GSANSB',
//                                           fontSize: 16,
//                                           color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ]),
//                     ))))));
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
