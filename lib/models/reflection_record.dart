class ReflectionRecord {
  static const int currentSchemaVersion = 1;

  final String id;
  final DateTime timestamp;
  final String feelingId;
  final String situationId;
  final String durationId;
  final String summary;
  final String? practicalStepTitle;
  final String? practicalStepDescription;
  final String? closingMessage;
  final String? evaluation;
  final bool isSaved;
  final int schemaVersion;

  const ReflectionRecord({
    required this.id,
    required this.timestamp,
    required this.feelingId,
    required this.situationId,
    required this.durationId,
    required this.summary,
    this.practicalStepTitle,
    this.practicalStepDescription,
    this.closingMessage,
    this.evaluation,
    this.isSaved = true,
    this.schemaVersion = currentSchemaVersion,
  });

  ReflectionRecord copyWith({
    String? id,
    DateTime? timestamp,
    String? feelingId,
    String? situationId,
    String? durationId,
    String? summary,
    String? practicalStepTitle,
    String? practicalStepDescription,
    String? closingMessage,
    String? evaluation,
    bool? isSaved,
    int? schemaVersion,
  }) {
    return ReflectionRecord(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      feelingId: feelingId ?? this.feelingId,
      situationId: situationId ?? this.situationId,
      durationId: durationId ?? this.durationId,
      summary: summary ?? this.summary,
      practicalStepTitle: practicalStepTitle ?? this.practicalStepTitle,
      practicalStepDescription: practicalStepDescription ?? this.practicalStepDescription,
      closingMessage: closingMessage ?? this.closingMessage,
      evaluation: evaluation ?? this.evaluation,
      isSaved: isSaved ?? this.isSaved,
      schemaVersion: schemaVersion ?? this.schemaVersion,
    );
  }

  Map<String, dynamic> toJson() => {
    'schemaVersion': schemaVersion,
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'feelingId': feelingId,
    'situationId': situationId,
    'durationId': durationId,
    'summary': summary,
    if (practicalStepTitle != null) 'practicalStepTitle': practicalStepTitle,
    if (practicalStepDescription != null)
      'practicalStepDescription': practicalStepDescription,
    if (closingMessage != null) 'closingMessage': closingMessage,
    if (evaluation != null) 'evaluation': evaluation,
    'isSaved': isSaved,
  };

  factory ReflectionRecord.fromJson(Map<String, dynamic> json) {
    return ReflectionRecord(
      schemaVersion: json['schemaVersion'] as int? ?? currentSchemaVersion,
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      feelingId: json['feelingId'] as String? ?? '',
      situationId: json['situationId'] as String? ?? '',
      durationId: json['durationId'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      practicalStepTitle: json['practicalStepTitle'] as String?,
      practicalStepDescription: json['practicalStepDescription'] as String?,
      closingMessage: json['closingMessage'] as String?,
      evaluation: json['evaluation'] as String?,
      isSaved: json['isSaved'] as bool? ?? true,
    );
  }
}
