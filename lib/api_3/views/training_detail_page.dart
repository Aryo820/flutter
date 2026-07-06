import 'package:flutter/material.dart';
import 'package:ppkd_b6/api_3/models/training_model.dart';
import 'package:ppkd_b6/api_3/service/auth_service.dart';

class TrainingDetailPage extends StatefulWidget {
  final int trainingId;
  const TrainingDetailPage({super.key, required this.trainingId});

  @override
  State<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

class _TrainingDetailPageState extends State<TrainingDetailPage> {
  final _authService = AuthService();
  late Future<TrainingDetail?> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _authService.getTrainingDetail(widget.trainingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        title: const Text('Detail Pelatihan'),
      ),
      body: FutureBuilder<TrainingDetail?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1A237E)),
            );
          }
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
                    Text('Gagal memuat detail:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => setState(_load),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }
          final d = snapshot.data;
          if (d == null) {
            return const Center(child: Text('Data tidak ditemukan'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.title ?? '-',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        const Divider(height: 24),
                        _infoRow(Icons.badge_outlined, 'ID', '${d.id ?? '-'}'),
                        _infoRow(Icons.description_outlined, 'Deskripsi',
                            d.description ?? '-'),
                        _infoRow(Icons.people_outline, 'Jumlah Peserta',
                            '${d.participantCount ?? '-'}'),
                        _infoRow(Icons.verified_outlined, 'Standar',
                            '${d.standard ?? '-'}'),
                        _infoRow(Icons.timer_outlined, 'Durasi',
                            '${d.duration ?? '-'}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _listSection('Units', d.units),
                const SizedBox(height: 16),
                _listSection('Activities', d.activities),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _listSection(String title, List<dynamic> items) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            const Divider(height: 20),
            if (items.isEmpty)
              const Text('Belum ada data',
                  style: TextStyle(color: Colors.grey))
            else
              ...items.map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.circle, size: 8, color: Color(0xFF1A237E)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_itemLabel(e))),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _itemLabel(dynamic e) {
    if (e is Map) {
      return (e['title'] ?? e['name'] ?? e.toString()).toString();
    }
    return e.toString();
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1A237E)),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
