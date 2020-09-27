import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hinataPicks/Blog/BlogCard.dart';
import 'package:hinataPicks/Blog/personalBlog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  var downloadUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // TODO お気に入りメンバーの登録 || それのみ表示
        // TODO 匿名ログインが必要になる
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('blogArticle')
              .orderBy('id', descending: false)
              //.orderBy('createAt')
              .limit(20)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.docs.length == 0) {
              return Container(
                child: Center(
                  child: GFLoader(type: GFLoaderType.circle),
                ),
              );
            } else {
              final snapData = snapshot.data.docs;
              return Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "New Blog",
                          style: TextStyle(fontSize: 36.0, letterSpacing: 1.0),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: snapData.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 0),
                          child: FlatButton(
                            onPressed: () => setState(() {
                              _launchURL(snapData[index].get('url'));
                            }),
                            child: BlogCardWidget(
                              dataDocs: snapshot.data.docs[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 50),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Search Member",
                            style:
                                TextStyle(fontSize: 36.0, letterSpacing: 1.0),
                          )
                        ],
                      )),
                  SizedBox(height: 11),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('memberLists')
                          .orderBy('id', descending: false)
                          .limit(22)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.data.docs.length == 0) {
                          return Container(
                            child: Center(
                              child: GFLoader(type: GFLoaderType.circle),
                            ),
                          );
                        } else {
                          final memberList = snapshot.data.docs;
                          return Column(
                            //TODO 個別ページに遷移させる
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 46),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "1期生",
                                        style: TextStyle(
                                            fontSize: 24.0, letterSpacing: 0.7),
                                      )
                                    ],
                                  )),
                              Column(children: [
                                SizedBox(
                                    height: 140,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: memberList.length - 13,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(left: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FlatButton(
                                                //TODO 引数としてblogArticle全てのブログデータと選択した人の名前を入れる
                                                onPressed: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PersonalBlogPage(
                                                                profile:
                                                                    memberList[
                                                                        index],
                                                                blogData:
                                                                    snapData))),
                                                child: Container(
                                                  width: 97,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                            memberList[index].get(
                                                                'profile_img'),
                                                          ))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ))
                              ]),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 46),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "2期生",
                                        style: TextStyle(
                                            fontSize: 24.0, letterSpacing: 0.7),
                                      )
                                    ],
                                  )),
                              Column(
                                children: [
                                  SizedBox(
                                      height: 140,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: memberList.length - 13,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(left: 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FlatButton(
                                                  onPressed: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PersonalBlogPage(
                                                                  profile:
                                                                      memberList[9 +
                                                                          index],
                                                                  blogData:
                                                                      snapData))),
                                                  child: Container(
                                                    width: 97,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                              memberList[
                                                                      9 + index]
                                                                  .get(
                                                                      'profile_img'),
                                                            ))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ))
                                ],
                              ),
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 46),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "3期生",
                                        style: TextStyle(
                                            fontSize: 24.0, letterSpacing: 0.7),
                                      )
                                    ],
                                  )),
                              Column(
                                children: [
                                  SizedBox(
                                      height: 140,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: memberList.length - 18,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(left: 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FlatButton(
                                                  onPressed: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PersonalBlogPage(
                                                                  profile:
                                                                      memberList[18 +
                                                                          index],
                                                                  blogData:
                                                                      snapData))),
                                                  child: Container(
                                                    width: 97,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                              memberList[18 +
                                                                      index]
                                                                  .get(
                                                                      'profile_img'),
                                                            ))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ))
                                ],
                              ),
                            ],
                          );
                        }
                      }),
                  SizedBox(
                    height: 70,
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _launchURL(String link) async {
    if (await canLaunch(link)) {
      await launch(
        link,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'サイトを開くことが出来ません。。。 $link';
    }
  }
}

// FlatButton(
//   onPressed: () => setState(() {
//     _launchURL(_blogList.get('url'));
//   }),
//   child:
