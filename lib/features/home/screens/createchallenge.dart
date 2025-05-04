// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<bool> sendChallengeRequest(BuildContext context, String email, String duration, String distance) async {
  try {
    CollectionReference challenges = FirebaseFirestore.instance.collection('challenges');

    // Check if the email is in the friends collection
    QuerySnapshot friendsSnapshot = await FirebaseFirestore.instance
      .collection('friends')
      .where('email', isEqualTo: email)
      .get();

    if (friendsSnapshot.docs.isEmpty) {
      // Show error dialog if the email is not in friends
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.red,
            title: Text('Error', style: TextStyle(color: Colors.white)),
            content: Text('The email $email is not in your friends list.', style: TextStyle(color: Colors.white)),
            actions: [
              TextButton(
                child: Text('OK', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false; // Indicating failure
    }

    // Add challenge request to the challenges collection
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Text('Firebase Error', style: TextStyle(color: Colors.white)),
          content: Text('${e.message}', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return false; // Indicating failure
  } catch (e) {
    // Catch any other unexpected errors
    print('Unexpected Error: $e');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Text('Unexpected Error', style: TextStyle(color: Colors.white)),
          content: Text('$e', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return false; // Indicating failure
  }
}
