import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stridehub/core/constants/colors.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leaderboard',
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top Performers',
                style: GoogleFonts.dosis(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 10),
              // Example leaderboard entry
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    child: Text('1', style: TextStyle(color: Colors.white)),
                  ),
                  title: Text('John Doe'),
                  subtitle: Text('Points: 1500'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Navigate to user details
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    child: Text('2', style: TextStyle(color: Colors.white)),
                  ),
                  title: Text('Jane Smith'),
                  subtitle: Text('Points: 1400'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Navigate to user details
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    child: Text('3', style: TextStyle(color: Colors.white)),
                  ),
                  title: Text('Alice Johnson'),
                  subtitle: Text('Points: 1300'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Navigate to user details
                  },
                ),
              ),
              // Add more leaderboard entries here
            ],
          ),
        ),
      ),
    );
  }
}
