import 'package:hinataPicks/notification.dart';
import 'package:hinataPicks/pole/pole.dart';

import 'importer.dart';

class HomeSection extends StatefulWidget {
  @override
  _HomeSectionState createState() => _HomeSectionState();
}

enum BottomIcons { Blog, Video, Ranking, Other }

class _HomeSectionState extends State<HomeSection> {
  BottomIcons bottomIcons = BottomIcons.Video;
  bool isLoading = true;

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
    super.initState();
    anonymouslyLogin();
    initializeFirestore();
    initNotification();
    _isPole();
    reviewDialog();
  }

  @override
  dispose() {
    super.dispose();
  }

  Future<void> anonymouslyLogin() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> initializeFirestore() async {
    final _userUid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('customerInfo')
        .doc(_userUid)
        .get()
        .then((doc) async {
      if (doc.exists) {
        print("cheked document!");
        if (doc.data()['reviewCount'] == null) {
          await FirebaseFirestore.instance
              .collection('customerInfo')
              .doc(_userUid)
              .update({'reviewCount': 1});
        } else {
          await FirebaseFirestore.instance
              .collection('customerInfo')
              .doc(_userUid)
              .update({'reviewCount': doc.data()['reviewCount'] + 1});
        }
      } else {
        print("No such document!");
        await FirebaseFirestore.instance
            .collection('customerInfo')
            .doc(_userUid)
            .set({
          'uid': _userUid,
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

  Future reviewDialog() async {
    var fetchReviewCount = await FirebaseFirestore.instance
        .collection('customerInfo')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (fetchReviewCount.data()['reviewCount'] % 10 == 0 ||
        fetchReviewCount.data()['reviewCount'] == 2) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('お願い'),
          content: const Text('ひなこいチャットの関するレビュー・ご要望等を書いていただけたら幸いです！'),
          actions: [
            FlatButton(
                onPressed: () {
                  LaunchReview.launch(
                      iOSAppId: "1536579253",
                      androidAppId: 'app.mine.hinataPicks');
                },
                child: const Text('レビューを書く')),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('書かない'))
          ],
        ),
      );
    }
  }

  Future<void> _isPole() async {
    final uid = FirebaseAuth.instance.currentUser.uid;
    final isPoleDoc = await FirebaseFirestore.instance
        .collection('customerInfo')
        .doc(uid)
        .get();
    if (isPoleDoc.data()['twitter'] == null ||
        isPoleDoc.data()['twitter'] == '') {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => PolePage()));
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isLoading)
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Now Loading...',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w300))
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("ひなこいチャット", style: TextStyle(color: Colors.black)),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingPage()));
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
                      LaunchReview.launch(
                          iOSAppId: "1536579253",
                          androidAppId: 'app.mine.hinataPicks');
                    },
                  ),
                  const ListTile(
                    title: const Text(
                      'version 1.1.8',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                bottomIcons == BottomIcons.Blog ? BlogPage() : Container(),
                bottomIcons == BottomIcons.Video ? BoardPage() : Container(),
                bottomIcons == BottomIcons.Ranking
                    ? StrategyHomePage()
                    : Container(),
                bottomIcons == BottomIcons.Other ? ProfilePage() : Container(),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 60, right: 60, bottom: 36),
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
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 8,
                                          bottom: 8),
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
                                  bottomIcons = BottomIcons.Ranking;
                                });
                              },
                              child: bottomIcons == BottomIcons.Ranking
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Colors.indigo.shade100
                                              .withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      padding: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 8,
                                          bottom: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.new_releases,
                                            color: Colors.indigo,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text('ひなこい',
                                              style: TextStyle(
                                                  color: Colors.indigo,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15))
                                        ],
                                      ),
                                    )
                                  : Icon(Icons.new_releases)),
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
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 8,
                                          bottom: 8),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.book,
                                            color: Colors.indigo,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const Text('ブログ',
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
                                          left: 16,
                                          right: 16,
                                          top: 8,
                                          bottom: 8),
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
            ));
  }
}
