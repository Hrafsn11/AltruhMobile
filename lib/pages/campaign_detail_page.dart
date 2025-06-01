import 'package:flutter/material.dart';
import '../models/campaign.dart';
import '../models/user_model.dart';
import 'donasi_page.dart';

class CampaignDetailPage extends StatefulWidget {
  final Campaign campaign;
  final UserModel user;

  const CampaignDetailPage({
    super.key,
    required this.campaign,
    required this.user,
  });

  @override
  State<CampaignDetailPage> createState() => _CampaignDetailPageState();
}

class _CampaignDetailPageState extends State<CampaignDetailPage> {
  void _handleDonationButton(BuildContext context) {
    // Navigasi ke halaman donasi universal (DonasiPage) yang otomatis menyesuaikan tipe campaign
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DonasiPage(
          campaign: {
            'id': widget.campaign.id,
            'title': widget.campaign.title,
            'description': widget.campaign.description,
            'type': widget.campaign.type.toLowerCase(),
          },
          user: widget.user, 
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;

    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.amber[700],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  (campaign.imageUrl.isNotEmpty)
                      ? Image.network(
                          campaign.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 40),
                          ),
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 40),
                        ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.10),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.campaign,
                            color: Colors.amber, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          campaign.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4E342E),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.amber[100],
                        child: const Icon(Icons.person, color: Colors.brown),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dibuat oleh',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFF8D6E63)),
                          ),
                          Text(
                            campaign.creatorName,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4E342E)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.08),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(color: Colors.amber[100]!, width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Terkumpul',
                                  style: TextStyle(
                                      color: Color(0xFF8D6E63), fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  campaign.displayCollected,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4E342E)),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.amber[50],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.amber[200]!),
                              ),
                              child: Text(
                                campaign.type.toUpperCase(),
                                style: const TextStyle(
                                    color: Color(0xFF8D6E63),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: campaign.progress.clamp(0, 1),
                            backgroundColor: Colors.amber[50],
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.amber[700]!),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Target: ${campaign.displayTarget}',
                          style: const TextStyle(
                              color: Color(0xFF8D6E63), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Tentang Campaign',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4E342E)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber[100]!),
                    ),
                    child: Text(
                      campaign.description,
                      style: const TextStyle(
                          fontSize: 16, height: 1.6, color: Color(0xFF5D4037)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () => _handleDonationButton(context),
          icon: const Icon(Icons.volunteer_activism, color: Colors.white),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[700],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 2,
          ),
          label: const Text(
            'Donasi Sekarang',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
