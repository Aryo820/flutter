import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ppkd_b6/api_3/models/user_model.dart';
import 'package:ppkd_b6/api_3/service/auth_service.dart';

class EditPhotoPage extends StatefulWidget {
  final UserModel currentUser;

  const EditPhotoPage({super.key, required this.currentUser});

  @override
  State<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  final _authService = AuthService();
  final _imagePicker = ImagePicker();

  File? _selectedImage;
  String? _base64Image;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      final file = File(pickedFile.path);
      final bytes = await file.readAsBytes();
      final base64Str = base64Encode(bytes);
      final extension = pickedFile.path.split('.').last.toLowerCase();
      final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

      setState(() {
        _selectedImage = file;
        _base64Image = 'data:$mimeType;base64,$base64Str';
        _errorMessage = null;
      });
    } catch (e) {
      setState(() => _errorMessage = 'Gagal memilih gambar: $e');
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Pilih Sumber Foto',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF1A237E),
                child: Icon(Icons.camera_alt, color: Colors.white),
              ),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF1A237E),
                child: Icon(Icons.photo_library, color: Colors.white),
              ),
              title: const Text('Galeri Foto'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadPhoto() async {
    if (_base64Image == null) {
      setState(() => _errorMessage = 'Pilih foto terlebih dahulu');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.updateProfilePhoto(base64Image: _base64Image!);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto profil berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true); // Kembali dengan sinyal refresh
    } on DioException catch (e) {
      final data = e.response?.data;
      String msg = 'Gagal mengupload foto';
      if (data != null && data['message'] != null) {
        msg = data['message'];
      }
      setState(() => _errorMessage = msg);
    } catch (e) {
      setState(() => _errorMessage = 'Terjadi kesalahan: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildCurrentPhoto() {
    final photo = widget.currentUser.profilePhoto;
    if (photo != null && photo.isNotEmpty) {
      try {
        final bytes = base64Decode(
            photo.contains(',') ? photo.split(',').last : photo);
        return CircleAvatar(
          radius: 60,
          backgroundImage: MemoryImage(bytes),
        );
      } catch (_) {}
    }
    return CircleAvatar(
      radius: 60,
      backgroundColor: const Color(0xFF1A237E).withOpacity(0.15),
      child: Text(
        (widget.currentUser.name?.isNotEmpty == true)
            ? widget.currentUser.name![0].toUpperCase()
            : '?',
        style: const TextStyle(
            fontSize: 44,
            color: Color(0xFF1A237E),
            fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        title: const Text('Edit Foto Profil'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            // Foto saat ini / preview
            Center(
              child: Stack(
                children: [
                  _selectedImage != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(_selectedImage!),
                        )
                      : _buildCurrentPhoto(),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showPickerOptions,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1A237E),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              _selectedImage != null
                  ? 'Preview foto baru'
                  : 'Foto profil saat ini',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 32),

            // Error message
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: Colors.red.shade600, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                            color: Colors.red.shade700, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Tombol Pilih Foto
            OutlinedButton.icon(
              onPressed: _showPickerOptions,
              icon: const Icon(Icons.photo_library),
              label: const Text('Pilih Foto'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1A237E),
                side: const BorderSide(color: Color(0xFF1A237E)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Upload
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: (_isLoading || _selectedImage == null)
                    ? null
                    : _uploadPhoto,
                icon: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.cloud_upload),
                label: Text(
                  _isLoading ? 'Mengupload...' : 'Upload Foto',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Foto akan dikompres dan dikonversi ke format base64 sebelum dikirim ke server.',
                      style: TextStyle(color: Colors.blue, fontSize: 12),
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
