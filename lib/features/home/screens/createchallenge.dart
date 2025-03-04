import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<bool> sendChallengeRequest(BuildContext context, String email, String duration, String distance) async {
  try {
    CollectionReference challenges = FirebaseFirestore.instance.collection('challenges');

    await challenges.add({
      'email': email,
      'duration': duration,
      'distance': distance,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Challenge request sent to $email!')),
    );

    return true; // Indicating success
  } on FirebaseException catch (e) {
    // Catch specific Firebase errors
    print('Firebase Error: ${e.message}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Firebase Error: ${e.message}')),
    );

    return false; // Indicating failure
  } catch (e) {
    // Catch any other unexpected errors
    print('Unexpected Error: $e');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Unexpected Error: $e')),
    );

    return false; // Indicating failure
  }
}
