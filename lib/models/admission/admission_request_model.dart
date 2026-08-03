import 'dart:io';

class AdmissionRequestModel {
  final int? id;

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final DateTime? birthDate;
  final String nationality;
  final String profession;
  final String address;
  final String universityOrigin;
  final String currentLevel;
  final String requestedLevel;
  final String currentField;
  final String requestedField;
  final Map<String, File?> documents;

  const AdmissionRequestModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.nationality,
    required this.profession,
    required this.address,
    required this.universityOrigin,
    required this.currentLevel,
    required this.requestedLevel,
    required this.currentField,
    required this.requestedField,
    required this.documents,
  });

  factory AdmissionRequestModel.fromJson(Map<String, dynamic> json) {
    return AdmissionRequestModel(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.tryParse(json['birthDate']),
      nationality: json['nationality'] ?? '',
      profession: json['profession'] ?? '',
      address: json['address'] ?? '',
      universityOrigin: json['universityOrigin'] ?? '',
      currentLevel: json['currentLevel'] ?? '',
      requestedLevel: json['requestedLevel'] ?? '',
      currentField: json['currentField'] ?? '',
      requestedField: json['requestedField'] ?? '',
      documents: {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate != null
          ? '${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}'
          : null,
      'nationality': nationality,
      'phone': phone,
      'email': email,
      'profession': profession,
      'address': address,
      'universityOrigin': universityOrigin,
      'currentLevel': currentLevel,
      'requestedLevel': requestedLevel,
      'currentField': currentField,
      'requestedField': requestedField,
    };
  }
}