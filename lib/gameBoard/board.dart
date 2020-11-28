import 'package:hinataPicks/gameBoard/board_detail_image.dart';
import 'package:hinataPicks/gameBoard/board_user_info.dart';
import '../importer.dart';

// ignore: must_be_immutable
class BoardPage extends StatefulWidget {
  var collection, addComment;
  BoardPage({Key key, @required this.collection}) : super(key: key);
  @override
  BoardPageState createState() => BoardPageState();
}

class BoardPageState extends State<BoardPage> {
  List chatsList = [];
  String content;
  var _messageCautionsList = ['ブロック', '報告'];
  //TODO シングルトン化してコードの省略
  final _firebaseAuth = FirebaseAuth.instance.currentUser.uid;
  var chatLength, customerImagePath;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  TapGestureRecognizer _recognizer = TapGestureRecognizer()
    ..onTap = () {
      launch('https://hinatapicks.web.app/');
    };

  replyComment(collection, replyName) async {
    if (_formKey.currentState.validate()) {
      String userName, userImage = '';
      final _firebaseAuth = FirebaseAuth.instance.currentUser.uid;
      _formKey.currentState.save();
      // 各boardのcollectionを取得
      final sendComment = FirebaseFirestore.instance.collection(collection);
      // boradのコメントの個数を取得
      final commentLength =
          await FirebaseFirestore.instance.collection(collection).get();
      // 各Userで画像を取得
      final sendUserInfoDoc = await FirebaseFirestore.instance
          .collection('customerInfo')
          .doc(_firebaseAuth)
          .get();

      if (sendUserInfoDoc.data()['imagePath'] == null) {
        await FirebaseFirestore.instance
            .collection('customerInfo')
            .doc(_firebaseAuth)
            .update({'imagePath': ''});
      } else {
        userImage = await sendUserInfoDoc.data()['imagePath'];
      }

      if (sendUserInfoDoc.data()['insta'] == '') {
        userName =
            '匿名おひさまさん(${sendUserInfoDoc.data()['uid'].toString().substring(0, 7)})';
      } else {
        userName = await sendUserInfoDoc.data()['insta'];
      }

      await sendComment.doc((commentLength.docs.length + 1).toString()).set({
        'userUid': _firebaseAuth,
        'name': userName,
        'context': content,
        'like': 0,
        'imagePath': userImage,
        'createAt': Timestamp.now(),
        'returnName': replyName
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeSection()));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: BottomAddCommentButton(
            collection: widget.collection,
            chatLength: chatLength,
            sendUser: ''),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(widget.collection)
                .orderBy('createAt', descending: true)
                .limit(160)
                .snapshots(),
            builder: (context, snapshot) {
              return (!snapshot.hasData)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Now Loading...',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w300))
                        ],
                      ),
                    )
                  : (snapshot.data.docs.length == 0)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (widget.collection == 'friendChats')
                                  ? Image.asset(
                                      'assets/images/chat-hinakoi.png',
                                      scale: 1.4)
                                  : Image.asset('assets/images/chat-normal.png',
                                      scale: 1.4),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2)
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final chatsItem = snapshot.data.docs[index];
                            chatLength = snapshot.data.docs.length;
                            DateTime createdTime =
                                chatsItem.data()['createAt'].toDate();
                            return (chatsItem.data()['name'] == '運営')
                                ? commentBox(chatsItem, createdTime, 'admin')
                                : commentBox(chatsItem, createdTime, '');
                          });
            }));
  }

  Widget commentBox(chatsItem, createdTime, isAdmin) {
    return Row(
      children: [
        FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BoardUserInfoPage(
                          userUid: chatsItem.data()['userUid'])));
            },
            child: Container(
                width: MediaQuery.of(context).size.width * 0.16,
                height: MediaQuery.of(context).size.width * 0.16,
                decoration: BoxDecoration(
                    // border: Border.all(
                    //     color: Colors.grey, width: 5),
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: (chatsItem.data()['imagePath'] == null ||
                                chatsItem.data()['imagePath'] == '')
                            ? AssetImage(
                                'assets/images/HinataPicks-logo-new.png')
                            : NetworkImage(chatsItem.data()['imagePath']))))),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.only(bottom: 5, left: 3),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: (isAdmin == 'admin')
                    ? Colors.red[300]
                    : (chatsItem.data()['returnName'] != null)
                        ? Color(0xff99FF73)
                        : Color(0xff7cc8e9),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chatsItem.data()['name'],
                        style: TextStyle(
                            color: (isAdmin == 'admin')
                                ? Colors.black
                                : Colors.blueGrey,
                            fontSize: 13.2,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.52,
                        child: (chatsItem.data()['returnName'] != null)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '@' + chatsItem.data()['returnName'],
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  _selectableTextContent(chatsItem),
                                ],
                              )
                            : _selectableTextContent(chatsItem),
                      ),
                      const SizedBox(height: 5),
                      (chatsItem.data()['postImage'] != null)
                          ? Stack(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BoardDetailsImage(
                                        image: chatsItem.data()['postImage'],
                                      ),
                                    ),
                                  ),
                                  child: Hero(
                                    tag: 'imageTag',
                                    child: Image.network(
                                      chatsItem.data()['postImage'],
                                      filterQuality: FilterQuality.medium,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  Text(
                    createdTime.toLocal().toString().substring(
                          0,
                          createdTime.toLocal().toString().length - 10,
                        ),
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12.6,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 28),
                  Text(
                    '返信',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12.2,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      Icons.reply,
                      size: 20,
                    ),
                    color: Colors.grey,
                    onPressed: () {
                      var myname = chatsItem.data()['name'];
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('返信'),
                          content: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text(myname + 'に返信'),
                                  TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    validator: (input) {
                                      for (var i = 0;
                                          i < prohibisionWords.length;
                                          i++) {
                                        if (input
                                            .contains(prohibisionWords[i])) {
                                          return '不適切な言葉が含まれています';
                                        }
                                        if (input.isEmpty) {
                                          return '投稿内容を入力してください';
                                        }
                                      }
                                      return null;
                                    },
                                    onSaved: (input) => content = input,
                                    decoration: const InputDecoration(
                                        labelText: '投稿内容'),
                                  ),
                                  const SizedBox(height: 15),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '投稿すると',
                                          style: TextStyle(
                                              color: Colors.grey[800]),
                                        ),
                                        TextSpan(
                                          text: '利用規約',
                                          style: TextStyle(
                                              color: Colors.lightBlue),
                                          recognizer: _recognizer,
                                        ),
                                        TextSpan(
                                          text: 'に同意したものとみなします。',
                                          style: TextStyle(
                                              color: Colors.grey[800]),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('キャンセル')),
                            FlatButton(
                              onPressed: () {
                                replyComment(widget.collection,
                                    chatsItem.data()['name']);
                              },
                              child: const Text('返信'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        PopupMenuButton<String>(
            icon: Icon(
              Icons.sms_failed_outlined,
              size: 23,
            ),
            itemBuilder: (BuildContext context) {
              return _messageCautionsList.map((String s) {
                return PopupMenuItem(
                  child: FlatButton(
                      onPressed: () {
                        if (s == 'ブロック') {
                          blockDialog(chatsItem);
                        }
                        if (s == '報告') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingPage()));
                        }
                      },
                      child: Text(s)),
                  value: s,
                );
              }).toList();
            })
      ],
    );
  }

  Future removeComment(String nowUser) async {
    await FirebaseFirestore.instance
        .collection(widget.collection)
        .doc(nowUser)
        .delete();
    return Navigator.pop(context);
  }

  Widget _selectableTextContent(chatsItem) {
    return SelectableAutoLinkText(
      chatsItem.data()['context'],
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w300,
      ),
      linkStyle: const TextStyle(
        color: Colors.blueAccent,
      ),
      highlightedLinkStyle: TextStyle(
        color: Colors.blueAccent,
        backgroundColor: Colors.blueAccent.withAlpha(0x33),
      ),
      onTap: (url) => _launchURL(url),
      onLongPress: (url) => Share.share(url),
    );
  }

  blockDialog(chatsItem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('警告'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('本当にブロックしますか?'),
                Text(
                  '不適切と判断した場合のみ',
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  '当コメントが削除されます',
                  style: TextStyle(fontSize: 13),
                )
              ],
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('usersContactForm').add(
                  {
                    'uid': _firebaseAuth,
                    'cautionUid': chatsItem.data()['userUid'],
                    'cautionContext': chatsItem.data()['context'],
                    'createAt': Timestamp.now(),
                  },
                );
                Navigator.pop(context);
              },
              child: Text('はい'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('いいえ'),
            )
          ],
        );
      },
    );
  }
}
