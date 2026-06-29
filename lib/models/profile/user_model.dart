class UserModel {
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String birthDate;
  final String level;
  final String department;
  final String avatar;
  final bool active;

  const UserModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.level,
    required this.department,
    required this.avatar,
    required this.active,
  });

  factory UserModel.fallback() {
    return const UserModel(
      fullName: "Jean DUPONT",
      email: "jeandupont@gmail.com",
      phone: "+228 70 00 00 00",
      address: "Tokoin Doumasséssé",
      birthDate: "12 mars 2003",
      level: "2ème année Licence",
      department: "Architecture",
      avatar: "",
      active: true,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json["full_name"] ??
          json["name"] ??
          "Jean DUPONT",

      email: json["email"] ??
          "jeandupont@gmail.com",

      phone: json["phone"] ??
          "+228 70 00 00 00",

      address: json["address"] ??
          "Tokoin Doumasséssé",

      birthDate: json["birth_date"] ??
          "12 mars 2003",

      level: json["level"] ??
          "2ème année Licence",

      department: json["department"] ??
          json["program"] ??
          "Architecture",

      avatar: json["avatar"] ?? "",

      active: json["active"] ?? true,
    );
  }
}