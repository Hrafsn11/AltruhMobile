import 'package:donasi_app/models/user_model.dart';
import 'package:donasi_app/pages/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/create_campaign_page.dart';
import 'pages/profile_page.dart';
import 'core/theme.dart';
import 'pages/splash_screen.dart';

void main() {
  runApp(const AltruhApp());
}

class AltruhApp extends StatelessWidget {
  const AltruhApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Altruh App',
      theme: altruhTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  final UserModel user;
  const MainNavigation({super.key, required this.user});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  List<Widget> _pages = [];

  @override
  void initState() {
    _pages = [
      HomePage(user: widget.user),
      CreateCampaignPage(),
      ProfilePage(user: widget.user),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[700],
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Galang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
