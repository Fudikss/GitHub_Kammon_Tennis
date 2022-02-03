import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/home.dart';

class AddMemberInfo extends StatefulWidget {
  const AddMemberInfo({ Key? key }) : super(key: key);

  @override
  _AddMemberInfoState createState() => _AddMemberInfoState();
}

class _AddMemberInfoState extends State<AddMemberInfo> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  User user = FirebaseAuth.instance.currentUser!;

  TextEditingController email = TextEditingController();
  TextEditingController passwd = TextEditingController();
  TextEditingController confirm_passwd = TextEditingController();
  TextEditingController nickname = TextEditingController();

  var gender_value_ = "남성";

  late FocusNode currentFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  void initState() {
    super.initState();
    currentFocus = FocusNode();
  }

  String _checkEmail(FocusNode focusNode, String value) {
    if( value.isEmpty) {
      focusNode.requestFocus();
      return 'Email을 입력하세요.';
    } else {      
      RegExp regExp = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if(!regExp.hasMatch(value)) {
        focusNode.requestFocus();	//포커스를 해당 textformfield에 맞춘다.
        return '잘못된 이메일 형식입니다.';
      }
      else{
        return '';
      }
    }
  }

  String _checkPassword(FocusNode focusNode, String value) {
    if( value.isEmpty) {
      focusNode.requestFocus();
      return 'Password를 입력하세요.';
    } else {
      int length = value.length;
      if(length != 6 ) {
        return '6자리 비밀번호를 입력하세요.';
      }
      return '';
    }
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

  void _join() async {
    String _gender = gender_value_;
    String _nick = nickname.text;
    bool isMemberNick = false;
    List<String> _joinClub = [];
    List<String> _joinMatchList = [];

    final QuerySnapshot result = await FirebaseFirestore.instance.collection('Users').get();
    final List<DocumentSnapshot> documents = result.docs;
    
    if(_nick == "") {
      showDialog(
        context: context, 
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('닉네임을 입력해주세요.'),
            actions: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                }, 
                child: 
                  Text('확인')
              )  
            ],
          );                                
        } 
      );
    }
    else {
      documents.forEach((data) {
        if( _nick == data['nickname']) {
          isMemberNick = true;
        }
      });

      if(isMemberNick == true) {
        showDialog(
          context: context, 
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('이미 사용 중인 닉네임 입니다.'),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  }, 
                  child: 
                    Text('확인')
                )  
              ],
            );                                
          } 
        );
      } else {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        var docId = firestore.collection("Users").doc(user.uid);
        docId.set({
          "nickname": _nick,
          "gender": _gender,
          "fcm_token": '',
          'match_win': 0,
          'match_draw': 0,
          'match_loss': 0,
          'reg_date': Timestamp.now(),
          'JoinClub' : _joinClub,
          'join_match_list' : _joinMatchList,
          'profile_image' : '',
          'reportCount' : 0
        });

        var docMarketChat = firestore.collection("Users").doc(user.uid).collection('TotalMarketChat').doc('MarketChat');
        docMarketChat.set({ 'ItemID' : []});

        var docMarketChat2 = firestore.collection("Users").doc(user.uid).collection('BuyAndSell').doc('BuyList');
        docMarketChat2.set({ 'BuyItem' : []});

        var docMarketChat3 = firestore.collection("Users").doc(user.uid).collection('BuyAndSell').doc('SellList');
        docMarketChat3.set({ 'SellItem' : []});

        var docMarketReport = firestore.collection("Users").doc(user.uid).collection('Report').doc('ReportList');
        docMarketReport.set({ 'ReportItem' : []});

        User? curUser = FirebaseAuth.instance.currentUser;
        UserAccountInfo userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
        _setUserProvider(curUser!.uid, userAccount_);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Home(),
          ),
        );
      }
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
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
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: Color(0xFFFFFFFF),
              child: Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
                    SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 140,),
                    SizedBox(height: 30,), 
                    Text('추가 정보 입력', style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[600]),),
                    SizedBox(height: 20,),
                    Text('닉네임', style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[600]),),
                    SizedBox(height: 10,),
                    Container(
                      height: 30,
                      child:
                        TextFormField(
                          controller: nickname,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: '닉네임을 입력해주세요.',
                            hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey[400]),
                          )                          
                        ),
                    ), 
                    SizedBox(height: 20,),   
                    Text('성별', style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[600]),),
                    SizedBox(height: 10,),
                    Container(
                      height: 30,
                      child:
                        DropdownButton<String>(
                          isExpanded: true,
                          value: gender_value_,
                          items: ["남성", "여성"].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,                  
                              child: Text(value, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[400]),),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              gender_value_ = newValue!;
                              FocusScope.of(context).requestFocus(currentFocus);
                            });
                          },
                        ),
                    ),
                    SizedBox(height: 50,),
                    Container(
                      //color: Colors.amberAccent,
                      width: MediaQuery.of(context).size.width, 
                      height: 30,
                      child: 
                      Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child:
                          OutlinedButton(
                            focusNode: currentFocus,
                            onPressed: () {
                              _formKey.currentState!.validate();
                              _join();
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
                              Text('회원가입', 
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'GSANSB'
                                ),
                              ),
                          ),
                      )
                    ) 
                  ],
                )
              )
            ),
          )
        )
      )
    );
  }
}


