import 'package:flutter/material.dart';
import 'package:hinataPicks/models/boardModel.dart';
import 'package:provider/provider.dart';

class BoardUserInfoPage extends StatefulWidget {
  var userUid;
  BoardUserInfoPage({Key key, this.userUid}) : super(key: key);
  @override
  _BoardUserInfoPageState createState() => _BoardUserInfoPageState();
}

class _BoardUserInfoPageState extends State<BoardUserInfoPage> {
  var consumerModel;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BoardModel>(
        create: (_) => BoardModel()..fetchSelectedCustomerInfo(widget.userUid),
        child: Consumer<BoardModel>(builder: (context, model, child) {
          consumerModel = model.customerInfo;
          return Scaffold(
              appBar: AppBar(
                title:
                    Text("HinataPicks", style: TextStyle(color: Colors.black)),
                iconTheme: const IconThemeData(color: Colors.black),
                backgroundColor: Colors.white,
                elevation: 0,
                brightness: Brightness.light,
                centerTitle: true,
              ),
              body: (model.isLoading)
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    ))
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          child: Container(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [],
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ),
                          painter: HeaderCurvedContainer(),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _profileText(),
                              _circleAvatar(),
                              _textListCalling(),
                              const SizedBox(height: 120)
                            ],
                          ),
                        ),
                      ],
                    ));
        }));
  }

  Widget _profileText() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Text(
        'Profile',
        style: TextStyle(
          fontSize: 35.0,
          letterSpacing: 1.5,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _circleAvatar() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.width / 2,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        color: Colors.white,
        image: DecorationImage(
            fit: BoxFit.cover,
            image: (consumerModel.imagePath == '')
                ? AssetImage('assets/images/HinataPicks-logo-new.png')
                : NetworkImage(consumerModel.imagePath)),
      ),
    );
  }

  Widget _textList({
    String text,
    String myText,
    IconData icon,
  }) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(right: 12, left: 12, top: 14, bottom: 14),
        child: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Color(0xff7cc8e9),
                ),
                Text(
                  text,
                  style: TextStyle(
                    letterSpacing: 0.8,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Flexible(
              child: Text(
                myText,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: TextStyle(
                  letterSpacing: 0.8,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textListCalling() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 30),
          _textList(
              text: '名前',
              myText: consumerModel.name,
              icon: Icons.emoji_people_outlined),
          const SizedBox(height: 16),
          _textList(
              text: 'ひなこいid',
              myText: consumerModel.gameId,
              icon: Icons.gamepad),
          const SizedBox(height: 16),
          _textList(text: 'いいね', myText: '準備中', icon: Icons.thumb_up),
          const SizedBox(height: 16),
          _textList(
              text: 'メッセージ',
              myText: consumerModel.message,
              icon: Icons.message),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Paint paint = Paint()..color = const Color(0xff6361f3);
    Paint paint = Paint()..color = const Color(0xff7cc8e9);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 250.0, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}