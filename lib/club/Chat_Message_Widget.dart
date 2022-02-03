import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessageWidget extends StatefulWidget {
  final String doc_get_user_uid;
  final String comment;
  final String user_nick_name;
  final String check_user_uid;
  const ChatMessageWidget(
      {Key? key,
      required this.doc_get_user_uid,
      required this.comment,
      required this.user_nick_name,
      required this.check_user_uid})
      : super(key: key);

  @override
  _ChatMessageWidgetState createState() => _ChatMessageWidgetState(
      doc_get_user_uid, comment, user_nick_name, check_user_uid);
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  String get_doc_user_uid = "";
  String comment_text = "";
  String nick_name = "";
  String check_uid = "";
  User user = FirebaseAuth.instance.currentUser!;

  _ChatMessageWidgetState(
      this.get_doc_user_uid, this.comment_text, this.nick_name, this.check_uid);
  @override
  Widget build(BuildContext context) {
    var isMe = get_doc_user_uid == check_uid;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                // padding: EdgeInsets.symmetric(horizontal: 13),
                padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
                child: Text(
                  nick_name,
                  style: TextStyle(fontFamily: 'GSANSM'),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  decoration: BoxDecoration(
                      color: isMe ? Colors.yellow : Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(isMe ? 10 : 0),
                          topRight: Radius.circular(isMe ? 0 : 10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Text(
                    comment_text,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'GSANSM'),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
