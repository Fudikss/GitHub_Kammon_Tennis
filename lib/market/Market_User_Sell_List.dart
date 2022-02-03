import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/club/first_screen_1_0.dart';
import 'package:snstennis/home.dart';
import 'package:snstennis/instant/instant_main.dart';
import 'Market_Item_BuyAndSell_Info.dart';
import 'Market_Main_Page.dart';
import 'Market_Item_Sell_Info.dart';

class USerSellList extends StatefulWidget {
  const USerSellList({Key? key}) : super(key: key);

  @override
  _USerSellListState createState() => _USerSellListState();
}

class _USerSellListState extends State<USerSellList> {
  late UserAccountInfo user_account_info_;

  User user = FirebaseAuth.instance.currentUser!;

  int _selectedNaviIndex = 3;

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Text(
                '판매내역',
                style: TextStyle(
                    fontFamily: 'GSANSB',
                    color: Colors.grey[700],
                    fontSize: 20),
              ),
            ),
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(user.uid)
                    .collection("BuyAndSell")
                    .doc("SellList")
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error!");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container();
                  } else {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;

                    List item_title = [];
                    List item_intro = [];
                    List item_price = [];
                    List item_datetime = [];
                    List item_nick_name = [];
                    List item_user_uid = [];
                    List item_image_url = [];
                    List item_id = [];
                    List item_profile_image = [];

                    if (data["SellItem"].length != 0) {
                      for (int i = 0; i < data["SellItem"].length; i++) {
                        item_title.add(data["SellItem"][i]["Title"]);
                        item_intro.add(data["SellItem"][i]["Intro"]);
                        item_price.add(data["SellItem"][i]["Price"]);
                        item_datetime.add(data["SellItem"][i]["DateTime"]);
                        item_nick_name.add(data["SellItem"][i]["NickName"]);
                        item_user_uid.add(data["SellItem"][i]["UserUID"]);
                        item_id.add(data["SellItem"][i]["ItemID"]);
                        item_image_url.add(data["SellItem"][i]["ImageUrl"]);
                        item_profile_image
                            .add(data["SellItem"][i]["profile_image"]);
                      }

                      return ListView.separated(
                          // scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,

                              // decoration: BoxDecoration(
                              //     color: Colors.white,
                              //     borderRadius: BorderRadius.circular(5)),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.push(context, MaterialPageRoute(
                                  //     builder: (BuildContext context) {
                                  //   return MarktetItemBuyAndSellInfo(
                                  //       prev_nick_name: item_nick_name[index],
                                  //       prev_title: item_title[index],
                                  //       prev_intro: item_intro[index],
                                  //       prev_price: item_price[index],
                                  //       prev_datetime: item_datetime[index],
                                  //       prev_imageurl: item_image_url[index],
                                  //       prev_UserUID: item_user_uid[index],
                                  //       prev_itemID: item_id[index]);
                                  // }));
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return MarketItemSellInfo(
                                        prev_nick_name: item_nick_name[index],
                                        prev_title: item_title[index],
                                        prev_intro: item_intro[index],
                                        prev_price: item_price[index],
                                        prev_date_time: item_datetime[index],
                                        prev_image_url: item_image_url[index],
                                        prev_user_uid: item_user_uid[index],
                                        prev_item_id: item_id[index],
                                        prev_profile_image:
                                            item_profile_image[index]);
                                  }));
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 15, 0, 15),
                                      child: ListTile(
                                        leading: SizedBox(
                                          height: 130,
                                          width: 100,
                                          child: item_image_url[index] != ""
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      item_image_url[index],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fill,
                                                        // colorFilter: const ColorFilter.mode(
                                                        //   Colors.red,
                                                        //   BlendMode.colorBurn,
                                                        // ),
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(
                                                    strokeWidth: 1.0,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                        ),
                                        title: Column(
                                          children: [
                                            Row(children: [
                                              Text(
                                                item_title[index],
                                                style: TextStyle(
                                                    color: Color(0xff58585b),
                                                    fontFamily: 'GSANSM',
                                                    fontSize: 14),
                                              ),
                                            ]),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(children: [
                                              Text(
                                                item_datetime[index],
                                                style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontFamily: 'GSANSM',
                                                    fontSize: 12),
                                              ),
                                            ]),
                                            SizedBox(
                                              height: 10.0,
                                            ),
                                            Row(children: [
                                              Text(
                                                item_price[index],
                                                style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontFamily: 'GSANSB',
                                                    fontSize: 13),
                                              ),
                                            ]),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 1.5,
                              color: Colors.grey[200],
                            );
                          },
                          itemCount: item_title.length);
                    }
                    return Container(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
                          child: Text(
                            "판매내역이 없습니다.",
                            style: TextStyle(
                                color: Color(0xff58585b),
                                fontFamily: 'GSANSM',
                                fontSize: 14),
                          )),
                    );
                  }
                })
          ],
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
    );
  }
}