//1.0.0+7
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/home.dart';

// class AddMemberInfo extends StatefulWidget {
//   const AddMemberInfo({ Key? key }) : super(key: key);

//   @override
//   _AddMemberInfoState createState() => _AddMemberInfoState();
// }

// class _AddMemberInfoState extends State<AddMemberInfo> {
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   User user = FirebaseAuth.instance.currentUser!;

//   TextEditingController email = TextEditingController();
//   TextEditingController passwd = TextEditingController();
//   TextEditingController confirm_passwd = TextEditingController();
//   TextEditingController nickname = TextEditingController();

//   var gender_value_ = "남성";

//   late FocusNode currentFocus = FocusNode();
//   FocusNode emailFocus = FocusNode();
//   FocusNode passwordFocus = FocusNode();

//   void initState() {
//     super.initState();
//     currentFocus = FocusNode();
//   }

//   String _checkEmail(FocusNode focusNode, String value) {
//     if( value.isEmpty) {
//       focusNode.requestFocus();
//       return 'Email을 입력하세요.';
//     } else {      
//       RegExp regExp = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
//       if(!regExp.hasMatch(value)) {
//         focusNode.requestFocus();	//포커스를 해당 textformfield에 맞춘다.
//         return '잘못된 이메일 형식입니다.';
//       }
//       else{
//         return '';
//       }
//     }
//   }

//   String _checkPassword(FocusNode focusNode, String value) {
//     if( value.isEmpty) {
//       focusNode.requestFocus();
//       return 'Password를 입력하세요.';
//     } else {
//       int length = value.length;
//       if(length != 6 ) {
//         return '6자리 비밀번호를 입력하세요.';
//       }
//       return '';
//     }
//   }

//   Future<Map<dynamic, dynamic>> _getData(String userId) async {
//     var data1;
//     var data2;
//     CollectionReference ref = FirebaseFirestore.instance.collection('Users');
//     DocumentSnapshot snapshot1 = await ref.doc(userId).get();
//     DocumentSnapshot snapshot2 = await ref.doc(userId).collection('TotalMarketChat').doc('MarketChat').get();
    
//     data1 = snapshot1.data();
//     data2 = snapshot2.data();

//     var data = {
//       'nickname' : data1['nickname'].toString(),
//       'gender' : data1['gender'].toString(),
//       'fcmToken' : data1['fcm_token'].toString(),
//       'reg_data' : data1['reg_date'].toString(),
//       'profile_image' : data1['profile_image'].toString(),
//       'marketChatItem' : data2['ItemID'],
//       'reportCount' : data1['reportCount']
//     };
//     print(data);
//     return data;
//   }

//   Future _setUserProvider(String userId, UserAccountInfo _userAccount) async{
//     print('set user data');
//     final data = _getData(userId);
//     data.then((value) => {
//       _userAccount.logIn(
//         userId, 
//         value['nickname'],
//         value['gender'],
//         value['fcm_token'].toString(),
//         value['reg_date'].toString(),
//         value['profile_image'].toString(),
//         value['marketChatItem'],
//         value['reportCount']
//       ),      
//     });
//   }

//   void _join() async {
//     String _gender = gender_value_;
//     String _nick = nickname.text;
//     bool isMemberNick = false;
//     List<String> _joinClub = [];
//     List<String> _joinMatchList = [];

//     final QuerySnapshot result = await FirebaseFirestore.instance.collection('Users').get();
//     final List<DocumentSnapshot> documents = result.docs;
    
//     documents.forEach((data) {
//       if( _nick == data['nickname']) {
//         isMemberNick = true;
//       }
//     });

//     if(isMemberNick == true) {
//       showDialog(
//         context: context, 
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('이미 사용 중인 닉네임 입니다.'),
//             actions: [
//               OutlinedButton(
//                 onPressed: () {
//                   Navigator.pop(context, true);
//                 }, 
//                 child: 
//                   Text('확인')
//               )  
//             ],
//           );                                
//         } 
//       );
//     } else {
//       FirebaseFirestore firestore = FirebaseFirestore.instance;
//       var docId = firestore.collection("Users").doc(user.uid);
//       docId.set({
//         "nickname": _nick,
//         "gender": _gender,
//         "fcm_token": '',
//         'match_win': 0,
//         'match_draw': 0,
//         'match_loss': 0,
//         'reg_date': Timestamp.now(),
//         'JoinClub' : _joinClub,
//         'join_match_list' : _joinMatchList,
//         'profile_image' : ''
//       });

