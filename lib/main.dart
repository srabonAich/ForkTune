import 'package:flutter/material.dart';
import 'package:my_first_app/screens/forgot_password.dart';
import 'package:my_first_app/screens/signup_screen.dart';
import 'package:my_first_app/screens/launch_screen.dart';
import 'package:my_first_app/screens/welcome_page.dart';
import 'package:my_first_app/screens/about_us_page.dart';
import 'package:my_first_app/screens/profile_page.dart';
import 'package:my_first_app/screens/EditProfilePage.dart';
import 'package:my_first_app/screens/home_page.dart';
import 'package:my_first_app/screens/meal_planner_page.dart';
import 'package:my_first_app/screens/recipe_screen.dart';
import 'package:my_first_app/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Forktune',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/launch',
      routes: {''
        '/launch': (context) => const LaunchScreen(),
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/meal-planning': (context) => const MealPlanningPage(),
        '/recipe': (context) => const RecipeScreen(),
        '/edit-profile': (context) => const EditProfilePage(),
        //'/welcome': (context) => const WelcomePage(),
        '/about': (context) => const AboutUsPage(),
        '/forgotpassword': (context) => const ForgotPasswordScreen(),
      },
    );
  }
}
