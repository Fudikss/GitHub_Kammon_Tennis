import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/Club_Settings.dart';
import 'package:snstennis/club/first_screen_1_0.dart';
import 'package:snstennis/home.dart';
import 'package:snstennis/instant/instant_main.dart';
import 'Market_Main_Page.dart';

class MarketItemPostWrite extends StatefulWidget {
  const MarketItemPostWrite({Key? key}) : super(key: key);

  @override
  _MarketItemPostWriteState createState() => _MarketItemPostWriteState();
}

class _MarketItemPostWriteState extends State<MarketItemPostWrite> {
  int _selectedNaviIndex = 3;

  String market_item_title = "";
  String market_item_intro = "";
  String market_item_price = "";
  String market_item_imgurl = "";

  String doc_image_path = "";

  List total = [];

  late UserAccountInfo user_account_info_;

  User user = FirebaseAuth.instance.currentUser!;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final formKey = new GlobalKey<FormState>();

  void validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      print(
          "success $market_item_title, $market_item_intro, $market_item_price");
    } else {
      print("failed");
    }
  }

  ///
  /// 이미지 기능 함수
  ///
  File? _imageFile = null;

  String fileName = "";

  List file_name = [];

  final picker = ImagePicker();

  List<XFile>? imageFileList = [];

  List image_url = [];

  Future pickImage() async {
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final List<XFile>? images = await picker.pickMultiImage(
        // maxHeight: 500,
        // maxWidth: 500,
        imageQuality: 20);

    if (images == null) {
      // Navigator.pop(this.context);
      return;
    } else if (images.isNotEmpty) {
      imageFileList!.addAll(images);
    }

    for (int i = 0; i < imageFileList!.length; i++) {
      total.add(imageFileList![i].name);
    }
    print("Image List Length:" + imageFileList!.length.toString());

    setState(() {
      // _imageFile = File(pickedFile!.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context, String doc_path) async {
    for (int i = 0; i < imageFileList!.length; i++) {
      fileName = basename(imageFileList![i].path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Market')
          .child('/${doc_path}')
          .child('/$fileName');

      final metadata = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': fileName});
      firebase_storage.UploadTask uploadTask;
      uploadTask = ref.putFile(io.File(imageFileList![i].path), metadata);

      firebase_storage.UploadTask task = await Future.value(uploadTask);
      Future.value(uploadTask)
          .then((value) => {print("Upload file path ${value.ref.fullPath}")})
          .onError((error, stackTrace) =>
              {print("Upload file path error ${error.toString()} ")});
    }
  }

  // Future pickImage() async {
  //   final pickedFile =
  //       await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
  //   //final List<XFile>? images = await picker.pickMultiImage();
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //     });
  //   } else {
  //     return;
  //   }
  // }

  // Future uploadImageToFirebase(BuildContext context, String doc_path) async {
  //   fileName = basename(_imageFile!.path);
  //   firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('Market')
  //       .child('/${doc_path}')
  //       .child('/$fileName');

  //   final metadata = firebase_storage.SettableMetadata(
  //       contentType: 'image/jpeg',
  //       customMetadata: {'picked-file-path': fileName});
  //   firebase_storage.UploadTask uploadTask;
  //   //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
  //   uploadTask = ref.putFile(io.File(_imageFile!.path), metadata);

  //   firebase_storage.UploadTask task = await Future.value(uploadTask);
  //   Future.value(uploadTask)
  //       .then((value) => {print("Upload file path ${value.ref.fullPath}")})
  //       .onError((error, stackTrace) =>
  //           {print("Upload file path error ${error.toString()} ")});
  // }

  @override
  Widget build(BuildContext context) {
    user_account_info_ = Provider.of<UserAccountInfo>(context, listen: false);

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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MarketMainPage(
                        item_id: user_account_info_.marketChatItem,
                      );
                    }));
                  },
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          iconTheme: IconThemeData(color: Colors.grey),
          title:
              // Image.asset(
              //   'assets/images/PNG/logo2.png',
              //   width: 110,
              // ),
              SvgPicture.asset(
            'assets/images/SVG/LOGO_KAMMON_small.svg',
            width: 110,
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  // validateAndSave();

                  try {
                    validateAndSave();

                    List sell_url = [];

                    String url = "";

                    var docid =
                        FirebaseFirestore.instance.collection("Market").doc();

                    if (imageFileList!.length != 0) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return SplashScreen(
                          prev_image_path: docid.toString(),
                          prev_market_item_title: market_item_title,
                          prev_market_item_intro: market_item_intro,
                          prev_market_item_price: market_item_price,
                          prev_imageFileList: imageFileList,
                          prev_account_nick_name: user_account_info_.nickname,
                          prev_profile_image: user_account_info_.profile_image,
                        );
                      }));
                    } else {
                      docid.set({
                        "Title": market_item_title,
                        "Intro": market_item_intro,
                        "Price": market_item_price,
                        "DateTime": formatDate(DateTime.now(),
                            [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                        "NickName": user_account_info_.nickname,
                        "UserUID": user.uid,
                        "ItemID": docid.id,
                        "profile_image": user_account_info_.profile_image,
                        "ImageUrl": "",
                        "readCount": 0,
                        "reportCount": 0
                      });

                      sell_url = [
                        {
                          "Title": market_item_title,
                          "Intro": market_item_intro,
                          "Price": market_item_price,
                          "DateTime": formatDate(DateTime.now(),
                              [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                          "NickName": user_account_info_.nickname,
                          "UserUID": user.uid,
                          "ItemID": docid.id,
                          "profile_image": user_account_info_.profile_image,
                          "ImageUrl": "",
                          "readCount": 0,
                          "reportCount": 0
                        }
                      ];

                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(user.uid)
                          .collection("BuyAndSell")
                          .doc("SellList")
                          .update(
                              {"SellItem": FieldValue.arrayUnion(sell_url)});

                      image_url.clear();

                      Navigator.of(context).pop();

                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (BuildContext context) {
                      //   return SplashScreen();
                      // }));
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                // onPressed: () async {
                //   // validateAndSave();

                //   try {
                //     validateAndSave();

                //     List sell_url = [];

                //     String url = "";

                //     var docid = FirebaseFirestore.instance.collection("Market").doc();

                //     if (_imageFile != null) {
                //       doc_image_path = docid.id;
                //       uploadImageToFirebase(context, doc_image_path);

                //       Timer(Duration(milliseconds: 5000), () async {
                //         final ref = firebase_storage.FirebaseStorage.instance
                //             .ref()
                //             .child("Market")
                //             .child(doc_image_path);

                //         // for (int i = 0; i < total.length; i++) {
                //         //   image_url.add(await ref.child(total[i]).getDownloadURL());
                //         // }

                //         url = await ref.child(fileName).getDownloadURL();

                //         // docid.set({
                //         //   "Title": market_item_title,
                //         //   "Intro": market_item_intro,
                //         //   "Price": market_item_price,
                //         //   "DateTime": formatDate(DateTime.now(),
                //         //       [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                //         //   "NickName": user_account_info_.nickname_,
                //         //   "UserUID": user.uid,
                //         //   "ItemID": docid.id,
                //         //   "ImageUrl": []
                //         // });

                //         // docid
                //         //     .update({"ImageUrl": FieldValue.arrayUnion(image_url)});

                //         docid.set({
                //           "Title": market_item_title,
                //           "Intro": market_item_intro,
                //           "Price": market_item_price,
                //           "DateTime": formatDate(DateTime.now(), [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                //           "NickName": user_account_info_.nickname,
                //           "UserUID": user.uid,
                //           "ItemID": docid.id,
                //           "ImageUrl": url,
                //           'readCount' : 0,
                //           'reportCount' : 0
                //         });

                //         // sell_url = [
                //         //   {
                //         //     "Title": market_item_title,
                //         //     "Intro": market_item_intro,
                //         //     "Price": market_item_price,
                //         //     "DateTime": formatDate(DateTime.now(),
                //         //         [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                //         //     "NickName": user_account_info_.nickname_,
                //         //     "UserUID": user.uid,
                //         //     "ItemID": docid.id,
                //         //     "ImageUrl": image_url
                //         //   }
                //         // ];

                //         sell_url = [
                //           {
                //             "Title": market_item_title,
                //             "Intro": market_item_intro,
                //             "Price": market_item_price,
                //             "DateTime": formatDate(DateTime.now(),
                //                 [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                //             "NickName": user_account_info_.nickname,
                //             "UserUID": user.uid,
                //             "ItemID": docid.id,
                //             "ImageUrl": url
                //           }
                //         ];

                //         FirebaseFirestore.instance
                //             .collection("Users")
                //             .doc(user.uid)
                //             .collection("BuyAndSell")
                //             .doc("SellList")
                //             .update(
                //                 {"SellItem": FieldValue.arrayUnion(sell_url)});

                //         image_url.clear();

                //         Navigator.of(context).pop();
                //       });
                //     } else {
                //       docid.set({
                //         "Title": market_item_title,
                //         "Intro": market_item_intro,
                //         "Price": market_item_price,
                //         "DateTime": formatDate(DateTime.now(),
                //             [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                //         "NickName": user_account_info_.nickname,
                //         "UserUID": user.uid,
                //         "ItemID": docid.id,
                //         "ImageUrl": "",
                //         'readCount' : 0,
                //         'reportCount' : 0
                //       });

                //       // sell_url = [
                //       //   {
                //       //     "Title": market_item_title,
                //       //     "Intro": market_item_intro,
                //       //     "Price": market_item_price,
                //       //     "DateTime": formatDate(DateTime.now(),
                //       //         [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                //       //     "NickName": user_account_info_.nickname_,
                //       //     "UserUID": user.uid,
                //       //     "ItemID": docid.id,
                //       //     "ImageUrl": image_url
                //       //   }
                //       // ];

                //       sell_url = [
                //         {
                //           "Title": market_item_title,
                //           "Intro": market_item_intro,
                //           "Price": market_item_price,
                //           "DateTime": formatDate(DateTime.now(),
                //               [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
                //           "NickName": user_account_info_.nickname,
                //           "UserUID": user.uid,
                //           "ItemID": docid.id,
                //           "ImageUrl": ""
                //         }
                //       ];

                //       FirebaseFirestore.instance
                //           .collection("Users")
                //           .doc(user.uid)
                //           .collection("BuyAndSell")
                //           .doc("SellList")
                //           .update({"SellItem": FieldValue.arrayUnion(sell_url)});

                //       image_url.clear();

                //       Navigator.of(context).pop();
                //     }
                //   } catch (e) {
                //     print(e);
                //   }
                // },
                child: Text(
                  "완료",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'GSANSB',
                      fontSize: 15.0),
                ))
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          child: TextFormField(
                            obscureText: false,
                            maxLines: null,
                            decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              hintText: '제목을 입력해주세요',
                              hintStyle: TextStyle(
                                  fontFamily: 'GSANSM',
                                  fontSize: 12,
                                  color: Color(0xff9f9f9f)),
                              // enabledBorder: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //       color: Colors.grey.shade300,
                              //       width: 2,
                              //     ),
                              //     borderRadius:
                              //         const BorderRadius.all(Radius.circular(5))),
                              // focusedBorder: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //       color: Colors.grey.shade300,
                              //       width: 2,
                              //     ),
                              //     borderRadius:
                              //         const BorderRadius.all(Radius.circular(5))),
                              //filled: true,
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'market_item_title' : null,
                            onSaved: (value) => market_item_title = value!,
                          ),
                        ),
                      ),
                      // Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            maxLines: null,
                            decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              hintText: '가격을 입력해주세요',
                              hintStyle: TextStyle(
                                  fontFamily: 'GSANSM',
                                  fontSize: 12,
                                  color: Color(0xff9f9f9f)),
                              // enabledBorder: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //       color: Colors.grey.shade300,
                              //       width: 2,
                              //     ),
                              //     borderRadius:
                              //         const BorderRadius.all(Radius.circular(5))),
                              // focusedBorder: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //       color: Colors.grey.shade300,
                              //       width: 2,
                              //     ),
                              //     borderRadius:
                              //         const BorderRadius.all(Radius.circular(5))),
                              //filled: true,
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'market_item_price' : null,
                            onSaved: (value) => market_item_price = value!,
                          ),
                        ),
                      ),
                      // Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          child: TextFormField(
                            obscureText: false,
                            maxLines: null,
                            decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              hintText: '내용을 입력해주세요',
                              hintStyle: TextStyle(
                                  fontFamily: 'GSANSM',
                                  fontSize: 12,
                                  color: Color(0xff9f9f9f)),
                              // enabledBorder: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //       color: Colors.grey.shade300,
                              //       width: 2,
                              //     ),
                              //     borderRadius:
                              //         const BorderRadius.all(Radius.circular(5))),
                              // focusedBorder: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //       color: Colors.grey.shade300,
                              //       width: 2,
                              //     ),
                              //     borderRadius:
                              //         const BorderRadius.all(Radius.circular(5))),
                              //filled: true,
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'market_item_intro' : null,
                            onSaved: (value) => market_item_intro = value!,
                          ),
                        ),
                      ),
                      // Divider(thickness: 1.5, height: 1.5, color: Colors.grey[200]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 300,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    height: 300,
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
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    height: 300,
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                        // child: imageFileList!.length != 0
                                        child: _imageFile != null
                                            ? Image.file(_imageFile!)
                                            // ? GridView.builder(
                                            //     itemCount: imageFileList!.length,
                                            //     gridDelegate:
                                            //         SliverGridDelegateWithFixedCrossAxisCount(
                                            //       crossAxisCount: 2,
                                            //     ),
                                            //     itemBuilder: (BuildContext context,
                                            //         int index) {
                                            //       return Image.file(
                                            //         File(imageFileList![index].path),
                                            //         fit: BoxFit.contain,
                                            //       );
                                            //     })
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
                                                          fontSize: 25.0,
                                                          fontFamily:
                                                              'GMARKETSANSM',
                                                        ),
                                                      )),
                                                ),
                                              )),
                                  )
                                ],
                              ),
                            ),
                          ]),
                      // TextButton(
                      //     onPressed: () async {
                      //       validateAndSave();

                      //       try {
                      //         var docid = FirebaseFirestore.instance
                      //             .collection("Market")
                      //             .doc();

                      //         docid.set({
                      //           "Title": market_item_title,
                      //           "Intro": market_item_intro,
                      //           "Price": market_item_price,
                      //           "DataTime": formatDate(
                      //               DateTime.now(), [yyyy, ".", mm, '.', dd]),
                      //           "NickName": user_account_info_.nickname_,
                      //           "UserUID": user.uid,
                      //           "ItemID": docid.id,
                      //           "ImageUrl": ""
                      //         });
                      //       } catch (e) {
                      //         print(e);
                      //       }
                      //     },
                      //     child: Text(
                      //       "완료",
                      //       style: TextStyle(
                      //           color: Colors.black,
                      //           fontFamily: 'GSANSB',
                      //           fontSize: 15.0),
                      //     ))
                    ],
                  ),
                ),
              ),
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
        title: Text("준비중 입니다!!"),
        content: Text("추후 추가 예정입니다!!"),
        actions: <Widget>[
          ElevatedButton(
            child: Text("OK"),
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
  final String prev_market_item_title;
  final String prev_market_item_intro;
  final String prev_market_item_price;
  final List<XFile>? prev_imageFileList;
  final String prev_account_nick_name;
  final String prev_profile_image;
  const SplashScreen(
      {Key? key,
      required this.prev_image_path,
      required this.prev_market_item_title,
      required this.prev_market_item_intro,
      required this.prev_market_item_price,
      required this.prev_imageFileList,
      required this.prev_account_nick_name,
      required this.prev_profile_image})
      : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState(
      prev_image_path,
      prev_market_item_title,
      prev_market_item_intro,
      prev_market_item_price,
      prev_imageFileList,
      prev_account_nick_name,
      prev_profile_image);
}

class _SplashScreenState extends State<SplashScreen> {
  String image_path = "";
  String market_item_title = "";
  String market_item_intro = "";
  String market_item_price = "";
  List<XFile>? imageFileList = [];
  String nick_name = "";
  String profile_image = "";

  UserAccountInfo userInfo = UserAccountInfo();

  User user = FirebaseAuth.instance.currentUser!;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String fileName = "";
  String doc_image_path = "";

  _SplashScreenState(
      this.image_path,
      this.market_item_title,
      this.market_item_intro,
      this.market_item_price,
      this.imageFileList,
      this.nick_name,
      this.profile_image);

  Future uploadImageToFirebase(BuildContext context, String doc_path) async {
    for (int i = 0; i < imageFileList!.length; i++) {
      fileName = basename(imageFileList![i].path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Market')
          .child('/${doc_path}')
          .child('/$fileName');

      final metadata = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': fileName});
      firebase_storage.UploadTask uploadTask;
      uploadTask = ref.putFile(io.File(imageFileList![i].path), metadata);

      firebase_storage.UploadTask task = await Future.value(uploadTask);
      Future.value(uploadTask)
          .then((value) => {print("Upload file path ${value.ref.fullPath}")})
          .onError((error, stackTrace) =>
              {print("Upload file path error ${error.toString()} ")});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List url_list = [];

    List sell_url = [];

    var docid = FirebaseFirestore.instance.collection("Market").doc();

    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("Market")
        .child(docid.id);
    uploadImageToFirebase(this.context, docid.id).then((value) async => {
          for (int i = 0; i < imageFileList!.length; i++)
            {
              url_list
                  .add(await ref.child(imageFileList![i].name).getDownloadURL())
            },
          docid.set({
            "Title": market_item_title,
            "Intro": market_item_intro,
            "Price": market_item_price,
            "DateTime": formatDate(
                DateTime.now(), [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
            "NickName": nick_name,
            "UserUID": user.uid,
            "ItemID": docid.id,
            "ImageUrl": url_list[0],
            "ImageUrlList": url_list,
            "profile_image": profile_image,
            "readCount": 0,
            "reportCount": 0
          }),
          sell_url = [
            {
              "Title": market_item_title,
              "Intro": market_item_intro,
              "Price": market_item_price,
              "DateTime": formatDate(
                  DateTime.now(), [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
              "NickName": nick_name,
              "UserUID": user.uid,
              "ItemID": docid.id,
              "profile_image": profile_image,
              "ImageUrl": url_list[0],
              "ImageUrlList": url_list,
              "readCount": 0,
              "reportCount": 0
            }
          ],
          FirebaseFirestore.instance
              .collection("Users")
              .doc(user.uid)
              .collection("BuyAndSell")
              .doc("SellList")
              .update({"SellItem": FieldValue.arrayUnion(sell_url)}),
          Navigator.of(this.context)..pop()..pop(),
        });

    Timer(Duration(milliseconds: 5000), () async {
      for (int i = 0; i < imageFileList!.length; i++) {
        url_list.add(await ref.child(imageFileList![i].name).getDownloadURL());
      }

      docid.set({
        "Title": market_item_title,
        "Intro": market_item_intro,
        "Price": market_item_price,
        "DateTime": formatDate(
            DateTime.now(), [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
        "NickName": nick_name,
        "UserUID": user.uid,
        "ItemID": docid.id,
        "ImageUrl": url_list[0],
        "ImageUrlList": url_list,
        "profile_image": profile_image,
        "readCount": 0,
        "reportCount": 0
      });

      sell_url = [
        {
          "Title": market_item_title,
          "Intro": market_item_intro,
          "Price": market_item_price,
          "DateTime": formatDate(
              DateTime.now(), [yyyy, ".", mm, '.', dd, "/", HH, ':', nn]),
          "NickName": nick_name,
          "UserUID": user.uid,
          "ItemID": docid.id,
          "profile_image": profile_image,
          "ImageUrl": url_list[0],
          "ImageUrlList": url_list,
          "readCount": 0,
          "reportCount": 0
        }
      ];

      FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .collection("BuyAndSell")
          .doc("SellList")
          .update({"SellItem": FieldValue.arrayUnion(sell_url)});

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
                  'assets/images/SVG/LOGO_horizontal.svg',
                  width: 150,
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
