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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Detail Verifikasi Identitas',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with Status
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
                  _buildStatusCard(),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Content Section
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
                  Text(
                    'Informasi Verifikasi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Detail lengkap data verifikasi identitas',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailItem(
                    icon: Icons.person_outline,
                    label: 'Nama Lengkap',
                    value: data.fullName,
                    iconColor: Colors.blue[600]!,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailItem(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: data.email,
                    iconColor: Colors.green[600]!,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailItem(
                    icon: Icons.phone_outlined,
                    label: 'No. Telepon',
                    value: data.phoneNumber,
                    iconColor: Colors.orange[600]!,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailItem(
                    icon: Icons.credit_card_outlined,
                    label: 'No. KTP',
                    value: data.ktpNumber,
                    iconColor: Colors.purple[600]!,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailItem(
                    icon: Icons.account_balance_outlined,
                    label: 'No. Rekening',
                    value: data.bankAccountNumber,
                    iconColor: Colors.teal[600]!,
                  ),
                ],
              ),
            ),

            // Timestamp Information
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
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
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.amber[700],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Informasi Waktu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTimestampItem(
                    icon: Icons.add_circle_outline,
                    label: 'Tanggal Pengajuan',
                    value: _formatDateTime(data.createdAt),
                    iconColor: Colors.blue[600]!,
                  ),
                  const SizedBox(height: 12),
                  _buildTimestampItem(
                    icon: Icons.update,
                    label: 'Terakhir Diperbarui',
                    value: _formatDateTime(data.updatedAt),
                    iconColor: Colors.green[600]!,
                  ),
                ],
              ),
            ),

            // Action Section (if needed)
            if (data.status.toLowerCase() == 'pending')
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber[50]!, Colors.amber[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.amber[800],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Menunggu Tindakan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.amber[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Verifikasi ini memerlukan review dan persetujuan dari admin',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.amber[700],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 80), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildTimestampItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildStatusCard() {
    Color statusColor;
    Color statusBgColor;
    String statusText;
    IconData statusIcon;
    String statusDescription;

    switch (data.status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.orange[700]!;
        statusBgColor = Colors.orange[50]!;
        statusText = 'Menunggu Review';
        statusIcon = Icons.hourglass_top;
        statusDescription = 'Sedang dalam proses verifikasi oleh admin';
        break;
      case 'approved':
        statusColor = Colors.green[700]!;
        statusBgColor = Colors.green[50]!;
        statusText = 'Disetujui';
        statusIcon = Icons.check_circle;
        statusDescription = 'Verifikasi identitas telah berhasil';
        break;
      case 'rejected':
        statusColor = Colors.red[700]!;
        statusBgColor = Colors.red[50]!;
        statusText = 'Ditolak';
        statusIcon = Icons.cancel;
        statusDescription = 'Verifikasi identitas ditolak, perlu perbaikan';
        break;
      default:
        statusColor = Colors.grey[700]!;
        statusBgColor = Colors.grey[50]!;
        statusText = 'Unknown';
        statusIcon = Icons.help;
        statusDescription = 'Status tidak diketahui';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusIcon,
              color: statusColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            statusDescription,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              'Status: ${data.status.toUpperCase()}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
