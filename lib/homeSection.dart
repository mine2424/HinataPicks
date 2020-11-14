import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hinataPicks/gameBoard/board.dart';
import 'package:hinataPicks/gameBoard/boardSelect.dart';
import 'package:hinataPicks/setting/profile.dart';
import 'package:hinataPicks/setting/setting.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Blog/Blog.dart';

class HomeSection extends StatefulWidget {
  @override
  _HomeSectionState createState() => _HomeSectionState();
}

enum BottomIcons { Blog, Video, Archive, Other }

class _HomeSectionState extends State<HomeSection> {
  BottomIcons bottomIcons = BottomIcons.Video;
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
  initState() {
    anonymouslyLogin();
    reviewDialog();
    super.initState();
  }

  Future reviewDialog() async {
    var fetchReviewCount = await FirebaseFirestore.instance
        .collection('customerInfo')
        .doc(_firebaseAuth)
        .get();
    int reviewCount = fetchReviewCount.data()['reviewCount'];
    if (reviewCount % 10 == 0) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('お願い'),
                content: Text('HinataPicksの関するレビュー・ご要望等を書いていただけたら幸いです！'),
                actions: [
                  FlatButton(
                      onPressed: () {
                        LaunchReview.launch(iOSAppId: "1536579253");
                      },
                      child: Text('レビューを書く')),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('書かない'))
                ],
              ));
    }
  }

  Future anonymouslyLogin() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signInAnonymously();
    final doc = FirebaseFirestore.instance
        .collection('customerInfo')
        .doc(firebaseAuth.currentUser.uid)
        .get();
    doc.then((doc) async {
      if (doc.exists) {
        print("cheked document!");
        final reviewCount = doc.data()['reviewCount'];
        if (reviewCount == null) {
          FirebaseFirestore.instance
              .collection('customerInfo')
              .doc(firebaseAuth.currentUser.uid)
              .update({'reviewCount': 1});
        } else {
          FirebaseFirestore.instance
              .collection('customerInfo')
              .doc(firebaseAuth.currentUser.uid)
              .update({'reviewCount': reviewCount + 1});
        }
      } else {
        print("No such document!");
        await FirebaseFirestore.instance
            .collection('customerInfo')
            .doc(firebaseAuth.currentUser.uid)
            .set({
          'uid': firebaseAuth.currentUser.uid,
          'like': 0,
          'message': '',
          'gameId': '',
          'twitter': '',
          'insta': '',
          'name': '',
          'imagePath': '',
          'reviewCount': 0,
          'createAt': Timestamp.now()
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //TabController _tabController;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text("HinataPicks", style: TextStyle(color: Colors.black)),
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0,
            brightness: Brightness.light,
            centerTitle: true,
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                    child: Column(
                  children: [
                    const Text('アプリについて'),
                  ],
                )),
                Divider(),
                ListTile(
                  title: const Text(
                    'お問い合わせ',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingPage()));
                  },
                ),
                ListTile(
                  title: const Text(
                    '利用規約',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    _launchURL('https://hinatapicks.web.app/');
                  },
                ),
                ListTile(
                  title: const Text(
                    'レビューを書く',
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    LaunchReview.launch(iOSAppId: "1536579253");
                  },
                ),
                const ListTile(
                  title: const Text(
                    'version 1.0.6',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              bottomIcons == BottomIcons.Blog ? BlogPage() : Container(),
              bottomIcons == BottomIcons.Video ? BoardSelect() : Container(),
              bottomIcons == BottomIcons.Other ? ProfilePage() : Container(),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 60, right: 60, bottom: 36),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                bottomIcons = BottomIcons.Video;
                              });
                            },
                            child: bottomIcons == BottomIcons.Video
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.indigo.shade100
                                            .withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.chat,
                                          color: Colors.indigo,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text('掲示板',
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))
                                      ],
                                    ),
                                  )
                                : Icon(Icons.chat)),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                bottomIcons = BottomIcons.Blog;
                              });
                            },
                            child: bottomIcons == BottomIcons.Blog
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.indigo.shade100
                                            .withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.book,
                                          color: Colors.indigo,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text('ブログ',
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))
                                      ],
                                    ),
                                  )
                                : Icon(Icons.book)),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                bottomIcons = BottomIcons.Other;
                              });
                            },
                            child: bottomIcons == BottomIcons.Other
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.indigo.shade100
                                            .withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.people,
                                          color: Colors.indigo,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text('設定',
                                            style: TextStyle(
                                                color: Colors.indigo,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15))
                                      ],
                                    ),
                                  )
                                : Icon(Icons.people)),
                      ],
                    ),
                  ))
            ],
          )),
    );
  }
}
