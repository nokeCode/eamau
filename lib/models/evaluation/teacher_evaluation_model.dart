class TeacherEvaluationModel {
  final int courseId;
  final int teacherId;
  final String courseName;
  final String teacherName;
  final List<EvaluationCriterion> criteria;

  TeacherEvaluationModel({
    required this.courseId,
    required this.teacherId,
    required this.courseName,
    required this.teacherName,
    required this.criteria,
  });

  factory TeacherEvaluationModel.fromJson(Map<String, dynamic> json) {
    return TeacherEvaluationModel(
      courseId: json['course_id'] ?? 1,
      teacherId: json['teacher_id'] ?? 1,
      courseName: json['course_name'] ?? 'Atelier Urbaine',
      teacherName: json['teacher_name'] ?? 'M. Kossi Mensah',
      criteria: (json['criteria'] as List?)
          ?.map((e) => EvaluationCriterion.fromJson(e))
          .toList() ??
          [
            EvaluationCriterion(
              key: 'content',
              title: 'Qualité du contenu',
            ),
            EvaluationCriterion(
              key: 'clarity',
              title: 'Clarté des explications',
            ),
            EvaluationCriterion(
              key: 'availability',
              title: "Disponibilité de l'enseignant",
            ),
          ],
    );
  }

  factory TeacherEvaluationModel.fallback() {
    return TeacherEvaluationModel(
      courseId: 1,
      teacherId: 1,
      courseName: 'Atelier Urbaine',
      teacherName: 'M. Kossi Mensah',
      criteria: [
        EvaluationCriterion(
          key: 'content',
          title: 'Qualité du contenu',
        ),
        EvaluationCriterion(
          key: 'clarity',
          title: 'Clarté des explications',
        ),
        EvaluationCriterion(
          key: 'availability',
          title: "Disponibilité de l'enseignant",
        ),
      ],
    );
  }
}

class EvaluationCriterion {
  final String key;
  final String title;

  EvaluationCriterion({
    required this.key,
    required this.title,
  });

  factory EvaluationCriterion.fromJson(Map<String, dynamic> json) {
    return EvaluationCriterion(
      key: json['key'] ?? '',
      title: json['title'] ?? '',
    );
  }
}