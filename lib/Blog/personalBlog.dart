import 'package:flutter/material.dart';

class PersonalBlogPage extends StatelessWidget {
  var profile;
  var blogData;
  PersonalBlogPage({Key key, @required this.profile, @required this.blogData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF21BFBD),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_back),
                          color: Colors.white,
                        ),
                        Container(
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.settings),
                                  color: Colors.white,
                                  onPressed: () {})
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Stack(children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Image(
                        image: NetworkImage(this.profile.get('profile_img')),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ]),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(65),
                            topRight: Radius.circular(65))),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 300,
                      child: ListView(
                        children: [],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
