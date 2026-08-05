class ProfileAcademicModel {
  final String year;
  final String specialty;
  final String grade;
  final String group;
  final String status;

  ProfileAcademicModel({
    required this.year,
    required this.specialty,
    required this.grade,
    required this.group,
    required this.status,
  });

  factory ProfileAcademicModel.empty() {
    return ProfileAcademicModel(
      year: '',
      specialty: '',
      grade: '',
      group: '',
      status: '',
    );
  }

  factory ProfileAcademicModel.fromJson(Map<String, dynamic> json) {
    return ProfileAcademicModel(
      year: json['year'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      grade: json['grade'] as String? ?? '',
      group: json['group'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}
