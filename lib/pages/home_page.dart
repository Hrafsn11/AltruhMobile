import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'riwayat_page.dart';
import 'campaign_detail_page.dart';
import 'semua_bantuan_page.dart';
import '../models/user_model.dart';
import '../models/campaign.dart';
import '../widgets/campaign_card.dart';
import 'filtered_campaign_list_page.dart';
import '../core/api_config.dart';

class HomePage extends StatefulWidget {
  final UserModel user;
  HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Campaign> campaigns = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchCampaigns();
  }

  Future<void> fetchCampaigns() async {
    setState(() {
      isLoading = true;
      error = '';
    });
    try {
      final response =
          await http.get(Uri.parse('${ApiConfig.baseUrl}:8000/api/campaigns'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['data'] ?? [];
        setState(() {
          campaigns = list.map((e) => Campaign.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Gagal memuat kampanye.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Tidak dapat terhubung ke server.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.7;
    final user = widget.user;

    final List<String> carouselImages = [
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=800&q=80',
    ];

    // Menu universal untuk semua user
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.volunteer_activism,
        'label': 'Donasi Uang',
        'type': 'financial'
      },
      {'icon': Icons.shopping_bag, 'label': 'Donasi Barang', 'type': 'goods'},
      {
        'icon': Icons.emoji_emotions,
        'label': 'Emosional', // Singkat agar tidak overflow
        'type': 'emotional'
      },
      {'icon': Icons.history, 'label': 'Riwayat'},
      {'icon': Icons.favorite, 'label': 'Favorit'},
      {'icon': Icons.campaign, 'label': 'Kampanye'},
      {'icon': Icons.people, 'label': 'Komunitas'},
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.amber[50],
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/img_profile.webp'),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Halo,',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                Text(user.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.brown)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.amber),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.amber[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: carousel.CarouselSlider(
                options: carousel.CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.88,
                  autoPlayInterval: const Duration(seconds: 4),
                ),
                items: carouselImages.map((url) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.08),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Horizontal Menu
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (['financial', 'goods', 'emotional']
                            .contains(menuItems[index]['type'])) {
                          String type = menuItems[index]['type'];
                          String title = menuItems[index]['label'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FilteredCampaignListPage(
                                campaignType: type,
                                title: title,
                                user: user,
                              ),
                            ),
                          );
                        } else if (menuItems[index]['label'] == 'Riwayat') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => RiwayatPage(user: user)));
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => const AlertDialog(
                              title: Text('Info'),
                              content: Text(
                                  'Fitur ini belum tersedia atau dinonaktifkan.'),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 90,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withOpacity(0.10),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                menuItems[index]['icon'],
                                color: Colors.amber[700],
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              menuItems[index]['label'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6D4C41),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: Colors.brown, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Ayo berdonasi dan bantu sesama! Lihat kampanye terbaru dan dukung yang membutuhkan.',
                        style:
                            TextStyle(fontSize: 15, color: Colors.brown[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Title Kampanye
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Kampanye Terbaru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),

            // Campaign Cards
            Container(
              height: 350,
              margin: const EdgeInsets.only(bottom: 0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error.isNotEmpty
                      ? Center(child: Text(error))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          itemCount:
                              campaigns.length > 5 ? 5 : campaigns.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: cardWidth,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CampaignDetailPage(
                                          campaign: campaigns[index],
                                          user: user),
                                    ),
                                  );
                                },
                                child: CampaignCard(campaign: campaigns[index]),
                              ),
                            );
                          },
                        ),
            ),
            // Tombol Lihat Semua Bantuan
            if (!isLoading && error.isEmpty && campaigns.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SemuaBantuanPage(user: user),
                        ),
                      );
                    },
                    child: const Text(
                      'Lihat Semua Bantuan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
