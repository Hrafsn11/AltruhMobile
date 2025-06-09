import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';
import '../models/campaign.dart';

class VerifikasiCampaignAdminPage extends StatefulWidget {
  const VerifikasiCampaignAdminPage({super.key});

  @override
  State<VerifikasiCampaignAdminPage> createState() => _VerifikasiCampaignAdminPageState();
}

class _VerifikasiCampaignAdminPageState extends State<VerifikasiCampaignAdminPage> {
  List<dynamic> campaigns = [];
  bool isLoading = true;

  void _getPendingCampaigns() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}:8000/api/admin/campaigns/pending'),
        headers: {
          'Accept': 'application/json',
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
          campaigns = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        campaigns = [];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _getPendingCampaigns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Campaign'),
        backgroundColor: Colors.amber[700],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.amber[700],
              ),
            )
          : campaigns.isEmpty
              ? const Center(child: Text('Tidak ada campaign yang perlu diverifikasi'))
              : ListView.builder(
                  itemCount: campaigns.length,
                  itemBuilder: (context, index) {
                    final campaign = campaigns[index];
                    return Card(
                      margin: const EdgeInsets.all(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              campaign['title'] ?? '-',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Tipe: ${campaign['type'] ?? '-'}'),
                            Text('Target: ${campaign['type'] == 'financial' ? campaign['target_amount']?.toString() ?? campaign['display_target'] ?? '-' : campaign['type'] == 'goods' ? campaign['target_items']?.toString() ?? campaign['display_target'] ?? '-' : campaign['type'] == 'emotional' ? campaign['target_sessions']?.toString() ?? campaign['display_target'] ?? '-' : campaign['display_target'] ?? '-'}'),
                            Text('Pembuat: ${campaign['user'] != null ? campaign['user']['name'] : '-'}'),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => AlertDialog(
                                          content: Row(
                                            children: [
                                              CircularProgressIndicator(
                                                color: Colors.amber[700],
                                              ),
                                              const SizedBox(width: 16),
                                              const Text('Memproses...'),
                                            ],
                                          ),
                                        ),
                                      );

                                      final prefs = await SharedPreferences.getInstance();
                                      final token = prefs.getString('token');
                                      if (token == null) return;

                                      try {
                                        final response = await http.post(
                                          Uri.parse('${ApiConfig.baseUrl}:8000/api/admin/campaigns/${campaign['id']}/approve'),
                                          headers: {
                                            'Accept': 'application/json',
                                            'Authorization': 'Bearer $token',
                                          },
                                        );

                                        Navigator.of(context).pop();

                                        if (response.statusCode == 200) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Campaign berhasil disetujui')),
                                          );
                                          _getPendingCampaigns();
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Gagal menyetujui campaign')),
                                          );
                                        }
                                      } catch (e) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Terjadi kesalahan')),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text('Setujui'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: FilledButton(
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => AlertDialog(
                                          content: Row(
                                            children: [
                                              CircularProgressIndicator(
                                                color: Colors.amber[700],
                                              ),
                                              const SizedBox(width: 16),
                                              const Text('Memproses...'),
                                            ],
                                          ),
                                        ),
                                      );

                                      final prefs = await SharedPreferences.getInstance();
                                      final token = prefs.getString('token');
                                      if (token == null) return;

                                      try {
                                        final response = await http.post(
                                          Uri.parse('${ApiConfig.baseUrl}:8000/api/admin/campaigns/${campaign['id']}/reject'),
                                          headers: {
                                            'Accept': 'application/json',
                                            'Authorization': 'Bearer $token',
                                          },
                                        );

                                        Navigator.of(context).pop();

                                        if (response.statusCode == 200) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Campaign berhasil ditolak')),
                                          );
                                          _getPendingCampaigns();
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Gagal menolak campaign')),
                                          );
                                        }
                                      } catch (e) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Terjadi kesalahan')),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Tolak'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
} 