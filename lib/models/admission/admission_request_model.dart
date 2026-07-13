import 'dart:io';

class AdmissionRequestModel {
  final int? id;

  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  final DateTime? birthDate;
  final String nationality;

  final String diploma;
  final String graduationYear;

  final String previousSchool;
  final String previousCountry;

  final String level;
  final String program;

  final Map<String, File?> documents;

  final String status;

  const AdmissionRequestModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.nationality,
    required this.diploma,
    required this.graduationYear,
    required this.previousSchool,
    required this.previousCountry,
    required this.level,
    required this.program,
    required this.documents,
    this.status = "draft",
  });

  factory AdmissionRequestModel.fromJson(Map<String, dynamic> json) {
    return AdmissionRequestModel(
      id: json["id"],
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      birthDate: json["birth_date"] == null
          ? null
          : DateTime.parse(json["birth_date"]),
      nationality: json["nationality"] ?? "",
      diploma: json["diploma"] ?? "",
      graduationYear: json["graduation_year"] ?? "",
      previousSchool: json["previous_school"] ?? "",
      previousCountry: json["previous_country"] ?? "",
      level: json["level"] ?? "",
      program: json["program"] ?? "",
      documents: {},
      status: json["status"] ?? "draft",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone": phone,
      "birth_date": birthDate?.toIso8601String(),
      "nationality": nationality,
      "diploma": diploma,
      "graduation_year": graduationYear,
      "previous_school": previousSchool,
      "previous_country": previousCountry,
      "level": level,
      "program": program,
      "status": status,
    };
  }
}