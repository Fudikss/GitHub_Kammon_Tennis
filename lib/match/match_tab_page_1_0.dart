import 'package:snstennis/match/match_end_list_1_0.dart';
import 'package:snstennis/match/match_play_list_1_0.dart';
import 'package:snstennis/match/match_wait_list_1_0.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MatchTabPage extends StatefulWidget {
  const MatchTabPage({ Key? key }) : super(key: key);

  @override
  _MatchTabPageState createState() => _MatchTabPageState();
}

class _MatchTabPageState extends State<MatchTabPage> with SingleTickerProviderStateMixin{
  late TabController tab_controller;

  @override
  void initState() {
    tab_controller = TabController(length: 3, vsync: this);
    super.initState();  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey),
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: 
          SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 110,),
        bottom: DecoratedTabBar(
          tabBar: TabBar(
            controller: tab_controller,
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 4,
            labelColor: Color(0xff58585b),
            unselectedLabelColor: Color(0xff9f9f9f),
            labelStyle: TextStyle(fontFamily: 'GSANSB', fontSize: 14,),
            unselectedLabelStyle: TextStyle(fontFamily: 'GSANSB', fontSize: 14),
            labelPadding: EdgeInsets.fromLTRB(0, 0, 0, 8),
            tabs: [
              Text('대기'),
              Text('진행'),
              Text('기록'),
            ],
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xffedecec),
                width: 0.8,
              ),
            ),
          ),
        ),
      )
      )
      ,
      body: TabBarView(
        controller: tab_controller,
        children: [
          MatchWaitList(),
          MatchPlayList(),
          MatchEndList(),
        ]),
    );
  }
}

class DecoratedTabBar extends StatelessWidget implements PreferredSizeWidget {
  DecoratedTabBar({required this.tabBar, required this.decoration});

  final TabBar tabBar;
  final BoxDecoration decoration;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: 
            Container(decoration: decoration)
        ),
        tabBar,
      ],
    );
  }
}