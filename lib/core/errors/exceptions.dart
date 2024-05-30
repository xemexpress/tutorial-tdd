import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

class APIException extends Equatable implements Exception {
  const APIException({
    required this.message,
    required this.statusCode,
  });

  APIException.fromResponse(http.Response response)
      : this(
          message: response.body,
          statusCode: response.statusCode,
        );

  final String message;
  final int statusCode;

  @override
  List<Object> get props => [message, statusCode];
}
