import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snstennis/account/user_account_info.dart';

import 'SearchClubList.dart';

class SearchClub extends StatefulWidget {
  const SearchClub({Key? key}) : super(key: key);

  @override
  _SearchClubState createState() => _SearchClubState();
}

class _SearchClubState extends State<SearchClub> {

  String clubname = "";

  TextEditingController clubName = TextEditingController();

  final formKey = new GlobalKey<FormState>();
  late UserAccountInfo user_account_info_;

  void validateAndSave(){
    final form = formKey.currentState;

    if(form!.validate()){
      form.save();
      print("success $clubname");
    }else{
      print("failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //endDrawer: Drawer(child:HamburgerMenu()),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          iconTheme: IconThemeData(color: Colors.grey),
          automaticallyImplyLeading: false,
          title: 
            //Image.asset('assets/images/PNG/logo2.png', width: 110,),
            SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
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
          child: SingleChildScrollView(child: 
            Container(
              width: MediaQuery.of(context).size.width,
              //height: MediaQuery.of(context).size.height * 1,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: 
                Form(
                  key: formKey,
                  child: 
                    //SingleChildScrollView(
                      //child: 
                        Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: 
                          Column(
                            children: [
                              Container(
                                color: Color(0xfffbd6ce),
                                child: 
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: 
                                      SizedBox(
                                        //width: 180,
                                        height: 30,
                                        child: TextFormField(
                                          controller: clubName,
                                          decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            contentPadding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                                            hintText: '검색어를 입력하세요.',
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 2,
                                              ),
                                              borderRadius: const BorderRadius.all(Radius.circular(5))                
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.grey.shade300,
                                                width: 2,
                                              ),
                                              borderRadius: const BorderRadius.all(Radius.circular(5))
                                            ),
                                            //filled: true,
                                          ),
                                          // validator: (value) =>
                                          // value!.isEmpty ? 'Failed ClubName' : null,


                                          //onSaved: (value) => clubname = value!,
                                        ),
                                      )
                                  )                                  
                              ),
                              SizedBox(height: 20,),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('* 클럽 이름에 포함되는 단어를 검색어로 입력.\n',
                                      style: TextStyle(fontFamily: 'GSANSM', fontSize: 14, color: Colors.grey[600])
                                    ),
                                    Text('* 영어의 경우 대소문자를 구분하여 입력.',
                                      style: TextStyle(fontFamily: 'GSANSM', fontSize: 14, color: Colors.grey[600]),
                                    )
                                  ]
                                ),
                              ),
                              SizedBox(
                                width: 250, height: 30,
                                child: 
                                  Container(
                                    child: 
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          //validateAndSave();

                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (BuildContext context){
                                                return SearchClubList(name: clubName.text,);
                                              })
                                          );
                                        }, 
                                        icon: Icon(Icons.search, color: Colors.white,), 
                                        style: OutlinedButton.styleFrom(
                                          primary: Colors.white,
                                          backgroundColor: Theme.of(context).primaryColor,
                                          //backgroundColor: Color(0xffe9394f),
                                          shape: RoundedRectangleBorder(side: BorderSide(
                                              color: Color(0xffe9394f),
                                              width: 1,
                                              style: BorderStyle.solid
                                          ), borderRadius: BorderRadius.circular(50)),
                                          elevation: 3
                                        ),                                        
                                        label: Text(
                                          "검색하기",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontFamily: 'GSANSB',
                                              //decoration: TextDecoration.underline,
                                              decorationThickness: 1
                                          ),
                                        )
                                      ),
                                  ),
                              ),                             
                            ],
                          ),
                        )
                    //)
                ),
            ),)
        )
    );
  }
}









//1.0.0.+7
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:snstennis/account/user_account_info.dart';
// import 'package:snstennis/hamburger.dart';

// import 'SearchClubList.dart';

// class SearchClub extends StatefulWidget {
//   const SearchClub({Key? key}) : super(key: key);

