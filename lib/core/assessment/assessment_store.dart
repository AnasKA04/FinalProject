import 'assessment_models.dart';

class AssessmentStore {
  AssessmentStore._();
  static final AssessmentStore instance = AssessmentStore._();

  final List<AssessmentPacket> _submissions = [];

  List<AssessmentPacket> get submissions => List.unmodifiable(_submissions);

  void submit(AssessmentPacket packet) {
    _submissions.insert(0, packet);
  }

  void clear() => _submissions.clear();
}
