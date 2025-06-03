import 'dart:io';

import 'package:donasi_app/models/identity_verification_model.dart';
import 'package:donasi_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../service/identity_verification_service.dart';

class VerifikasiIdentitasPage extends StatefulWidget {
  final UserModel user;
  const VerifikasiIdentitasPage({super.key, required this.user});

  @override
  State<VerifikasiIdentitasPage> createState() =>
      _VerifikasiIdentitasPageState();
}

class _VerifikasiIdentitasPageState extends State<VerifikasiIdentitasPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final bankController = TextEditingController();
  final ktpController = TextEditingController();

  File? _image;
  IdentityVerificationModel? _verification;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void _getIdentityVerification() async {
    final result =
        await IdentityVerificationService().getIdentityVerification();
    isLoading = false;
    result.fold(
      (err) {
        setState(() {
          _verification = null;
        });
      },
      (data) {
        setState(() {
          _verification = data;
        });
      },
    );
  }

  @override
  void initState() {
    _getIdentityVerification();
    super.initState();
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Identitas'),
        backgroundColor: Colors.amber[700],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.amber[700],
            ))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _verification == null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nama Lengkap'),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Masukkan Nama Lengkap';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Masukkan Nama Lengkap',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: Colors.grey[400],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('Email'),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Masukkan Email';
                              }
                              final emailRegex =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Masukkan Email',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: Colors.grey[400],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('No. Telepon'),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: phoneController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Masukkan No. Telepon';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Masukkan No. Telepon',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: Colors.grey[400],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text('No. Akun Bank'),
                          const SizedBox(height: 4),
                          TextFormField(
                            controller: bankController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Masukkan No. Akun Bank';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Masukkan  No. Akun Bank',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: Colors.grey[400],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
                            ),
                          ),
                          const SizedBox(height: 10),
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
                            decoration: InputDecoration(
                              hintText: 'Masukkan No. KTP',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                                color: Colors.grey[400],
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 16),
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
                                      border: Border.all(
                                          color: const Color(0xffE7ECFA)),
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
                              onPressed: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                if (nameController.text.isNotEmpty &&
                                    emailController.text.isNotEmpty &&
                                    phoneController.text.isNotEmpty &&
                                    bankController.text.isNotEmpty &&
                                    ktpController.text.isNotEmpty &&
                                    _image != null) {
                                  String? pathFile = _image!.path;

                                  final result =
                                      await IdentityVerificationService()
                                          .createIdentityVerification(
                                              nameController.text,
                                              emailController.text,
                                              phoneController.text,
                                              bankController.text,
                                              ktpController.text,
                                              pathFile);

                                  result.fold(
                                    (err) {
                                      _showResultDialog(
                                          success: false,
                                          message: 'Terjadi Kesalahan');
                                      setState(() {});
                                    },
                                    (data) {
                                      _showResultDialog(
                                          success: true,
                                          message:
                                              'Berhasil mengajukan verifikasi identitas');
                                      setState(() {
                                        _getIdentityVerification();
                                      });
                                    },
                                  );
                                }
                              },
                              child: const Text('Simpan'),
                            ),
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListItem(
                              title: 'Status', value: _verification!.status),
                          const SizedBox(height: 10),
                          ListItem(
                              title: 'Nama Lengkap',
                              value: _verification!.fullName),
                          const SizedBox(height: 10),
                          ListItem(title: 'Email', value: _verification!.email),
                          const SizedBox(height: 10),
                          ListItem(
                              title: 'No. Telepon',
                              value: _verification!.phoneNumber),
                          const SizedBox(height: 10),
                          ListItem(
                              title: 'No. Akun Bank',
                              value: _verification!.bankAccountNumber),
                          const SizedBox(height: 10),
                          ListItem(
                              title: 'No. KTP',
                              value: _verification!.ktpNumber),
                          const SizedBox(height: 10),
                          const Text('Foto KTP :'),
                          const SizedBox(height: 4),
                          Image.network(
                              'http://192.168.100.97:8000/storage/${_verification!.photo}')
                        ],
                      ),
              ],
            ),
    );
  }

  Future<void> _showResultDialog(
      {required bool success, required String message}) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(success ? Icons.check_circle : Icons.error,
                color: success ? Colors.green : Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                color: success ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String title;
  final String value;
  const ListItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          child: Text(value),
        ),
      ],
    );
  }
}
