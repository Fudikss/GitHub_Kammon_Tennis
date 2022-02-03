import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/match/match_play_doubles_1_0.dart';
import 'package:snstennis/match/match_play_single_kdk_1_0.dart';

class StartGame extends StatefulWidget {
  const StartGame({ Key? key, required this.matchUid, required this.prevPage, required this.matchType }) : super(key: key);

  final String matchUid;
  final String prevPage;
  final int matchType;
  
  @override
  _StartGameState createState() => _StartGameState(matchUid, prevPage, matchType);
}

class _StartGameState extends State<StartGame> with TickerProviderStateMixin{
  late Timer _userTimer;
  late UserAccountInfo user_account_info_;

  late AnimationController _controller;
  late Animation<double> _animation;

  final String matchUid;
  final String prevPage;
  final int matchType;

  _StartGameState(this.matchUid, this.prevPage, this.matchType);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _userTimer = Timer(Duration(milliseconds: 3000), () {
      Navigator.of(context).pop();  
      if(matchType == 0) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MatchPlaySingleKDK(matchUid: matchUid, prevPage: 'wait_list',)
          )
        );
      }
      else if(matchType == 1) {
        
      }
      else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MatchPlayDoubles(matchUid: matchUid, prevPage: 'wait_list',)
          )
        );

        //_insertUserJoinMatch();
      }
    });

    _controller = AnimationController(
          duration: const Duration(milliseconds: 3000),
          vsync: this,
          value: 0.25,
          lowerBound: 0.25,
          upperBound: 1.0
      );
      _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  
      _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    user_account_info_ = Provider.of<UserAccountInfo>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: 
        SafeArea(
          child: Center(
            child: Stack(
              children: [                
                Align(
                  alignment: Alignment(0.0, 0.0),
                  child: RotationTransition(
                      turns: _animation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          SvgPicture.asset('assets/images/SVG/dice.svg', width: 110,),
                        ]
                      )
                    ),
                ),
                // Align(
                //   alignment: Alignment(0.0, 0.0),
                //   child: Text('매치 준비 중...', style: TextStyle(fontFamily: 'SBB', fontSize: 24, color: Theme.of(context).primaryColor),)
                // ),
                Align(
                  alignment: Alignment(0.0, 0.0),
                  child: SizedBox(
                    width: 200,
                    height: 200,
                      child: CircularProgressIndicator(
                        strokeWidth: 10,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColorLight),
                    ) 
                  ),
                ),
                Align(
                  alignment: Alignment(0.0, 0.4),
                  child: 
                    Text("LET'S COMON !", style: Theme.of(context).textTheme.headline1,)
                )
              ],
            )
      ),)
    );
  }
}