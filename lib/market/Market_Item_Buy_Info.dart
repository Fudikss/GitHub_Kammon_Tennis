import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/first_screen_1_0.dart';
import 'Market_Click_Image.dart';

class MarketItemBuyInfo extends StatefulWidget {
  final String prev_nick_name;
  final String prev_title;
  final String prev_intro;
  final String prev_price;
  final String prev_date_time;
  final String prev_image_url;
  final String prev_user_uid;
  final String prev_item_id;
  final String prev_profile_image;

  const MarketItemBuyInfo({
    Key? key,
    required this.prev_nick_name,
    required this.prev_title,
    required this.prev_intro,
    required this.prev_price,
    required this.prev_date_time,
    required this.prev_image_url,
    required this.prev_user_uid,
    required this.prev_item_id,
    required this.prev_profile_image,
  }) : super(key: key);

  @override
  _MarketItemBuyInfoState createState() => _MarketItemBuyInfoState(
      prev_nick_name,
      prev_title,
      prev_intro,
      prev_price,
      prev_date_time,
      prev_image_url,
      prev_user_uid,
      prev_item_id,
      prev_profile_image);
}

class _MarketItemBuyInfoState extends State<MarketItemBuyInfo> {
  String nickname = "";
  String title = "";
  String intro = "";
  String price = "";
  String datetime = "";
  String image_url = "";
  String user_uid = "";
  String item_id = "";
  String profile_image = "";

  User user = FirebaseAuth.instance.currentUser!;

  int _selectedNaviIndex = 0;

  _MarketItemBuyInfoState(
      this.nickname,
      this.title,
      this.intro,
      this.price,
      this.datetime,
      this.image_url,
      this.user_uid,
      this.item_id,
      this.profile_image);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserAccountInfo userAccount_ = Provider.of(context, listen: false);
    return Scaffold(
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
        actions: [],
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return MarketClickImage(url: image_url);
                  }));
                },
                child: image_url != ""
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3.5,
                        // color: Theme.of(context).primaryColorLight,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          image: DecorationImage(
                              image: NetworkImage(
                                image_url,
                              ),
                              fit: BoxFit.fill),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3.5,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                        )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          'https://www.edmundsgovtech.com/wp-content/uploads/2020/01/default-picture_0_0.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nickname,
                            style: Theme.of(context).textTheme.subtitle1,
                            //style: TextStyle(fontSize: 11, fontFamily: 'GSANSB', color: Theme.of(context).primaryColor),
                          ),
                          Text(
                            datetime,
                            style: Theme.of(context).textTheme.subtitle2,
                            //style: TextStyle(fontSize: 11, fontFamily: 'GSANSB', color: Theme.of(context).primaryColor),
                          ),
                        ]),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Divider(
                      thickness: 1.5, height: 1.5, color: Colors.grey[200])),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontFamily: 'GSANSB', fontSize: 16),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      intro,
                      style: TextStyle(fontFamily: 'GSANSM', fontSize: 13),
                    ),
                  ],
                ),
              )
            ],
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
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            //backgroundColor: Colors.grey[300],
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: Theme.of(context).primaryColor,
            //selectedItemColor: Colors.grey[800],
            currentIndex: _selectedNaviIndex,
            onTap: (int index) {
              _selectedNaviIndex = index;
              setState(() {
                if (_selectedNaviIndex == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return FirstScreen();
                  }));
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                title: Container(height: 0.0),
                icon: Container(),
              ),
              BottomNavigationBarItem(
                title: Container(height: 0.0),
                icon: Text(
                  price,
                  style: TextStyle(fontFamily: 'GSANSB', fontSize: 16),
                ),
              ),
              BottomNavigationBarItem(
                title: Container(height: 7.0),
                icon: Container(
                    width: 130,
                    height: 38,
                    child: ElevatedButton(
                      child: Text(
                        "??????????????????",
                        style: TextStyle(
                          fontFamily: 'GSANSB',
                          fontSize: 15,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Color(0xffe9394f),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0),
                      onPressed: () {
                        print("??????????????????");
                        // Navigator.pop(context, 2);

                        Navigator.of(context)..pop()..pop(2);
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
