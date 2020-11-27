import './importer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging firebaseMessaging;

BuildContext context;

Future<void> initNotification() async {
  firebaseMessaging = FirebaseMessaging()
    ..requestNotificationPermissions()
    ..onIosSettingsRegistered.listen(
      (IosNotificationSettings settings) {
        const IosNotificationSettings(
          sound: true,
          badge: true,
          alert: true,
        );
      },
    )
    ..configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        return PopUpNotification(message: "onMessage");
      },
      onBackgroundMessage:
          Platform.isAndroid ? myBackgroundMessageHandler : null,
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        return PopUpNotification(message: "onLaunch");
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        return PopUpNotification(message: "onResume");
      },
    );
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // データメッセージをハンドリング
    final dynamic data = message['data'];
    print(data);
    return PopUpNotification(message: data);
  }

  if (message.containsKey('notification')) {
    // 通知メッセージをハンドリング
    final dynamic notification = message['notification'];
    print(notification);
    return PopUpNotification(message: notification);
  }
  print('onBackground: $message');
}

class PopUpNotification extends StatelessWidget {
  var message;
  PopUpNotification({Key key, this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Message: $message"),
          actions: <Widget>[
            FlatButton(
              child: const Text('CLOSE'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: const Text('SHOW'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}
