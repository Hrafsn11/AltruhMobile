import 'package:flutter/material.dart';
import '../models/donasi.dart';

class DonasiDetailPage extends StatelessWidget {
  final Donasi donasi;

  const DonasiDetailPage({super.key, required this.donasi});

  IconData _getIcon(String tipe) {
    switch (tipe) {
      case 'Barang':
        return Icons.card_giftcard;
      case 'Uang':
        return Icons.attach_money;
      case 'Emosional':
        return Icons.favorite;
      default:
        return Icons.volunteer_activism;
    }
  }

  Color _getColor(String tipe) {
    switch (tipe) {
      case 'Barang':
        return Colors.orange.shade100;
      case 'Uang':
        return Colors.green.shade100;
      case 'Emosional':
        return Colors.pink.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Donasi"),
        backgroundColor: Colors.amber[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and type
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _getColor(donasi.tipe),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _getIcon(donasi.tipe),
                    size: 64,
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    donasi.tipe,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    donasi.judul,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        donasi.tanggal,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    "Detail Donasi",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      donasi.deskripsi,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
