// Model untuk endpoint Batches
// GET /api/batches -> List<Batch>
// Catatan: koleksi Postman tidak menyertakan contoh response untuk endpoint ini,
// sehingga parsing dibuat defensif terhadap beberapa kemungkinan nama key.

class Batch {
  final int? id;
  final String? batchKe;
  final DateTime? startDate;
  final DateTime? endDate;

  Batch({this.id, this.batchKe, this.startDate, this.endDate});

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }

  // Konversi aman: terima int, String, atau null dari API
  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is double) return value.toInt();
    return null;
  }

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: _toInt(json['id']),
      // dukung beberapa kemungkinan key: batch_ke / batch / name / title
      batchKe: (json['batch_ke'] ??
              json['batch'] ??
              json['name'] ??
              json['title'])
          ?.toString(),
      startDate: _parseDate(json['start_date'] ?? json['mulai']),
      endDate: _parseDate(json['end_date'] ?? json['selesai']),
    );
  }
}

class BatchListResponse {
  final String? message;
  final List<Batch> data;

  BatchListResponse({this.message, this.data = const []});

  factory BatchListResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'];
    return BatchListResponse(
      message: json['message'],
      data: list is List
          ? list.whereType<Map<String, dynamic>>().map(Batch.fromJson).toList()
          : const [],
    );
  }
}
