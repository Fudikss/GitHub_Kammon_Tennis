import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/app.dart';

class WinterJoinUser extends StatefulWidget {
  const WinterJoinUser({Key? key}) : super(key: key);

  @override
  _WinterJoinUserState createState() => _WinterJoinUserState();
}

class _WinterJoinUserState extends State<WinterJoinUser> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nickname = TextEditingController();
  TextEditingController area = TextEditingController();
  TextEditingController intro = TextEditingController();

  var gender_value_ = "남성";

  late FocusNode currentFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "동계현장실습",
          style: TextStyle(color: Color(0xFFF6F4F0), fontSize: 25.0),
        ),
        actions: [],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFFF0CDB4),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                child: TextFormField(
                    controller: nickname,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '닉네임을 입력해주세요.',
                      hintStyle:
                          TextStyle(fontSize: 14.0, color: Colors.grey[400]),
                    )),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '성별',
                    style: TextStyle(
                        fontFamily: 'GSANSM', color: Colors.grey[600]),
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width - 150,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: gender_value_,
                        items: ["남성", "여성"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[400]),
                            ),
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
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: 30,
                child: TextFormField(
                    controller: nickname,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '살고있는 지역을 입력해주세요.',
                      hintStyle:
                          TextStyle(fontSize: 14.0, color: Colors.grey[400]),
                    )),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: 30,
                child: TextFormField(
                    controller: nickname,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '자기소개를 입력해주세요.',
                      hintStyle:
                          TextStyle(fontSize: 14.0, color: Colors.grey[400]),
                    )),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () {},
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
                    "회원가입 완료",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
