import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hadith_reader/core/app_color.dart';
import 'package:hadith_reader/screen/login_page_view.dart';

import '../providers/home_provider.dart';
import '../providers/profile_provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Profile",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Name", style: TextStyle(fontSize: 12)),
                        Text(
                          user?.displayName ?? 'User',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text("Email", style: TextStyle(fontSize: 12)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              user?.email ?? 'Not provided',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: user?.email ?? ''));
                                  _showSnackBar(
                                      context, "Email copied.", Colors.green);
                                },
                                child: const Icon(Icons.copy)),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildListTile(
                      context,
                      const Icon(Icons.my_location),
                      "Locate Me",
                      () async {
                        final profileProvider = Provider.of<ProfileProvider>(
                            context,
                            listen: false);
                        final hadithProvider =
                            Provider.of<HadithProvider>(context, listen: false);

                        await profileProvider
                            .updateLocation();
                        hadithProvider.fetchPrayerTimings(
                            profileProvider: profileProvider); 
                      },
                    ),
                    const Divider(),
                    _buildListTile(
                      context,
                      const Icon(Icons.logout),
                      "Logout",
                      () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildListTile(
    BuildContext context, Icon icon, String text, VoidCallback onTap) {
  return ListTile(
    leading: icon,
    title: Text(text),
    onTap: onTap,
  );
}

void _showSnackBar(BuildContext context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
    ),
  );
}
