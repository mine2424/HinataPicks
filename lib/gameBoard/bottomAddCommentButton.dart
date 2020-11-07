import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hinataPicks/homeSection.dart';
import 'package:hinataPicks/prohibitionMatter/prohibitionWord.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomAddCommentButton extends StatefulWidget {
  var collection, chatLength;
  BottomAddCommentButton({Key key, @required this.collection, this.chatLength})
      : super(key: key);
  @override
  _BottomAddCommentButtonState createState() => _BottomAddCommentButtonState();
}

class _BottomAddCommentButtonState extends State<BottomAddCommentButton> {
  String name, content;
  int like;
  Timestamp createAt;
  bool isSending = false;
  final approbation = 'https://hinatapicks.web.app/';
  //匿名ログインのuser uid取得

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  addComment(collection) async {
    if (_formKey.currentState.validate()) {
      String userImagePath, tempImagePath;
      final _firebaseAuth = FirebaseAuth.instance.currentUser.uid;
      this.isSending = true;
      _formKey.currentState.save();
      // 各boardのcollectionを取得
      final sendComment = FirebaseFirestore.instance.collection(collection);
      // boradのコメントの個数を取得
      final commentLength =
          await FirebaseFirestore.instance.collection(collection).get();
      // 各Userで画像を取得
      final sendUserInfoDoc = FirebaseFirestore.instance
          .collection('customerInfo')
          .doc(_firebaseAuth);
      final sendUserInfoQuery = await sendUserInfoDoc.get();
      final sendUserInfo = sendUserInfoQuery.get('imagePath');
      if (sendUserInfo != null) {
        userImagePath = sendUserInfo;
      }
      sendComment.doc((commentLength.docs.length + 1).toString()).set({
        'userUid': _firebaseAuth,
        'name': name,
        'context': content,
        'like': 0,
        'imagePath': userImagePath,
        'createAt': Timestamp.now()
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeSection()));
    }
  }

  //外部URLへページ遷移(webviewではない)
  static _launchURL(String link) async {
    if (await canLaunch(link)) {
      await launch(
        link,
        universalLinksOnly: true,
        forceSafariVC: true,
        forceWebView: false,
      );
    } else {
      throw 'サイトを開くことが出来ません。。。 $link';
    }
  }

  TapGestureRecognizer _recognizer = TapGestureRecognizer()
    ..onTap = () {
      _launchURL('https://hinatapicks.web.app/');
    };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 55),
      child: FloatingActionButton(
        onPressed: () {
          return showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text('投稿'),
                    content: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (input) {
                                if (input == '運営' || input == 'うんえい') {
                                  return 'その名前は使えません';
                                }
                                for (var i = 0;
                                    i < prohibisionWords.length;
                                    i++) {
                                  if (input.contains(prohibisionWords[i])) {
                                    return '不適切な言葉が含まれています';
                                  }
                                }
                              },
                              onSaved: (input) {
                                name = input;
                                if (input.isEmpty) {
                                  name = '匿名おひさまさん';
                                }
                              },
                              decoration:
                                  const InputDecoration(labelText: '名前'),
                            ),
                            // Text(''),
                            TextFormField(
                              validator: (input) {
                                for (var i = 0;
                                    i < prohibisionWords.length;
                                    i++) {
                                  if (input.contains(prohibisionWords[i])) {
                                    return '不適切な言葉が含まれています';
                                  }
                                  if (input.isEmpty) {
                                    return '投稿内容を入力してください';
                                  } else {
                                    return null;
                                  }
                                }
                              },
                              onSaved: (input) => content = input,
                              decoration:
                                  const InputDecoration(labelText: '投稿内容'),
                            ),
                            const SizedBox(height: 15),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '投稿すると',
                                    style: TextStyle(color: Colors.grey[800]),
                                  ),
                                  TextSpan(
                                    text: '利用規約',
                                    style: TextStyle(color: Colors.lightBlue),
                                    recognizer: _recognizer,
                                  ),
                                  TextSpan(
                                    text: 'に同意したものとみなします。',
                                    style: TextStyle(color: Colors.grey[800]),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('キャンセル')),
                      FlatButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              // TextFormFieldのonSavedが呼び出される
                              _formKey.currentState.save();
                              addComment(widget.collection);
                            }
                          },
                          child: const Text('投稿'))
                    ],
                  ));
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xff7cc8e9),
      ),
    );
  }
}
