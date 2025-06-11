import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';

class DonasiPage extends StatefulWidget {
  final Map<String, dynamic> campaign;
  final dynamic user; // Tambahkan user
  const DonasiPage({Key? key, required this.campaign, required this.user})
      : super(key: key);

  @override
  State<DonasiPage> createState() => _DonasiPageState();
}

class _DonasiPageState extends State<DonasiPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _itemDescController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _itemDescController.dispose();
    super.dispose();
  }

  Future<void> _submitDonation() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    final type = widget.campaign['type'];
    final id = widget.campaign['id'];
    final url = Uri.parse('${ApiConfig.baseUrl}:8000/api/donations');
    Map<String, dynamic> body = {
      'campaign_id': id,
      'type': type,
      'donor_name': widget.user.name, // Gunakan nama user login
      // 'user_id': widget.user.id, // JANGAN kirim user_id, backend ambil dari token
    };
    if (type == 'financial') {
      body['amount'] = int.tryParse(_amountController.text) ?? 0;
    } else if (type == 'goods') {
      body['item_description'] = _itemDescController.text;
      body['item_quantity'] = int.tryParse(_amountController.text) ?? 0;
    } else if (type == 'emotional') {
      body['initial_message'] = _itemDescController.text;
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      debugPrint('TOKEN USED: ' + (token ?? 'NULL'));
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      setState(() => isLoading = false);
      Map<String, dynamic>? data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = null;
      }
      debugPrint('Status: \\${response.statusCode}');
      debugPrint('Response: \\${response.body}');
      if (response.statusCode == 201 ||
          (data != null && data['success'] == true)) {
        _showDialog('Donasi berhasil! Terima kasih atas kebaikan Anda.', true);
      } else {
        _showDialog(
            data != null
                ? (data['message'] ??
                    'Donasi gagal. (Status: \\${response.statusCode})')
                : 'Donasi gagal. (Status: \\${response.statusCode})',
            false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showDialog('Gagal terhubung ke server: $e', false);
    }
  }

  void _showDialog(String message, bool success) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: success ? Colors.green[50] : Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                success ? Icons.check_circle : Icons.error,
                color: success ? Colors.green[600] : Colors.red[600],
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              success ? 'Berhasil!' : 'Oops!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: success ? Colors.green[700] : Colors.red[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber[600]!, Colors.amber[700]!],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (success) Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.campaign['type'];
    final title = widget.campaign['title'] ?? '';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Donasi',
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
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _getCampaignColor(type).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            _getCampaignIcon(type),
                            size: 40,
                            color: _getCampaignColor(type),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Donasi ${_getCampaignTypeText(type)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: _getCampaignColor(type),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Form Section
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            color: Colors.blue[700],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Detail Donasi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Isi form di bawah untuk melakukan donasi',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Campaign Type Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getCampaignColor(type).withOpacity(0.1),
                            _getCampaignColor(type).withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getCampaignColor(type).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getCampaignColor(type).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getCampaignIcon(type),
                              color: _getCampaignColor(type),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getCampaignTypeText(type),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: _getCampaignColor(type),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getCampaignDescription(type),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _getCampaignColor(type)
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Dynamic Form Fields based on campaign type
                    if (type == 'financial') ...[
                      _buildFormField(
                        controller: _amountController,
                        label: 'Nominal Donasi',
                        hint: 'Masukkan nominal dalam Rupiah',
                        icon: Icons.monetization_on,
                        iconColor: Colors.green[600]!,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Masukkan nominal donasi';
                          if (int.tryParse(v) == null || int.parse(v) <= 0)
                            return 'Nominal tidak valid';
                          return null;
                        },
                      ),
                    ] else if (type == 'goods') ...[
                      _buildFormField(
                        controller: _itemDescController,
                        label: 'Deskripsi Barang',
                        hint: 'Jelaskan barang yang akan disumbangkan',
                        icon: Icons.inventory_2,
                        iconColor: Colors.orange[600]!,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Deskripsi barang wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _buildFormField(
                        controller: _amountController,
                        label: 'Jumlah Barang',
                        hint: 'Masukkan jumlah barang',
                        icon: Icons.numbers,
                        iconColor: Colors.orange[600]!,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Masukkan jumlah barang';
                          if (int.tryParse(v) == null || int.parse(v) <= 0)
                            return 'Jumlah tidak valid';
                          return null;
                        },
                      ),
                    ] else if (type == 'emotional') ...[
                      _buildFormField(
                        controller: _amountController,
                        label: 'Jumlah Sesi Dukungan',
                        hint: 'Berapa sesi dukungan yang ingin diberikan',
                        icon: Icons.psychology,
                        iconColor: Colors.pink[600]!,
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Masukkan jumlah sesi';
                          if (int.tryParse(v) == null || int.parse(v) <= 0)
                            return 'Jumlah sesi tidak valid';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildFormField(
                        controller: _itemDescController,
                        label: 'Pesan Dukungan',
                        hint: 'Tulis pesan motivasi atau dukungan (opsional)',
                        icon: Icons.message,
                        iconColor: Colors.pink[600]!,
                        maxLines: 3,
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Submit Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amber[600]!, Colors.amber[700]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _handleDonationSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.volunteer_activism,
                                color: Colors.white,
                                size: 24,
                              ),
                        label: Text(
                          isLoading ? 'Memproses...' : 'Kirim Donasi',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
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
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Future<void> _handleDonationSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final confirm = await _showConfirmationDialog();
    if (confirm == true) {
      _submitDonation();
    }
  }

  Future<bool?> _showConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.help_outline,
                color: Colors.amber[700],
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Konfirmasi Donasi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Apakah Anda yakin ingin mengirim donasi ini?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber[600]!, Colors.amber[700]!],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Ya, Donasi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCampaignColor(String type) {
    switch (type) {
      case 'financial':
        return Colors.green[600]!;
      case 'goods':
        return Colors.orange[600]!;
      case 'emotional':
        return Colors.pink[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getCampaignIcon(String type) {
    switch (type) {
      case 'financial':
        return Icons.monetization_on;
      case 'goods':
        return Icons.inventory_2;
      case 'emotional':
        return Icons.psychology;
      default:
        return Icons.volunteer_activism;
    }
  }

  String _getCampaignTypeText(String type) {
    switch (type) {
      case 'financial':
        return 'Uang';
      case 'goods':
        return 'Barang';
      case 'emotional':
        return 'Dukungan Emosional';
      default:
        return 'Donasi';
    }
  }

  String _getCampaignDescription(String type) {
    switch (type) {
      case 'financial':
        return 'Berikan bantuan finansial';
      case 'goods':
        return 'Sumbangkan barang yang dibutuhkan';
      case 'emotional':
        return 'Berikan dukungan moral dan motivasi';
      default:
        return 'Berikan bantuan Anda';
    }
  }
}
