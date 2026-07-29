/// Exception API générale
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

/// Erreur d'authentification (401)
class UnauthorizedException extends ApiException {
  UnauthorizedException({String? message})
      : super(
          message: message ?? 'Authentification requise',
          statusCode: 401,
        );
}

/// Erreur d'accès interdit (403)
class ForbiddenException extends ApiException {
  ForbiddenException({String? message})
      : super(
          message: message ?? 'Accès interdit',
          statusCode: 403,
        );
}

/// Erreur ressource non trouvée (404)
class NotFoundException extends ApiException {
  NotFoundException({String? message})
      : super(
          message: message ?? 'Ressource non trouvée',
          statusCode: 404,
        );
}

/// Erreur de validation (422)
class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;

  ValidationException({String? message, this.errors})
      : super(
          message: message ?? 'Erreur de validation',
          statusCode: 422,
        );
}

/// Erreur serveur (500)
class ServerException extends ApiException {
  ServerException({String? message})
      : super(
          message: message ?? 'Erreur serveur',
          statusCode: 500,
        );
}

/// Erreur réseau
class NetworkException extends ApiException {
  NetworkException({String? message})
      : super(
          message: message ?? 'Erreur de connexion réseau',
        );
}

/// Erreur timeout
class TimeoutException extends ApiException {
  TimeoutException({String? message})
      : super(
          message: message ?? 'Délai d\'attente dépassé',
        );
}

/// Erreur d'annulation
class CancelledException extends ApiException {
  CancelledException({String? message})
      : super(
          message: message ?? 'Requête annulée',
        );
}
