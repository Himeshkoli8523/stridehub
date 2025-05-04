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
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Please log in to see friend requests.',
            style: TextStyle(color: AppColors.textColor),
          ),
        ),
      );
    }

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
          _buildSectionTitle('Incoming Friend Requests'),
          _buildFriendRequestList(
            query: FirebaseFirestore.instance
                .collection('friend_requests')
                .where('to', isEqualTo: currentUser.uid)
                .where('status', isEqualTo: 'pending'),
            onAccept: (requestId, fromUserId) {
              _friendService.acceptFriendRequest(requestId, fromUserId);
            },
            onReject: (requestId) {
              _friendService.rejectFriendRequest(requestId);
            },
          ),
          Divider(),
          _buildSectionTitle('Outgoing Friend Requests'),
          _buildFriendRequestList(
            query: FirebaseFirestore.instance
                .collection('friend_requests')
                .where('from', isEqualTo: currentUser.uid)
                .where('status', isEqualTo: 'pending'),
            isOutgoing: true,
            onCancel: (requestId) {
              _friendService.cancelFriendRequest(requestId);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.dosis(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
      ),
    );
  }

  Widget _buildFriendRequestList({
    required Query query,
    bool isOutgoing = false,
    void Function(String requestId, String userId)? onAccept,
    void Function(String requestId)? onReject,
    void Function(String requestId)? onCancel,
  }) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                isOutgoing ? 'No outgoing friend requests' : 'No incoming friend requests',
                style: TextStyle(color: AppColors.textColor),
              ),
            );
          }

          var requests = snapshot.data!.docs;
          List userIds =
              requests.map((req) => isOutgoing ? req['to'] : req['from']).toList();

          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where(FieldPath.documentId, whereIn: userIds)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!userSnapshot.hasData || userSnapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'Users not found.',
                    style: TextStyle(color: AppColors.textColor),
                  ),
                );
              }

              var users = {for (var doc in userSnapshot.data!.docs) doc.id: doc};

              return ListView.separated(
                itemCount: requests.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  var request = requests[index];
                  var userId = isOutgoing ? request['to'] : request['from'];

                  if (!users.containsKey(userId)) {
                    return ListTile(title: Text('User not found'));
                  }

                  var user = users[userId]!;
                  return ListTile(
                    title: Text(
                      user['fullName'],
                      style: TextStyle(color: AppColors.textColor),
                    ),
                    subtitle: Text(
                      user['email'],
                      style: TextStyle(color: AppColors.captionColor),
                    ),
                    trailing: isOutgoing
                        ? IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () => onCancel?.call(request.id),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () => onAccept?.call(request.id, userId),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.red),
                                onPressed: () => onReject?.call(request.id),
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
    );
  }
}
