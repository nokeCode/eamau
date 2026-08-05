class ApiConfig {
  static const String baseUrl = 'http://192.168.2.89:9090/api';
  static const String apiVersion = '/v1';
  static const String fullBaseUrl = '$baseUrl$apiVersion';

  static String get mediaBaseUrl {
    if (baseUrl.endsWith('/api')) {
      return baseUrl.substring(0, baseUrl.length - 4);
    }
    return baseUrl;
  }

  static String imageUrl(String path) {
    if (path.startsWith('http')) return path;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return '$mediaBaseUrl$normalizedPath';
  }
}
