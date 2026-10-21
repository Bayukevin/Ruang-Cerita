class SessionAnswer {
  final String questionId;
  final String optionId;
  final String? label;

  const SessionAnswer({
    required this.questionId,
    required this.optionId,
    this.label,
  });

  Map<String, dynamic> toJson() => {
    'questionId': questionId,
    'optionId': optionId,
    if (label != null) 'label': label,
  };

  factory SessionAnswer.fromJson(Map<String, dynamic> json) {
    return SessionAnswer(
      questionId: json['questionId'] as String? ?? '',
      optionId: json['optionId'] as String? ?? '',
      label: json['label'] as String?,
    );
  }
}
