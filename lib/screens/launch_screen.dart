// falling leaves
import 'package:flutter/material.dart';
import 'dart:math';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;
  late List<Widget> _fallingParticles;

  @override
  void initState() {
    super.initState();
    _generateFallingParticles();
  }

  // Generate falling leaf particles
  void _generateFallingParticles() {
    List<Widget> particles = [];
    List<AnimationController> controllers = [];
    List<Animation<Offset>> animations = [];

    for (int i = 0; i < 30; i++) {
      double startX = Random().nextDouble() * 300; // Random X position
      double startY = -50.0; // Start off-screen
      double endY = 700.0 + Random().nextDouble() * 1000; // Random end Y position

      // Create AnimationController for each leaf
      AnimationController controller = AnimationController(
        duration: Duration(seconds: 8 + Random().nextInt(4)),
        vsync: this,
      )..repeat();

      // Define the leaf falling animation
      Animation<Offset> animation = Tween<Offset>(
        begin: Offset(startX, startY),
        end: Offset(startX, endY),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ));

      // Store the animation and controller
      controllers.add(controller);
      animations.add(animation);

      // Create a widget for each leaf
      particles.add(
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Positioned(
              left: animation.value.dx,
              top: animation.value.dy,
              child: Opacity(
                opacity: 0.5, // You can adjust opacity here
                child: Image.asset(
                  'assets/images/leaf1.png', // Replace with your leaf or snowflake image
                  width: 50,
                  height: 40,
                ),
              ),
            );
          },
        ),
      );
    }

    setState(() {
      _fallingParticles = particles;
      _controllers = controllers;
      _animations = animations;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: SafeArea(
        child: Stack(
          children: [
            // Falling leaves particles
            ..._fallingParticles,
            // Center content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image with styling and glow effect
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amberAccent.withOpacity(0.7), // Glowing color (adjust as needed)
                            blurRadius: 20, // The blur amount of the glow
                            spreadRadius: 5, // How far the glow spreads
                            offset: Offset(0, 0), // No offset to center the glow
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/launch_image.png', // Replace with the new image
                          width: 250,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Forktune',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A6CFF),
                        fontFamily: 'Roboto', // You can replace with a custom font
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your Personalized Cooking Journey',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A6CFF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}









// import 'package:flutter/material.dart';
//
// class LaunchScreen extends StatelessWidget {
//   const LaunchScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/images/launch_image.png',
//                   width: 200,
//                   height: 150,
//                   fit: BoxFit.contain,
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Forktune',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF6A6CFF),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'Your Personalized Cooking Journey',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.black,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 36),
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pushReplacementNamed(context, '/login');
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF6A6CFF),
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Get Started',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

/*
import 'package:flutter/material.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/launch_image.png',
                  width: 200,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Forktune',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A6CFF),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your Personalized Cooking Journey',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6A6CFF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/

/*
import 'package:flutter/material.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), //0xFFFFF8E1,0xFFF9C1B2,0xFFF8C8B8
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image with styling
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/launch_image.png', // Replace with the new image
                      width: 250,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Forktune',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A6CFF),
                    fontFamily: 'Roboto', // You can replace with a custom font
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your Personalized Cooking Journey',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A6CFF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/

// poor animation
/*
import 'package:flutter/material.dart';
import 'dart:math';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _animations;

  // This will hold the screen dimensions once they're available
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only calculate the screen size once dependencies are ready
    if (screenWidth == 0 && screenHeight == 0) {
      final mediaQuery = MediaQuery.of(context);
      setState(() {
        screenWidth = mediaQuery.size.width;
        screenHeight = mediaQuery.size.height;
      });

      // Initialize animations with the correct screen size
      _animations = List.generate(
        5, // Number of floating images
            (_) => _createRandomAnimation(),
      );
    }
  }

  // Creates an animation for a random position that will move around the screen
  Animation<Offset> _createRandomAnimation() {
    final random = Random();

    final startX = random.nextDouble() * screenWidth;
    final startY = random.nextDouble() * screenHeight;

    final endX = random.nextDouble() * screenWidth;
    final endY = random.nextDouble() * screenHeight;

    return Tween<Offset>(
      begin: Offset(startX, startY),
      end: Offset(endX, endY),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: SafeArea(
        child: Stack(
          children: [
            // Background content (centered UI elements)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image with styling
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/launch_image.png', // Replace with the new image
                          width: 250,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Forktune',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A6CFF),
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your Personalized Cooking Journey',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A6CFF),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Floating images
            if (_animations.isNotEmpty)
              for (var i = 0; i < _animations.length; i++)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Positioned(
                      left: _animations[i].value.dx,
                      top: _animations[i].value.dy,
                      child: Opacity(
                        opacity: 0.1, // Adjust opacity for watermark effect
                        child: Image.asset(
                          'assets/images/launch_image.png', // Use your watermark images here
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
*/

// glowing logo
/*
import 'package:flutter/material.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image with styling and glow effect
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amberAccent.withOpacity(0.7), // Glowing color (adjust as needed)
                        blurRadius: 20, // The blur amount of the glow
                        spreadRadius: 5, // How far the glow spreads
                        offset: Offset(0, 0), // No offset to center the glow
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/launch_image.png', // Replace with the new image
                      width: 250,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Forktune',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A6CFF),
                    fontFamily: 'Roboto', // You can replace with a custom font
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your Personalized Cooking Journey',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A6CFF),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/


