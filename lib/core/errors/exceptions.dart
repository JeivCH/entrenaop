// Excepción para errores del servidor o de Supabase
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

// Excepción para errores de caché local
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}
