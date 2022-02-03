import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:snstennis/account/user_account_info.dart';
import 'package:snstennis/match/match_wait.dart';

class EnterGameSplash extends StatefulWidget {
  const EnterGameSplash({ Key? key, required this.matchUid, required this.masterUid}) : super(key: key);

  final String matchUid;
  final String masterUid;

  @override
  _EnterGameSplashState createState() => _EnterGameSplashState(matchUid, masterUid);
}

class _EnterGameSplashState extends State<EnterGameSplash> with TickerProviderStateMixin{
  _EnterGameSplashState(this.matchUid, this.masterUid);
  final String matchUid;
  final String masterUid;
  late Timer _userTimer;
  late UserAccountInfo user_account_info_;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userTimer = Timer(Duration(milliseconds: 2000), () {
      Navigator.of(context).pop();

      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MatchWait(match_uid: matchUid, master_uid: masterUid,)
          )
      );
    });

    _controller = AnimationController(
          duration: const Duration(milliseconds: 2000),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Text('입장하는 중...', style: TextStyle(fontFamily: 'GSANSM', color: Theme.of(context).primaryColor, fontSize: 18))
                    ]
                  ),
                ),
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
              ],
            )
      ),)
    );
  }
}