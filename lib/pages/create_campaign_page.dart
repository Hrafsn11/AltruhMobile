import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCampaignPage extends StatefulWidget {
  @override
  _CreateCampaignPageState createState() => _CreateCampaignPageState();
}

class _CreateCampaignPageState extends State<CreateCampaignPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAmountController = TextEditingController();
  String _selectedType = '';
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
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

  Future<void> _submitForm() async {
    if (token == null || token!.isEmpty) {
      _showResultDialog(
          success: false,
          message: 'Token login tidak ditemukan. Silakan login ulang!');
      return;
    }
    if (_selectedType.isEmpty) {
      _showResultDialog(
          success: false, message: 'Pilih tipe campaign terlebih dahulu!');
      return;
    }
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('http://192.168.1.4:8000/api/campaigns');
      try {
        final Map<String, dynamic> body = {
          'title': _titleController.text,
          'description': _descriptionController.text,
        };
        if (_selectedType == 'financial') {
          body['type'] = 'financial';
          body['target_amount'] =
              int.tryParse(_targetAmountController.text) ?? 0;
        } else if (_selectedType == 'barang') {
          body['type'] = 'goods';
          body['target_items'] =
              int.tryParse(_targetAmountController.text) ?? 0;
        } else if (_selectedType == 'emosional') {
          body['type'] = 'emotional';
          body['target_sessions'] =
              int.tryParse(_targetAmountController.text) ?? 0;
        }
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );
        final data = jsonDecode(response.body);
        if (response.statusCode == 201 && data['success'] == true) {
          _showResultDialog(
              success: true,
              message: 'Campaign berhasil dibuat! Menunggu verifikasi admin.');
          setState(() {
            _titleController.clear();
            _descriptionController.clear();
            _targetAmountController.clear();
            _selectedType = '';
          });
        } else {
          _showResultDialog(
              success: false,
              message: data['message'] ?? 'Gagal membuat campaign.');
        }
      } catch (e) {
        _showResultDialog(
            success: false, message: 'Gagal terhubung ke server: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.campaign, color: Colors.amber, size: 28),
            ),
            const SizedBox(width: 10),
            const Text('Buat Campaign',
                style: TextStyle(
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.08),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(color: Colors.amber[100]!, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Form Campaign Baru",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Isi data campaign dengan lengkap dan menarik agar lebih banyak donatur yang tertarik.",
                      style: TextStyle(fontSize: 14, color: Colors.brown),
                    ),
                  ],
                ),
              ),
              DropdownButtonFormField<String>(
                value: _selectedType.isEmpty ? null : _selectedType,
                decoration: InputDecoration(
                  labelText: 'Tipe Campaign',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  prefixIcon: const Icon(Icons.category, color: Colors.amber),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'financial',
                    child: Text('Donasi Uang'),
                  ),
                  DropdownMenuItem(
                    value: 'barang',
                    child: Text('Donasi Barang'),
                  ),
                  DropdownMenuItem(
                    value: 'emosional',
                    child: Text('Dukungan Emosional'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih tipe campaign';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (_selectedType.isNotEmpty)
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Judul Campaign',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon:
                              const Icon(Icons.title, color: Colors.amber),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Deskripsi',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.description,
                              color: Colors.amber),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Deskripsi tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _targetAmountController,
                        decoration: InputDecoration(
                          labelText: _selectedType == 'financial'
                              ? 'Target Donasi (Rp)'
                              : _selectedType == 'barang'
                                  ? 'Target Jumlah Barang'
                                  : 'Target Sesi Dukungan',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: Icon(
                            _selectedType == 'financial'
                                ? Icons.monetization_on
                                : _selectedType == 'barang'
                                    ? Icons.inventory_2
                                    : Icons.psychology,
                            color: Colors.amber,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return _selectedType == 'financial'
                                ? 'Target donasi tidak boleh kosong'
                                : _selectedType == 'barang'
                                    ? 'Target barang tidak boleh kosong'
                                    : 'Target sesi tidak boleh kosong';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Harus berupa angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submitForm,
                          icon: const Icon(Icons.add_circle_outline,
                              color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[700],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 2,
                          ),
                          label: const Text(
                            'Buat Campaign',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }
}
