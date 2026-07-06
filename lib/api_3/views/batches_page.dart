import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ppkd_b6/api_3/models/batch_model.dart';
import 'package:ppkd_b6/api_3/service/auth_service.dart';

class BatchesPage extends StatefulWidget {
  const BatchesPage({super.key});

  @override
  State<BatchesPage> createState() => _BatchesPageState();
}

class _BatchesPageState extends State<BatchesPage> {
  final _authService = AuthService();
  late Future<List<Batch>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _authService.getBatches();
  }

  Future<void> _refresh() async {
    setState(_load);
    await _future;
  }

  String _fmt(DateTime? d) =>
      d == null ? '-' : DateFormat('d MMM yyyy', 'id_ID').format(d);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        title: const Text('Daftar Batch'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Batch>>(
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
                  Icon(Icons.group_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Center(child: Text('Belum ada data batch')),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final b = list[i];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1A237E),
                      child: Text('${b.id ?? '-'}',
                          style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(
                      b.batchKe != null ? 'Batch ${b.batchKe}' : 'Batch ${b.id ?? '-'}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: (b.startDate != null || b.endDate != null)
                        ? Text('${_fmt(b.startDate)} - ${_fmt(b.endDate)}')
                        : null,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
