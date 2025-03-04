// lib/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:stridehub/features/home/screens/home_screen.dart';
import 'package:stridehub/features/home/screens/challenges.dart';
import 'package:stridehub/features/home/screens/leaderboard.dart';
import 'package:stridehub/features/home/screens/profile_screen.dart';
import 'package:stridehub/core/constants/colors.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // Home Screen
    ChallengesScreen(), // Challenges Screen
    LeaderboardScreen(), // Leaderboard Screen
    ProfileScreen(), // Profile Screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _screens[
            _currentIndex], // Display the current screen based on index
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.flag), label: 'Challenges'),
            BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          unselectedItemColor: AppColors.bottomNavigationBarItemColor,
          selectedItemColor: AppColors.bottomNavigationBarItemSelectedColor,
          type: BottomNavigationBarType.fixed,
          elevation: 10,
        ),
      ),
    );
  }
}
