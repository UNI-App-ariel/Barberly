/// A class that represents a failure state, typically used for error handling.
class Failure {
  /// The error message associated with the failure.
  final String message;

  /// Creates an instance of [Failure] with an optional [message].
  /// If no message is provided, a default message is used.
  Failure([this.message = 'An unexpected error occurred.']);
}
