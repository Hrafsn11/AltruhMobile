import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../core/api_config.dart';

class MyCampaignsPage extends StatefulWidget {
  final UserModel user;
  const MyCampaignsPage({Key? key, required this.user}) : super(key: key);

  @override
  State<MyCampaignsPage> createState() => _MyCampaignsPageState();
}

class _MyCampaignsPageState extends State<MyCampaignsPage> {
  List<dynamic> campaigns = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchMyCampaigns();
  }

  Future<void> fetchMyCampaigns() async {
    setState(() {
      isLoading = true;
      error = '';
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse('${ApiConfig.baseUrl}:8000/api/my-campaigns');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          campaigns = data['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Gagal memuat campaign.';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campaign Saya'),
        backgroundColor: Colors.amber[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.amber[50],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : campaigns.isEmpty
                  ? const Center(
                      child: Text('Belum ada campaign yang Anda buat.'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: campaigns.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final c = campaigns[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 2,
                          child: ListTile(
                            leading: Icon(
                              c['type'] == 'financial'
                                  ? Icons.attach_money
                                  : c['type'] == 'goods'
                                      ? Icons.inventory
                                      : Icons.emoji_emotions,
                              color: Colors.amber[700],
                              size: 32,
                            ),
                            title: Text(c['title'] ?? '-',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tipe: ${c['type'] ?? '-'}'),
                                Text('Status: ${c['status'] ?? '-'}'),
                                Text('Target: ${c['display_target'] ?? '-'}'),
                                Text(
                                    'Terkumpul: ${c['display_collected'] ?? '-'}'),
                                Text(
                                    'Tanggal: ${c['created_at']?.toString().substring(0, 10) ?? '-'}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
