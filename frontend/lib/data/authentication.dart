abstract interface class Authentication {
  Map<String, String> makeHeaders();
  int get userId;
}
