class PracticalStep {
  final String? id;
  final String title;
  final String description;

  const PracticalStep({
    this.id,
    required this.title,
    required this.description,
  });

  factory PracticalStep.fromJson(Map<String, dynamic> json) {
    return PracticalStep(
      id: json['id'] as String?,
      title: json['title'] as String? ?? 'Langkah Praktis',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'title': title,
    'description': description,
  };
}

class SuggestedExercise {
  final String? id;
  final String title;
  final int durationMinutes;

  const SuggestedExercise({
    this.id,
    required this.title,
    this.durationMinutes = 1,
  });

  factory SuggestedExercise.fromJson(Map<String, dynamic> json) {
    return SuggestedExercise(
      id: json['id'] as String?,
      title: json['title'] as String? ?? 'Latihan Pernapasan',
      durationMinutes: json['durationMinutes'] as int? ??
          json['duration_minutes'] as int? ??
          1,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'title': title,
    'durationMinutes': durationMinutes,
  };
}

class AiReflectionResponse {
  final String summary;
  final String validation;
  final PracticalStep? practicalStep;
  final List<String> additionalSteps;
  final String audioScript;
  final String closingMessage;
  final SuggestedExercise? suggestedExercise;
  final bool isCrisis;
  final String disclaimer;

  const AiReflectionResponse({
    required this.summary,
    required this.validation,
    this.practicalStep,
    this.additionalSteps = const [],
    required this.audioScript,
    required this.closingMessage,
    this.suggestedExercise,
    this.isCrisis = false,
    this.disclaimer =
        'Dukungan umum untuk refleksi diri, bukan diagnosis atau pengganti bantuan profesional.',
  });

  factory AiReflectionResponse.fromJson(Map<String, dynamic> json) {
    PracticalStep? step;
    if (json['practicalStep'] is Map<String, dynamic>) {
      step = PracticalStep.fromJson(json['practicalStep'] as Map<String, dynamic>);
    } else if (json['practical_step'] is Map<String, dynamic>) {
      step = PracticalStep.fromJson(json['practical_step'] as Map<String, dynamic>);
    }

    SuggestedExercise? exercise;
    if (json['suggestedExercise'] is Map<String, dynamic>) {
      exercise = SuggestedExercise.fromJson(
          json['suggestedExercise'] as Map<String, dynamic>);
    } else if (json['suggested_exercise'] is Map<String, dynamic>) {
      exercise = SuggestedExercise.fromJson(
          json['suggested_exercise'] as Map<String, dynamic>);
    }

    List<String> extraSteps = [];
    final stepsRaw = json['additionalSteps'] ?? json['additional_steps'];
    if (stepsRaw is List) {
      extraSteps = stepsRaw.map((e) => e.toString()).toList();
    }

    final summaryText = json['summary'] as String? ??
        json['text'] as String? ??
        json['message'] as String? ??
        '';

    return AiReflectionResponse(
      summary: summaryText,
      validation: json['validation'] as String? ?? '',
      practicalStep: step,
      additionalSteps: extraSteps,
      audioScript: json['audioScript'] as String? ??
          json['audio_script'] as String? ??
          summaryText,
      closingMessage: json['closingMessage'] as String? ??
          json['closing_message'] as String? ??
          'Kamu sudah melangkah dengan baik hari ini.',
      suggestedExercise: exercise,
      isCrisis: json['isCrisis'] as bool? ?? json['is_crisis'] as bool? ?? false,
      disclaimer: json['disclaimer'] as String? ??
          'Dukungan umum untuk refleksi diri, bukan diagnosis atau pengganti bantuan profesional.',
    );
  }

  Map<String, dynamic> toJson() => {
    'summary': summary,
    'validation': validation,
    if (practicalStep != null) 'practicalStep': practicalStep!.toJson(),
    'additionalSteps': additionalSteps,
    'audioScript': audioScript,
    'closingMessage': closingMessage,
    if (suggestedExercise != null)
      'suggestedExercise': suggestedExercise!.toJson(),
    'isCrisis': isCrisis,
    'disclaimer': disclaimer,
  };
}
