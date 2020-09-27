import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hinataPicks/Blog/BlogCard.dart';
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
              .limit(10)
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
                          padding: EdgeInsets.only(left: 30),
                          child: BlogCardWidget(
                            dataDocs: snapshot.data.docs[index],
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
                            "Search Blog",
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
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: memberList.length - 12,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(left: 30),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 100,
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
                                      height: 150,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: memberList.length - 9,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(left: 30),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 100,
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
                                      height: 150,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: memberList.length - 18,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(left: 30),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                            memberList[
                                                                    18 + index]
                                                                .get(
                                                                    'profile_img'),
                                                          ))),
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
