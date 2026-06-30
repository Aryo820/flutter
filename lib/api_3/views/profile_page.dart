import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppkd_b6/api_3/models/user_model.dart';
import 'package:ppkd_b6/api_3/service/auth_service.dart';
import 'package:ppkd_b6/api_3/views/edit_profile_page.dart';
import 'package:ppkd_b6/api_3/views/edit_photo_page.dart';
import 'package:ppkd_b6/api_3/views/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = AuthService();
  late Future<UserModel?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    _profileFuture = _authService.getProfile().then((res) => res.data);
  }

  void _refresh() {
    setState(() => _loadProfile());
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  Widget _buildAvatar(UserModel user) {
    if (user.profilePhoto != null && user.profilePhoto!.isNotEmpty) {
      try {
        final bytes = base64Decode(user.profilePhoto!.contains(',')
            ? user.profilePhoto!.split(',').last
            : user.profilePhoto!);
        return CircleAvatar(
          radius: 55,
          backgroundImage: MemoryImage(bytes),
        );
      } catch (_) {}
    }
    return CircleAvatar(
      radius: 55,
      backgroundColor: Colors.white.withOpacity(0.3),
      child: Text(
        (user.name?.isNotEmpty == true) ? user.name![0].toUpperCase() : '?',
        style: const TextStyle(
            fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
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
        title: const Text('Profil Saya'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          // --- Loading ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF1A237E)),
                  SizedBox(height: 16),
                  Text('Memuat profil...',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // --- Error ---
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat profil:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _refresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // --- Data ---
          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('Data profil tidak ditemukan'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header dengan background biru
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A237E),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildAvatar(user),
                      const SizedBox(height: 16),
                      Text(
                        user.name ?? '-',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email ?? '-',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14),
                      ),
                      const SizedBox(height: 20),

                      // Tombol Edit Foto
                      OutlinedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditPhotoPage(currentUser: user),
                            ),
                          );
                          if (result == true) _refresh();
                        },
                        icon: const Icon(Icons.camera_alt, size: 18),
                        label: const Text('Ubah Foto'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ],
                  ),
                ),

                // Detail info
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informasi Akun',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          const Divider(height: 24),
                          _infoRow(Icons.badge_outlined, 'ID', '${user.id ?? '-'}'),
                          _infoRow(Icons.person_outline, 'Nama', user.name ?? '-'),
                          _infoRow(Icons.email_outlined, 'Email', user.email ?? '-'),
                          _infoRow(
                              Icons.wc_outlined,
                              'Jenis Kelamin',
                              user.jenisKelamin == 'L'
                                  ? 'Laki-laki'
                                  : user.jenisKelamin == 'P'
                                      ? 'Perempuan'
                                      : '-'),
                          _infoRow(Icons.group_outlined, 'Batch ID',
                              '${user.batchId ?? '-'}'),
                          _infoRow(Icons.school_outlined, 'Training ID',
                              '${user.trainingId ?? '-'}'),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tombol Edit Profil
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfilePage(currentUser: user),
                          ),
                        );
                        if (result == true) _refresh();
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text(
                        'Edit Profil',
                        style: TextStyle(
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
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1A237E)),
          const SizedBox(width: 12),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
