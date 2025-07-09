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

    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

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


// debug code
/*
import 'package:flutter/material.dart';
import 'dart:math';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;
  late final List<Animation<double>> _rotations;
  List<Widget> _fallingParticles = [];

  @override
  void initState() {
    super.initState();
    _controllers = [];
    _animations = [];
    _rotations = [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateFallingParticles();
      debugPrint("Initialized ${_fallingParticles.length} particles");
    });
  }

  void _generateFallingParticles() {
    final screenSize = MediaQuery.of(context).size;
    const particleCount = 30;

    for (int i = 0; i < particleCount; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 10 + Random().nextInt(5)),
      )..repeat();

      final animation = Tween<Offset>(
        begin: Offset(Random().nextDouble() * screenSize.width, -50),
        end: Offset(
          Random().nextDouble() * screenSize.width,
          screenSize.height + 100,
        ),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ));

      final rotation = Tween(begin: 0.0, end: 2 * pi).animate(controller);

      controller.addListener(() {
        setState(() {});
      });

      _controllers.add(controller);
      _animations.add(animation);
      _rotations.add(rotation);

      _fallingParticles.add(
        AnimatedBuilder(
          animation: Listenable.merge([animation, rotation]),
          builder: (context, _) {
            return Positioned(
              left: animation.value.dx,
              top: animation.value.dy,
              child: Transform.rotate(
                angle: rotation.value,
                child: Opacity(
                  opacity: 0.7,
                  child: Icon(
                    Icons.eco, // Using icon as guaranteed fallback
                    color: Colors.green,
                    size: 24 + Random().nextDouble() * 16,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    setState(() {});
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: SizedBox.expand(
        child: Stack(
          children: [
            // DEBUG: Visual layout helper (can remove later)
            Container(color: Colors.red.withOpacity(0.1)),

            // Falling particles
            ..._fallingParticles,

            // Main content
            Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // DEBUG: Visible particle counter
                      Text(
                        'Visible Particles: ${_fallingParticles.length}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Your main content
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/launch_image.png',
                            width: 250,
                            height: 180,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.restaurant,
                              size: 100,
                              color: Colors.amber,
                            ),
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
                          onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}
*/

// updated falling leaves but issue with logo.
/*
import 'package:flutter/material.dart';
import 'dart:math';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers = [];
  late final List<Animation<Offset>> _animations = [];
  late final List<Widget> _fallingParticles = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Wait for the widget to be mounted before generating particles
      _generateFallingParticles();
    });
  }

  void _generateFallingParticles() {
    final particles = <Widget>[];
    final controllers = <AnimationController>[];
    final animations = <Animation<Offset>>[];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    for (int i = 0; i < 30; i++) {
      final startX = Random().nextDouble() * screenWidth;
      final startY = -50.0;
      final endY = screenHeight + 100;

      final controller = AnimationController(
        duration: Duration(seconds: 8 + Random().nextInt(4)),
        vsync: this,
      )..repeat();

      final animation = Tween<Offset>(
        begin: Offset(startX, startY),
        end: Offset(
          startX + (Random().nextDouble() * 0.2 - 0.1) * screenWidth, // Slight horizontal movement
          endY,
        ),
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ));

      controller.addListener(() => setState(() {}));

      controllers.add(controller);
      animations.add(animation);

      final particleSize = 20 + Random().nextDouble() * 30;

      particles.add(
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Positioned(
              left: animation.value.dx,
              top: animation.value.dy,
              child: Transform.rotate(
                angle: controller.value * 2 * pi,
                child: Opacity(
                  opacity: 0.5 + 0.3 * sin(controller.value * 2 * pi),
                  child: Image.asset(
                    'assets/images/leaf1.png',
                    width: particleSize,
                    height: particleSize,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.eco, size: particleSize, color: Colors.green),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    setState(() {
      _controllers.addAll(controllers);
      _animations.addAll(animations);
      _fallingParticles.addAll(particles);
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: SafeArea(
        child: Stack(
          children: [
            // Falling leaves particles
            ..._fallingParticles,
            // Center content
            SingleChildScrollView(
              child: Container(
                width: screenWidth,
                height: screenHeight,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05, // 5% of screen width
                  vertical: screenHeight * 0.02, // 2% of screen height
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image with responsive sizing
                    Container(
                      width: screenWidth * 0.7, // 70% of screen width
                      height: screenHeight * 0.25, // 25% of screen height
                      constraints: BoxConstraints(
                        maxWidth: 300,
                        maxHeight: 200,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amberAccent.withOpacity(0.7),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/launch_image.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.restaurant, size: 80, color: Colors.amber),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03), // 3% of screen height
                    const Text(
                      'Forktune',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A6CFF),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Your Personalized Cooking Journey',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    SizedBox(
                      width: screenWidth * 0.8, // 80% of screen width
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A6CFF),
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.02,
                          ),
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
*/


// previous falling leaves
/*
import 'package:flutter/material.dart';
import 'dart:math';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers = [];
  late final List<Animation<Offset>> _animations = [];
  late final List<Widget> _fallingParticles = [];

  @override
  void initState() {
    super.initState();
    _generateFallingParticles();
  }

  void _generateFallingParticles() {
    final particles = <Widget>[];
    final controllers = <AnimationController>[];
    final animations = <Animation<Offset>>[];

    for (int i = 0; i < 30; i++) {
      final startX = Random().nextDouble() * 300;
      final startY = -50.0;
      final endY = 700.0 + Random().nextDouble() * 1000;

      final controller = AnimationController(
        duration: Duration(seconds: 8 + Random().nextInt(4)),
        vsync: this,
      )..repeat();

      final animation = Tween<Offset>(
        begin: Offset(startX, startY),
        end: Offset(startX + (Random().nextDouble() * 40 - 20), endY), // Add slight horizontal movement
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeIn,
      ));

      controller.addListener(() => setState(() {}));

      controllers.add(controller);
      animations.add(animation);

      particles.add(
        AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Positioned(
              left: animation.value.dx,
              top: animation.value.dy,
              child: Transform.rotate(
                angle: controller.value * 2 * pi, // Rotating animation
                child: Opacity(
                  opacity: 0.5 + 0.3 * sin(controller.value * 2 * pi), // Pulsing opacity
                  child: Image.asset(
                    'assets/images/leaf1.png',
                    width: 30 + 10 * sin(controller.value * pi), // Size variation
                    height: 24 + 8 * sin(controller.value * pi),
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.eco, color: Colors.green), // Fallback widget
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    setState(() {
      _controllers.addAll(controllers);
      _animations.addAll(animations);
      _fallingParticles.addAll(particles);
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amberAccent.withOpacity(0.7),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/launch_image.png',
                          width: 250,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.restaurant, size: 100, color: Colors.amber),
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
          ],
        ),
      ),
    );
  }
}
*/








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


