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
    _descriptionController = TextEditingController(text: widget.campaign.description);
    _selectedType = widget.campaign.type;
    // Initialize target based on type
    switch (_selectedType) {
      case 'financial':
         _targetAmountController = TextEditingController(text: widget.campaign.targetAmount.toString());
        break;
      case 'goods':
         _targetAmountController = TextEditingController(text: widget.campaign.targetAmount.toString()); // Assuming targetAmount holds item count for goods
        break;
      case 'emotional':
         _targetAmountController = TextEditingController(text: widget.campaign.targetAmount.toString()); // Assuming targetAmount holds session count for emotional
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
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('${ApiConfig.baseUrl}:8000/api/campaigns/${widget.campaign.id}'); // Use campaign ID for update
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
            body['target_amount'] = int.tryParse(_targetAmountController.text) ?? 0;
            break;
          case 'goods':
            body['target_items'] = int.tryParse(_targetAmountController.text) ?? 0; // Assuming API accepts target_items
            break;
          case 'emotional':
            body['target_sessions'] = int.tryParse(_targetAmountController.text) ?? 0; // Assuming API accepts target_sessions
            break;
        }
        print('Edit Request Body: ${jsonEncode(body)}');

        final response = await http.put( // Use PUT or appropriate method for update
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
        if (response.statusCode == 200 && data['success'] == true) { // Assuming 200 for success
          _showResultDialog(
              success: true,
              message: 'Campaign berhasil diperbarui!');
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
            const Text('Edit Campaign',
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      "Form Edit Campaign", // Changed title here
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Perbarui data campaign Anda.", // Changed description here
                      style: TextStyle(fontSize: 14, color: Colors.brown),
                    ),
                  ],
                ),
              ),
              // Display type but disable editing
               InputDecorator(
                decoration: InputDecoration(
                   labelText: 'Tipe Campaign',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  prefixIcon: const Icon(Icons.category, color: Colors.amber),
                  filled: true,
                  fillColor: Colors.grey[200], // Indicate disabled
                ),
                 child: Text(
                  _selectedType.toUpperCase(),
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                 ),
              ),
              const SizedBox(height: 16),
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
                          labelText: 'Deskripsi Campaign',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          prefixIcon: const Icon(Icons.description,
                              color: Colors.amber),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Deskripsi tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Show target field only for financial, goods, emotional
                       if (_selectedType == 'financial' || _selectedType == 'goods' || _selectedType == 'emotional')
                         TextFormField(
                          controller: _targetAmountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: _selectedType == 'financial'
                                ? 'Target Donasi (Rp)'
                                : _selectedType == 'goods'
                                    ? 'Target Barang'
                                    : 'Target Sesi',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            prefixIcon: Icon(
                              _selectedType == 'financial'
                                  ? Icons.attach_money
                                  : _selectedType == 'goods'
                                      ? Icons.inventory_2
                                      : Icons.sentiment_satisfied_alt,
                              color: Colors.amber,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                           validator: (value) {
                             if (value == null || value.isEmpty) {
                               return 'Target tidak boleh kosong';
                             }
                             if (int.tryParse(value) == null || int.parse(value) <= 0) {
                               return 'Target harus berupa angka positif';
                             }
                             return null;
                           },
                        ),
                       const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.amber[700]),
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 14)),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          onPressed: _submitForm,
                          child: const Text(
                            'Perbarui Campaign',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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
} 