import 'registration_referential_model.dart';

class RegistrationStatus {
  final bool open;
  final bool canCreate;
  final RegistrationOption? activeSchoolYear;
  final String message;

  const RegistrationStatus({
    required this.open,
    required this.canCreate,
    this.activeSchoolYear,
    required this.message,
  });

  factory RegistrationStatus.fromJson(dynamic source) {
    if (source is Map) {
      final map = Map<String, dynamic>.from(source);
      return RegistrationStatus(
        open: map['open'] == true,
        canCreate: map['canCreate'] == true,
        activeSchoolYear: map['activeSchoolYear'] != null
            ? RegistrationOption.fromJson(map['activeSchoolYear'])
            : null,
        message: map['message']?.toString() ?? '',
      );
    }
    return const RegistrationStatus(
      open: false,
      canCreate: false,
      activeSchoolYear: null,
      message: '',
    );
  }
}
