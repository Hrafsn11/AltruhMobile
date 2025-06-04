import 'package:flutter/material.dart';

import '../models/identity_verification_model.dart';

class DetailVerifikasiIdentitasPage extends StatelessWidget {
  final IdentityVerificationModel data;

  const DetailVerifikasiIdentitasPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Verifikasi Identitas'),
        backgroundColor: Colors.amber[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildItem('Nama', data.fullName),
          _buildItem('Email', data.email),
          _buildItem('Telepon', data.phoneNumber),
          _buildItem('No. KTP', data.ktpNumber),
          _buildItem('Status', data.status),
        ],
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 100,
              child: Text(
                '$label:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
