class AppException implements Exception {
  final String? message;
  final String? prefix;

  AppException([this.message, this.prefix]);
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, 'Bad Request');
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, 'Unable to Connect');
}

class DefaultException extends AppException {
  DefaultException([String? message]) : super(message, 'Something Went wrong');
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String? message])
      : super(message, 'Api not responding');
}

class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? message])
      : super(message, 'UnAuthorized request');
}
