import 'package:flutter/material.dart';

class BoardModel extends ChangeNotifier {
  
  
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


