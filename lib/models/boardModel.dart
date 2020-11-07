import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hinataPicks/classes/users.dart';

class BoardModel extends ChangeNotifier {
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
}

// Future<void> fetchFriendComments() async {
//   this.isLoading = true;
//   final allFriendChats =
//       await FirebaseFirestore.instance.collection('friendChats').orderBy('createAt',descending: true).get();
//   for (var i = 0; i < allFriendChats.docs.length; i++) {
//     chatsList.add(FriendChats(
//         name: allFriendChats.docs[i].data()['name'],
//         context: allFriendChats.docs[i].data()['context'],
//         createAt: allFriendChats.docs[i].data()['createAt'],
//         like: allFriendChats.docs[i].data()['like'],
//         userId: allFriendChats.docs[i].data()['uid']));
//   }
//   this.isLoading = false;
//   notifyListeners();
// }
