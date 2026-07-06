import 'package:flutter/material.dart';
import 'package:ppkd_b6/api_3/models/training_model.dart';
import 'package:ppkd_b6/api_3/service/auth_service.dart';
import 'package:ppkd_b6/api_3/views/training_detail_page.dart';

class TrainingsPage extends StatefulWidget {
  const TrainingsPage({super.key});

  @override
  State<TrainingsPage> createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<TrainingsPage> {
  final _authService = AuthService();
  late Future<List<Training>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _authService.getTrainings();
  }

  Future<void> _refresh() async {
    setState(_load);
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        title: const Text('Daftar Pelatihan'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Training>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1A237E)),
              );
            }
            if (snapshot.hasError) {
              return _errorState('${snapshot.error}');
            }
            final list = snapshot.data ?? [];
            if (list.isEmpty) {
              return _emptyState();
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final t = list[i];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1A237E),
                      child: Text(
                        '${t.id ?? '-'}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      t.title ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: t.id == null
                        ? null
                        : () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TrainingDetailPage(trainingId: t.id!),
                              ),
                            ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _errorState(String msg) {
    return ListView(
      children: [
        const SizedBox(height: 120),
        const Icon(Icons.error_outline, size: 64, color: Colors.red),
        const SizedBox(height: 16),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Gagal memuat data:\n$msg',
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

  Widget _emptyState() {
    return ListView(
      children: const [
        SizedBox(height: 140),
        Icon(Icons.school_outlined, size: 64, color: Colors.grey),
        SizedBox(height: 12),
        Center(child: Text('Belum ada data pelatihan')),
      ],
    );
  }
}
