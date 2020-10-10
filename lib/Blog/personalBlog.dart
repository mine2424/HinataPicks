import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PersonalBlogPage extends StatelessWidget {
  var profile;
  var blogData;
  var sortBlogData;
  PersonalBlogPage({Key key, @required this.profile, @required this.blogData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF21BFBD),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: 500,
              width: 300,
            ),
            Positioned(
              child: Text(this.profile.get('name')),
              top: 50,
              left: -40,
            ),
            DraggableScrollableSheet(
              maxChildSize: 0.85,
              builder:
                  (BuildContext context, ScrollController scrolController) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: ListView.builder(
                    controller: scrolController,
                    //shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
                    itemCount: this.sortBlogData.length,
                    itemBuilder: (context, index) {
                      //sortBlogData.addAll(this.blogData[index].get('title').where((elem) => elem.contain(this.profile.get('name'))));
                      for (int i = 0; i < this.blogData.length; i++) {
                        if (blogData[i]
                            .get('title')
                            .contains(profile.get('name'))) {
                          print(index);
                          this.sortBlogData.add(blogData[i].toString());
                        }
                      }

                      return ListTile(
                        title: Text(this.sortBlogData.toString()),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ));
  }

//firebase storageを使ったjsonファイルのデータ取得コード（貴重）
  printUrl() async {
    StorageReference ref =
        FirebaseStorage.instance.ref().child("hinata/pyBlogArticle.json");
    String url = (await ref.getDownloadURL()).toString();
    //print(url);
    final response = await http.get(url);
    final ListData = jsonDecode(utf8.decode(response.body.runes.toList()));
    print(ListData["7"]['page_number']['title']);
  }
}
