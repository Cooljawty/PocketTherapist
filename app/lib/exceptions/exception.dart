
/// [SignatureMismatchException] is used to notify the use that a SignatureMismatchException occured
/// If this were to ever happen, it would indicate potential data loss or tampering
class SignatureMismatchException implements Exception {
  String cause;
  SignatureMismatchException(this.cause);
}
