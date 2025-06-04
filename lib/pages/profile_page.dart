import 'dart:io';

import 'package:donasi_app/pages/auth/login_page.dart';
import 'package:donasi_app/pages/campaign/my_campaigns_page.dart';
import 'package:donasi_app/pages/verifikasi_identitas_admin_page.dart';
import 'package:donasi_app/pages/verifikasi_identitas_page.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  final UserModel user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Scaffold(
      backgroundColor: Colors.amber[700],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          ClipOval(
            child: user.photo != null && user.photo!.isNotEmpty
                ? (user.photo!.startsWith('http')
                    ? Image.network(
                        user.photo!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(user.photo!),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ))
                : Image.asset(
                    'assets/images/img_profile.webp',
                    width: 80,
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            user.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            user.email,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.account_circle,
                    title: 'Edit Profile',
                    onTap: () {
                      // Fitur edit profile dinonaktifkan sementara
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Edit Profile belum tersedia.'),
                        ),
                      );
                    },
                  ),
                  // if (user.role != 'admin')
                  _buildMenuItem(
                    icon: Icons.badge_outlined,
                    title: 'Verifikasi Identitas',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VerifikasiIdentitasPage(user: widget.user),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.campaign,
                    title: 'Manajemen Campaign Saya',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MyCampaignsPage(user: widget.user),
                        ),
                      );
                    },
                  ),
                  if (user.role == 'admin')
                    _buildMenuItem(
                      icon: Icons.badge_outlined,
                      title: 'Admin Verifikasi Identitas',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const VerifikasiIdentitasAdminPage(),
                          ),
                        );
                      },
                    ),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Keluar',
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16)),
              child: Icon(
                icon,
                color: Colors.amber[700],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
    );
  }
}
