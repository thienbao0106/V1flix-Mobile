class SignUpResult {
  final String error;
  final bool result;
  final String? message;

  SignUpResult({required this.error, required this.result, this.message});
}

class UserRegisterData {
  final String username;
  final String password;
  final String confirmedPassword;
  final String email;

  UserRegisterData(
      {required this.username,
      required this.password,
      required this.confirmedPassword,
      required this.email});
}
