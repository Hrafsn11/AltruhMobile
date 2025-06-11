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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Verifikasi Identitas',
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
          : verifications.isEmpty
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
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada data verifikasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Belum ada pengajuan verifikasi identitas',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  color: Colors.amber[700],
                  onRefresh: () async {
                    setState(() {
                      isLoading = true;
                    });
                    _getIdentityVerification();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: verifications.length,
                    itemBuilder: (context, index) {
                      IdentityVerificationModel data = verifications[index];
                      return _buildVerificationCard(data);
                    },
                  ),
                ),
    );
  }

  Widget _buildVerificationCard(IdentityVerificationModel data) {
    Color statusColor;
    Color statusBgColor;
    String statusText;
    IconData statusIcon;

    switch (data.status) {
      case 'pending':
        statusColor = Colors.orange[700]!;
        statusBgColor = Colors.orange[50]!;
        statusText = 'Menunggu Review';
        statusIcon = Icons.hourglass_top;
        break;
      case 'approved':
        statusColor = Colors.green[700]!;
        statusBgColor = Colors.green[50]!;
        statusText = 'Disetujui';
        statusIcon = Icons.check_circle;
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
        statusText = 'Unknown';
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailVerifikasiIdentitasPage(
                  data: data,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              statusIcon,
                              color: statusColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: statusColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'ID: ${data.id}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // KTP Number
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'No. KTP: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          data.ktpNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons for pending status
                if (data.status == 'pending') ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _approveVerification(data),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[600],
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text(
                            'Setujui',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _rejectVerification(data),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text(
                            'Tolak',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _approveVerification(IdentityVerificationModel data) async {
    _showLoadingDialog('Menyetujui verifikasi...');
    final result = await IdentityVerificationService()
        .approveIdentityVerification(data.id);
    Navigator.of(context).pop();

    result.fold(
      (error) {
        _showSnackBar('Gagal menyetujui verifikasi: $error', isError: true);
      },
      (message) {
        _showSnackBar(message);
        setState(() {
          isLoading = true;
        });
        _getIdentityVerification();
      },
    );
  }

  Future<void> _rejectVerification(IdentityVerificationModel data) async {
    _showLoadingDialog('Menolak verifikasi...');
    final result =
        await IdentityVerificationService().rejectIdentityVerification(data.id);
    Navigator.of(context).pop();

    result.fold(
      (error) {
        _showSnackBar('Gagal menolak verifikasi: $error', isError: true);
      },
      (message) {
        _showSnackBar(message);
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
}
