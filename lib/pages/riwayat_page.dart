import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';

class RiwayatPage extends StatefulWidget {
  final dynamic user;
  const RiwayatPage({Key? key, required this.user}) : super(key: key);

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<dynamic> donations = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchDonations();
  }

  Future<void> fetchDonations() async {
    setState(() {
      isLoading = true;
      error = '';
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final url = Uri.parse('${ApiConfig.baseUrl}:8000/api/my-donations');
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
          donations = data['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Gagal memuat riwayat donasi.';
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Riwayat Donasi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.amber[700],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: fetchDonations,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Colors.amber[700],
        onRefresh: fetchDonations,
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
                      'Memuat riwayat donasi...',
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
                          onPressed: fetchDonations,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[700],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                : donations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.history_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum Ada Riwayat',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Anda belum melakukan donasi apapun.\nMulai berbagi kebaikan sekarang!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[500],
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          // Header Stats
                          Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.amber[100]!, Colors.amber[50]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.amber[200]!),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.amber[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.volunteer_activism,
                                    color: Colors.amber[800],
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
                                        'Total Donasi Anda',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.amber[800],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${donations.length} donasi',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.amber[900],
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
                                    color: Colors.amber[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Terima Kasih!',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.amber[900],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Donations List
                          Expanded(
                            child: ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: donations.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final d = donations[index];
                                return _buildDonationCard(d);
                              },
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }

  Widget _buildDonationCard(dynamic donation) {
    final campaign = donation['campaign'] ?? {};
    final type = campaign['type'] ?? '';
    final status = donation['payment_verified'] ?? 'pending';

    Color statusColor;
    Color statusBgColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'verified':
      case 'approved':
        statusColor = Colors.green[700]!;
        statusBgColor = Colors.green[50]!;
        statusText = 'Terverifikasi';
        statusIcon = Icons.verified;
        break;
      case 'pending':
        statusColor = Colors.orange[700]!;
        statusBgColor = Colors.orange[50]!;
        statusText = 'Menunggu Verifikasi';
        statusIcon = Icons.hourglass_top;
        break;
      case 'rejected':
        statusColor = Colors.red[700]!;
        statusBgColor = Colors.red[50]!;
        statusText = 'Ditolak';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey[700]!;
        statusBgColor = Colors.grey[50]!;
        statusText = status;
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with campaign info
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCampaignColor(type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCampaignIcon(type),
                    color: _getCampaignColor(type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign['title'] ?? 'Campaign Tidak Diketahui',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getCampaignColor(type).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _getCampaignTypeText(type).toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _getCampaignColor(type),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Status Badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    statusIcon,
                    color: statusColor,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Donation Details
            _buildDonationDetails(donation, type),

            const SizedBox(height: 12),

            // Date
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 6),
                Text(
                  'Tanggal: ${donation['created_at']?.toString().substring(0, 10) ?? '-'}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationDetails(dynamic donation, String type) {
    if (type == 'financial' && donation['amount'] != null) {
      return Row(
        children: [
          Icon(Icons.monetization_on, size: 16, color: Colors.green[600]),
          const SizedBox(width: 6),
          Text(
            'Nominal: Rp ${donation['amount']}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      );
    } else if (type == 'goods') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (donation['item_quantity'] != null)
            Row(
              children: [
                Icon(Icons.inventory_2, size: 16, color: Colors.orange[600]),
                const SizedBox(width: 6),
                Text(
                  'Jumlah: ${donation['item_quantity']} barang',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          if (donation['item_description'] != null) ...[
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.description, size: 16, color: Colors.orange[600]),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Barang: ${donation['item_description']}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    } else if (type == 'emotional' && donation['initial_message'] != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.psychology, size: 16, color: Colors.pink[600]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Pesan: ${donation['initial_message']}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Color _getCampaignColor(String type) {
    switch (type) {
      case 'financial':
        return Colors.green[600]!;
      case 'goods':
        return Colors.orange[600]!;
      case 'emotional':
        return Colors.pink[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getCampaignIcon(String type) {
    switch (type) {
      case 'financial':
        return Icons.monetization_on;
      case 'goods':
        return Icons.inventory_2;
      case 'emotional':
        return Icons.psychology;
      default:
        return Icons.volunteer_activism;
    }
  }

  String _getCampaignTypeText(String type) {
    switch (type) {
      case 'financial':
        return 'Uang';
      case 'goods':
        return 'Barang';
      case 'emotional':
        return 'Emosional';
      default:
        return 'Donasi';
    }
  }
}
