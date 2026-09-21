import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final loginTime = DateTime.now();
    final formattedTime =
        '${loginTime.hour.toString().padLeft(2, '0')}:${loginTime.minute.toString().padLeft(2, '0')}:${loginTime.second.toString().padLeft(2, '0')}';
    final formattedDate =
        '${loginTime.day.toString().padLeft(2, '0')}/${loginTime.month.toString().padLeft(2, '0')}/${loginTime.year}';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome header card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 36, color: Colors.blue),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Welcome, $username!',
                    key: const Key('welcomeText'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'You have successfully logged in',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Session info card
            _sectionTitle('Session Info'),
            _infoCard([
              _infoRow(Icons.badge_outlined, 'Username', username),
              _infoRow(Icons.access_time, 'Login Time', formattedTime),
              _infoRow(
                  Icons.calendar_today_outlined, 'Login Date', formattedDate),
              _infoRow(Icons.verified_user_outlined, 'Status', 'Active'),
            ]),

            const SizedBox(height: 20),

            // App info card
            _sectionTitle('App Info'),
            _infoCard([
              _infoRow(Icons.apps, 'App Name', 'CI/CD POC App'),
              _infoRow(Icons.tag, 'Version', '1.0.0'),
              _infoRow(Icons.flutter_dash, 'Framework', 'Flutter'),
              _infoRow(Icons.dns_outlined, 'Environment', 'Debug / POC'),
            ]),

            const SizedBox(height: 20),

            // Pipeline info card
            _sectionTitle('This POC Demonstrates'),
            _infoCard([
              _infoRow(Icons.rule_folder_outlined, 'Unit Testing',
                  'login_logic_test.dart'),
              _infoRow(
                  Icons.widgets_outlined, 'Widget Testing', 'widget_test.dart'),
              _infoRow(Icons.api_outlined, 'API Testing', 'Karate + Cucumber'),
              _infoRow(Icons.fact_check_outlined, 'Quality Gate',
                  'SonarQube / SonarCloud'),
              _infoRow(Icons.autorenew, 'CI/CD', 'GitHub Actions'),
            ]),

            const SizedBox(height: 28),

            ElevatedButton.icon(
              key: const Key('logoutButton'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _infoCard(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: rows),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
