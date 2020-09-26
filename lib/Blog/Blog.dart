import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/getwidget.dart';

class BlogPage extends StatefulWidget {
  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  var downloadUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7CC7E8),
        elevation: 0,
        brightness: Brightness.light,
        centerTitle: true,
        title: Text(
          'HinataPicks',
          style: TextStyle(fontFamily: 'serif'),
        ),
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      child: Column(
                        children: <Widget>[
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('blogArticle')
                                // .orderBy('createAt', descending: true)
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
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.docs.length,
                                  // separatorBuilder: (context, index) =>
                                  //     Divider(),
                                  itemBuilder: (context, index) {
                                    final _blogList = snapshot.data.docs[index];
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20.0, 5.0, 20.0, 5.0),
                                            height: 160,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: Image(
                                                          width: 102,
                                                          // height: 160,
                                                          image: NetworkImage(
                                                              _blogList.get(
                                                                  'imageUrl')),
                                                          fit: BoxFit.fitWidth,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 30,
                                                      ),
                                                      Container(
                                                        width: 160,
                                                        child: Text(
                                                          (_blogList
                                                              .get('title')
                                                              .toString()),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          maxLines: 5,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ]),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
