import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snstennis/account/user_check.dart';
import 'package:snstennis/home.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({ Key? key }) : super(key: key);

  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  TextEditingController nickname = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? pickedFile;
  String imagePath = '';

  Future<File?> _selectImage() async {
    XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    return await _cropImage(selectedImage);
  }

  Future<File?> _cropImage(XFile? selectedImage) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: selectedImage!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '사진 영역 설정',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Theme.of(context).primaryColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: '사진 영역 설정',
        ));
    if( croppedFile != null) {
      setState(() {
        pickedFile = croppedFile;
      });
    }
    return croppedFile;
  }

  // Future<firebase_storage.UploadTask> _uploadProfileImage(String uid, File file) async {

  //   firebase_storage.Reference ref =  firebase_storage.FirebaseStorage.instance.ref().child('profile_images/$uid').child('profile.jpg');
  //   return ref.putFile(file);
  // }

  Future<firebase_storage.UploadTask> _uploadProfileImage(String uid, File file, String nickname_) async {
    firebase_storage.Reference ref =  firebase_storage.FirebaseStorage.instance.ref().child('profile_images/$uid').child('profile.jpg');
    firebase_storage.UploadTask task = ref.putFile(file);

    task.snapshotEvents.listen((event) async {
      if(event.bytesTransferred == event.totalBytes) {
        imagePath = await event.ref.getDownloadURL();
        final data = _updateProfile(uid, nickname_, imagePath);
        data.then((value) => {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Home())
          )
        });
      }
    });
    
    return task;
  }

  Future _updateProfile(String uid, String nickname_, String imagePath) async{
    return await FirebaseFirestore.instance.collection('Users').doc(uid).update({
      'nickname': nickname_,
      'profile_image' : imagePath
    });
  }

  Future<Map<dynamic, dynamic>> _getData(String userId) async {
    var data1;
    var data2;
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
    DocumentSnapshot snapshot1 = await ref.doc(userId).get();
    DocumentSnapshot snapshot2 = await ref.doc(userId).collection('TotalMarketChat').doc('MarketChat').get();
    
    data1 = snapshot1.data();
    data2 = snapshot2.data();

    var data = {
      'nickname' : data1['nickname'].toString(),
      'gender' : data1['gender'].toString(),
      'fcmToken' : data1['fcm_token'].toString(),
      'reg_data' : data1['reg_date'].toString(),
      'profile_image' : data1['profile_image'].toString(),
      'marketChatItem' : data2['ItemID'],
      'reportCount' : data1['reportCount']
    };
    print(data);

    // userAccount.logIn(
    //     userId,
    //     data['nickname'],
    //     data['gender'],
    //     data['fcm_token'].toString(),
    //     data['reg_date'].toString(),
    //     data['profile_image'].toString(),
    //     data['marketChatItem']
    //   );    

    return data;
  }

  Future _setUserProvider(String userId, UserAccountInfo _userAccount) async{
    print('set user data');
    final data = _getData(userId);
    data.then((value) => {
      _userAccount.logIn(
        userId, 
        value['nickname'],
        value['gender'],
        value['fcm_token'].toString(),
        value['reg_date'].toString(),
        value['profile_image'].toString(),
        value['marketChatItem'],
        value['reportCount']
      ),      
    });
  }

  Widget drawProfileImage(File pikedFile, String imagePath) {
    if( pickedFile == null) {
      return CircleAvatar(
        backgroundColor: Colors.white,
          radius: 120,
          backgroundImage: FileImage(File(pickedFile!.path))
      );
    } else {
      if(imagePath == '') {
        return ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child:
            SvgPicture.asset('assets/images/SVG/profile_pink.svg', width: 120,)
            //Image.network('https://www.edmundsgovtech.com/wp-content/uploads/2020/01/default-picture_0_0.png', fit: BoxFit.cover,),
        );
      } else {
        return CircleAvatar(
          backgroundColor: Colors.white,
            radius: 60,
            backgroundImage: NetworkImage(imagePath)
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    UserAccountInfo userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        title: 
          SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Home())
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child:Padding(padding: EdgeInsets.fromLTRB(20, 60, 20, 20), 
            child: Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      pickedFile == null ?
                        userAccount_.profile_image == '' ?
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child:
                            SvgPicture.asset('assets/images/SVG/profile_pink.svg', width: 120,)
                        ) : 
                        CircleAvatar(
                          backgroundColor: Colors.white,
                            radius: 60,
                            backgroundImage: NetworkImage(userAccount_.profile_image)
                        )
                      : CircleAvatar(
                        backgroundColor: Colors.white,
                          radius: 60,
                          backgroundImage: FileImage(File(pickedFile!.path))
                      ),
                      //drawProfileImage(pickedFile!, userAccount_.profile_image),
                      // userAccount_.profile_image == '' ?
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(40),
                      //   child:
                      //     SvgPicture.asset('assets/images/SVG/profile_pink.svg', width: 120,)
                      //     //Image.network('https://www.edmundsgovtech.com/wp-content/uploads/2020/01/default-picture_0_0.png', fit: BoxFit.cover,),
                      // ) : pickedFile == null ?
                      // CircleAvatar(
                      //   backgroundColor: Colors.white,
                      //     radius: 120,
                      //     backgroundImage: NetworkImage(userAccount_.profile_image)
                      // ): 
                      // CircleAvatar(
                      //   backgroundColor: Colors.white,
                      //     radius: 120,
                      //     backgroundImage: FileImage(File(pickedFile!.path))
                      // ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child:IconButton(
                            onPressed: () {
                              _selectImage();
                            },
                            icon: Icon(Icons.camera_alt),
                            color: Theme.of(context).primaryColorLight,
                            iconSize: 40,
                          )
                        )
                      )
                    ],
                  ),
                  SizedBox(height: 30,),
                  Container(
                    width: MediaQuery.of(context).size.width, 
                    //height: 30,
                    child: 
                      Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextFormField(
                        controller: nickname,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: userAccount_.nickname,
                          hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey[400]),
                        )                          
                      ),
                    )
                  ),
                  SizedBox(height: 30,),
                  Container(
                    width: MediaQuery.of(context).size.width, 
                    //height: 30,
                    child: 
                      Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child:
                        OutlinedButton(
                          onPressed: () {
                            String inputNickname;
                            nickname.text == '' ? inputNickname = userAccount_.nickname : inputNickname = nickname.text;
                            
                            if( pickedFile == null) {
                              final profile = _updateProfile(userAccount_.uid, inputNickname, userAccount_.profile_image);
                              profile.then((value) => {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => UserCheck())
                                  )
                              });
                            } else {
                              final uploading = _uploadProfileImage(userAccount_.uid, pickedFile!, inputNickname);
                            }                            
                          },          
                          style: OutlinedButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.blue,
                                width: 1,
                                style: BorderStyle.solid
                              ), borderRadius: BorderRadius.circular(50)
                            ),
                            elevation: 1
                          ),                    
                          child: 
                            Text('수정완료', 
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'GSANSB'
                              ),
                            ),
                        ),
                    )
                  ),
                  SizedBox(height: 20,),
                  Container(
                    child: Text('앱을 종료한 후 재실행하면 적용이 완료됩니다.', 
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'GSANSB',
                        color: Colors.grey.shade600
                      ),
                    ),
                  )
                ],
              )
            )
          )
        )
      ),
    );
  }
}