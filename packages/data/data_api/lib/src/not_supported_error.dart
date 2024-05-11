class NotSupportedError extends Error {
  final String? message;

  NotSupportedError({this.message});

  @override
  String toString() {
    if (message != null) {
      return 'NotSupportedError: $message';
    }
    return 'NotSupportedError';
  }
}
