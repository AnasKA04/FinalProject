enum QuestionType { singleChoice }

class Choice {
  final String id;
  final String text;
  final int score; // For routing only (not shown to patient)
  const Choice({required this.id, required this.text, required this.score});
}

class AssessmentQuestion {
  final String id;
  final String title;
  final String subtitle;
  final QuestionType type;
  final List<Choice> choices;

  /// Optional branching:
  /// map from choiceId -> nextQuestionId
  final Map<String, String>? nextByChoice;

  const AssessmentQuestion({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.choices,
    this.nextByChoice,
  });
}

class AssessmentAnswer {
  final String questionId;
  final String choiceId;
  final int score;
  const AssessmentAnswer({
    required this.questionId,
    required this.choiceId,
    required this.score,
  });
}

class AssessmentPacket {
  final DateTime submittedAt;
  final List<AssessmentAnswer> answers;

  /// Flags for therapist triage (patient will NOT see these)
  final bool flaggedForFollowUp;
  final bool flaggedSafety;

  const AssessmentPacket({
    required this.submittedAt,
    required this.answers,
    required this.flaggedForFollowUp,
    required this.flaggedSafety,
  });
}
