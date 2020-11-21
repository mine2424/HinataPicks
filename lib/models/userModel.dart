import '../importer.dart';

class UserModel extends ChangeNotifier {
  CustomerUser customerInfo;
  List<CustomerUser> customerUserList;
  bool isLoading = false;
  final firebaseAuth = FirebaseAuth.instance.currentUser.uid;

  Future<void> fetchCustomerInfo() async {
    this.isLoading = true;
    var customerInfo;
    //customerInfoからuser画像を取得
    final customerUserInfo = await FirebaseFirestore.instance
        .collection('customerInfo')
        .doc(firebaseAuth)
        .get()
        .then((value) => value.data()['imagePath']);
    //仮にキーが存在していなかったらからで取得
    if (customerUserInfo == '' || customerUserInfo == null) {
      customerInfo = await FirebaseFirestore.instance
          .collection('customerInfo')
          .doc(firebaseAuth)
          .get()
          .then((value) => CustomerUser(
              uid: value.data()['uid'],
              name: value.data()['insta'],
              gameId: value.data()['gameId'],
              twitter: value.data()['twitter'],
              like: value.data()['like'],
              message: value.data()['message'],
              createAt: value.data()['createAt'],
              imagePath: ''));
    } else {
      customerInfo = await FirebaseFirestore.instance
          .collection('customerInfo')
          .doc(firebaseAuth)
          .get()
          .then((value) => CustomerUser(
              uid: value.data()['uid'],
              name: value.data()['insta'],
              gameId: value.data()['gameId'],
              twitter: value.data()['twitter'],
              like: value.data()['like'],
              message: value.data()['message'],
              createAt: value.data()['createAt'],
              imagePath: value.data()['imagePath']));
    }

    this.isLoading = false;
    this.customerInfo = customerInfo;
    notifyListeners();
  }

  Future<void> fetchSelectedCustomerInfo(userUid) async {
    this.isLoading = true;
    var customerInfo;
    //customerInfoからuser画像を取得
    final customerUserInfo = await FirebaseFirestore.instance
        .collection('customerInfo')
        .doc(userUid)
        .get()
        .then((value) => value.data()['imagePath']);
    //仮にキーが存在していなかったらからで取得
    if (customerUserInfo == '' || customerUserInfo == null) {
      customerInfo = await FirebaseFirestore.instance
          .collection('customerInfo')
          .doc(userUid)
          .get()
          .then((value) => CustomerUser(
              uid: value.data()['uid'],
              name: value.data()['insta'],
              gameId: value.data()['gameId'],
              twitter: value.data()['twitter'],
              like: value.data()['like'],
              message: value.data()['message'],
              createAt: value.data()['createAt'],
              imagePath: ''));
    } else {
      customerInfo = await FirebaseFirestore.instance
          .collection('customerInfo')
          .doc(userUid)
          .get()
          .then((value) => CustomerUser(
              uid: value.data()['uid'],
              name: value.data()['insta'],
              gameId: value.data()['gameId'],
              twitter: value.data()['twitter'],
              like: value.data()['like'],
              message: value.data()['message'],
              createAt: value.data()['createAt'],
              imagePath: value.data()['imagePath']));
    }

    this.isLoading = false;
    this.customerInfo = customerInfo;
    notifyListeners();
  }
}
