import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hinataPicks/gameBoard/board.dart';

class BoardSelect extends StatefulWidget {
  @override
  _BoardSelectState createState() => _BoardSelectState();
}

class _BoardSelectState extends State<BoardSelect> {
  TabController _tabController;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.black.withOpacity(0.5),
                  unselectedLabelStyle: TextStyle(fontSize: 13.0),
                  labelColor: Colors.black,
                  labelStyle: TextStyle(fontSize: 16.0),
                  indicatorColor: Colors.black,
                  indicatorWeight: 2.0,
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'ひなこい'),
                    Tab(text: '雑談'),
                    Tab(text: '出演番組観戦'),
                  ],
                ), // TabBar
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BoardPage(collection: 'friendChats'),
              BoardPage(collection: 'discussionChats'),
              BoardPage(collection: 'otherChats')
            ],
          ),
        ),
      ),
    );
  }
}
