import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: authProvider.isAuthenticated
          ? _buildAuthenticatedProfile(context, authProvider, languageProvider)
          : _buildGuestProfile(context),
    );
  }

  Widget _buildAuthenticatedProfile(
    BuildContext context,
    AuthProvider authProvider,
    LanguageProvider languageProvider,
  ) {
    final user = authProvider.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF1977CC),
            child: Text(
              user?.name.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.name ?? 'User',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Chip(
            label: Text(user?.role.toUpperCase() ?? 'PATIENT'),
            backgroundColor: const Color(0xFF1977CC).withOpacity(0.1),
          ),
          const SizedBox(height: 32),
          _buildProfileOption(
            context,
            'Language',
            languageProvider.currentLanguage,
            Icons.language,
            () => _showLanguageDialog(context, languageProvider),
          ),
          _buildProfileOption(
            context,
            'My Appointments',
            '',
            Icons.calendar_today,
            () {},
          ),
          _buildProfileOption(
            context,
            'Medical Records',
            '',
            Icons.folder,
            () {},
          ),
          _buildProfileOption(
            context,
            'Prescriptions',
            '',
            Icons.receipt,
            () {},
          ),
          _buildProfileOption(
            context,
            'Settings',
            '',
            Icons.settings,
            () {},
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await authProvider.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Sign Out'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestProfile(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_outline,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              'Sign in to access your profile',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Create an account or sign in to save your health data, appointments, and more.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1977CC),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Sign In / Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1977CC)),
        title: Text(title),
        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languageProvider.availableLanguages.length,
            itemBuilder: (context, index) {
              final language = languageProvider.availableLanguages[index];
              return ListTile(
                title: Text(language),
                trailing: languageProvider.currentLanguage == language
                    ? const Icon(Icons.check, color: Color(0xFF1977CC))
                    : null,
                onTap: () {
                  languageProvider.setLanguage(language);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
