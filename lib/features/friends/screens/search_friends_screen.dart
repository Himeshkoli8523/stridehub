// lib/features/friends/screens/search_friends_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stridehub/core/constants/colors.dart';

class SearchFriendsScreen extends StatefulWidget {
  const SearchFriendsScreen({super.key});

  @override
  _SearchFriendsScreenState createState() => _SearchFriendsScreenState();
}

class _SearchFriendsScreenState extends State<SearchFriendsScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchResult = '';
  DocumentSnapshot? _friendDoc;

  Future<void> _searchFriend() async {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _searchResult = 'Please enter an email address.';
        _friendDoc = null;
      });
      return;
    }

    QuerySnapshot userSnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (userSnapshot.docs.isEmpty) {
      setState(() {
        _searchResult = 'No user found with this email.';
        _friendDoc = null;
      });
    } else {
      setState(() {
        _searchResult = 'User found: ${userSnapshot.docs.first['fullName']}';
        _friendDoc = userSnapshot.docs.first;
      });
    }
  }

  void _viewFriendProfile(DocumentSnapshot friendDoc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendProfileScreen(friendDoc: friendDoc),
      ),
    );
  }

  Future<void> _sendFriendRequest(String friendEmail) async {
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

      setState(() {
        _searchResult = 'Friend request sent to $friendEmail';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Friends',
          style: GoogleFonts.dosis(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter friend\'s email',
                labelStyle: TextStyle(color: AppColors.captionColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
              style: TextStyle(color: AppColors.textColor),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _searchFriend,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                foregroundColor: AppColors.buttonTextColor,
              ),
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            Text(
              _searchResult,
              style: TextStyle(color: AppColors.textColor),
            ),
            if (_friendDoc != null)
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    (_friendDoc!.data()
                            as Map<String, dynamic>)['profilePicture'] ??
                        'assets/images/default_profile.png',
                  ),
                ),
                title: Text(
                    (_friendDoc!.data() as Map<String, dynamic>)['fullName']),
                subtitle:
                    Text((_friendDoc!.data() as Map<String, dynamic>)['email']),
                onTap: () => _viewFriendProfile(_friendDoc!),
              ),
            if (_searchResult.startsWith('User found:'))
              ElevatedButton(
                onPressed: () =>
                    _sendFriendRequest(_emailController.text.trim()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  foregroundColor: AppColors.buttonTextColor,
                ),
                child: Text('Send Friend Request'),
              ),
          ],
        ),
      ),
    );
  }
}

class FriendProfileScreen extends StatelessWidget {
  final DocumentSnapshot friendDoc;

  const FriendProfileScreen({super.key, required this.friendDoc});

  @override
  Widget build(BuildContext context) {
    final friendData = friendDoc.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(friendData['fullName']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  friendData['profilePicture'] ??
                      'assets/images/default_profile.png',
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Email: ${friendData['email']}'),
            Text('Full Name: ${friendData['fullName']}'),
            Text('Phone Number: ${friendData['phoneNumber']}'),
            Text('Date of Birth: ${friendData['dob']}'),
            Text('Gender: ${friendData['gender']}'),
            Text('Height: ${friendData['height']} ${friendData['heightUnit']}'),
            Text('Weight: ${friendData['weight']}'),
          ],
        ),
      ),
    );
  }
}
