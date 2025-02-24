/// A custom exception class to handle server-related errors.
class ServerException implements Exception {
  /// The error message associated with the exception.
  final String message;

  /// Creates an instance of [ServerException] with a given [message].
  const ServerException(this.message);

  /// Returns a string representation of the exception, including the error message.
  @override
  String toString() {
    return 'ServerException: $message';
  }
}
