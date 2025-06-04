import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
    final url = Uri.parse('http://192.168.100.141:8000/api/my-donations');
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
      appBar: AppBar(
        title: const Text('Riwayat Donasi'),
        backgroundColor: Colors.amber[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.amber[50],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : donations.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/empty_state.png',
                            height: 160),
                        const SizedBox(height: 18),
                        const Text('Belum ada riwayat donasi.',
                            style:
                                TextStyle(fontSize: 16, color: Colors.brown)),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: donations.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final d = donations[index];
                        final campaign = d['campaign'] ?? {};
                        final isUang = campaign['type'] == 'financial';
                        final isBarang = campaign['type'] == 'goods';
                        final isEmosional = campaign['type'] == 'emotional';
                        final status = d['payment_verified'] ?? '-';
                        final statusColor = status == 'verified'
                            ? Colors.green
                            : status == 'pending'
                                ? Colors.orange
                                : Colors.red;
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.amber[100]!,
                              width: 1.2,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 16),
                            leading: CircleAvatar(
                              backgroundColor: Colors.amber[50],
                              radius: 28,
                              child: Icon(
                                isUang
                                    ? Icons.attach_money
                                    : isBarang
                                        ? Icons.inventory
                                        : Icons.emoji_emotions,
                                color: Colors.amber[700],
                                size: 30,
                              ),
                            ),
                            title: Text(
                              campaign['title'] ?? '-',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF4E342E)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.amber[50],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          (campaign['type'] ?? '-')
                                              .toString()
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: Color(0xFF8D6E63)),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(Icons.verified,
                                          color: statusColor, size: 18),
                                      const SizedBox(width: 4),
                                      Text(
                                        status == 'verified' ||
                                                status == 'approved'
                                            ? 'Terverifikasi'
                                            : status == 'pending'
                                                ? 'Menunggu Verifikasi'
                                                : status == 'rejected'
                                                    ? 'Ditolak'
                                                    : status,
                                        style: TextStyle(
                                            color: statusColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  if (isUang && d['amount'] != null)
                                    Text('Nominal: Rp${d['amount']}',
                                        style: const TextStyle(fontSize: 14)),
                                  if (isBarang && d['item_quantity'] != null)
                                    Text('Jumlah Barang: ${d['item_quantity']}',
                                        style: const TextStyle(fontSize: 14)),
                                  if (isBarang && d['item_description'] != null)
                                    Text('Barang: ${d['item_description']}',
                                        style: const TextStyle(fontSize: 14)),
                                  if (isEmosional &&
                                      d['initial_message'] != null)
                                    Text('Pesan: ${d['initial_message']}',
                                        style: const TextStyle(fontSize: 14)),
                                  Text(
                                    'Tanggal: ${d['created_at']?.toString().substring(0, 10) ?? '-'}',
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
