import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ppkd_b6/api_3/models/user_model.dart';
import 'package:ppkd_b6/api_3/service/auth_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _authService = AuthService();
  late Future<List<UserModel>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _authService.getUsers();
  }

  Future<void> _refresh() async {
    setState(_load);
    await _future;
  }

  Widget _avatar(UserModel u) {
    final photo = u.profilePhoto;
    if (photo != null && photo.isNotEmpty && photo.contains('base64')) {
      try {
        final bytes = base64Decode(photo.split(',').last);
        return CircleAvatar(backgroundImage: MemoryImage(bytes));
      } catch (_) {}
    }
    return CircleAvatar(
      backgroundColor: const Color(0xFF1A237E),
      child: Text(
        (u.name?.isNotEmpty == true) ? u.name![0].toUpperCase() : '?',
        style: const TextStyle(color: Colors.white),
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
        title: const Text('Daftar Pengguna'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<UserModel>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1A237E)),
              );
            }
            if (snapshot.hasError) {
              return ListView(
                children: [
                  const SizedBox(height: 120),
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Gagal memuat data:\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => setState(_load),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ),
                ],
              );
            }
            final list = snapshot.data ?? [];
            if (list.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 140),
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Center(child: Text('Belum ada data pengguna')),
                ],
              );
            }
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  color: const Color(0xFFE8EAF6),
                  child: Text('Total: ${list.length} pengguna',
                      style: const TextStyle(
                          color: Color(0xFF1A237E),
                          fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final u = list[i];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: _avatar(u),
                          title: Text(u.name ?? '-',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(u.email ?? '-'),
                          trailing: Text('#${u.id ?? '-'}',
                              style: const TextStyle(color: Colors.grey)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
