import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/Club_Settings.dart';
import 'package:snstennis/instant/instant_main.dart';

class InstantView extends StatefulWidget {
  const InstantView({ Key? key, required this.itemId, required this.master_uid }) : super(key: key);
  final String itemId;
  final String master_uid;
  @override
  _InstantViewState createState() => _InstantViewState(itemId, master_uid);
}

class _InstantViewState extends State<InstantView> {
  _InstantViewState(this.itemId, this.master_uid);
  late UserAccountInfo userAccount_;
  late ScrollController scrollController;
  late ScrollController commentController;
  late ScrollController pageScrollController;
  final String itemId;
  TextEditingController comment = TextEditingController();
  bool bottomFlag = false;
  Map postData = Map();
  final String master_uid;
  double chatScrollposition = 0.0;
  
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    commentController = ScrollController();

    commentController.addListener(() {
      print('offset = ${commentController.offset}');
    });
    
    pageScrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );

    // Timer(Duration(milliseconds: 500), () {
    //   chatScrollposition = commentController.position.maxScrollExtent;
    //   commentController.animateTo(commentController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
    // });
  }

  @override
  void dispose() {
    scrollController.dispose();
    commentController.dispose();
    pageScrollController.dispose();
    super.dispose();
  }

  void _insertComment(String userId) async{
    try {
        await FirebaseFirestore.instance.collection('Instant').doc(itemId).collection('InstantComment').doc().set(
          {
            'uid' : userId,
            'nickname' : userAccount_.nickname,
            'profile_image' : userAccount_.profile_image,
            'comment' : comment.text,
            'regDate' : formatDate(DateTime.now(), [am, ' ', hh, ':', nn]),
            'timestamp' : Timestamp.now(),
          }
        );
      } catch (e) {
        print(e);
      }
  }

  void _setInstantState() async {
    await FirebaseFirestore.instance.collection('Instant').doc(itemId).update({
      'state' : false
    });
  }

  Widget _inputCommentWidget() {
    return Container(
      child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text('COMMENT', style: TextStyle(color: Colors.grey[700], fontSize: 16, fontFamily: 'GSANSM'),),
            SizedBox(height:10),
            Container(
              color: Colors.grey[200],
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        child: TextField(
                          controller: comment,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              fillColor: Colors.grey[200],
                              filled: true,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      _insertComment(userAccount_.uid);
                      comment.clear();
                      FocusScope.of(context).unfocus();
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xffe83a4f),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset("assets/images/SVG/arrow.svg"),
                          onPressed: null,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10 ,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: OutlinedButton(
                  onPressed: () {
                    //master_uid= postData['master']['uid'];
                    if(postData['master']['uid'] != userAccount_.uid) {
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('방장만 가능합니다.'),
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
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('모집을 완료하시겠습니까?'),
                            actions: [
                              OutlinedButton(
                                onPressed: () {
                                  _setInstantState();
                                  Navigator.pop(context, true);
                                }, 
                                child: 
                                  Text('확인')
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                }, 
                                child: 
                                  Text('취소')
                              )  
                            ],
                          );
                        }
                      );
                      
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                    //backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                      style: BorderStyle.solid
                    ), borderRadius: BorderRadius.circular(20)),
                    elevation: 1
                  ),
                  child: Text('모집 완료', style: TextStyle(color: Colors.white, fontFamily: 'GSANSM', fontSize: 18),)
                )
              )
            )
          ],
        )
      )
    );
  }

    Future deleteInstant() async {
    // await FirebaseFirestore.instance.collection('Instant').doc(itemId).collection('Instant').get();

    // await FirebaseFirestore.instance.collection('Instant').doc(itemId).delete();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Instant').doc(itemId).collection('InstantComment').get();
    var list = querySnapshot.docs;
    list.forEach((element) async {
      await FirebaseFirestore.instance.collection('Instant').doc(itemId).collection('InstantComment').doc(element.id).delete();
    });

    await FirebaseFirestore.instance.collection('Instant').doc(itemId).delete();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => InstantPLay(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        automaticallyImplyLeading: false,
        title: 
          SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
        actions: [
          userAccount_.uid == master_uid ?
          TextButton(
              onPressed: () {
                showDialog(
                  context: context, 
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('정말 삭제하시겠습니까?', style: TextStyle(fontFamily: 'GSANSM', fontSize: 16, color: Colors.grey[600])),
                      actions: <Widget>[
                        OutlinedButton(
                          onPressed: () {
                            final data = deleteInstant();
                            data.then((value) => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => InstantPLay(),
                                ),
                              )
                            });
                          },
                          child: Text("확인"),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("취소"),
                        ),
                      ],
                    );
                  }
                );
              },
              child: Text(
                "게시글 삭제",
                style: TextStyle(color: Colors.black, fontFamily: "GSANSM"),
              )
          )
          :
          Container()
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                controller: pageScrollController,
                child: Container(
                  //color: Colors.grey[100],
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  //height: MediaQuery.of(context).size.height,
                  child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      children: [
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('Instant').doc(itemId).get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if(snapshot.hasError) {
                              return Center(
                                child: Text('DB Error!!')
                              );
                            }
                            if(snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              postData = snapshot.data!.data() as Map<String, dynamic>;
                              //master_uid = snapshot.data!.get('master.uid');
                              return Column(
                                children: [
                                  SizedBox(height: 60,),
                                  Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Text(postData['title'], style: Theme.of(context).textTheme.headline2),
                                        ),
                                        // userAccount_.uid == master_uid ? 
                                        // SizedBox(
                                        //   width: 50,
                                        //   height: 30,
                                        //   child: TextButton(
                                        //     onPressed: () {
                                              
                                        //     }, 
                                        //     style: OutlinedButton.styleFrom(
                                        //       primary: Theme.of(context).primaryColor,
                                        //       backgroundColor: Colors.white,
                                        //       shape: RoundedRectangleBorder(side: BorderSide(
                                        //         color: Theme.of(context).primaryColor,
                                        //         width: 1,
                                        //         style: BorderStyle.solid
                                        //       ), 
                                        //       borderRadius: BorderRadius.circular(20)),
                                        //       elevation: 0
                                        //     ),
                                        //     child: Text('삭제', style: TextStyle(fontSize: 13, fontFamily: 'GSANSB', color: Theme.of(context).primaryColor),)
                                        //   )
                                        // )
                                        // : 
                                        // Container()
                                      ],
                                    )
                                  ),
                                  SizedBox(height: 20,),
                                  
                                  Divider(
                                    height: 0.8,
                                    thickness: 0.8,
                                    color: Colors.grey[400],
                                  ),

                                  SizedBox(height: 5,),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    //height: 20,
                                    child: Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 30, height: 30,
                                                child: 
                                                  postData['master']['profile_image'].toString() == '' ?
                                                  ClipRRect(
                                                    //borderRadius: BorderRadius.circular(40),
                                                    child:
                                                      SvgPicture.asset('assets/images/SVG/profile_pink.svg', fit: BoxFit.fill,)
                                                  ) :
                                                  CircleAvatar(
                                                    backgroundColor: Colors.white,
                                                      radius: 120,
                                                      backgroundImage: NetworkImage(postData['master']['profile_image'].toString())
                                                  ),
                                              ),
                                              SizedBox(width: 5,),
                                              Container(
                                                height: 20,
                                                child:Text(postData['master']['nickname'], style: TextStyle(color: Colors.grey[700], fontFamily: 'GSANSM', fontSize: 16),)
                                              ),
                                            ],
                                          ),
                                          Container(
                                            child:
                                              Text(postData['area'], style: TextStyle(color: Colors.grey[700], fontFamily: 'GSANSM', fontSize: 16),)
                                          )
                                        ],
                                      ),
                                    )
                                  ),
                                  SizedBox(height: 5,),

                                  Divider(
                                    height: 0.8,
                                    thickness: 0.8,
                                    color: Colors.grey[400],
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                      child: Text(postData['info'], style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: 'GSANSM'),),
                                    )
                                  ),
                                  SizedBox(height: 10,),
                                  Divider(
                                    height: 0.8,
                                    thickness: 0.8,
                                    color: Colors.grey[400],
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height*0.34,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection('Instant').doc(itemId).collection('InstantComment').orderBy('timestamp', descending: true).snapshots(),
                                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if(snapshot.hasError) {
                                            return Center(
                                              child: Text('DB Error!!')
                                            );
                                          }
                                          if(snapshot.connectionState == ConnectionState.waiting) {
                                            return Center(child: CircularProgressIndicator());
                                          } else {
                                            return ListView.builder(
                                              reverse: true,
                                              controller: commentController,
                                              itemBuilder: (BuildContext context, idx) {
                                                DocumentSnapshot data = snapshot.data!.docs[idx];

                                                return Container(
                                                  child : Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                                    child: data['uid'] == userAccount_.uid ?
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                                                          child: Text(
                                                            data['regDate'],
                                                            style: TextStyle(
                                                                fontFamily: 'GSANSM',
                                                                fontSize: 9.0),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.symmetric(horizontal: 5),
                                                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                                          decoration: BoxDecoration(
                                                            color: Color(0xffFBD6C2),
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(10),
                                                              topRight: Radius.circular(0),
                                                              bottomLeft: Radius.circular(10),
                                                              bottomRight: Radius.circular(10)
                                                            )
                                                          ),
                                                          child: Text(
                                                            data['comment'],
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                                fontFamily: 'GSANSM'),
                                                          )),
                                                      ],
                                                    )
                                                    :
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                                          child: Text(
                                                            data['nickname'],
                                                            style: TextStyle(
                                                                fontFamily: 'GSANSM',
                                                                fontSize: 9.0),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            data['profile_image'] == '' ?
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(40),
                                                              child:
                                                                SvgPicture.asset('assets/images/SVG/profile_pink.svg', width: 40,)
                                                            )
                                                            :
                                                            Container(
                                                              width: 40, height: 40,
                                                              child: CircleAvatar(
                                                                backgroundColor: Colors.white,
                                                                radius: 120,
                                                                backgroundImage: NetworkImage(data['profile_image'])
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.symmetric(horizontal: 5),
                                                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                border: Border.all(color: Color(0xffe9394f), width: 1),
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius.circular(0),
                                                                    topRight: Radius.circular(10),
                                                                    bottomLeft: Radius.circular(10),
                                                                    bottomRight: Radius.circular(10)
                                                                )
                                                              ),
                                                              child: Text(
                                                                data['comment'],
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 14,
                                                                    fontFamily: 'GSANSM'),
                                                              )
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )
                                                  )
                                                );
                                              },
                                              itemCount: snapshot.data!.docs.length,
                                            );
                                          }
                                      }
                                    )
                                  ),
                                ],
                              );
                            }
                          }
                        )
                      ],
                    )
                  )
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: _inputCommentWidget()
            )
          ],
        )
      )
    );
  }
}








