import 'package:flutter/material.dart';

class UserAccountInfo extends ChangeNotifier {
  String uid = '';
  String nickname = '';
  String gender = '';
  String fcmToken = '';
  String regDate = '';
  int matchWin = 0;
  int matchDraw = 0;
  int matchLose = 0;
  List<dynamic> marketChatItem = [];
  String profile_image = '';
  int reportCount = 0;

  String grade = '';
  
  String get _uid => uid;
  String get _nickname => nickname;
  String get _gender => gender;
  String get _fcmToken => fcmToken;
  String get _regDate => regDate;
  int get _matchWin => matchWin;
  int get _matchDraw => matchDraw;
  int get _matchLose => matchLose;
  String get _grade => grade;
  List<dynamic> get _marketChatItem => marketChatItem;

  void logIn(String uid_, String nickname_, String gender_, String fcmToken_, String regDate_, String imagePath, var marketChatItem_, var reportCount_ ) {
    uid = uid_;
    nickname = nickname_;
    gender = gender_;
    fcmToken = fcmToken_;
    regDate = regDate_;
    profile_image = imagePath;
    marketChatItem = marketChatItem_;
    reportCount = reportCount_;

    notifyListeners();
  }

  // void logIn(String uid_, String nickname_, String gender_, String fcmToken_, String regDate_) {
  //   uid = uid_;
  //   nickname = nickname_;
  //   gender = gender_;
  //   fcmToken = fcmToken_;
  //   regDate = regDate_;

  //   notifyListeners();
  // }

  void logOut() {
    nickname = '';
    gender = '';
    fcmToken = '';
    regDate = '';
    profile_image = '';
    marketChatItem = [];
    matchWin = 0;
    matchDraw = 0;
    matchLose = 0;

    notifyListeners();
  }

  void checkGrade(String grade_) {
    grade = grade_;
    notifyListeners();
  }
}