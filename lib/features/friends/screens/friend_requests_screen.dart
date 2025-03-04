import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stridehub/core/constants/colors.dart';
import 'package:stridehub/features/friends/services/friend_service.dart';

class FriendRequestsScreen extends StatelessWidget {
  final FriendService _friendService = FriendService();

  FriendRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Friend Requests',
          style: GoogleFonts.dosis(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Text(
            'Incoming Friend Requests',
            style: GoogleFonts.dosis(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('friend_requests')
                  .where('to', isEqualTo: currentUser?.uid)
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var requests = snapshot.data!.docs;
                if (requests.isEmpty) {
                  return Center(
                    child: Text(
                      'No incoming friend requests',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    var request = requests[index];
                    var fromUserId = request['from'];
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(fromUserId)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return ListTile(
                            title: Text('Loading...'),
                          );
                        }
                        var user = userSnapshot.data!;
                        var fullName = user['fullName'];
                        var email = user['email'];
                        return ListTile(
                          title: Text(
                            fullName,
                            style: TextStyle(color: AppColors.textColor),
                          ),
                          subtitle: Text(
                            email,
                            style: TextStyle(color: AppColors.captionColor),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  _friendService.acceptFriendRequest(
                                      request.id, fromUserId);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {

                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Divider(),
          Text(
            'Outgoing Friend Requests',
            style: GoogleFonts.dosis(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('friend_requests')
                  .where('from', isEqualTo: currentUser?.uid)
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var requests = snapshot.data!.docs;
                if (requests.isEmpty) {
                  return Center(
                    child: Text(
                      'No outgoing friend requests',
                      style: TextStyle(color: AppColors.textColor),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    var request = requests[index];
                    var toUserId = request['to'];
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(toUserId)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData) {
                          return ListTile(
                            title: Text('Loading...'),
                          );
                        }
                        var user = userSnapshot.data!;
                        var fullName = user['fullName'];
                        var email = user['email'];

                        return ListTile(
                          title: Text(
                            fullName,
                            style: TextStyle(color: AppColors.textColor),
                          ),
                          subtitle: Text(
                            email,
                            style: TextStyle(color: AppColors.captionColor),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              // Handle canceling friend request
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
