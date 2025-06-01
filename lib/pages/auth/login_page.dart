import 'package:donasi_app/models/user_model.dart';
import 'package:flutter/material.dart';
import '/../main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String error = '';
  bool _isObscure = true;

  void login() async {
    final email = emailCtrl.text;
    final pass = passwordCtrl.text;
    setState(() {
      error = '';
    });
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.4:8000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': pass}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          data['success'] == true &&
          data['user'] != null) {
        final userMap = data['user'] as Map<String, dynamic>;
        final user = UserModel(
          id: userMap['id'] is int
              ? userMap['id']
              : int.tryParse(userMap['id']?.toString() ?? '0') ?? 0,
          name: userMap['name']?.toString() ?? '',
          email: userMap['email']?.toString() ?? '',
          phone: userMap['phone']?.toString() ?? '',
          password: '',
          role: (userMap['is_admin'] == true || userMap['is_admin'] == 1)
              ? 'admin'
              : 'user',
        );
        // Simpan token ke SharedPreferences
        if (data['token'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login berhasil! Selamat datang,  ${user.name}'),
            backgroundColor: Colors.green[700],
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 800));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MainNavigation(user: user),
          ),
        );
      } else {
        setState(() {
          error = data['message']?.toString() ?? 'Login gagal.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        error = 'Tidak dapat terhubung ke server. Error: ${e.toString()}';
      });
      print('LOGIN ERROR: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                // Logo and Welcome Text
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.volunteer_activism,
                        size: 80,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Selamat Datang',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Masuk untuk melanjutkan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // Email Field
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukkan email anda',
                    prefixIcon: Icon(Icons.email, color: Colors.amber[700]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.amber[700]!),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Field
                TextField(
                  controller: passwordCtrl,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password anda',
                    prefixIcon: Icon(Icons.lock, color: Colors.amber[700]),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.amber[700]!),
                    ),
                  ),
                ),

                // Error Message
                if (error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[100]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red[700], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 30),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 16),
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
