import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/instant/instant_view.dart';

class InstantCreate extends StatefulWidget {
  const InstantCreate({ Key? key }) : super(key: key);

  @override
  _InstantCreateState createState() => _InstantCreateState();
}

class _InstantCreateState extends State<InstantCreate> {
  late UserAccountInfo userAccount_;
  String itemId = '';
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
  

  var _selectedValue = '지역선택';

  TextEditingController instantName = TextEditingController();
  TextEditingController instantInfo = TextEditingController();

  Future _createInstant() async {
    Map<String, dynamic> master = {
      'uid': userAccount_.uid,
      'nickname': userAccount_.nickname,
      'fcm_token' : userAccount_.fcmToken,
      'profile_image' : userAccount_.profile_image
    };

    var docid = FirebaseFirestore.instance.collection('Instant').doc();
    docid.set({
      'state' : true,
      'title' : instantName.text,
      'area' : _selectedValue,
      'info' : instantInfo.text,
      'master' : master,
      'regDate' : formatDate(DateTime.now(), [yyyy, '-', m, '-', dd]),
      'timeStamp' : Timestamp.now()
    } 
    );

    var docidComment = FirebaseFirestore.instance.collection('Instant').doc(docid.id).collection('InstantComment').doc('CommentList');
    docidComment.set({});

    itemId = docid.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
    return WillPopScope(
      onWillPop: () async{
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("글 작성을 취소하시겠습니까?", style: TextStyle(fontFamily: 'GSANSM', fontSize: 16, color: Colors.grey[700]),),
              actions: <Widget>[
                OutlinedButton(
                  child: Text("계속 작성하기", style: TextStyle(fontFamily: 'GSANSM', fontSize: 14),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                OutlinedButton(
                  child: Text("취소하기", style: TextStyle(fontFamily: 'GSANSM', fontSize: 14),),
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          iconTheme: IconThemeData(color: Colors.grey),
          leading: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text("글 작성을 취소하시겠습니까?", style: TextStyle(fontFamily: 'GSANSM', fontSize: 16, color: Colors.grey[700]),),
                    actions: <Widget>[
                      OutlinedButton(
                        child: Text("계속 작성하기", style: TextStyle(fontFamily: 'GSANSM', fontSize: 14),),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      OutlinedButton(
                        child: Text("취소하기", style: TextStyle(fontFamily: 'GSANSM', fontSize: 14),),
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
          automaticallyImplyLeading: false,
          title: 
            SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  //color: Colors.amberAccent,
                  child: Column(
                    children: [
                      SizedBox(height: 60,),
                      Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Text('벙개 등록', style: Theme.of(context).textTheme.headline2),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                height: 30,
                                  child:
                                    DropdownButton(
                                      onTap: () {
                                        FocusScopeNode currentFocus = FocusScope.of(context);
                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }
                                      },
                                      isExpanded: true,
                                      value: _selectedValue,
                                      items: area.map(
                                        (value) {
                                          return DropdownMenuItem(
                                            value: value,
                                            child: Text('   ' + value, style: TextStyle(color: Colors.grey[600], fontFamily: 'GSANSM', fontSize: 14)),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedValue = value.toString();
                                        });
                                        
                                      },
                                    ),
                              )
                            )
                          ],
                        )
                      ),
                      SizedBox(height: 30,),
                      Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: TextFormField(
                          controller: instantName,
                          decoration: InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                            hintText: '제목 입력...',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(10))                               
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 2,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: SizedBox(
                          height: 250,
                          child: TextFormField(maxLines: 20,
                            controller: instantInfo,
                            decoration: InputDecoration(
                              contentPadding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                              hintText: '내용 입력...',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(10))                 
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 2,
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(10))
                              ),
                            ),
                          ),
                        )
                      ),
                      SizedBox(height: 20,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                          child: OutlinedButton(
                            onPressed: () {
                              if(instantName.text == '') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("제목을 입력해주세요."),
                                      actions: <Widget>[
                                        OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('확인'))
                                      ],
                                    );
                                  });
                              } else {
                                if(_selectedValue == '지역선택') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("지역을 선택해주세요."),
                                        actions: <Widget>[
                                          OutlinedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('확인'))
                                        ],
                                      );
                                    });
                                } else {
                                  final data = _createInstant();
                                    data.then((value) => {
                                      Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => InstantView(itemId: itemId, master_uid: userAccount_.uid,),
                                      ),)
                                    });
                                }
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.blue,
                                width: 1,
                                style: BorderStyle.solid
                              ), borderRadius: BorderRadius.circular(50)),
                              elevation: 3
                            ),
                            child: Text('새 벙개 만들기', 
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'GSANSM',
                                //fontWeight: FontWeight.w700
                              ),
                            ),
                          )
                        )
                      )
                    ],
                  )
                )
              )
            )
          ),
        )
      ),
    );
  }
}








//1.0.0.+7
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:date_format/date_format.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/instant/instant_view.dart';

// class InstantCreate extends StatefulWidget {
//   const InstantCreate({ Key? key }) : super(key: key);

//   @override
//   _InstantCreateState createState() => _InstantCreateState();
// }

// class _InstantCreateState extends State<InstantCreate> {
//   late UserAccountInfo userAccount_;
//   String itemId = '';
//   final area = [
//     "지역선택",
//     "강원도",
//     "경기도",
//     "경상남도",
//     "경상북도",
//     "광주광역시",
//     "대구광역시",
//     "대전광역시",
//     "부산광역시",
//     "서울",
//     "울산광역시",
//     "인천광역시",
//     "전라남도",
//     "전라북도",
//     "제주도",
//     "충청남도",
//     "충청북도",
//   ];

//   var _selectedValue = '지역선택';

//   TextEditingController instantName = TextEditingController();
//   TextEditingController instantInfo = TextEditingController();

