import 'package:cloud_firestore/cloud_firestore.dart';

class SupportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Listen for new support messages
  void listenForSupportMessages(Function(Map<String, dynamic>) onNewMessage) {
    _firestore.collection('support_messages').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          onNewMessage(change.doc.data()!);
        }
      }
    });
  }

  // Reply to a support message
  Future<void> replyToSupportMessage(String messageId, String reply) async {
    await _firestore.collection('support_messages').doc(messageId).update({
      'reply': reply,
      'repliedAt': FieldValue.serverTimestamp(),
    });
  }

  // Send a new support message (for clients)
  Future<void> sendSupportMessage(String userId, String content) async {
    await _firestore.collection('support_messages').add({
      'userId': userId,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
      'reply': null,
    });
  }
}
