import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_config.dart';
import '../../models/campaign.dart';

class EditCampaignPage extends StatefulWidget {
  final Campaign campaign;
  const EditCampaignPage({Key? key, required this.campaign}) : super(key: key);

  @override
  _EditCampaignPageState createState() => _EditCampaignPageState();
}

class _EditCampaignPageState extends State<EditCampaignPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _targetAmountController;
  late String _selectedType;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _titleController = TextEditingController(text: widget.campaign.title);
    _descriptionController =
        TextEditingController(text: widget.campaign.description);
    _selectedType = widget.campaign.type;
    // Initialize target based on type
    switch (_selectedType) {
      case 'financial':
        _targetAmountController = TextEditingController(
            text: widget.campaign.targetAmount.toString());
        break;
      case 'goods':
        _targetAmountController = TextEditingController(
            text: widget.campaign.targetAmount
                .toString()); // Assuming targetAmount holds item count for goods
        break;
      case 'emotional':
        _targetAmountController = TextEditingController(
            text: widget.campaign.targetAmount
                .toString()); // Assuming targetAmount holds session count for emotional
        break;
      default:
        _targetAmountController = TextEditingController();
        break;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    super.dispose();
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
              success ? 'Berhasil!' : 'Gagal!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: success ? Colors.green[700] : Colors.red[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
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
                  colors: success
                      ? [Colors.green[400]!, Colors.green[600]!]
                      : [Colors.amber[400]!, Colors.amber[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    if (success) {
                      Navigator.of(context)
                          .pop(true); // Return to previous page with success
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: const Center(
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
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
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(
          '${ApiConfig.baseUrl}:8000/api/campaigns/${widget.campaign.id}'); // Use campaign ID for update
      print('Edit URL: $url');
      try {
        final Map<String, dynamic> body = {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'type': _selectedType, // Include type in update
        };
        // Include target based on type
        switch (_selectedType) {
          case 'financial':
            body['target_amount'] =
                int.tryParse(_targetAmountController.text) ?? 0;
            break;
          case 'goods':
            body['target_items'] = int.tryParse(_targetAmountController.text) ??
                0; // Assuming API accepts target_items
            break;
          case 'emotional':
            body['target_sessions'] =
                int.tryParse(_targetAmountController.text) ??
                    0; // Assuming API accepts target_sessions
            break;
        }
        print('Edit Request Body: ${jsonEncode(body)}');

        final response = await http.put(
          // Use PUT or appropriate method for update
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );

        print('Status Code (editCampaign): ${response.statusCode}');
        print('Response Body (editCampaign): ${response.body}');

        final data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['success'] == true) {
          // Assuming 200 for success
          _showResultDialog(
              success: true, message: 'Campaign berhasil diperbarui!');
          // Optionally navigate back after successful update
          // Navigator.pop(context, true); // Pass true to indicate success and refresh list
        } else {
          _showResultDialog(
              success: false,
              message: data['message'] ?? 'Gagal memperbarui campaign.');
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
      body: CustomScrollView(
        slivers: [
          // Modern SliverAppBar with gradient
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: Colors.amber[700],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SafeArea(
                      child: Container(
                        height: constraints.maxHeight,
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 35,
                          bottom: 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Edit Campaign',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Flexible(
                              child: Text(
                                'Perbarui informasi kampanye Anda',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Content Section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),

                    // Campaign Type Display Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _getTypeColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getTypeIcon(),
                              color: _getTypeColor(),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tipe Campaign',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getTypeDisplayName(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _getTypeColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getTypeColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Tidak dapat diubah',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: _getTypeColor(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Form Container
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Form Header
                            Row(
                              children: [
                                Icon(
                                  Icons.edit_note,
                                  color: Colors.amber[700],
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Informasi Campaign',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Title Field
                            TextFormField(
                              controller: _titleController,
                              decoration: InputDecoration(
                                labelText: 'Judul Campaign',
                                labelStyle: TextStyle(color: Colors.grey[600]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.amber[600]!, width: 2),
                                ),
                                prefixIcon:
                                    Icon(Icons.title, color: Colors.amber[600]),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Judul tidak boleh kosong';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Description Field
                            TextFormField(
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Deskripsi Campaign',
                                labelStyle: TextStyle(color: Colors.grey[600]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.amber[600]!, width: 2),
                                ),
                                prefixIcon: Icon(Icons.description,
                                    color: Colors.amber[600]),
                                filled: true,
                                fillColor: Colors.grey[50],
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

                            const SizedBox(height: 20),

                            // Target Field
                            if (_selectedType == 'financial' ||
                                _selectedType == 'goods' ||
                                _selectedType == 'emotional')
                              TextFormField(
                                controller: _targetAmountController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: _getTargetLabel(),
                                  labelStyle:
                                      TextStyle(color: Colors.grey[600]),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.amber[600]!, width: 2),
                                  ),
                                  prefixIcon: Icon(_getTargetIcon(),
                                      color: Colors.amber[600]),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Target tidak boleh kosong';
                                  }
                                  if (int.tryParse(value) == null ||
                                      int.parse(value) <= 0) {
                                    return 'Target harus berupa angka positif';
                                  }
                                  return null;
                                },
                              ),

                            const SizedBox(height: 32),

                            // Submit Button
                            Container(
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
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _submitForm,
                                  borderRadius: BorderRadius.circular(16),
                                  child: const Center(
                                    child: Text(
                                      'Perbarui Campaign',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
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
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor() {
    switch (_selectedType) {
      case 'financial':
        return Colors.green;
      case 'goods':
        return Colors.blue;
      case 'emotional':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon() {
    switch (_selectedType) {
      case 'financial':
        return Icons.attach_money;
      case 'goods':
        return Icons.inventory;
      case 'emotional':
        return Icons.emoji_emotions;
      default:
        return Icons.campaign;
    }
  }

  String _getTypeDisplayName() {
    switch (_selectedType) {
      case 'financial':
        return 'Bantuan Finansial';
      case 'goods':
        return 'Bantuan Barang';
      case 'emotional':
        return 'Dukungan Emosional';
      default:
        return 'Unknown';
    }
  }

  String _getTargetLabel() {
    switch (_selectedType) {
      case 'financial':
        return 'Target Donasi (Rp)';
      case 'goods':
        return 'Target Barang';
      case 'emotional':
        return 'Target Sesi';
      default:
        return 'Target';
    }
  }

  IconData _getTargetIcon() {
    switch (_selectedType) {
      case 'financial':
        return Icons.attach_money;
      case 'goods':
        return Icons.inventory_2;
      case 'emotional':
        return Icons.sentiment_satisfied_alt;
      default:
        return Icons.flag;
    }
  }
}
