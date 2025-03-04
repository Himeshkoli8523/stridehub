import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendFriendRequest(String friendEmail) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    QuerySnapshot userSnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: friendEmail)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      String friendId = userSnapshot.docs.first.id;

      await _firestore.collection('friend_requests').add({
        'from': currentUser.uid,
        'to': friendId,
        'status': 'pending',
      });
    }
  }

  Future<void> acceptFriendRequest(String requestId, String fromUserId) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) return;

    await _firestore.collection('friend_requests').doc(requestId).update({
      'status': 'accepted',
    });

    await _firestore.collection('users').doc(currentUser.uid).update({
      'friends': FieldValue.arrayUnion([fromUserId]),
    });

    await _firestore.collection('users').doc(fromUserId).update({
      'friends': FieldValue.arrayUnion([currentUser.uid]),
    });
  }
}
