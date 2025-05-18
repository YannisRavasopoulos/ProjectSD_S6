class LocationException implements Exception {
  final String message;

  LocationException(this.message);

  @override
  String toString() {
    return 'LocationException: $message';
  }
}
