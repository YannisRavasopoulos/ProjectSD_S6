abstract interface class AuthenticationRepository {
  Future<void> authenticate(String email, String password);

  Future<void> clear();
}
