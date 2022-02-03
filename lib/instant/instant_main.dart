import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/first_screen_1_0.dart';
import 'package:snstennis/home.dart';
import 'package:snstennis/instant/instant_create.dart';
import 'package:snstennis/instant/instant_view.dart';
import 'package:snstennis/market/Market_Main_Page.dart';
import 'package:intl/intl.dart';

class InstantPLay extends StatefulWidget {
  const InstantPLay({ Key? key }) : super(key: key);

  @override
  _InstantPLayState createState() => _InstantPLayState();
}

class _InstantPLayState extends State<InstantPLay> {
  int _selectedNaviIndex = 1;
  List<dynamic>  dataList = [];

  final area = [
    "전체",
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

  var _selectedValue = '전체';

  _getDataList(String keyword) async {
    dataList.add(keyword);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    UserAccountInfo userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context, 
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('종료하시겠습니까?', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontFamily: 'GSANSM'),),
              actions: [
                OutlinedButton(onPressed: () {
                  SystemNavigator.pop();
                }, child: Text('확인', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontFamily: 'GSANSM'),)),
                OutlinedButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text('취소', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontFamily: 'GSANSM'),))
              ],
            );
          }
        );
      },
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        title: 
          SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          //child: Expanded(
            child: Container(
              //color: Colors.amberAccent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 140,
              //child: Expanded(
                //child: Container()
                child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    //color: Colors.blueGrey,
                    child:Column(
                      children: [
                        SizedBox(height: 60,),
                        Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text('지역선택 :', style: Theme.of(context).textTheme.headline2),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  color: Colors.grey[300],
                                  height: 30,
                                    child:
                                      DropdownButton(
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
                                            _getDataList(_selectedValue);
                                          });
                                        },
                                      ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.grey[700],
                          height: 1,
                        ),
                        _selectedValue == '전체' ?
                        Expanded(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('Instant').orderBy('timeStamp', descending: true).snapshots(),
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
                                  itemBuilder: (BuildContext context, idx) {
                                    DocumentSnapshot data = snapshot.data!.docs[idx];
                                    return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) => InstantView(itemId: data.id, master_uid: data['master']['uid'],),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Theme.of(context).primaryColorLight, width: 0.8),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                                  child: 
                                                        Row(
                                              children : [
                                                Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(data['title'], style: TextStyle(color: Colors.grey[700], fontFamily: 'GSANSM', fontSize: 16),),
                                                        SizedBox(height: 10),
                                                        Text('방장 : ' + data['master']['nickname'].toString(), style: TextStyle(fontFamily: 'GSANSM', fontSize: 15, color: Colors.grey[400]),),
                                                    ],)
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child : 
                                                    Container(
                                                      child: data['state'] ? 
                                                        Text('모집중', style: TextStyle(fontFamily: 'GSANSM', fontSize: 12, color: Theme.of(context).primaryColor),) 
                                                        : Text('모집마감', style: TextStyle(fontFamily: 'GSANSM', fontSize: 12, color: Colors.grey[400],) )
                                                    ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                      child: Text(data['area'], style: TextStyle(fontFamily: 'GSANSM', fontSize: 12, color: Colors.grey[400],), textAlign: TextAlign.center,)
                                                  )
                                                )
                                              ]
                                            ),
                                                ),
                                              ],
                                            )
                                          ),
                                        )
                                    );
                                  },
                                  itemCount: snapshot.data!.docs.length
                                );
                              }                          
                            },
                          )
                        )
                        :
                        Expanded(
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection('Instant').where('area', isEqualTo: _selectedValue).orderBy('timeStamp', descending: true).snapshots(),
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
                                  itemBuilder: (BuildContext context, idx) {
                                    DocumentSnapshot data = snapshot.data!.docs[idx];
                                    return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) => InstantView(itemId: data.id, master_uid: data['master']['uid']),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(color: Theme.of(context).primaryColorLight, width: 0.8),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                                  child: 
                                                        Row(
                                              children : [
                                                Expanded(
                                                  flex: 4,
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(data['title'], style: TextStyle(color: Colors.grey[700], fontFamily: 'GSANSM', fontSize: 16),),
                                                        SizedBox(height: 10),
                                                        Text('방장 : ' + data['master']['nickname'].toString(), style: TextStyle(fontFamily: 'GSANSM', fontSize: 15, color: Colors.grey[400]),),
                                                    ],)
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child : 
                                                    Container(
                                                      child: data['state'] ? 
                                                        Text('모집중', style: TextStyle(fontFamily: 'GSANSM', fontSize: 12, color: Theme.of(context).primaryColor),) 
                                                        : Text('모집마감', style: TextStyle(fontFamily: 'GSANSM', fontSize: 12, color: Colors.grey[400],) )
                                                    ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                      child: Text(data['area'], style: TextStyle(fontFamily: 'GSANSM', fontSize: 12, color: Colors.grey[400],), textAlign: TextAlign.center,)
                                                  )
                                                )
                                              ]
                                            ),
                                                ),
                                              ],
                                            )
                                          ),
                                        )
                                    );
                                    
                                  },
                                  
                                  itemCount: snapshot.data!.docs.length
                                );
                              }                          
                            },
                          )
                        )
                      ],
                    ),
                  //)
                ),
              //)            
            ),
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => InstantCreate(),
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
        child: Icon(
          Icons.add,
          color: Color(0xFFFFFFFF),
          size: 40,
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
                  offset: Offset(0.0, 0.75)
              )
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
                if(_selectedNaviIndex == 0) { 
                  print(_selectedNaviIndex);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context){
                        return Home();
                      }
                  ));
                }
                if(_selectedNaviIndex == 1) { 
                  print(_selectedNaviIndex);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context){
                        return InstantPLay();
                      }
                  ));
                }
                if(_selectedNaviIndex == 2) { 
                  print(_selectedNaviIndex);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context){
                        return FirstScreen();
                      }
                  ));
                }
                if(_selectedNaviIndex == 3) { 
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context){
                      return MarketMainPage(item_id: userAccount_.marketChatItem);
                    }
                  ));
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                title: Text('홈', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
                icon: SvgPicture.asset('assets/images/SVG/home.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/home_selected.svg', width: 23,),
              ),
              BottomNavigationBarItem(
                title: Text('벙개', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
                icon: SvgPicture.asset('assets/images/SVG/light.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/light_selected.svg', width: 23,),
              ),
              BottomNavigationBarItem(
                title: Text('클럽', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
                icon: SvgPicture.asset('assets/images/SVG/club.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/club_selected.svg', width: 23,),
              ),
              BottomNavigationBarItem(
                title: Text('중고장터', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11),),
                icon: SvgPicture.asset('assets/images/SVG/basket.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/basket_selected.svg', width: 23,),
              ),
              BottomNavigationBarItem(
                title: Text('더보기', style: TextStyle(fontFamily: 'GSANSM', fontSize: 11)),
                icon: SvgPicture.asset('assets/images/SVG/more.svg', width: 23,),
                activeIcon: SvgPicture.asset('assets/images/SVG/more_selected.svg', width: 23,),
              ),
            ],        
          )
        )
      ),
    ));
  }
}








