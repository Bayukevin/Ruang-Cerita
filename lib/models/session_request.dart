import 'session_answer.dart';

class SessionRequest {
  final String feelingId;
  final String situationId;
  final String durationId;
  final String? supportGoalId;
  final List<SessionAnswer> answers;
  final String? safetyConcern;
  final DateTime clientTimestamp;

  SessionRequest({
    required this.feelingId,
    required this.situationId,
    required this.durationId,
    this.supportGoalId,
    this.answers = const [],
    this.safetyConcern,
    DateTime? clientTimestamp,
  }) : clientTimestamp = clientTimestamp ?? DateTime.now();

  Map<String, dynamic> toDataMap() => {
    'feeling': feelingId,
    'situation': situationId,
    'duration': durationId,
    if (supportGoalId != null) 'supportGoal': supportGoalId,
    'answers': answers.map((a) => a.toJson()).toList(),
    'safetyConcern': safetyConcern ?? 'none',
    'clientTimestamp': clientTimestamp.toIso8601String(),
  };

  /// Constructs payload adhering to PRD with compatibility fallbacks
  Map<String, dynamic> toApiPayload({required String idToken}) {
    final data = toDataMap();
    return {
      'action': 'generate_reflection',
      'idToken': idToken,
      'data': data,
      // ponytail: legacy GAS compatibility until deployment standardized
      'session': data,
    };
  }

  factory SessionRequest.fromSelection({
    required String feelingId,
    required String situationId,
    required String durationId,
    String? supportGoalId,
    String? safetyConcern,
  }) {
    return SessionRequest(
      feelingId: feelingId,
      situationId: situationId,
      durationId: durationId,
      supportGoalId: supportGoalId,
      answers: [
        SessionAnswer(
          questionId: 'duration_v1',
          optionId: durationId,
        ),
      ],
      safetyConcern: safetyConcern,
    );
  }
}
