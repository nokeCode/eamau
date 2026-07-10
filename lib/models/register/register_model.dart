class RegisterModel {
  final String nom;
  final String prenom;
  final String email;
  final String telephone;
  final String password;

  RegisterModel({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "nom": nom,
      "prenom": prenom,
      "email": email,
      "telephone": telephone,
      "password": password,
    };
  }

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      nom: json["nom"] ?? "",
      prenom: json["prenom"] ?? "",
      email: json["email"] ?? "",
      telephone: json["telephone"] ?? "",
      password: "",
    );
  }
}