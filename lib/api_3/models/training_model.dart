// Model untuk endpoint Trainings (List & Detail)
// GET /api/trainings        -> List<Training>  (item: { id, title })
// GET /api/trainings/{id}   -> TrainingDetail

// Konversi aman: terima int, String, atau null dari API
int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}

class Training {
  final int? id;
  final String? title;

  Training({this.id, this.title});

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: _toInt(json['id']),
      title: json['title'],
    );
  }
}

class TrainingListResponse {
  final String? message;
  final List<Training> data;

  TrainingListResponse({this.message, this.data = const []});

  factory TrainingListResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'];
    return TrainingListResponse(
      message: json['message'],
      data: list is List
          ? list
              .whereType<Map<String, dynamic>>()
              .map(Training.fromJson)
              .toList()
          : const [],
    );
  }
}

class TrainingDetail {
  final int? id;
  final String? title;
  final String? description;
  final dynamic participantCount;
  final dynamic standard;
  final dynamic duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<dynamic> units;
  final List<dynamic> activities;

  TrainingDetail({
    this.id,
    this.title,
    this.description,
    this.participantCount,
    this.standard,
    this.duration,
    this.createdAt,
    this.updatedAt,
    this.units = const [],
    this.activities = const [],
  });

  factory TrainingDetail.fromJson(Map<String, dynamic> json) {
    return TrainingDetail(
      id: _toInt(json['id']),
      title: json['title'],
      description: json['description'],
      participantCount: json['participant_count'],
      standard: json['standard'],
      duration: json['duration'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      units: json['units'] is List ? json['units'] : const [],
      activities: json['activities'] is List ? json['activities'] : const [],
    );
  }
}

class TrainingDetailResponse {
  final String? message;
  final TrainingDetail? data;

  TrainingDetailResponse({this.message, this.data});

  factory TrainingDetailResponse.fromJson(Map<String, dynamic> json) {
    return TrainingDetailResponse(
      message: json['message'],
      data: json['data'] != null ? TrainingDetail.fromJson(json['data']) : null,
    );
  }
}
