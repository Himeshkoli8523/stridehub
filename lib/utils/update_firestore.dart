import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

Future<void> updateExistingUsers() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  QuerySnapshot usersSnapshot = await firestore.collection('users').get();

  for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
    String userId = userDoc.id;
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

    // Check if the email field exists in Firestore
    if (userData.containsKey('email')) {
      await firestore.collection('users').doc(userId).update({
        'friends': FieldValue.arrayUnion([]),
      });
    } else {
      await firestore.collection('users').doc(userId).update({
        'email': '',
        'friends': FieldValue.arrayUnion([]),
      });
    }
  }

  print('All existing user documents have been updated.');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await updateExistingUsers();
}
