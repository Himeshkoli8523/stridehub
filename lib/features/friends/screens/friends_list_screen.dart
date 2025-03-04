// lib/features/friends/screens/friends_list_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stridehub/core/constants/colors.dart';
import 'package:stridehub/routes/app_routes.dart';

class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Friends',
          style: GoogleFonts.dosis(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.searchFriends);
            },
          ),
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.friendRequests);
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
  stream: _firestore.collection('users').doc(currentUser?.uid).snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
      return Center(child: Text('No data available'));
    }

    var user = snapshot.data!;
    var friends = (user.data() as Map<String, dynamic>)['friends'] ?? [];

    if (friends.isEmpty) {
      return Center(
        child: Text(
          'No friends yet',
          style: TextStyle(color: AppColors.textColor),
        ),
      );
    }

    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        var friendId = friends[index];
        return FutureBuilder<DocumentSnapshot>(
          future: _firestore.collection('users').doc(friendId).get(),
          builder: (context, friendSnapshot) {
            if (friendSnapshot.connectionState == ConnectionState.waiting) {
              return ListTile(title: Text('Loading...'));
            }
            if (!friendSnapshot.hasData || !friendSnapshot.data!.exists) {
              return ListTile(title: Text('Friend data not available'));
            }
            var friend = friendSnapshot.data!;
            var fullName = friend['fullName'];
            var email = friend['email'];
            return ListTile(
              title: Text(fullName, style: TextStyle(color: AppColors.textColor)),
              subtitle: Text(email, style: TextStyle(color: AppColors.captionColor)),
            );
          },
        );
      },
    );
  },
),
  
    );
  }
}
