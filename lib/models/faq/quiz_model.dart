class QuizModel {
  final String id;
  final String text;
  final String? answer;
  final int? position;
  final bool enabled;

  QuizModel({
    required this.id,
    required this.text,
    this.answer,
    this.position,
    this.enabled = true,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id']?.toString() ?? '',
      text: json['text'] ?? '',
      answer: json['answer'],
      position: json['position'] != null ? int.tryParse(json['position'].toString()) : null,
      enabled: json['enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'answer': answer,
      'position': position,
      'enabled': enabled,
    };
  }
}
