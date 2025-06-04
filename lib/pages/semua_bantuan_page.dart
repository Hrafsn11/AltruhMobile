import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../models/user_model.dart';
import '../widgets/campaign_card.dart';
import 'campaign_detail_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/api_config.dart';

class SemuaBantuanPage extends StatefulWidget {
  final UserModel user;
  const SemuaBantuanPage({Key? key, required this.user}) : super(key: key);

  @override
  State<SemuaBantuanPage> createState() => _SemuaBantuanPageState();
}

class _SemuaBantuanPageState extends State<SemuaBantuanPage> {
  List<Campaign> campaigns = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchAllCampaigns();
  }

  Future<void> fetchAllCampaigns() async {
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
    final user = widget.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Bantuan'),
        backgroundColor: Colors.amber[50],
        iconTheme: const IconThemeData(color: Colors.brown),
        elevation: 0,
      ),
      backgroundColor: Colors.amber[50],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.65, // lebih tinggi
                  ),
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: campaigns.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CampaignDetailPage(
                                campaign: campaigns[index], user: user),
                          ),
                        );
                      },
                      child: CampaignCard(campaign: campaigns[index]),
                    );
                  },
                ),
    );
  }
}