//1.0.0.+7
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/club/first_screen_1_0.dart';
// import 'package:snstennis/home.dart';
// import 'package:snstennis/instant/instant_create.dart';
// import 'package:snstennis/instant/instant_view.dart';
// import 'package:snstennis/market/Market_Main_Page.dart';
// import 'package:intl/intl.dart';

// class InstantPLay extends StatefulWidget {
//   const InstantPLay({ Key? key }) : super(key: key);

//   @override
//   _InstantPLayState createState() => _InstantPLayState();
// }

// class _InstantPLayState extends State<InstantPLay> {
//   int _selectedNaviIndex = 1;
//   List<dynamic>  dataList = [];

//   final area = [
//     "전체",
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

//   var _selectedValue = '전체';

//   _getDataList(String keyword) async {
//     dataList.add(keyword);
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//     UserAccountInfo userAccount_ = Provider.of<UserAccountInfo>(context, listen: false);
//     return WillPopScope(
//       onWillPop: () async {
//         return await showDialog(
//           context: context, 
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('종료하시겠습니까?', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontFamily: 'GSANSM'),),
//               actions: [
//                 OutlinedButton(onPressed: () {
//                   SystemNavigator.pop();
//                 }, child: Text('확인', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontFamily: 'GSANSM'),)),
//                 OutlinedButton(onPressed: () {
//                   Navigator.of(context).pop();
//                 }, child: Text('취소', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16, fontFamily: 'GSANSM'),))
//               ],
//             );
//           }
//         );
//       },
//       child: Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFFFFFF),
//         iconTheme: IconThemeData(color: Colors.grey),
//         automaticallyImplyLeading: false,
//         title: 
//           SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
//         actions: [],
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           //child: Expanded(
//             child: Container(
//               //color: Colors.amberAccent,
//               width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height - 140,
//               //child: Expanded(
//                 //child: Container()
//                 child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                   child: Container(
//                     //color: Colors.blueGrey,
//                     child:Column(
//                       children: [
//                         SizedBox(height: 60,),
//                         Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 flex: 5,
//                                 child: Text('지역선택 :', style: Theme.of(context).textTheme.headline2),
//                               ),
//                               Expanded(
//                                 flex: 5,
//                                 child: Container(
//                                   color: Colors.grey[300],
//                                   height: 30,
//                                     child:
//                                       DropdownButton(
//                                         isExpanded: true,
//                                         value: _selectedValue,
//                                         items: area.map(
//                                           (value) {
//                                             return DropdownMenuItem(
//                                               value: value,
//                                               child: Text('   ' + value, style: TextStyle(color: Colors.grey[600], fontFamily: 'GSANSM', fontSize: 14)),
//                                             );
//                                           },
//                                         ).toList(),
//                                         onChanged: (value) {
//                                           setState(() {
//                                             _selectedValue = value.toString();
//                                             _getDataList(_selectedValue);
//                                           });
//                                         },
//                                       ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Container(
//                           color: Colors.grey[700],
//                           height: 1,
//                         ),
//                         _selectedValue == '전체' ?
//                         Expanded(
//                           child: StreamBuilder(
//                             stream: FirebaseFirestore.instance.collection('Instant').orderBy('timeStamp', descending: true).snapshots(),
//                             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                               if(snapshot.hasError) {
//                                 return Center(
//                                   child: Text('DB Error!!')
//                                 );
//                               }
//                               if(snapshot.connectionState == ConnectionState.waiting) {
//                                 return Center(child: CircularProgressIndicator());
//                               } else {
//                                 return ListView.builder(
//                                   itemBuilder: (BuildContext context, idx) {
//                                     DocumentSnapshot data = snapshot.data!.docs[idx];
//                                     return InkWell(
//                                         onTap: () {
//                                           Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                               builder: (BuildContext context) => InstantView(itemId: data.id,),
//                                             ),
//                                           );
//                                         },
//                                         child: Padding(
//                                           padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               border: Border.all(color: Theme.of(context).primaryColorLight, width: 0.8),
//                                               borderRadius: BorderRadius.circular(10),
//                                             ),
//                                             child: Column(
//                                               children: [
//                                                 Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
//                                                   child: 
//                                                         Row(
//                                               children : [
//                                                 Expanded(
//                                                   flex: 4,
//                                                   child: Container(
//                                                     margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
//                                                     child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         Text(data['title'], style: TextStyle(color: Colors.grey[700], fontFamily: 'GSANSM', fontSize: 16),),
//                                                         SizedBox(height: 10),
//                                                         Text('방장 : ' + data['master']['nickname'].toString(), style: TextStyle(fontFamily: 'GSANSM', fontSize: 15, color: Colors.grey[400]),),
//                                                     ],)
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   flex: 2,
//                                                   child : 
//                                                     Container(
//                                                       child: data['state'] ? 
//                                                         Text('모집중', style: TextStyle(fontFamily: 'GSANSM', fontSize: 12, color: Theme.of(context).primaryColor),) 
//                                                         : Text('모집마감', style: TextStyle(fontFamily: 'GSANSM', fontSize: 12, color: Colors.grey[400],) )
//                                                     ),
//                                                 ),
//                                                 Expanded(
//                                                   flex: 2,
//                                                   child: Container(
//                                                       child: Text(data['area'], style: TextStyle(fontFamily: 'GSANSM', fontSize: 12, color: Colors.grey[400],), textAlign: TextAlign.center,)
//                                                   )
//                                                 )
//                                               ]
//                                             ),
//                                                 ),
//                                               ],
//                                             )
//                                           ),
//                                         )
//                                     );
//                                   },
//                                   itemCount: snapshot.data!.docs.length
//                                 );
//                               }                          
//                             },
//                           )
//                         )
//                         :
//                         Expanded(
//                           child: StreamBuilder(
//                             stream: FirebaseFirestore.instance.collection('Instant').where('area', isEqualTo: _selectedValue).orderBy('timeStamp', descending: true).snapshots(),
//                             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                               if(snapshot.hasError) {
//                                 return Center(
//                                   child: Text('DB Error!!')
//                                 );
//                               }
//                               if(snapshot.connectionState == ConnectionState.waiting) {
//                                 return Center(child: CircularProgressIndicator());
//                               } else {
//                                 return ListView.builder(
//                                   itemBuilder: (BuildContext context, idx) {
//                                     DocumentSnapshot data = snapshot.data!.docs[idx];
//                                     return InkWell(
//                                         onTap: () {
//                                           Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                               builder: (BuildContext context) => InstantView(itemId: data.id,),
//                                             ),
//                                           );
//                                         },
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               children : [
//                                                 Expanded(
//                                                   flex: 4,
//                                                   child: Container(
//                                                     margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
//                                                     child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         Text(data['title'], style: TextStyle(color: Colors.grey[700], fontFamily: 'GSANSM', fontSize: 16),),
//                                                         SizedBox(height: 10),
//                                                         Text('방장 : ' + data['master']['nickname'].toString(), style: TextStyle(fontFamily: 'GSANSM', fontSize: 15, color: Colors.grey[400]),),
//                                                     ],)
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   flex: 1,
//                                                   child : 
//                                                     Container(
//                                                       child: data['state'] ? 
//                                                         Text('모집중', style: TextStyle(fontFamily: 'GSANSM', fontSize: 12, color: Theme.of(context).primaryColor),) 
//                                                         : Text('모집마감', style: TextStyle(fontFamily: 'GSANSM', fontSize: 12, color: Colors.grey[400],) )
//                                                     ),
//                                                 ),
//                                                 Expanded(
//                                                   flex: 2,
//                                                   child: Container(
//                                                       child: Text(data['area'], style: TextStyle(fontFamily: 'GSANSM', fontSize: 12, color: Colors.grey[400],), textAlign: TextAlign.center,)
//                                                   )
//                                                 )
//                                               ]
//                                             ),
//                                             Container(
//                                               width: MediaQuery.of(context).size.width,
//                                               height: 7,
//                                               color: Colors.grey[300],
//                                             )
//                                           ],
//                                         )
//                                     );
                                    
//                                   },
                                  
//                                   itemCount: snapshot.data!.docs.length
//                                 );
//                               }                          
//                             },
//                           )
//                         )
//                       ],
//                     ),
//                   //)
//                 ),
//               //)            
//             ),
//           )
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (BuildContext context) => InstantCreate(),
//             ),
//           );
//         },
//         backgroundColor: Theme.of(context).primaryColor,
//         elevation: 4,
//         child: Icon(
//           Icons.add,
//           color: Color(0xFFFFFFFF),
//           size: 40,
//         ),
//       ),
//       bottomNavigationBar: SizedBox(
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
//             backgroundColor: Colors.white,
//             elevation: 3,
//             selectedItemColor: Theme.of(context).primaryColor,
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
//       ),
//     ));
//   }
// }