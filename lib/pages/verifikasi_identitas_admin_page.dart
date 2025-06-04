import 'package:donasi_app/models/identity_verification_model.dart';
import 'package:donasi_app/pages/detail_verifikasi_identitas_page.dart';
import 'package:donasi_app/service/identity_verification_service.dart';
import 'package:flutter/material.dart';

class VerifikasiIdentitasAdminPage extends StatefulWidget {
  const VerifikasiIdentitasAdminPage({super.key});

  @override
  State<VerifikasiIdentitasAdminPage> createState() =>
      _VerifikasiIdentitasAdminPageState();
}

class _VerifikasiIdentitasAdminPageState
    extends State<VerifikasiIdentitasAdminPage> {
  List<IdentityVerificationModel> verifications = [];

  void _getIdentityVerification() async {
    final result =
        await IdentityVerificationService().getIdentityVerifications();
    isLoading = false;
    result.fold(
      (err) {
        setState(() {
          verifications = [];
        });
      },
      (data) {
        setState(() {
          verifications = data;
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
          : verifications.isEmpty
              ? const Center(child: Text('Tidak ada data'))
              : ListView.builder(
                  itemCount: verifications.length,
                  itemBuilder: (context, index) {
                    IdentityVerificationModel data = verifications[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailVerifikasiIdentitasPage(
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
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                            content: Row(
                                              children: [
                                                CircularProgressIndicator(
                                                  color: Colors.amber[700],
                                                ),
                                                const SizedBox(width: 16),
                                                const Text('Memproses...'),
                                              ],
                                            ),
                                          ),
                                        );
                                        final result =
                                            await IdentityVerificationService()
                                                .approveIdentityVerification(
                                                    data.id);
                                        Navigator.of(context).pop();
                                        result.fold(
                                          (error) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Gagal verifikasi: $error')),
                                            );
                                          },
                                          (message) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(content: Text(message)),
                                            );

                                            setState(() {
                                              isLoading = true;
                                            });
                                            _getIdentityVerification();
                                          },
                                        );
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
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                            content: Row(
                                              children: [
                                                CircularProgressIndicator(
                                                  color: Colors.amber[700],
                                                ),
                                                const SizedBox(width: 16),
                                                const Text('Memproses...'),
                                              ],
                                            ),
                                          ),
                                        );
                                        final result =
                                            await IdentityVerificationService()
                                                .rejectIdentityVerification(
                                                    data.id);
                                        Navigator.of(context).pop();

                                        result.fold(
                                          (error) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Gagal menolak: $error')),
                                            );
                                          },
                                          (message) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(content: Text(message)),
                                            );
                                            setState(() {
                                              isLoading = true;
                                            });
                                            _getIdentityVerification();
                                          },
                                        );
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
