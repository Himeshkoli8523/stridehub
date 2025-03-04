import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp(String email, String password, String fullName) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'fullName': fullName,
        'friends': [],
        'dob': '',
        'gender': '',
        'height': '',
        'heightUnit': '',
        'phoneNumber': '',
        'weight': '',
      });
    }
  }

  Future<void> signIn(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        Map<String, dynamic> updates = {};

        if (!userData.containsKey('email')) {
          updates['email'] = user.email ?? '';
        }
        if (!userData.containsKey('fullName')) {
          updates['fullName'] = '';
        }
        if (!userData.containsKey('friends')) {
          updates['friends'] = [];
        }
        if (!userData.containsKey('dob')) {
          updates['dob'] = '';
        }
        if (!userData.containsKey('gender')) {
          updates['gender'] = '';
        }
        if (!userData.containsKey('height')) {
          updates['height'] = '';
        }
        if (!userData.containsKey('heightUnit')) {
          updates['heightUnit'] = '';
        }
        if (!userData.containsKey('phoneNumber')) {
          updates['phoneNumber'] = '';
        }
        if (!userData.containsKey('weight')) {
          updates['weight'] = '';
        }

        if (updates.isNotEmpty) {
          await _firestore.collection('users').doc(user.uid).update(updates);
        }
      }
    }
  }
}
