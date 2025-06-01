import 'dart:io';

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
          Align(
            alignment: Alignment.center,
            child: ClipOval(
              child: data.user.photo != null
                  ? Image.file(
                      File(data.user.photo!),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/img_profile.webp',
                      width: 80,
                    ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          _buildItem('Nama', data.user.name),
          _buildItem('Email', data.user.email),
          _buildItem('Telepon', data.user.phone),
          _buildItem('No. KTP', data.ktpNumber),
          _buildItem('Status', data.status),
          const SizedBox(height: 12),
          const Text(
            'Foto KTP',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Image.file(
            File(data.photo),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
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
