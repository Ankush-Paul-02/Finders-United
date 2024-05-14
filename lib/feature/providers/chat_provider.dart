import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../core/constants/database_constants.dart';
import '../models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  /// SEND MESSAGE
  Future<void> sendMessage(
    String receiverId,
    String message,
  ) async {
    /// GET CURRENT USER INFO
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserPhoneNumber =
        _firebaseAuth.currentUser!.phoneNumber.toString();
    final Timestamp timestamp = Timestamp.now();

    /// CREATE A NEW MESSAGE
    MessageModel newMessage = MessageModel(
      senderId: currentUserId,
      senderPhoneNumber: currentUserPhoneNumber,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    /// CONSTRUCT CHAT ROOM ID FROM CURRENT USER ID AND RECEIVER USER ID
    List<String> ids = [currentUserId, receiverId];
    // SORT THE IDS (THIS WILL ENSURE THAT THE CHAT ROOM ID IS ALWAYS THE SAME FOR ANY PAIR OF PEOPLE)
    ids.sort();
    String chatRoomId = ids.join("_");

    /// ADD NEW MESSAGE TO DATABASE
    await _firestore
        .collection(DatabaseConstants.chatRoomFirestore)
        .doc(chatRoomId)
        .collection(DatabaseConstants.chatRoomFirestoreMessages)
        .add(newMessage.toMap());
    debugPrint('Message sent successfully!');
  }

  /// GET MESSAGES
  Stream<QuerySnapshot> getMessages(
    String userId,
    String otherUserId,
  ) {
    /// CHAT ROOM ID
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection(DatabaseConstants.chatRoomFirestore)
        .doc(chatRoomId)
        .collection(DatabaseConstants.chatRoomFirestoreMessages)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
