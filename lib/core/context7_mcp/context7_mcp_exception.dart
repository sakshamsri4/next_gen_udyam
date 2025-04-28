/// Exception thrown when an error occurs while interacting with the Context 7 MCP server.
class Context7McpException implements Exception {
  /// Creates a new Context7McpException.
  const Context7McpException({
    required this.message,
    required this.code,
    this.statusCode,
  });

  /// The error message.
  final String message;

  /// The error code.
  final String code;

  /// The HTTP status code, if applicable.
  final int? statusCode;

  @override
  String toString() {
    final statusCodeString = statusCode != null ? ' (Status: $statusCode)' : '';
    return 'Context7McpException: [$code]$statusCodeString $message';
  }
}
