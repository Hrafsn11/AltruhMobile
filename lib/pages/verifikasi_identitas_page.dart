import 'package:donasi_app/models/identity_verification_model.dart';
import 'package:donasi_app/models/user_model.dart';
import 'package:flutter/material.dart';

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

  IdentityVerificationModel? _verification;

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Verifikasi Identitas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.amber[700],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.amber[700],
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Memuat data verifikasi...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.amber[700]!,
                          Colors.amber[600]!,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_user,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Verifikasi Identitas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Lengkapi data untuk verifikasi akun Anda',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ), // Content Section
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _verification == null ||
                                (_verification != null &&
                                    _verification!.status == 'rejected')
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Rejection Notice
                                  if (_verification != null &&
                                      _verification!.status == 'rejected')
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 24),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.red[50]!,
                                            Colors.red[100]!
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        border:
                                            Border.all(color: Colors.red[200]!),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.red[100],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.info_outline,
                                              color: Colors.red[700],
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Verifikasi Ditolak',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.red[800],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Silakan periksa kembali data Anda dan ajukan ulang',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  // Form Section
                                  Text(
                                    'Informasi Pribadi',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Pastikan data yang Anda masukkan sesuai dengan identitas resmi',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Name Field
                                  _buildFormField(
                                    label: 'Nama Lengkap',
                                    controller: nameController,
                                    icon: Icons.person_outline,
                                    hint: 'Masukkan nama lengkap sesuai KTP',
                                  ),
                                  const SizedBox(height: 20),

                                  // Email Field
                                  _buildFormField(
                                    label: 'Email',
                                    controller: emailController,
                                    icon: Icons.email_outlined,
                                    hint: 'Masukkan alamat email aktif',
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 20),

                                  // Phone Field
                                  _buildFormField(
                                    label: 'No. Telepon',
                                    controller: phoneController,
                                    icon: Icons.phone_outlined,
                                    hint: 'Masukkan nomor telepon aktif',
                                    keyboardType: TextInputType.phone,
                                  ),
                                  const SizedBox(height: 20),

                                  // Bank Account Field
                                  _buildFormField(
                                    label: 'No. Rekening Bank',
                                    controller: bankController,
                                    icon: Icons.account_balance_outlined,
                                    hint: 'Masukkan nomor rekening bank',
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 20),

                                  // KTP Field
                                  _buildFormField(
                                    label: 'No. KTP',
                                    controller: ktpController,
                                    icon: Icons.credit_card_outlined,
                                    hint: 'Masukkan nomor KTP (16 digit)',
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 32),

                                  // Submit Button
                                  Container(
                                    width: double.infinity,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.amber[600]!,
                                          Colors.amber[700]!
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.amber.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _submitForm,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'Ajukan Verifikasi',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : _verification!.status == 'pending'
                                ? Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.orange[50]!,
                                              Colors.orange[100]!
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                              color: Colors.orange[200]!),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.orange[100],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.hourglass_top,
                                                color: Colors.orange[700],
                                                size: 40,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Menunggu Verifikasi',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.orange[800],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Pengajuan verifikasi identitas Anda sedang diproses oleh admin. Mohon tunggu hingga proses verifikasi selesai.',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.orange[700],
                                                height: 1.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.orange[200],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                'Status: Menunggu Review',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.orange[800],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.blue[200]!),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              color: Colors.blue[600],
                                              size: 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                'Proses verifikasi biasanya memakan waktu 1-3 hari kerja',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue[700],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.green[50]!,
                                              Colors.green[100]!
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                              color: Colors.green[200]!),
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                color: Colors.green[100],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.check_circle,
                                                color: Colors.green[700],
                                                size: 40,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Verifikasi Berhasil!',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.green[800],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Selamat! Identitas Anda telah berhasil diverifikasi. Anda sekarang dapat menggunakan semua fitur platform dengan akses penuh.',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.green[700],
                                                height: 1.5,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green[200],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                'Status: Terverifikasi',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green[800],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.amber[50]!,
                                              Colors.amber[100]!
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.amber[200]!),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star_outline,
                                              color: Colors.amber[700],
                                              size: 24,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Akun Premium Aktif',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.amber[800],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'Nikmati akses penuh ke semua fitur platform',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.amber[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.amber[700],
                  size: 20,
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    FocusScope.of(context).requestFocus(FocusNode());

    // Validation
    if (nameController.text.trim().isEmpty) {
      _showSnackBar('Nama lengkap harus diisi', isError: true);
      return;
    }
    if (emailController.text.trim().isEmpty) {
      _showSnackBar('Email harus diisi', isError: true);
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text.trim())) {
      _showSnackBar('Format email tidak valid', isError: true);
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      _showSnackBar('Nomor telepon harus diisi', isError: true);
      return;
    }
    if (bankController.text.trim().isEmpty) {
      _showSnackBar('Nomor rekening bank harus diisi', isError: true);
      return;
    }
    if (ktpController.text.trim().isEmpty) {
      _showSnackBar('Nomor KTP harus diisi', isError: true);
      return;
    }
    if (ktpController.text.trim().length != 16) {
      _showSnackBar('Nomor KTP harus 16 digit', isError: true);
      return;
    }

    _showLoadingDialog('Mengajukan verifikasi...');

    final result =
        await IdentityVerificationService().createIdentityVerification(
      nameController.text.trim(),
      emailController.text.trim(),
      phoneController.text.trim(),
      bankController.text.trim(),
      ktpController.text.trim(),
    );

    Navigator.of(context).pop();

    result.fold(
      (err) {
        _showSnackBar('Gagal mengajukan verifikasi: $err', isError: true);
      },
      (data) {
        _showSnackBar('Berhasil mengajukan verifikasi identitas');
        _clearForm();
        setState(() {
          isLoading = true;
        });
        _getIdentityVerification();
      },
    );
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircularProgressIndicator(
                color: Colors.amber[700],
                strokeWidth: 3,
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error : Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red[600] : Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    bankController.clear();
    ktpController.clear();
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
