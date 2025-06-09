import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../core/api_config.dart';
import '../../models/campaign.dart';
import '../../pages/campaign/edit_campaign_page.dart';

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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue[700]),
                                  onPressed: () async {
                                    // TODO: Implement edit campaign functionality
                                    // print('Edit Campaign: ${c['id']}');
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   SnackBar(content: Text('Edit Campaign ${c['title']}')),
                                    // );
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditCampaignPage(campaign: Campaign.fromJson(c)),
                                      ),
                                    );
                                    // Check if edit was successful and refresh list
                                    if (result != null && result is bool && result) {
                                      fetchMyCampaigns();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red[700]),
                                  onPressed: () {
                                    // TODO: Implement delete campaign functionality
                                    _confirmDeleteCampaign(context, c);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  void _confirmDeleteCampaign(BuildContext context, dynamic campaign) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Campaign'),
          content: Text('Apakah Anda yakin ingin menghapus campaign \'${campaign['title']}\'?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _deleteCampaign(campaign['id']); // Panggil fungsi delete
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCampaign(int campaignId) async {
    print('Deleting campaign with ID: $campaignId');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Menghapus campaign...')),
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus: Token tidak ditemukan.')),
      );
      return;
    }

    final url = Uri.parse('${ApiConfig.baseUrl}:8000/api/campaigns/$campaignId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code (deleteCampaign): ${response.statusCode}');
      print('Response Body (deleteCampaign): ${response.body}');

      if (response.statusCode == 200) {
        // Assuming 200 status code indicates successful deletion
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campaign berhasil dihapus.')),
        );
        fetchMyCampaigns(); // Refresh list after successful deletion
      } else if (response.statusCode == 401) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus: Tidak terautentikasi.')),
        );
      } else if (response.statusCode == 403) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus: Tidak diizinkan.')),
        );
      } else if (response.statusCode == 404) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghapus: Campaign tidak ditemukan.')),
        );
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error deleting campaign: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat menghapus campaign: $e')),
      );
    }
  }
}
