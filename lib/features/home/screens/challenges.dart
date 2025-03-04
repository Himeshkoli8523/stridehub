import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stridehub/core/constants/colors.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Challenges',
          style: GoogleFonts.dosis(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.dividerColor,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              createChallengeDialogBox(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                'Challenges by Friends',
                style: GoogleFonts.dosis(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 10),
              // Example of a challenge card
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/friend_profile.png'),
                      ),
                      title: Text('5K Walk Challenge'),
                      subtitle:
                          Text('Friend: Jane Smith\nStart Date: 1st Nov 2023'),
                    ),
                    ButtonBar(
                      children: [
                        TextButton(
                          onPressed: () {
                            // Handle accept action
                          },
                          child: Text('Accept'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle decline action
                          },
                          child: Text('Decline'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Add more widgets as needed
            ],
          ),
        ),
      ),
    );
  }

  void createChallengeDialogBox(BuildContext context) {
    final emailController = TextEditingController();
    final distanceController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Challenge'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email ID',
                ),
              ),
              TextField(
                controller: distanceController,
                decoration: InputDecoration(
                  labelText: 'Distance',
                ),
              ),
              TextField(
                controller: durationController,
                decoration: InputDecoration(
                  labelText: 'Duration',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle create challenge action
                String email = emailController.text;
                String distance = distanceController.text;
                String duration = durationController.text;
                // Add your logic to handle the input data
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
