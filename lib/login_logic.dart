class LoginResult {
  final bool success;
  final String message;

  LoginResult(this.success, this.message);
}

LoginResult validateLogin(String username, String password) {
  if (username.trim().isEmpty || password.trim().isEmpty) {
    return LoginResult(false, 'Username and password required');
  }

  if (username == 'Sandeep' && password == 'test123') {
    return LoginResult(true, 'Login successful');
  }

  return LoginResult(false, 'Invalid credentials');
}