//1.0.0.+7
// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:date_format/date_format.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/instant/instant_main.dart';

// class InstantView extends StatefulWidget {
//   const InstantView({ Key? key, required this.itemId }) : super(key: key);
//   final String itemId;
//   @override
//   _InstantViewState createState() => _InstantViewState(itemId);
// }

// class _InstantViewState extends State<InstantView> {
//   _InstantViewState(this.itemId);
//   late UserAccountInfo userAccount_;
//   late ScrollController scrollController;
//   late ScrollController commentController;
//   late ScrollController pageScrollController;
//   final String itemId;
//   TextEditingController comment = TextEditingController();
//   bool bottomFlag = false;
//   Map postData = Map();
//   double chatScrollposition = 0.0;
  
//   @override
//   void initState() {
//     super.initState();
//     scrollController = ScrollController();
//     commentController = ScrollController();

//     commentController.addListener(() {
//       print('offset = ${commentController.offset}');
//     });
    
//     pageScrollController = new ScrollController(
//       initialScrollOffset: 0.0,
//       keepScrollOffset: true,
//     );

//     // Timer(Duration(milliseconds: 500), () {
//     //   chatScrollposition = commentController.position.maxScrollExtent;
//     //   commentController.animateTo(commentController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
//     // });
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     commentController.dispose();
//     pageScrollController.dispose();
//     super.dispose();
//   }

