import 'package:flutter/material.dart';
import 'package:stridehub/core/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stridehub/routes/app_routes.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _steps = '0';
  late Stream<StepCount> _stepCountStream;

  @override
  void initState() {
    super.initState();
    _checkActivityRecognitionPermission();
  }

  Future<void> _checkActivityRecognitionPermission() async {
    var status = await Permission.activityRecognition.status;
    if (!status.isGranted) {
      await Permission.activityRecognition.request();
    }
    _initStepCounter();
  }

  void _initStepCounter() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(
      (StepCount event) {
        setState(() {
          _steps = event.steps.toString();
        });
      },
      onError: (error) {
        setState(() {
          _steps = 'Error';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevents back navigation
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Home',
            style: GoogleFonts.dosis(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.group),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.friendsList);
              },
            ),
          ],
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to StrideHub!',
                style: GoogleFonts.dosis(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Today\'s Progress'),
              const SizedBox(height: 10),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildProgressCircle(200, 0.8, AppColors.primaryColor),
                    _buildProgressCircle(160, 0.6, Colors.orange),
                    _buildProgressCircle(120, 0.4, Colors.red),
                    Column(
                      children: [
                        Text(
                          'Steps',
                          style: GoogleFonts.dosis(
                              fontSize: 18, color: AppColors.textColor),
                        ),
                        Text(
                          _steps,
                          style: GoogleFonts.dosis(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Upcoming Challenges'),
              _buildChallengeCard('10K Run Challenge', 'Starts on: 25th Oct 2023'),
              const SizedBox(height: 20),
              _buildSectionTitle('Leaderboard'),
              _buildLeaderboardCard('John Doe', 'Points: 1500'),
              const SizedBox(height: 20),
              _buildSectionTitle('Summary'),
              _buildSummaryCard('Weekly Goal: 35 km', 0.7, '70% of your weekly goal completed'),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.searchFriends);
                      },
                      child: const Text('Search Friends'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.friendRequests);
                      },
                      child: const Text('Friend Requests'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCircle(double size, double value, Color color) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: 12,
        backgroundColor: AppColors.dividerColor,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.dosis(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textColor,
      ),
    );
  }

  Widget _buildChallengeCard(String title, String subtitle) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(Icons.flag, color: AppColors.primaryColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {},
      ),
    );
  }

  Widget _buildLeaderboardCard(String name, String points) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primaryColor,
          child: Text('1', style: const TextStyle(color: Colors.white)),
        ),
        title: Text(name),
        subtitle: Text(points),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {},
      ),
    );
  }

  Widget _buildSummaryCard(String title, double progress, String progressText) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.dosis(fontSize: 18, color: AppColors.textColor)),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.dividerColor,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            ),
            const SizedBox(height: 10),
            Text(progressText, style: GoogleFonts.dosis(fontSize: 16, color: AppColors.textColor)),
          ],
        ),
      ),
    );
  }
}
