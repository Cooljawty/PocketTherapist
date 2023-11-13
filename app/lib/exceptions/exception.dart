class SignatureMismatchException implements Exception {
  String cause;
  SignatureMismatchException(this.cause);
}