import 'dart:io';

import 'package:donasi_app/data/dummy_identity_verification.dart';
import 'package:donasi_app/models/identity_verification_model.dart';
import 'package:donasi_app/pages/detail_verifikasi_identitas_page.dart';
import 'package:flutter/material.dart';

class VerifikasiIdentitasAdminPage extends StatefulWidget {
  const VerifikasiIdentitasAdminPage({super.key});

  @override
  State<VerifikasiIdentitasAdminPage> createState() =>
      _VerifikasiIdentitasAdminPageState();
}

class _VerifikasiIdentitasAdminPageState
    extends State<VerifikasiIdentitasAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Identitas'),
        backgroundColor: Colors.amber[700],
      ),
      body: ListView.builder(
        itemCount: identityVerifications.length,
        itemBuilder: (context, index) {
          IdentityVerificationModel data = identityVerifications[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailVerifikasiIdentitasPage(
                            data: data,
                          )));
            },
            child: Card(
              color: Colors.white,
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status     : ${data.status}'),
                    const SizedBox(height: 8),
                    Text('No. KTP  : ${data.ktpNumber}'),
                    const SizedBox(height: 8),
                    Image.file(
                      File(data.photo),
                      width: double.infinity,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              setState(() {
                                identityVerifications[index].status =
                                    'Disetujui';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Verifikasi'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              setState(() {
                                identityVerifications[index].status = 'Ditolak';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Tolak'),
                          ),
                        ),
                      ],
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
