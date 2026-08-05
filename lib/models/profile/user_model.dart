class UserModel {
  final String fullName;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String birthDate;
  final String birthPlace;
  final String gender;
  final String country;
  final String nationality;
  final String countryId;
  final String skype;
  final String whatsapp;
  final String maritalStatus;
  final String identityNumber;
  final String level;
  final String department;
  final String avatar;
  final bool active;
  final String username;
  final String matricule;
  // Validation related fields
  final String permanentPostalBox;
  final String permanentCity;
  final String permanentQuarter;
  final String permanentStreet;
  final String permanentHomePhone;
  final String permanentMobile;
  final String lomePostalBox;
  final String lomeCity;
  final String lomeQuarter;
  final String lomeStreet;
  final String lomeHomePhone;
  final String lomeMobile;
  final String lomeEmail;
  final String emergencyName;
  final String emergencyPostalBox;
  final String emergencyCity;
  final String emergencyQuarter;
  final String emergencyStreet;
  final String emergencyHomePhone;
  final String emergencyMobile;
  final String emergencyEmail;
  final String emergencyFirstName;
  final String identityFront;
  final String identityBack;

  const UserModel({
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.birthPlace,
    required this.gender,
    required this.country,
    required this.nationality,
    required this.countryId,
    required this.skype,
    required this.whatsapp,
    required this.maritalStatus,
    required this.identityNumber,
    required this.level,
    required this.department,
    required this.avatar,
    required this.active,
    required this.username,
    required this.matricule,
    required this.permanentPostalBox,
    required this.permanentCity,
    required this.permanentQuarter,
    required this.permanentStreet,
    required this.permanentHomePhone,
    required this.permanentMobile,
    required this.lomePostalBox,
    required this.lomeCity,
    required this.lomeQuarter,
    required this.lomeStreet,
    required this.lomeHomePhone,
    required this.lomeMobile,
    required this.lomeEmail,
    required this.emergencyName,
    required this.emergencyPostalBox,
    required this.emergencyCity,
    required this.emergencyQuarter,
    required this.emergencyStreet,
    required this.emergencyHomePhone,
    required this.emergencyMobile,
    required this.emergencyEmail,
    required this.emergencyFirstName,
    required this.identityFront,
    required this.identityBack,
  });

  factory UserModel.empty() {
    return const UserModel(
      fullName: '',
      firstName: '',
      lastName: '',
      email: '',
      phone: '',
      address: '',
      birthDate: '',
      birthPlace: '',
      gender: '',
      country: '',
      nationality: '',
      countryId: '',
      skype: '',
      whatsapp: '',
      maritalStatus: '',
      identityNumber: '',
      level: '',
      department: '',
      avatar: '',
      active: false,
      username: '',
      matricule: '',
      permanentPostalBox: '',
      permanentCity: '',
      permanentQuarter: '',
      permanentStreet: '',
      permanentHomePhone: '',
      permanentMobile: '',
      lomePostalBox: '',
      lomeCity: '',
      lomeQuarter: '',
      lomeStreet: '',
      lomeHomePhone: '',
      lomeMobile: '',
      lomeEmail: '',
      emergencyName: '',
      emergencyPostalBox: '',
      emergencyCity: '',
      emergencyQuarter: '',
      emergencyStreet: '',
      emergencyHomePhone: '',
      emergencyMobile: '',
      emergencyEmail: '',
      emergencyFirstName: '',
      identityFront: '',
      identityBack: '',
    );
  }

  factory UserModel.fallback() => UserModel.empty();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String text(dynamic value) => value?.toString() ?? '';
    final firstname = json["firstname"] ?? json["first_name"] ?? '';
    final lastname = json["lastname"] ?? json["last_name"] ?? '';
    final fullNameValue = [firstname, lastname]
        .where((part) => part.toString().trim().isNotEmpty)
        .join(' ');

    final school = json["school"] as Map<String, dynamic>?;
    final status = school?["status"] as String?;
    final bool activeValue = status != null
        ? status.toLowerCase().contains('accept')
        : (json["active"] is bool ? json["active"] as bool : true);

    final addressValue = json["address"] ??
        (json["matricule"] != null ? 'Matricule: ${json["matricule"]}' : null) ??
        "";

    return UserModel(
      fullName: fullNameValue.isNotEmpty
          ? fullNameValue
          : json["full_name"] ?? json["name"] ?? '',
      firstName: firstname,
      lastName: lastname,
      email: json["email"] ?? '',
      phone: json["phone"] ?? '',
      address: addressValue,
      birthDate: json["birth_date"] ?? json['birthDate'] ?? '',
      birthPlace: json['birth_place'] ?? json['birthPlace'] ?? '',
      gender: json['gender'] ?? '',
      country: text(json['country']),
      nationality: text(json['nationalite'] ?? json['nationality']),
      countryId: text(json['contry_id'] ?? json['country_id']),
      skype: text(json['skype']),
      whatsapp: text(json['whatsapp']),
      maritalStatus: text(json['situation_matri'] ?? json['marital_status']),
      identityNumber: json['identity_number'] ?? json['identityNumber'] ?? '',
      level: school?["grade"] ?? json["level"] ?? '',
      department: school?["specialty"] ?? json["department"] ?? json["program"] ?? '',
      avatar: json["photo"] ?? json["avatar"] ?? "",
      active: activeValue,
      username: json["username"] ?? '',
      matricule: json["matricule"] ?? '',
      permanentPostalBox: json['permanent_postal_box'] ?? '',
      permanentCity: json['permanent_city'] ?? '',
      permanentQuarter: json['permanent_quarter'] ?? '',
      permanentStreet: json['permanent_street'] ?? '',
      permanentHomePhone: json['permanent_home_phone'] ?? '',
      permanentMobile: json['permanent_mobile'] ?? '',
      lomePostalBox: json['lome_postal_box'] ?? '',
      lomeCity: json['lome_city'] ?? '',
      lomeQuarter: json['lome_quarter'] ?? '',
      lomeStreet: json['lome_street'] ?? '',
      lomeHomePhone: json['lome_home_phone'] ?? '',
      lomeMobile: json['lome_mobile'] ?? '',
      lomeEmail: json['lome_email'] ?? '',
      emergencyName: json['emergency_name'] ?? '',
      emergencyPostalBox: json['emergency_postal_box'] ?? '',
      emergencyCity: json['emergency_city'] ?? '',
      emergencyQuarter: json['emergency_quarter'] ?? '',
      emergencyStreet: json['emergency_street'] ?? '',
      emergencyHomePhone: json['emergency_home_phone'] ?? '',
      emergencyMobile: json['emergency_mobile'] ?? '',
      emergencyEmail: json['emergency_email'] ?? '',
      emergencyFirstName: text(json['prenompersoprev'] ?? json['emergency_first_name']),
      identityFront: json['identity_front'] ?? '',
      identityBack: json['identity_back'] ?? '',
    );
  }
}