//       var docMarketChat = firestore.collection("Users").doc(user.uid).collection('TotalMarketChat').doc('MarketChat');
//       docMarketChat.set({ 'ItemID' : []});

//       var docMarketChat2 = firestore.collection("Users").doc(user.uid).collection('BuyAndSell').doc('BuyList');
//       docMarketChat2.set({ 'BuyItem' : []});

//       var docMarketChat3 = firestore.collection("Users").doc(user.uid).collection('BuyAndSell').doc('SellList');
//       docMarketChat3.set({ 'SellItem' : []});

//       var docMarketReport = firestore.collection("Users").doc(user.uid).collection('Report').doc('ReportList');
//       docMarketReport.set({ 'ReportItem' : []});

//       User? curUser = FirebaseAuth.instance.currentUser;
//       UserAccountInfo userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
//       _setUserProvider(curUser!.uid, userAccount_);

//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (BuildContext context) => Home(),
//         ),
//       );
//     }
//   }

//   // void _join() async{
//   //   String _email = email.text;
//   //   String _pwd1 = passwd.text;
//   //   String _pwd2 = confirm_passwd.text;
//   //   String _gender = gender_value_;
//   //   String _nick = nickname.text;
//   //   List<String> _joinClub = [];
//   //   List<String> _joinMatchList = [];

//   //   if (_pwd1 != _pwd2) {
//   //     //password_alert();
//   //   } else if(email.text != '' && passwd.text != '' && nickname.text != '') {
//   //     bool isMemberNick = false;
//   //     bool isMemberEmail = false;
//   //     final QuerySnapshot result = await FirebaseFirestore.instance.collection('Users').get();
//   //     final List<DocumentSnapshot> documents = result.docs;
      
//   //     documents.forEach((data) {
//   //       if( _nick == data['nickname']) {
//   //         isMemberNick = true;
//   //       }
//   //       if( _email == data['id']) {
//   //         isMemberEmail = true;
//   //       }
//   //     });

//   //     if(isMemberNick == true) {
//   //       showDialog(
//   //         context: context, 
//   //         builder: (BuildContext context) {
//   //           return AlertDialog(
//   //             title: Text('이미 사용 중인 닉네임 입니다.'),
//   //             actions: [
//   //               OutlinedButton(
//   //                 onPressed: () {
//   //                   Navigator.pop(context, true);
//   //                 }, 
//   //                 child: 
//   //                   Text('확인')
//   //               )  
//   //             ],
//   //           );                                
//   //         } 
//   //       );
//   //     } else if( isMemberEmail == true) {
//   //       showDialog(
//   //         context: context, 
//   //         builder: (BuildContext context) {
//   //           return AlertDialog(
//   //             title: Text('이미 가입된 회원 입니다.'),
//   //             actions: [
//   //               OutlinedButton(
//   //                 onPressed: () {
//   //                   Navigator.pop(context, true);
//   //                 }, 
//   //                 child: 
//   //                   Text('확인')
//   //               )  
//   //             ],
//   //           );                                
//   //         } 
//   //       );
//   //     } 
//   //     else if( isMemberEmail == true && isMemberNick == true) {
//   //       showDialog(
//   //         context: context, 
//   //         builder: (BuildContext context) {
//   //           return AlertDialog(
//   //             title: Text('이미 가입된 회원입니다.\n이미 사용 중인 닉네임 입니다.'),
//   //             actions: [
//   //               OutlinedButton(
//   //                 onPressed: () {
//   //                   Navigator.pop(context, true);
//   //                 }, 
//   //                 child: 
//   //                   Text('확인')
//   //               )  
//   //             ],
//   //           );                                
//   //         } 
//   //       );
//   //     } else if(isMemberEmail == false && isMemberNick == false) {
//   //       await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _pwd1);
//   //       FirebaseFirestore firestore = FirebaseFirestore.instance;      

//   //       firestore.collection("Users").doc(user.uid).set({
//   //         "id": _email,
//   //         "gender": _gender,
//   //         "nickname": _nick,
//   //         "dev_token": '',
//   //         'match_win': 0,
//   //         'match_draw': 0,
//   //         'match_loss': 0,
//   //         'reg_date': Timestamp.now(),
//   //         'JoinClub' : _joinClub,
//   //         'join_match_list' : _joinMatchList
//   //       });

