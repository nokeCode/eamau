class ContactModel {
  final String phone;
  final String email;
  final String address;
  final String mapUrl;
  final Map<String, String> socialLinks;

  ContactModel({
    required this.phone,
    required this.email,
    required this.address,
    required this.mapUrl,
    required this.socialLinks,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      phone: json["phone"] ?? "",
      email: json["email"] ?? "",
      address: json["address"] ?? "",
      mapUrl: json["map_url"] ?? "",
      socialLinks: {
        "facebook": json["facebook"] ?? "",
        "instagram": json["instagram"] ?? "",
        "linkedin": json["linkedin"] ?? "",
        "youtube": json["youtube"] ?? "",
        "twitter": json["twitter"] ?? "",
      },
    );
  }

  factory ContactModel.fallback() {
    return ContactModel(
      phone: "+228 00 00 00 00",
      email: "contact@eamau.org",
      address: "Rue des balises; Doumasséssé Tokoin",
      mapUrl: "",
      socialLinks: {
        "facebook": "",
        "instagram": "",
        "linkedin": "",
        "youtube": "",
        "twitter": "",
      },
    );
  }
}