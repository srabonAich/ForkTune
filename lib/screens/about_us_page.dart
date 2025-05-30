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
