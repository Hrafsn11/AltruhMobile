import 'dart:io';

import 'package:donasi_app/data/dummy_identity_verification.dart';
import 'package:donasi_app/models/identity_verification_model.dart';
import 'package:donasi_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VerifikasiIdentitasPage extends StatefulWidget {
  final UserModel user;
  const VerifikasiIdentitasPage({super.key, required this.user});

  @override
  State<VerifikasiIdentitasPage> createState() =>
      _VerifikasiIdentitasPageState();
}

class _VerifikasiIdentitasPageState extends State<VerifikasiIdentitasPage> {
  final ktpController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    IdentityVerificationModel? match = identityVerifications
        .where((item) => item.user.id == widget.user.id)
        .cast<IdentityVerificationModel?>()
        .firstWhere(
          (e) => true,
          orElse: () => null,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Identitas'),
        backgroundColor: Colors.amber[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          match == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('No. KTP'),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: ktpController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Masukkan NO. KTP';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Masukkan No. KTP',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Foto KTP'),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: _pickImage,
                      child: _image != null
                          ? Image.file(_image!, width: double.infinity)
                          : Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xffE7ECFA)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(Icons.image,
                                    size: 50, color: Colors.grey),
                              ),
                            ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.amber[700]),
                        ),
                        onPressed: () {
                          if (ktpController.text.isNotEmpty && _image != null) {
                            identityVerifications.add(IdentityVerificationModel(
                              id: identityVerifications.length + 1,
                              user: widget.user,
                              ktpNumber: ktpController.text,
                              photo: _image!.path,
                              status: 'Menunggu',
                            ));
                          }
                          setState(() {});
                        },
                        child: const Text('Simpan'),
                      ),
                    )
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status     : ${match.status}'),
                    const SizedBox(height: 8),
                    Text('No. KTP  : ${match.ktpNumber}'),
                    const SizedBox(height: 8),
                    const Text('Foto KTP :'),
                    const SizedBox(height: 4),
                    if (File(match.photo).existsSync())
                      Image.file(File(match.photo), width: double.infinity),
                  ],
                ),
        ],
      ),
    );
  }
}
