import 'package:flutter/material.dart';
import 'auth/login_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'image': 'assets/images/img_profile.webp',
      'title': 'Selamat Datang di Altruh',
      'desc':
          'Altruh adalah platform donasi dan galang dana yang mudah, aman, dan transparan. Bersama, kita bisa membantu lebih banyak orang.'
    },
    {
      'image': 'assets/images/img_profile.webp',
      'title': 'Buat & Dukung Campaign',
      'desc':
          'Buat campaign galang dana untuk tujuan sosial, pendidikan, kesehatan, dan lainnya. Dukung campaign lain dengan donasi yang transparan.'
    },
    {
      'image': 'assets/images/img_profile.webp',
      'title': 'Transparan & Aman',
      'desc':
          'Setiap donasi tercatat, dapat dilacak, dan laporan penggunaan dana tersedia. Keamanan data dan transaksi Anda adalah prioritas kami.'
    },
    {
      'image': 'assets/images/img_profile.webp',
      'title': 'Komunitas Peduli',
      'desc':
          'Gabung bersama komunitas Altruh, berbagi inspirasi, dan wujudkan perubahan positif untuk Indonesia.'
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFE082), Color(0xFFFFF8E1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _onboardingData.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.15),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Image.asset(data['image']!, width: 120),
                            ),
                            const SizedBox(height: 32),
                            Text(
                              data['title']!,
                              style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFB300)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              data['desc']!,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.brown),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.amber
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      icon: Icon(_currentPage == _onboardingData.length - 1
                          ? Icons.check
                          : Icons.arrow_forward),
                      label: Text(_currentPage == _onboardingData.length - 1
                          ? 'Mulai Sekarang'
                          : 'Lanjut'),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
