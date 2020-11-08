import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hinataPicks/classes/friendChatClass.dart';
import 'package:hinataPicks/classes/users.dart';
import 'package:hinataPicks/homeSection.dart';
import 'package:hinataPicks/models/boardModel.dart';
import 'package:hinataPicks/prohibitionMatter/prohibitionWord.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomAddCommentButton extends StatefulWidget {
  var chatLength;
  String collection;
  String firebaseAuth;
  BottomAddCommentButton(
      {Key key, @required this.collection, this.chatLength, this.firebaseAuth})
      : super(key: key);
  @override
  _BottomAddCommentButtonState createState() => _BottomAddCommentButtonState();
}

class _BottomAddCommentButtonState extends State<BottomAddCommentButton> {
  String name, content;
  int like;
  Timestamp createAt;
  bool isSending = false;
  var customerModel;
  final approbation = 'https://hinatapicks.web.app/';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  addComment(collection, customerModel) async {
    if (_formKey.currentState.validate()) {
      String userImagePath, userName;
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
      final sendUserImageInfo = sendUserInfoQuery.get('imagePath');
      if (sendUserImageInfo != null) {
        userImagePath = sendUserImageInfo;
      }
      if (customerModel.name == '') {
        userName = '匿名おひさまさん';
      } else {
        userName = customerModel.name;
      }
      sendComment.doc((commentLength.docs.length + 1).toString()).set({
        'userUid': _firebaseAuth,
        'name': userName,
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
    return ChangeNotifierProvider<BoardModel>(
        create: (_) => BoardModel()..fetchCustomerInfo(),
        child: Consumer<BoardModel>(builder: (context, model, child) {
          customerModel = model.customerInfo;
          return (model.isLoading)
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ))
              : Container(
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
                                        (customerModel.name == '')
                                            ? Text('匿名おひさまさん')
                                            : Text(customerModel.name),
                                        TextFormField(
                                          validator: (input) {
                                            for (var i = 0;
                                                i < prohibisionWords.length;
                                                i++) {
                                              if (input.contains(
                                                  prohibisionWords[i])) {
                                                return '不適切な言葉が含まれています';
                                              }
                                              if (input.isEmpty) {
                                                return '投稿内容を入力してください';
                                              } else {
                                                return null;
                                              }
                                            }
                                            return null;
                                          },
                                          onSaved: (input) => content = input,
                                          decoration: const InputDecoration(
                                              labelText: '投稿内容'),
                                        ),
                                        const SizedBox(height: 15),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '投稿すると',
                                                style: TextStyle(
                                                    color: Colors.grey[800]),
                                              ),
                                              TextSpan(
                                                text: '利用規約',
                                                style: TextStyle(
                                                    color: Colors.lightBlue),
                                                recognizer: _recognizer,
                                              ),
                                              TextSpan(
                                                text: 'に同意したものとみなします。',
                                                style: TextStyle(
                                                    color: Colors.grey[800]),
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
                                          addComment(
                                              widget.collection, customerModel);
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
        }));
  }
}
