class RegisterRequest {
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String passwordConfirmation;
  final String? phone;

  RegisterRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.passwordConfirmation,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'password_confirmation': passwordConfirmation,
      if (phone != null) 'phone': phone,
    };
  }
}

