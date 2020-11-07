import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hinataPicks/classes/users.dart';
import 'package:hinataPicks/gameBoard/bottomAddCommentButton.dart';
import 'package:hinataPicks/setting/setting.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class BoardPage extends StatefulWidget {
  var collection;
  BoardPage({Key key, @required this.collection}) : super(key: key);
  @override
  BoardPageState createState() => BoardPageState();
}

class BoardPageState extends State<BoardPage> {
  List chatsList = [];
  var _messageCautionsList = ['ブロック', '報告'];
  var chatLength, customerImagePath;
  final _firebaseAuth = FirebaseAuth.instance.currentUser.uid;

  //外部URLへページ遷移(webviewではない)
  Future<void> _launchURL(String link) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: BottomAddCommentButton(
            collection: widget.collection, chatLength: chatLength),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(widget.collection)
                .orderBy('createAt', descending: true)
                .limit(160)
                .snapshots(),
            builder: (context, snapshot) {
              return (!snapshot.hasData)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [const Text('Now Loading...')],
                      ),
                    )
                  : (snapshot.data.docs.length == 0)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (widget.collection == 'friendChats')
                                  ? Image.asset(
                                      'assets/images/chat-hinakoi.png',
                                      scale: 1.4,
                                    )
                                  : Image.asset(
                                      'assets/images/chat-normal.png',
                                      scale: 1.4,
                                    ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final chatsItem = snapshot.data.docs[index];
                            chatLength = snapshot.data.docs.length;
                            DateTime createdTime =
                                chatsItem.data()['createAt'].toDate();
                            return (chatsItem.data()['name'] == '運営')
                                ? commentBox(chatsItem, createdTime)
                                : commentBox(chatsItem, createdTime);
                          },
                        );
            }));
  }

  Widget commentBox(chatsItem, createdTime) {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.13,
              height: MediaQuery.of(context).size.width * 0.13,
              decoration: BoxDecoration(
                  // border: Border.all(
                  //     color: Colors.grey, width: 5),
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: (chatsItem.data()['imagePath'] == null ||
                              chatsItem.data()['imagePath'] == '')
                          ? AssetImage('assets/images/HinataPicks-logo-new.png')
                          : NetworkImage(chatsItem.data()['imagePath']))),
            )),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5, left: 20),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                  color: Color(0xff7cc8e9),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatsItem.data()['name'],
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 13.2,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.52,
                          child: SelectableAutoLinkText(
                            chatsItem.data()['context'],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w300),
                            linkStyle:
                                const TextStyle(color: Colors.blueAccent),
                            highlightedLinkStyle: TextStyle(
                              color: Colors.blueAccent,
                              backgroundColor:
                                  Colors.blueAccent.withAlpha(0x33),
                            ),
                            onTap: (url) => _launchURL(url),
                            onLongPress: (url) => Share.share(url),
                          ))
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
              child: Text(
                createdTime.toLocal().toString().substring(
                      0,
                      createdTime.toLocal().toString().length - 7,
                    ),
                style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        PopupMenuButton<String>(
            icon: Icon(
              Icons.sms_failed_outlined,
              size: 23,
            ),
            itemBuilder: (BuildContext context) {
              return _messageCautionsList.map((String s) {
                return PopupMenuItem(
                  child: FlatButton(
                      onPressed: () {
                        if (s == 'ブロック') {
                          blockDialog(chatsItem);
                        }
                        if (s == '報告') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingPage()));
                        }
                      },
                      child: Text(s)),
                  value: s,
                );
              }).toList();
            })
      ],
    );
  }

  Future removeComment(String nowUser) async {
    await FirebaseFirestore.instance
        .collection(widget.collection)
        .doc(nowUser)
        .delete();
    return Navigator.pop(context);
  }

  blockDialog(chatsItem) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('警告'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('本当にブロックしますか?'),
                  Text(
                    '不適切と判断した場合のみ',
                    style: TextStyle(fontSize: 13),
                  ),
                  Text(
                    '当コメントが削除されます',
                    style: TextStyle(fontSize: 13),
                  )
                ],
              ),
            ),
            actions: [
              FlatButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('usersContactForm')
                        .add({
                      'uid': _firebaseAuth,
                      'cautionUid': chatsItem.data()['userUid'],
                      'cautionContext': chatsItem.data()['context'],
                      'createAt': Timestamp.now(),
                    });
                    Navigator.pop(context);
                  },
                  child: Text('はい')),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('いいえ'))
            ],
          );
        });
  }
}
