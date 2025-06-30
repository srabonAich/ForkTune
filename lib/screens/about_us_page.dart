//old
/*
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'ForkTune',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Our Team',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTeamMember(
              name: 'Rafiul Islam Sagor',
              roll: 'Backend',
              email: 'rafiulsagor55@gmail.com',
              photoUrl: 'assets/team/sagor.png',
            ),
            _buildTeamMember(
              name: 'Srabon Aich',
              roll: 'Developer',
              email: 'srabon@gmail.com',
              photoUrl: 'assets/team/srabon.jpg',
            ),
            _buildTeamMember(
              name: 'Ariful Islam',
              roll: 'Designer',
              email: 'arif@gmail.com',
              photoUrl: 'assets/team/Arif.png',
            ),
            _buildTeamMember(
              name: 'Saad',
              roll: 'Designer',
              email: 'Saad@gmail.com',
              photoUrl: 'assets/team/saad.jpg',
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('BACK'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String roll,
    required String email,
    required String photoUrl,
  }) {
    final ImageProvider imageProvider = photoUrl.startsWith('http')
        ? NetworkImage(photoUrl)
        : AssetImage(photoUrl) as ImageProvider;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: imageProvider,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(roll),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _launchEmail(email),
                    child: Text(
                      email,
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email';
    }
  }
}
*/

// new

//new

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F7FA),
              Color(0xFFE4E7EB),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 80, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo/Title
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.restaurant,
                      size: 50,
                      color: Color(0xFF6A6CFF),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'ForkTune',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A6CFF),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your Personal Recipe Companion',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Team Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Meet Our Team',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The people behind ForkTune',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTeamMember(
                      name: 'Rafiul Islam Sagor',
                      role: 'Backend Developer',
                      email: 'rafiulsagor55@gmail.com',
                      photoUrl: 'assets/team/sagor.png',
                    ),
                    _buildDivider(),
                    _buildTeamMember(
                      name: 'Srabon Aich',
                      role: 'Flutter Developer',
                      email: 'srabon@gmail.com',
                      photoUrl: 'assets/team/srabon.jpg',
                    ),
                    _buildDivider(),
                    _buildTeamMember(
                      name: 'Ariful Islam',
                      role: 'UI/UX Designer',
                      email: 'arif@gmail.com',
                      photoUrl: 'assets/team/Arif.png',
                    ),
                    _buildDivider(),
                    _buildTeamMember(
                      name: 'Saad',
                      role: 'Graphic Designer',
                      email: 'Saad@gmail.com',
                      photoUrl: 'assets/team/saad.jpg',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Back Button
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A6CFF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, size: 18),
                      SizedBox(width: 8),
                      Text('Back'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, color: Colors.black12),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String role,
    required String email,
    required String photoUrl,
  }) {
    final ImageProvider imageProvider = photoUrl.startsWith('http')
        ? NetworkImage(photoUrl)
        : AssetImage(photoUrl) as ImageProvider;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF6A6CFF).withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: imageProvider,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                role,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _launchEmail(email),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.email_outlined,
                        size: 16,
                        color: Color(0xFF6A6CFF),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Color(0xFF6A6CFF),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email';
    }
  }
}