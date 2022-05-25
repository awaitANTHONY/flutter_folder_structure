// import 'package:cloud_firestore/cloud_firestore.dart';

// class DatabaseService {
//   final CollectionReference userCollection =
//       FirebaseFirestore.instance.collection('users');
//   final CollectionReference roomCollection =
//       FirebaseFirestore.instance.collection('rooms');

//   Future saveUserData(data) async {
//     return await userCollection.doc(data['uid']).set({
//       'name': data['name'] ?? '',
//       'image': data['image'] ?? '',
//       'email': data['email'] ?? '',
//       'phone': data['phone'] ?? '',
//       'prodiver': data['prodiver'] ?? '',
//     });
//   }

//   Future<QuerySnapshot> getUserInfo(String mail) async {
//     return await userCollection.where('email', isEqualTo: mail).get();
//   }

//   Future createRoom(data) async {
//     return await roomCollection.doc(data['matchId']).set({
//       'name': data['name'] ?? '',
//       'roomId': data['matchId'] ?? '',
//       'icon': '',
//       'updatedAt': DateTime.now().millisecondsSinceEpoch,
//     });
//   }

//   sendMessage(String groupId, chatMessageData) {
//     roomCollection.doc(groupId).collection('messages').add(chatMessageData);
//     // roomCollection.doc(groupId).update({
//     //   'recentMessage': chatMessageData['message'],
//     //   'recentMessageSender': chatMessageData['sender'],
//     //   'recentMessageTime': chatMessageData['time'].toString(),
//     // });
//   }
// }
