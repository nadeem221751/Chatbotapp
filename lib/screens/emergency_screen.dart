import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Services'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmergencyBanner(),
            const SizedBox(height: 24),
            const Text(
              'Emergency Helplines',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildHelplineCard(
              'Emergency Services',
              '112',
              'All emergency services',
              Icons.emergency,
              Colors.red,
            ),
            _buildHelplineCard(
              'Ambulance',
              '102',
              'Medical emergency ambulance',
              Icons.local_hospital,
              Colors.orange,
            ),
            _buildHelplineCard(
              'National Health Helpline',
              '1800-180-1104',
              'Health information and guidance',
              Icons.health_and_safety,
              Colors.blue,
            ),
            _buildHelplineCard(
              'Mental Health Helpline',
              '08046110007',
              'NIMHANS mental health support',
              Icons.psychology,
              Colors.purple,
            ),
            _buildHelplineCard(
              'Women Helpline',
              '181',
              'Women in distress',
              Icons.woman,
              Colors.pink,
            ),
            _buildHelplineCard(
              'Child Helpline',
              '1098',
              'Children in need',
              Icons.child_care,
              Colors.green,
            ),
            const SizedBox(height: 24),
            _buildNearbyHospitalsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.warning_amber_rounded, size: 50, color: Colors.red.shade700),
          const SizedBox(height: 12),
          Text(
            'In case of emergency, call immediately',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Do not wait. Every second counts.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHelplineCard(
    String title,
    String number,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(description, style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.phone, color: color),
          onPressed: () => _makePhoneCall(number),
        ),
      ),
    );
  }

  Widget _buildNearbyHospitalsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nearby Hospitals',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            // Open maps to find nearby hospitals
            _openMaps();
          },
          icon: const Icon(Icons.map),
          label: const Text('Find Nearby Hospitals'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1977CC),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Coming Soon'),
                content: const Text('Ambulance booking feature is coming soon! For now, please call 102 directly.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _makePhoneCall('102');
                    },
                    child: const Text('Call 102'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.local_hospital),
          label: const Text('Request Ambulance'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openMaps() async {
    final Uri launchUri = Uri.parse(
      'https://www.google.com/maps/search/hospitals+near+me',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }
}