//   //       // Navigator.of(context).push(
//   //       //   MaterialPageRoute(
//   //       //     builder: (BuildContext context) => EmailVerify(),
//   //       //   ),
//   //       // );
//   //     }
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFFFFFF),
//         iconTheme: IconThemeData(color: Colors.grey),
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
//       body: Form(
//         key: _formKey,
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Container(
//               color: Color(0xFFFFFFFF),
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 30,),
//                     SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 140,),
//                     SizedBox(height: 30,), 
//                     Text('추가 정보 입력', style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[600]),),
//                     // Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
//                     //   child: Text('아이디', style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[600]),),
//                     // ),
//                     // Padding(
//                     //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                     //   child: 
//                     //     TextFormField(
//                     //       controller: email,
//                     //       keyboardType: TextInputType.emailAddress,
//                     //       focusNode: emailFocus,
//                     //       validator: (value) => _checkEmail(emailFocus, value!),
//                     //       decoration: InputDecoration(
//                     //         hintText: 'ID로 사용할 Email을 입력하세요.',
//                     //         hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey[400]),
//                     //       )
//                     //     ),
//                     // ),
//                     // SizedBox(height: 20,),
//                     // Text('비밀번호', style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[600]),),
//                     // Padding(
//                     //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                     //   child: 
//                     //     TextFormField(
//                     //       controller: passwd,
//                     //       keyboardType: TextInputType.number,
//                     //       focusNode: passwordFocus,
//                     //       validator: (value) => _checkPassword(emailFocus, value!),
//                     //       decoration: InputDecoration(
//                     //         hintText: '숫자 6자리의 비밀번호를 설정해주세요.',
//                     //         hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey[400]),
//                     //       )  
//                     //     ),
//                     // ),
//                     // SizedBox(height: 20,),
//                     // Text('비밀번호 확인', style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[600]),),
//                     // SizedBox(height: 10,),
//                     // Container(
//                     //   height: 30,
//                     //   child:
//                     //     TextFormField(
//                     //       controller: confirm_passwd,
//                     //       keyboardType: TextInputType.number,
//                     //       decoration: InputDecoration(
//                     //         hintText: '비밀번호를 다시 한 번 입력해주세요.',
//                     //         hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey[400]),
//                     //       )       
//                     //     ),
//                     // ),
//                     SizedBox(height: 20,),
//                     Text('닉네임', style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[600]),),
//                     SizedBox(height: 10,),
//                     Container(
//                       height: 30,
//                       child:
//                         TextFormField(
//                           controller: nickname,
//                           keyboardType: TextInputType.text,
//                           decoration: InputDecoration(
//                             hintText: '닉네임을 입력해주세요.',
//                             hintStyle: TextStyle(fontSize: 14.0, color: Colors.grey[400]),
//                           )                          
//                         ),
//                     ), 
//                     SizedBox(height: 20,),   
//                     Text('성별', style: TextStyle(fontFamily: 'GSANSM', color: Colors.grey[600]),),
//                     SizedBox(height: 10,),
//                     Container(
//                       height: 30,
//                       child:
//                         DropdownButton<String>(
//                           isExpanded: true,
//                           value: gender_value_,
//                           items: ["남성", "여성"].map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,                  
//                               child: Text(value, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[400]),),
//                             );
//                           }).toList(),
//                           onChanged: (String? newValue) {
//                             setState(() {
//                               gender_value_ = newValue!;
//                               FocusScope.of(context).requestFocus(currentFocus);
//                             });
//                           },
//                         ),
//                     ),
//                     SizedBox(height: 50,),
//                     Container(
//                       //color: Colors.amberAccent,
//                       width: MediaQuery.of(context).size.width, 
//                       height: 30,
//                       child: 
//                       Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//                         child:
//                           OutlinedButton(
//                             focusNode: currentFocus,
//                             onPressed: () {
//                               _formKey.currentState!.validate();
//                               _join();
//                             },          
//                             style: OutlinedButton.styleFrom(
//                               primary: Colors.white,
//                               backgroundColor: Theme.of(context).primaryColor,
//                               shape: RoundedRectangleBorder(
//                                 side: BorderSide(
//                                   color: Colors.blue,
//                                   width: 1,
//                                   style: BorderStyle.solid
//                                 ), borderRadius: BorderRadius.circular(50)
//                               ),
//                               elevation: 1
//                             ),                    
//                             child: 
//                               Text('회원가입', 
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontFamily: 'GSANSB'
//                                 ),
//                               ),
//                           ),
//                       )
//                     ) 
//                   ],
//                 )
//               )
//             ),
//           )
//         )
//       )
//     );
//   }
// }