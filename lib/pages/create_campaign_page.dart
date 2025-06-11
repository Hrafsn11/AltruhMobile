import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';

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
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tutup',
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
      final url = Uri.parse('${ApiConfig.baseUrl}:8000/api/campaigns');
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

        print('Status Code (createCampaign): ${response.statusCode}');
        print('Response Body (createCampaign): ${response.body}');

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        elevation: 0,
        title: const Text(
          'Buat Campaign',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
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
                            color: Colors.amber[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.campaign,
                            color: Colors.amber[700],
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Buat Campaign Baru",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Mulai perubahan positif dengan membuat kampanye Anda",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
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
                        "Informasi Campaign",
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
                    "Lengkapi informasi campaign dengan detail yang menarik",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Campaign Type Dropdown
                  _buildFormField(
                    child: DropdownButtonFormField<String>(
                      value: _selectedType.isEmpty ? null : _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Tipe Campaign',
                        prefixIcon: Icon(Icons.category, color: Colors.amber),
                        border: InputBorder.none,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'financial',
                          child: Row(
                            children: [
                              Icon(Icons.monetization_on,
                                  color: Colors.green, size: 20),
                              SizedBox(width: 8),
                              Text('Donasi Uang'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'barang',
                          child: Row(
                            children: [
                              Icon(Icons.inventory_2,
                                  color: Colors.orange, size: 20),
                              SizedBox(width: 8),
                              Text('Donasi Barang'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'emosional',
                          child: Row(
                            children: [
                              Icon(Icons.psychology,
                                  color: Colors.pink, size: 20),
                              SizedBox(width: 8),
                              Text('Dukungan Emosional'),
                            ],
                          ),
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
                  ),
                  const SizedBox(height: 20),

                  // Conditional Form Fields
                  if (_selectedType.isNotEmpty) ...[
                    // Campaign Type Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _getGradientColors(_selectedType),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: _getAccentColor(_selectedType)
                                .withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getAccentColor(_selectedType)
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getCampaignIcon(_selectedType),
                              color: _getAccentColor(_selectedType),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getCampaignTypeTitle(_selectedType),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: _getAccentColor(_selectedType),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getCampaignTypeDescription(_selectedType),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _getAccentColor(_selectedType)
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Title Field
                          _buildFormField(
                            child: TextFormField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                labelText: 'Judul Campaign',
                                prefixIcon:
                                    Icon(Icons.title, color: Colors.amber),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Judul tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Description Field
                          _buildFormField(
                            child: TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Deskripsi Campaign',
                                prefixIcon: Icon(Icons.description,
                                    color: Colors.amber),
                                border: InputBorder.none,
                                alignLabelWithHint: true,
                              ),
                              maxLines: 4,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Deskripsi tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Target Field
                          _buildFormField(
                            child: TextFormField(
                              controller: _targetAmountController,
                              decoration: InputDecoration(
                                labelText: _getTargetLabel(_selectedType),
                                prefixIcon: Icon(
                                  _getCampaignIcon(_selectedType),
                                  color: Colors.amber,
                                ),
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Target tidak boleh kosong';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Harus berupa angka';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Submit Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amber[600]!,
                                  Colors.amber[700]!
                                ],
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
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(
                                Icons.rocket_launch,
                                color: Colors.white,
                                size: 24,
                              ),
                              label: const Text(
                                'Buat Campaign',
                                style: TextStyle(
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
                  ],

                  // Helper Text
                  if (_selectedType.isEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
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
                              'Pilih tipe campaign terlebih dahulu untuk melanjutkan',
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
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: child,
      ),
    );
  }

  Color _getAccentColor(String type) {
    switch (type) {
      case 'financial':
        return Colors.green[600]!;
      case 'barang':
        return Colors.orange[600]!;
      case 'emosional':
        return Colors.pink[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  List<Color> _getGradientColors(String type) {
    switch (type) {
      case 'financial':
        return [Colors.green[50]!, Colors.green[100]!];
      case 'barang':
        return [Colors.orange[50]!, Colors.orange[100]!];
      case 'emosional':
        return [Colors.pink[50]!, Colors.pink[100]!];
      default:
        return [Colors.grey[50]!, Colors.grey[100]!];
    }
  }

  IconData _getCampaignIcon(String type) {
    switch (type) {
      case 'financial':
        return Icons.monetization_on;
      case 'barang':
        return Icons.inventory_2;
      case 'emosional':
        return Icons.psychology;
      default:
        return Icons.campaign;
    }
  }

  String _getCampaignTypeTitle(String type) {
    switch (type) {
      case 'financial':
        return 'Campaign Donasi Uang';
      case 'barang':
        return 'Campaign Donasi Barang';
      case 'emosional':
        return 'Campaign Dukungan Emosional';
      default:
        return 'Campaign';
    }
  }

  String _getCampaignTypeDescription(String type) {
    switch (type) {
      case 'financial':
        return 'Galang dana untuk kebutuhan mendesak';
      case 'barang':
        return 'Kumpulkan barang-barang yang dibutuhkan';
      case 'emosional':
        return 'Berikan dukungan moral dan motivasi';
      default:
        return 'Deskripsi campaign';
    }
  }

  String _getTargetLabel(String type) {
    switch (type) {
      case 'financial':
        return 'Target Donasi (Rp)';
      case 'barang':
        return 'Target Jumlah Barang';
      case 'emosional':
        return 'Target Sesi Dukungan';
      default:
        return 'Target';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }
}
