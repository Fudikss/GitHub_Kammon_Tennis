import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snstennis/account/add_member_info.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loginState = false;
  
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithKakao() async {
    var data;
    final clientState = Uuid().v4();
    final url = Uri.https('kauth.kakao.com', '/oauth/authorize', {
      'response_type': 'code',
      'client_id': "408cf0666d978020920b80917cae3aa7",
      'response_mode': 'form_post',
      'redirect_uri':
          'https://gratis-lucky-cap.glitch.me/callbacks/kakao/sign_in',
      'scope': 'profile_nickname gender account_email',
      'state': clientState,
    });

    final result = await FlutterWebAuth.authenticate(
        url: url.toString(),
        callbackUrlScheme: "webauthcallback"); //"applink"//"signinwithapple"
    final body = Uri.parse(result).queryParameters;
    print(body["code"]);

    final tokenUrl = Uri.https('kauth.kakao.com', '/oauth/token', {
      'grant_type': 'authorization_code',
      'client_id': "408cf0666d978020920b80917cae3aa7",
      'redirect_uri':
          'https://gratis-lucky-cap.glitch.me/callbacks/kakao/sign_in',
      'code': body["code"],
    });
    var responseTokens = await http.post(tokenUrl);
    Map<String, dynamic> bodys = json.decode(responseTokens.body);
    var response = await http.post(
      Uri.parse('https://gratis-lucky-cap.glitch.me/callbacks/kakao/token'),
      body: {"accessToken": bodys['access_token']}
    );
    return FirebaseAuth.instance.signInWithCustomToken(response.body);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loginState == false ?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_big.svg', width: 140,), 
              SizedBox(height: 60,),
              Container(
                child: InkWell(
                  //onTap: signInWithKakao,
                  onTap: () async {
                    setState(() {
                      loginState = true;
                    });
                    final clientState = Uuid().v4();
                    final url = Uri.https('kauth.kakao.com', '/oauth/authorize', {
                      'response_type': 'code',
                      'client_id': "408cf0666d978020920b80917cae3aa7",
                      'response_mode': 'form_post',
                      'redirect_uri':
                          'https://gratis-lucky-cap.glitch.me/callbacks/kakao/sign_in',
                      'scope': 'profile_nickname gender account_email',
                      'state': clientState,
                    });

                    final result = await FlutterWebAuth.authenticate(
                        url: url.toString(),
                        callbackUrlScheme: "webauthcallback"); 
                    final body = Uri.parse(result).queryParameters;
                    
                    final tokenUrl = Uri.https('kauth.kakao.com', '/oauth/token', {
                      'grant_type': 'authorization_code',
                      'client_id': "408cf0666d978020920b80917cae3aa7",
                      'redirect_uri':
                          'https://gratis-lucky-cap.glitch.me/callbacks/kakao/sign_in',
                      'code': body["code"],
                    });
                    var responseTokens = await http.post(tokenUrl);
                    Map<String, dynamic> bodys = json.decode(responseTokens.body);
                    var response = await http.post(
                      Uri.parse('https://gratis-lucky-cap.glitch.me/callbacks/kakao/token'),
                      body: {"accessToken": bodys['access_token']}
                    );

                    await FirebaseAuth.instance.signInWithCustomToken(response.body);
                  },
                  child: Image.asset('assets/images/PNG/kakao_login_large_narrow.png', height: 50,),
                ),
              ),
              SizedBox(height: 20,),
              SignInButton(
                Buttons.Google,
                //onPressed: signInWithGoogle,
                onPressed: () async{
                  setState(() {
                      loginState = true;
                  });

                  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

                  // Obtain the auth details from the request
                  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

                  // Create a new credential
                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth?.accessToken,
                    idToken: googleAuth?.idToken,
                  );
                  // Once signed in, return the UserCredential
                  await FirebaseAuth.instance.signInWithCredential(credential);
                },
              ),
              SizedBox(height: 20,),
              SignInButton(
                Buttons.FacebookNew,
                //onPressed: signInWithFacebook,
                onPressed: () async {
                  // Trigger the sign-in flow
                  final LoginResult loginResult = await FacebookAuth.instance.login();

                  // Create a credential from the access token
                  final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

                  // Once signed in, return the UserCredential
                  FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
                  // showDialog(
                  //   context: context, 
                  //   builder: 
                  // builder)
                },
              ),
            ],
          ),
        )
        :
        Center(
          child: Container(
            color: Colors.white,
            child: Center(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(0.0, 0.0),
                  child: SvgPicture.asset('assets/images/SVG/LOGO_KAMMON_small.svg', width: 150,),
                ),
              ],
            ))
          )
        )
    );
  }
}