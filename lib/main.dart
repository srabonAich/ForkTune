/*
import 'package:flutter/material.dart';
import 'package:my_first_app/screens/email_verification.dart';
import 'package:my_first_app/screens/forgot_password.dart';
import 'package:my_first_app/screens/notification_screen.dart';
import 'package:my_first_app/screens/saved_recipe_screen.dart';
import 'package:my_first_app/screens/signup_screen.dart';
import 'package:my_first_app/screens/launch_screen.dart';
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
      routes: {
        '/launch': (context) => const LaunchScreen(),
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/meal-planning': (context) => const MealPlanningPage(),
        '/recipe': (context) => const RecipeScreen(),
        '/edit-profile': (context) => const EditProfilePage(),
        // '/welcome': (context) => const WelcomePage(),
        '/about': (context) => const AboutUsPage(),
        '/forgotpassword': (context) => const ForgotPasswordScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/saved-recipe': (context) => const SavedRecipesScreen(),
        '/emailverification': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return EmailVerificationScreen(email: args['email'],);
        },
      },
    );
  }
}
*/

// dynamic for different user
// old
/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/screens/forgot_password.dart';
import 'package:my_first_app/screens/notification_screen.dart';
import 'package:my_first_app/screens/saved_recipe_screen.dart';
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
import 'package:my_first_app/models/user.dart'; // Add this import for your User model

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Add other providers here if needed
      ],
      child: const MyApp(),
    ),
  );
}

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<void> login(String email, String password) async {
    // Replace with your actual authentication logic
    // Mock user for demonstration
    _currentUser = User(
      id: '1',
      fullName: 'Alice Smith',
      email: email,
      dietaryRestrictions: 'Vegetarian',
      allergies: 'None',
      cuisinePreferences: 'Italian',
      skillLevel: 'Intermediate',
    );
    notifyListeners();
  }

  Future<void> updateUser(User updatedUser) async {
    _currentUser = updatedUser;
    notifyListeners();
    // Here you would typically also update the user in your backend
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
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
      routes: {
        '/launch': (context) => const LaunchScreen(),
        '/': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/meal-planning': (context) => const MealPlanningPage(),
        '/recipe': (context) => const RecipeScreen(),
        '/edit-profile': (context) {
          final user = Provider.of<UserProvider>(context).currentUser;
          return EditProfilePage(user: user!);
        },
        '/about': (context) => const AboutUsPage(),
        '/forgotpassword': (context) => const ForgotPasswordScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/saved-recipe': (context) => const SavedRecipesScreen(),
      },
      onGenerateRoute: (settings) {
        // Handle routes that need special initialization
        if (settings.name == '/welcome') {
          return MaterialPageRoute(builder: (_) => const WelcomePage());
        }
        return null;
      },
    );
  }
}
*/


//latest

import 'package:flutter/material.dart';
import 'package:ForkTune/screens/add_recipe_screen.dart';
import 'package:provider/provider.dart';
import 'package:ForkTune/providers/user_provider.dart';
import 'package:ForkTune/screens/email_verification.dart';
import 'package:ForkTune/screens/forgot_password.dart';
import 'package:ForkTune/screens/notification_screen.dart';
import 'package:ForkTune/screens/saved_recipe_screen.dart';
import 'package:ForkTune/screens/signup_screen.dart';
import 'package:ForkTune/screens/launch_screen.dart';
import 'package:ForkTune/screens/about_us_page.dart';
import 'package:ForkTune/screens/profile_page.dart';
import 'package:ForkTune/screens/EditProfilePage.dart';
import 'package:ForkTune/screens/home_page.dart';
import 'package:ForkTune/screens/meal_planner_page.dart';
import 'package:ForkTune/screens/recipe_screen.dart';
import 'package:ForkTune/screens/login_screen.dart';
import 'package:window_size/window_size.dart';
// 15, 32, 45, 80
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  setWindowTitle('Forktune');
  setWindowMinSize(Size(430, 830)); // Set desired min window size
  setWindowMaxSize(Size(430, 830));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider()..loadUser(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Forktune',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/launch',
        routes: {
          '/launch': (context) => const LaunchScreen(),
          '/': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpPage(),
          '/home': (context) => const HomePage(),
          '/profile': (context) => const ProfilePage(),
          '/meal-planning': (context) => const MealPlanningPage(),
          '/recipe': (context) => const RecipeScreen(),
          '/edit-profile': (context) {
            final user = Provider.of<UserProvider>(context).currentUser;
            if (user == null) {
              return const Scaffold(
                body: Center(child: Text('Please login first')),
              );
            }
            return const EditProfilePage(); // No need to pass user now
          },
          '/about': (context) => const AboutUsPage(),
          '/forgotpassword': (context) => const ForgotPasswordPage(),
          '/notifications': (context) => const NotificationScreen(),
          '/saved-recipe': (context) => const SavedRecipesScreen(),
          '/email-verification': (context) {
            final email = ModalRoute.of(context)!.settings.arguments as String;
            return EmailVerificationScreen(email: email);
          },
          '/add-recipe': (context) => AddRecipeScreen(
            selectedDate: DateTime.now(),
          ),
        },
      ),
    );
  }
}
