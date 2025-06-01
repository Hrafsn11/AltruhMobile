import 'dart:io';

import 'package:donasi_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/dummy_users.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  @override
  void initState() {
    nameController.text = widget.user.name;
    phoneController.text = widget.user.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.amber[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                ClipOval(
                  child: GestureDetector(
                      onTap: _pickImage,
                      child: _image != null
                          ? Image.file(
                              _image!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )
                          : widget.user.photo != null
                              ? Image.file(
                                  File(widget.user.photo!),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/img_profile.webp',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.amber[700],
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Nama Lengkap'),
          const SizedBox(height: 4),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Masukkan Nama Lengkap',
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Telepon'),
          const SizedBox(height: 4),
          TextFormField(
            controller: phoneController,
            decoration: const InputDecoration(
              hintText: 'Masukkan Telepon',
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.amber[700]),
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  final index =
                      dummyUsers.indexWhere((u) => u.id == widget.user.id);
                  if (index != -1) {
                    dummyUsers[index] = UserModel(
                      id: widget.user.id,
                      name: nameController.text,
                      email: widget.user.email,
                      password: widget.user.password,
                      phone: phoneController.text,
                      photo: _image?.path ?? widget.user.photo,
                      role: widget.user.role,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Profil berhasil diperbarui')),
                    );
                    Navigator.pop(context, true);
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          )
        ],
      ),
    );
  }
}
