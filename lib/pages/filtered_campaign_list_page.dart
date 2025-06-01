import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/campaign.dart';
import 'campaign_detail_page.dart';
import '../widgets/campaign_card.dart';

class FilteredCampaignListPage extends StatefulWidget {
  final String campaignType; // 'financial', 'goods', 'emotional'
  final String title;
  final dynamic user;

  const FilteredCampaignListPage({
    Key? key,
    required this.campaignType,
    required this.title,
    required this.user,
  }) : super(key: key);

  @override
  State<FilteredCampaignListPage> createState() =>
      _FilteredCampaignListPageState();
}

class _FilteredCampaignListPageState extends State<FilteredCampaignListPage> {
  List<Campaign> campaigns = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchFilteredCampaigns();
  }

  Future<void> fetchFilteredCampaigns() async {
    setState(() {
      isLoading = true;
      error = '';
    });
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.4:8000/api/campaigns'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['data'] ?? [];
        campaigns = list
            .map((e) => Campaign.fromJson(e))
            .where((c) => c.type == widget.campaignType)
            .toList();
      } else {
        error = 'Gagal memuat kampanye.';
      }
    } catch (e) {
      error = 'Tidak dapat terhubung ke server.';
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.amber[50],
        iconTheme: const IconThemeData(color: Colors.brown),
        elevation: 0,
      ),
      backgroundColor: Colors.amber[50],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : campaigns.isEmpty
                  ? const Center(
                      child: Text('Belum ada kampanye untuk kategori ini.'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  campaign: campaigns[index],
                                  user: widget.user,
                                ),
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
