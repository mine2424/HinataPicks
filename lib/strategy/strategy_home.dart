import 'package:hinataPicks/importer.dart';

class StrategyHomePage extends StatefulWidget {
  @override
  _StrategyHomePageState createState() => _StrategyHomePageState();
}

class _StrategyHomePageState extends State<StrategyHomePage> {
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
                    Tab(text: 'キャラランキング'),
                    Tab(text: 'お知らせ'),
                    Tab(text: 'リセマラ'),
                  ],
                ), // TabBar
              ],
            ),
          ),
          body: TabBarView(children: [
            WebView(
              key: GlobalKey(),
              initialUrl:
                  'https://keyaki-hinata-46.com/hinakoi/saikyou-hinakoi/',
            ),
            WebView(
              key: GlobalKey(),
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: 'https://twitter.com/hinakoiofficial',
            ),
            WebView(
              key: GlobalKey(),
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl:
                  'https://keyaki-hinata-46.com/hinakoi/risemara-hinakoi/',
            ),
          ]),
        ),
      ),
    );
  }
}