//   Future _createInstant() async {
//     Map<String, dynamic> master = {
//       'uid': userAccount_.uid,
//       'nickname': userAccount_.nickname,
//       'fcm_token' : userAccount_.fcmToken,
//       'profile_image' : userAccount_.profile_image
//     };

//     var docid = FirebaseFirestore.instance.collection('Instant').doc();
//     docid.set({
//       'state' : true,
//       'title' : instantName.text,
//       'area' : _selectedValue,
//       'info' : instantInfo.text,
//       'master' : master,
//       'regDate' : formatDate(DateTime.now(), [yyyy, '-', m, '-', dd]),
//       'timeStamp' : Timestamp.now()
//     } 
//     );

//     var docidComment = FirebaseFirestore.instance.collection('Instant').doc(docid.id).collection('InstantComment').doc('CommentList');
//     docidComment.set({});

//     itemId = docid.id.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
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
//         automaticallyImplyLeading: false,
//         title: 
//           SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
//         actions: [],
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//               child: Container(
//                 //color: Colors.amberAccent,
//                 child: Column(
//                   children: [
//                     SizedBox(height: 60,),
//                     Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             flex: 7,
//                             child: Text('벙개 등록', style: Theme.of(context).textTheme.headline2),
//                           ),
//                           Expanded(
//                             flex: 5,
//                             child: Container(
//                               height: 30,
//                                 child:
//                                   DropdownButton(
//                                     isExpanded: true,
//                                     value: _selectedValue,
//                                     items: area.map(
//                                       (value) {
//                                         return DropdownMenuItem(
//                                           value: value,
//                                           child: Text('   ' + value, style: TextStyle(color: Colors.grey[600], fontFamily: 'GSANSM', fontSize: 14)),
//                                         );
//                                       },
//                                     ).toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         _selectedValue = value.toString();
//                                       });
//                                     },
//                                   ),
//                             )
//                           )
//                         ],
//                       )
//                     ),
//                     SizedBox(height: 30,),
//                     Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                       child: TextFormField(
//                         controller: instantName,
//                         decoration: InputDecoration(
//                           contentPadding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
//                           hintText: '제목 입력...',
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Colors.grey.shade400,
//                               width: 1,
//                             ),
//                             borderRadius: const BorderRadius.all(Radius.circular(10))                               
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: Colors.grey.shade400,
//                               width: 2,
//                             ),
//                             borderRadius: const BorderRadius.all(Radius.circular(10))
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20,),
//                     Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                       child: SizedBox(
//                         height: 250,
//                         child: TextFormField(maxLines: 20,
//                           controller: instantInfo,
//                           decoration: InputDecoration(
//                             contentPadding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
//                             hintText: '내용 입력...',
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors.grey.shade400,
//                                 width: 1,
//                               ),
//                               borderRadius: const BorderRadius.all(Radius.circular(10))                 
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors.grey.shade400,
//                                 width: 2,
//                               ),
//                               borderRadius: const BorderRadius.all(Radius.circular(10))
//                             ),
//                           ),
//                         ),
//                       )
//                     ),
//                     SizedBox(height: 20,),
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       child: Padding(padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
//                         child: OutlinedButton(
//                           onPressed: () {
//                             if(instantName.text == '') {
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return AlertDialog(
//                                     title: Text("제목을 입력해주세요."),
//                                     actions: <Widget>[
//                                       OutlinedButton(
//                                           onPressed: () {
//                                             Navigator.of(context).pop();
//                                           },
//                                           child: Text('확인'))
//                                     ],
//                                   );
//                                 });
//                             } else {
//                               if(_selectedValue == '지역선택') {
//                                 showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return AlertDialog(
//                                       title: Text("지역을 선택해주세요."),
//                                       actions: <Widget>[
//                                         OutlinedButton(
//                                             onPressed: () {
//                                               Navigator.of(context).pop();
//                                             },
//                                             child: Text('확인'))
//                                       ],
//                                     );
//                                   });
//                               } else {
//                                 final data = _createInstant();
//                                   data.then((value) => {
//                                     Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder: (BuildContext context) => InstantView(itemId: itemId,),
//                                     ),)
//                                   });
//                               }
//                             }




//                             // if(instantName.text != '' || instantName.text != '') {
//                             //   final data = _createInstant();
//                             //   data.then((value) => {
//                             //     Navigator.of(context).push(
//                             //     MaterialPageRoute(
//                             //       builder: (BuildContext context) => InstantView(itemId: itemId,),
//                             //     ),)
//                             //   });
//                             // } else {
//                             //   showDialog(
//                             //     context: context,
//                             //     builder: (BuildContext context) {
//                             //       return AlertDialog(
//                             //         title: Text("제목을 입력해주세요."),
//                             //         actions: <Widget>[
//                             //           OutlinedButton(
//                             //               onPressed: () {
//                             //                 Navigator.of(context).pop();
//                             //               },
//                             //               child: Text('확인'))
//                             //         ],
//                             //       );
//                             //     });
//                             // }
//                           },
//                           style: OutlinedButton.styleFrom(
//                             primary: Colors.white,
//                             backgroundColor: Theme.of(context).primaryColor,
//                             shape: RoundedRectangleBorder(side: BorderSide(
//                               color: Colors.blue,
//                               width: 1,
//                               style: BorderStyle.solid
//                             ), borderRadius: BorderRadius.circular(50)),
//                             elevation: 3
//                           ),
//                           child: Text('새 벙개 만들기', 
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontFamily: 'GSANSM',
//                               //fontWeight: FontWeight.w700
//                             ),
//                           ),
//                         )
//                       )
//                     )
//                   ],
//                 )
//               )
//             )
//           )
//         ),
//       )
//     );
//   }
// }