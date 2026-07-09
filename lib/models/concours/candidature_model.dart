import 'dart:io';

class CandidatureModel {
  final String nom;
  final String prenom;
  final String dateNaissance;
  final String nationalite;
  final String telephone;
  final String email;
  final String typeCandidat;

  final File? photoIdentite;
  final File? acteNaissance;
  final File? diplome;
  final File? releveNotes;
  final File? carteIdentite;

  const CandidatureModel({
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.nationalite,
    required this.telephone,
    required this.email,
    required this.typeCandidat,
    this.photoIdentite,
    this.acteNaissance,
    this.diplome,
    this.releveNotes,
    this.carteIdentite,
  });

  factory CandidatureModel.fromJson(Map<String, dynamic> json) {
    return CandidatureModel(
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      dateNaissance: json['date_naissance'] ?? '',
      nationalite: json['nationalite'] ?? '',
      telephone: json['telephone'] ?? '',
      email: json['email'] ?? '',
      typeCandidat: json['type_candidat'] ?? '',
    );
  }

  Map<String, String> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'date_naissance': dateNaissance,
      'nationalite': nationalite,
      'telephone': telephone,
      'email': email,
      'type_candidat': typeCandidat,
    };
  }

  CandidatureModel copyWith({
    String? nom,
    String? prenom,
    String? dateNaissance,
    String? nationalite,
    String? telephone,
    String? email,
    String? typeCandidat,
    File? photoIdentite,
    File? acteNaissance,
    File? diplome,
    File? releveNotes,
    File? carteIdentite,
  }) {
    return CandidatureModel(
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      nationalite: nationalite ?? this.nationalite,
      telephone: telephone ?? this.telephone,
      email: email ?? this.email,
      typeCandidat: typeCandidat ?? this.typeCandidat,
      photoIdentite: photoIdentite ?? this.photoIdentite,
      acteNaissance: acteNaissance ?? this.acteNaissance,
      diplome: diplome ?? this.diplome,
      releveNotes: releveNotes ?? this.releveNotes,
      carteIdentite: carteIdentite ?? this.carteIdentite,
    );
  }
}