import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
    final url = Uri.parse('http://192.168.1.4:8000/api/donations');
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
        title: Text(success ? 'Sukses' : 'Gagal',
            style: TextStyle(color: success ? Colors.green : Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (success) Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.campaign['type'];
    final title = widget.campaign['title'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donasi'),
        backgroundColor: Colors.amber[700],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.amber[50],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4E342E))),
            const SizedBox(height: 18),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (type == 'financial') ...[
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nominal Donasi (Rp)',
                        prefixIcon:
                            Icon(Icons.attach_money, color: Colors.amber),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Masukkan nominal donasi';
                        if (int.tryParse(v) == null || int.parse(v) <= 0)
                          return 'Nominal tidak valid';
                        return null;
                      },
                    ),
                  ] else if (type == 'goods') ...[
                    TextFormField(
                      controller: _itemDescController,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi Barang',
                        prefixIcon: Icon(Icons.inventory, color: Colors.amber),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Deskripsi barang wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Barang',
                        prefixIcon: Icon(Icons.numbers, color: Colors.amber),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Masukkan jumlah barang';
                        if (int.tryParse(v) == null || int.parse(v) <= 0)
                          return 'Jumlah tidak valid';
                        return null;
                      },
                    ),
                  ] else if (type == 'emotional') ...[
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Sesi Dukungan',
                        prefixIcon: Icon(Icons.support, color: Colors.amber),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return 'Masukkan jumlah sesi';
                        if (int.tryParse(v) == null || int.parse(v) <= 0)
                          return 'Jumlah sesi tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _itemDescController,
                      decoration: const InputDecoration(
                        labelText: 'Pesan Dukungan (opsional)',
                        prefixIcon: Icon(Icons.message, color: Colors.amber),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 2,
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _submitDonation,
                      icon: const Icon(Icons.volunteer_activism,
                          color: Colors.white),
                      label: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Kirim Donasi',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