//   @override
//   _SearchClubState createState() => _SearchClubState();
// }

// class _SearchClubState extends State<SearchClub> {

//   String clubname = "";

//   final formKey = new GlobalKey<FormState>();
//   late UserAccountInfo user_account_info_;

//   void validateAndSave(){
//     final form = formKey.currentState;

//     if(form!.validate()){
//       form.save();
//       print("success $clubname");
//     }else{
//       print("failed");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       endDrawer: Drawer(child:HamburgerMenu()),
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Color(0xFFFFFFFF),
//           iconTheme: IconThemeData(color: Colors.grey),
//           automaticallyImplyLeading: false,
//           title: 
//             //Image.asset('assets/images/PNG/logo2.png', width: 110,),
//             SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
//             leading: IconButton(
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
//           child: SingleChildScrollView(child: 
//             Container(
//               width: MediaQuery.of(context).size.width,
//               //height: MediaQuery.of(context).size.height * 1,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//               ),
//               child: 
//                 Form(
//                   key: formKey,
//                   child: 
//                     //SingleChildScrollView(
//                       //child: 
//                         Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
//                         child: 
//                           Column(
//                             children: [
//                               Container(
//                                 color: Color(0xfffbd6ce),
//                                 child: 
//                                   Padding(
//                                     padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                                     child: 
//                                       SizedBox(
//                                         //width: 180,
//                                         height: 30,
//                                         child: TextFormField(
//                                           decoration: InputDecoration(
//                                             fillColor: Colors.white,
//                                             filled: true,
//                                             contentPadding: new EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
//                                             hintText: '검색어를 입력하세요.',
//                                             enabledBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                 color: Colors.grey.shade300,
//                                                 width: 2,
//                                               ),
//                                               borderRadius: const BorderRadius.all(Radius.circular(5))                
//                                             ),
//                                             focusedBorder: OutlineInputBorder(
//                                               borderSide: BorderSide(
//                                                 color: Colors.grey.shade300,
//                                                 width: 2,
//                                               ),
//                                               borderRadius: const BorderRadius.all(Radius.circular(5))
//                                             ),
//                                             //filled: true,
//                                           ),
//                                           // validator: (value) =>
//                                           // value!.isEmpty ? 'Failed ClubName' : null,
//                                           onSaved: (value) => clubname = value!,
//                                         ),
//                                       )
//                                   )                                  
//                               ),
//                               SizedBox(height: 100,),
//                               SizedBox(
//                                 width: 250, height: 30,
//                                 child: 
//                                   Container(
//                                     child: 
//                                       OutlinedButton.icon(
//                                         onPressed: () {
//                                           validateAndSave();

//                                           Navigator.push(context, MaterialPageRoute(
//                                               builder: (BuildContext context){
//                                                 return SearchClubList(name: clubname,);
//                                               })
//                                           );
//                                         }, 
//                                         icon: Icon(Icons.search, color: Colors.white,), 
//                                         style: OutlinedButton.styleFrom(
//                                           primary: Colors.white,
//                                           backgroundColor: Theme.of(context).primaryColor,
//                                           //backgroundColor: Color(0xffe9394f),
//                                           shape: RoundedRectangleBorder(side: BorderSide(
//                                               color: Color(0xffe9394f),
//                                               width: 1,
//                                               style: BorderStyle.solid
//                                           ), borderRadius: BorderRadius.circular(50)),
//                                           elevation: 3
//                                         ),                                        
//                                         label: Text(
//                                           "검색하기",
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 16.0,
//                                               fontFamily: 'GSANSB',
//                                               //decoration: TextDecoration.underline,
//                                               decorationThickness: 1
//                                           ),
//                                         )
//                                       ),
//                                   ),
//                               ),                             
//                             ],
//                           ),
//                         )
//                     //)
//                 ),
//             ),)
//         )
//     );
//   }
// }
