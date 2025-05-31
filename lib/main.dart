import 'package:flutter/material.dart';
import 'package:my_first_app/screens/signup_screen.dart';
import 'package:my_first_app/screens/launch_screen.dart';
import 'package:my_first_app/screens/welcome_page.dart';
import 'package:my_first_app/screens/about_us_page.dart';
import 'package:my_first_app/screens/edit_profile_screen.dart';
import 'package:my_first_app/screens/profile_page.dart';
import 'package:my_first_app/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forktune',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/launch',
      routes: {
        '/home': (context) => const HomePage(),
        '/launch': (context) => const LaunchScreen(),
        '/': (context) => const SignUpPage(),
        '/profile': (context) => const ProfilePage(),
        '/edit-profile': (context) => const EditProfilePage(),
        //'/welcome': (context) => const WelcomePage(),
        '/about': (context) => const AboutUsPage(),
      },
    );
  }
}
