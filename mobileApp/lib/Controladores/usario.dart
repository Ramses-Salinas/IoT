class Usuario {
  final Map<String, String> _users = {
    'alumno@unmsm.edu.pe': '123456',
    'profesor@unmsm.edu.pe': '123456',
  };

  bool validarUsuario(String email, String password) {
    return _users[email] == password;
  }

  bool registrarUsuario(String email, String password) {
    if (_users.containsKey(email)) {
      return false;
    }
    _users[email] = password;
    return true;
  }

  bool existeUsuario(String email) {
    return _users.containsKey(email);
  }
}

final Usuario usuario = Usuario();
