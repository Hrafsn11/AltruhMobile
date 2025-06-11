import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/campaign.dart';
import 'campaign_detail_page.dart';
import '../widgets/campaign_card.dart';
import '../core/api_config.dart';

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
          await http.get(Uri.parse('${ApiConfig.baseUrl}:8000/api/campaigns'));
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: _getTypeColor(widget.campaignType),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getTypeColor(widget.campaignType),
                _getTypeColor(widget.campaignType).withOpacity(0.8),
                _getTypeColor(widget.campaignType).withOpacity(0.6),
              ],
            ),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: fetchFilteredCampaigns,
              icon: const Icon(Icons.refresh, color: Colors.white),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: _getTypeColor(widget.campaignType),
        onRefresh: fetchFilteredCampaigns,
        child: isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.amber,
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Memuat kampanye...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : error.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red[400],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Oops!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.red[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: fetchFilteredCampaigns,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getTypeColor(widget.campaignType),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text(
                            'Coba Lagi',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : campaigns.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: _getTypeColor(widget.campaignType)
                                    .withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _getTypeColor(widget.campaignType)
                                      .withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                _getTypeIcon(widget.campaignType),
                                size: 64,
                                color: _getTypeColor(widget.campaignType),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Belum Ada Kampanye',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                'Belum ada kampanye ${widget.title.toLowerCase()} yang tersedia saat ini.\nCoba lagi nanti!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[500],
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            // Type Info Card
                            Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getTypeColor(widget.campaignType)
                                        .withOpacity(0.1),
                                    _getTypeColor(widget.campaignType)
                                        .withOpacity(0.05)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _getTypeColor(widget.campaignType)
                                      .withOpacity(0.2),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getTypeColor(widget.campaignType)
                                        .withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(widget.campaignType),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      _getTypeIcon(widget.campaignType),
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: _getTypeColor(
                                                widget.campaignType),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${campaigns.length} Kampanye Tersedia',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: _getTypeColor(
                                                    widget.campaignType)
                                                .withOpacity(0.7),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(widget.campaignType),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _getTypeDescription(widget.campaignType),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Campaigns List
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: campaigns.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: GestureDetector(
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
                                    child: CampaignCard(
                                        campaign: campaigns[index]),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'financial':
        return Colors.green;
      case 'goods':
        return Colors.blue;
      case 'emotional':
        return Colors.purple;
      default:
        return Colors.amber;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'financial':
        return Icons.monetization_on;
      case 'goods':
        return Icons.inventory;
      case 'emotional':
        return Icons.favorite;
      default:
        return Icons.campaign;
    }
  }

  String _getTypeDescription(String type) {
    switch (type) {
      case 'financial':
        return 'Bantuan Uang';
      case 'goods':
        return 'Bantuan Barang';
      case 'emotional':
        return 'Dukungan Moral';
      default:
        return 'Kampanye';
    }
  }
}
