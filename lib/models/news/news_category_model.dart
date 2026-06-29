class NewsCategoryModel {
  final int id;
  final String name;

  const NewsCategoryModel({
    required this.id,
    required this.name,
  });

  factory NewsCategoryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return NewsCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}