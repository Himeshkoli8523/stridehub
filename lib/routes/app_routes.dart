// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:stridehub/features/auth/screens/login.dart';
import 'package:stridehub/features/auth/screens/signup.dart';
import 'package:stridehub/features/auth/screens/profile_setup.dart';
import 'package:stridehub/bottom_nav_bar.dart';
import 'package:stridehub/features/friends/screens/search_friends_screen.dart';
import 'package:stridehub/features/friends/screens/friend_requests_screen.dart';
import 'package:stridehub/features/friends/screens/friends_list_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String signup = '/signup';
  static const String profileSetup = '/profileSetup';
  static const String home = '/home';
  static const String searchFriends = '/searchFriends';
  static const String friendRequests = '/friendRequests';
  static const String friendsList = '/friendsList';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case profileSetup:
        return MaterialPageRoute(builder: (_) => ProfileSetupPage());
      case home:
        return MaterialPageRoute(builder: (_) => BottomNavScreen());
      case searchFriends:
        return MaterialPageRoute(builder: (_) => SearchFriendsScreen());
      case friendRequests:
        return MaterialPageRoute(builder: (_) => FriendRequestsScreen());
      case friendsList:
        return MaterialPageRoute(builder: (_) => FriendsListScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