//   void _insertComment(String userId) async{
//     try {
//         await FirebaseFirestore.instance.collection('Instant').doc(itemId).collection('InstantComment').doc().set(
//           {
//             'uid' : userId,
//             'nickname' : userAccount_.nickname,
//             'profile_image' : userAccount_.profile_image,
//             'comment' : comment.text,
//             'regDate' : formatDate(DateTime.now(), [am, ' ', hh, ':', nn]),
//             'timestamp' : Timestamp.now(),
//           }
//         );
//       } catch (e) {
//         print(e);
//       }
//   }

//   void _setInstantState() async {
//     await FirebaseFirestore.instance.collection('Instant').doc(itemId).update({
//       'state' : false
//     });
//   }

//   Widget _inputCommentWidget() {
//     return Container(
//       child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             //Text('COMMENT', style: TextStyle(color: Colors.grey[700], fontSize: 16, fontFamily: 'GSANSM'),),
//             SizedBox(height:10),
//             Container(
//               color: Colors.grey[200],
//               width: MediaQuery.of(context).size.width,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                       child: GestureDetector(
//                         onTap: () {
//                           FocusScope.of(context).unfocus();
//                         },
//                         child: TextField(
//                           controller: comment,
//                           maxLines: null,
//                           keyboardType: TextInputType.multiline,
//                           style: TextStyle(fontSize: 20),
//                           decoration: InputDecoration(
//                               fillColor: Colors.grey[200],
//                               filled: true,
//                               border: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                               hintStyle: TextStyle(color: Colors.black)),
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () async {
//                       _insertComment(userAccount_.uid);
//                       comment.clear();
//                       FocusScope.of(context).unfocus();
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: Color(0xffe83a4f),
//                           borderRadius: BorderRadius.circular(60),
//                         ),
//                         child: IconButton(
//                           icon: SvgPicture.asset("assets/images/SVG/arrow.svg"),
//                           onPressed: null,
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             SizedBox(height: 10 ,),
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
//                 child: OutlinedButton(
//                   onPressed: () {
//                     if(postData['master']['uid'] != userAccount_.uid) {
//                       showDialog(
//                         context: context, 
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text('방장만 가능합니다.'),
//                             actions: [
//                               OutlinedButton(
//                                 onPressed: () {
//                                   Navigator.pop(context, true);
//                                 }, 
//                                 child: 
//                                   Text('확인')
//                               )  
//                             ],
//                           );
//                         }
//                       );
//                     } else {
//                       showDialog(
//                         context: context, 
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text('모집을 완료하시겠습니까?'),
//                             actions: [
//                               OutlinedButton(
//                                 onPressed: () {
//                                   _setInstantState();
//                                   Navigator.pop(context, true);
//                                 }, 
//                                 child: 
//                                   Text('확인')
//                               ),
//                               OutlinedButton(
//                                 onPressed: () {
//                                   Navigator.pop(context, true);
//                                 }, 
//                                 child: 
//                                   Text('취소')
//                               )  
//                             ],
//                           );
//                         }
//                       );
                      
//                     }
//                   },
//                   style: OutlinedButton.styleFrom(
//                     primary: Colors.white,
//                     backgroundColor: Theme.of(context).primaryColor,
//                     //backgroundColor: Colors.grey,
//                     shape: RoundedRectangleBorder(side: BorderSide(
//                       color: Theme.of(context).primaryColor,
//                       width: 1,
//                       style: BorderStyle.solid
//                     ), borderRadius: BorderRadius.circular(20)),
//                     elevation: 1
//                   ),
//                   child: Text('모집 완료', style: TextStyle(color: Colors.white, fontFamily: 'GSANSM', fontSize: 18),)
//                 )
//               )
//             )
//           ],
//         )
//       )
//     );
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
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (BuildContext context) => InstantPLay(),
//               ),
//             );
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
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 reverse: true,
//                 controller: pageScrollController,
//                 child: Container(
//                   //color: Colors.grey[100],
//                   alignment: Alignment.bottomCenter,
//                   width: MediaQuery.of(context).size.width,
//                   //height: MediaQuery.of(context).size.height,
//                   child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                     child: Column(
//                       children: [
//                         FutureBuilder<DocumentSnapshot>(
//                           future: FirebaseFirestore.instance.collection('Instant').doc(itemId).get(),
//                           builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//                             if(snapshot.hasError) {
//                               return Center(
//                                 child: Text('DB Error!!')
//                               );
//                             }
//                             if(snapshot.connectionState == ConnectionState.waiting) {
//                               return Center(child: CircularProgressIndicator());
//                             } else {
//                               postData = snapshot.data!.data() as Map<String, dynamic>;
//                               return Column(
//                                 children: [
//                                   SizedBox(height: 60,),
//                                   Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           flex: 7,
//                                           child: Text(postData['title'], style: Theme.of(context).textTheme.headline2),
//                                         ),
//                                       ],
//                                     )
//                                   ),
//                                   SizedBox(height: 20,),
                                  
//                                   Divider(
//                                     height: 0.8,
//                                     thickness: 0.8,
//                                     color: Colors.grey[400],
//                                   ),

//                                   SizedBox(height: 5,),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     //height: 20,
//                                     child: Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Container(
//                                                 width: 30, height: 30,
//                                                 child: 
//                                                   postData['master']['profile_image'].toString() == '' ?
//                                                   ClipRRect(
//                                                     //borderRadius: BorderRadius.circular(40),
//                                                     child:
//                                                       SvgPicture.asset('assets/images/SVG/profile_pink.svg', fit: BoxFit.fill,)
//                                                   ) :
//                                                   CircleAvatar(
//                                                     backgroundColor: Colors.white,
//                                                       radius: 120,
//                                                       backgroundImage: NetworkImage(postData['master']['profile_image'].toString())
//                                                   ),
//                                               ),
//                                               SizedBox(width: 5,),
//                                               Container(
//                                                 height: 20,
//                                                 child:Text(postData['master']['nickname'], style: TextStyle(color: Colors.grey[700], fontFamily: 'GSANSM', fontSize: 16),)
//                                               ),
//                                             ],
//                                           ),
//                                           Container(
//                                             child:
//                                               Text(postData['area'], style: TextStyle(color: Colors.grey[700], fontFamily: 'GSANSM', fontSize: 16),)
//                                           )
//                                         ],
//                                       ),
//                                     )
//                                   ),
//                                   SizedBox(height: 5,),

//                                   Divider(
//                                     height: 0.8,
//                                     thickness: 0.8,
//                                     color: Colors.grey[400],
//                                   ),

//                                   Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     height: 150,
//                                     child: Container(
//                                       margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
//                                       child: Text(postData['info'], style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: 'GSANSM'),),
//                                     )
//                                   ),
//                                   SizedBox(height: 10,),
//                                   Divider(
//                                     height: 0.8,
//                                     thickness: 0.8,
//                                     color: Colors.grey[400],
//                                   ),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     height: MediaQuery.of(context).size.height*0.34,
//                                     child: StreamBuilder(
//                                       stream: FirebaseFirestore.instance.collection('Instant').doc(itemId).collection('InstantComment').orderBy('timestamp', descending: true).snapshots(),
//                                       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                                         if(snapshot.hasError) {
//                                             return Center(
//                                               child: Text('DB Error!!')
//                                             );
//                                           }
//                                           if(snapshot.connectionState == ConnectionState.waiting) {
//                                             return Center(child: CircularProgressIndicator());
//                                           } else {
//                                             return ListView.builder(
//                                               reverse: true,
//                                               controller: commentController,
//                                               itemBuilder: (BuildContext context, idx) {
//                                                 DocumentSnapshot data = snapshot.data!.docs[idx];

//                                                 return Container(
//                                                   child : Padding(padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
//                                                     child: data['uid'] == userAccount_.uid ?
//                                                     Row(
//                                                       mainAxisAlignment: MainAxisAlignment.end,
//                                                       children: [
//                                                         Padding(
//                                                           padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
//                                                           child: Text(
//                                                             data['regDate'],
//                                                             style: TextStyle(
//                                                                 fontFamily: 'GSANSM',
//                                                                 fontSize: 9.0),
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           margin: EdgeInsets.symmetric(horizontal: 5),
//                                                           padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
//                                                           decoration: BoxDecoration(
//                                                             color: Color(0xffFBD6C2),
//                                                             borderRadius: BorderRadius.only(
//                                                               topLeft: Radius.circular(10),
//                                                               topRight: Radius.circular(0),
//                                                               bottomLeft: Radius.circular(10),
//                                                               bottomRight: Radius.circular(10)
//                                                             )
//                                                           ),
//                                                           child: Text(
//                                                             data['comment'],
//                                                             style: TextStyle(
//                                                                 color: Colors.black,
//                                                                 fontSize: 14,
//                                                                 fontFamily: 'GSANSM'),
//                                                           )),
//                                                       ],
//                                                     )
//                                                     :
//                                                     Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         Padding(
//                                                           padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
//                                                           child: Text(
//                                                             data['nickname'],
//                                                             style: TextStyle(
//                                                                 fontFamily: 'GSANSM',
//                                                                 fontSize: 9.0),
//                                                           ),
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             data['profile_image'] == '' ?
//                                                             ClipRRect(
//                                                               borderRadius: BorderRadius.circular(40),
//                                                               child:
//                                                                 SvgPicture.asset('assets/images/SVG/profile_pink.svg', width: 40,)
//                                                             )
//                                                             :
//                                                             Container(
//                                                               width: 40, height: 40,
//                                                               child: CircleAvatar(
//                                                                 backgroundColor: Colors.white,
//                                                                 radius: 120,
//                                                                 backgroundImage: NetworkImage(data['profile_image'])
//                                                               ),
//                                                             ),
//                                                             Container(
//                                                               margin: EdgeInsets.symmetric(horizontal: 5),
//                                                               padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
//                                                               decoration: BoxDecoration(
//                                                                 color: Colors.white,
//                                                                 border: Border.all(color: Color(0xffe9394f), width: 1),
//                                                                 borderRadius: BorderRadius.only(
//                                                                     topLeft: Radius.circular(0),
//                                                                     topRight: Radius.circular(10),
//                                                                     bottomLeft: Radius.circular(10),
//                                                                     bottomRight: Radius.circular(10)
//                                                                 )
//                                                               ),
//                                                               child: Text(
//                                                                 data['comment'],
//                                                                 style: TextStyle(
//                                                                     color: Colors.black,
//                                                                     fontSize: 14,
//                                                                     fontFamily: 'GSANSM'),
//                                                               )
//                                                             ),
//                                                           ],
//                                                         )
//                                                       ],
//                                                     )
//                                                   )
//                                                 );
//                                               },
//                                               itemCount: snapshot.data!.docs.length,
//                                             );
//                                           }
//                                       }
//                                     )
//                                   ),
//                                 ],
//                               );
//                             }
//                           }
//                         )
//                       ],
//                     )
//                   )
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width,
//               child: _inputCommentWidget()
//             )
//           ],
//         )
//       )
//     );
//   }
// }