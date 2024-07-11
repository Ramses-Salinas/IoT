import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kunan_v01/pantallas/register.dart';
import 'package:kunan_v01/Controladores/save_preferences.dart';
import 'Alumnos/alum_pantalla_principal.dart';
import 'Profesores/prof_pantalla_principal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _hasOfflineData = false;

  @override
  void initState() {
    super.initState();
    _checkOfflineData();
    print(_hasOfflineData);
  }

  Future<void> _checkOfflineData() async {
    final isLoggedIn = await SharedPrefUtils.getBool("isLoggedIn");
    final esProfesor = await SharedPrefUtils.getBool("esProfesor");
    final idUsuario = await SharedPrefUtils.getString("userId");

    if (isLoggedIn == true && idUsuario != null) {
      setState(() {
        _hasOfflineData = true;
      });
    } else {
      setState(() {
        _hasOfflineData = false;
      });
    }
  }

  Future<void> _checkOfflineLogin() async {
    final isLoggedIn = await SharedPrefUtils.getBool("isLoggedIn");
    final esProfesor = await SharedPrefUtils.getBool("esProfesor");
    final idUsuario = await SharedPrefUtils.getString("userId");

    if (isLoggedIn == true && idUsuario != null) {
      if (esProfesor == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfMainMenuScreen(idUsuario: idUsuario),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EstMainMenuScreen(idUsuario: idUsuario),
          ),
        );
      }
    }
  }

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, ingresa el correo y la contraseña')),
      );
      return;
    }

    if (!email.endsWith('@unmsm.edu.pe')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, ingresa un correo de la UNMSM')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('https://kunan.onrender.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': email,
          'password': password,
        }),
      );
      print(response);
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('ResponseBody');
        print(responseBody);
        if (responseBody['acceso'] == 'Acceso exitoso') {
          await SharedPrefUtils.saveString(
              'userId', responseBody['id'].toString());
          await SharedPrefUtils.saveBool(
              'esProfesor', responseBody['esProfesor']);
          await SharedPrefUtils.saveBool('isLoggedIn', true);
          if (responseBody['esProfesor']) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfMainMenuScreen(idUsuario: responseBody['id'])),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EstMainMenuScreen(idUsuario: responseBody['id'])),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Correo o contraseña incorrectos')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error en el servidor')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF21283F),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Image.asset(
                  'assets/imagenes/sombrero-de-graduacion.png',
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                const SizedBox(height: 20),
                const Text(
                  'KUNAN',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromRGBO(178, 219, 144, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 80),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Correo',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Ingresa tu correo',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Contraseña',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 50,
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Ingresa tu contraseña',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              child: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          obscureText: !_passwordVisible,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(178, 219, 144, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _hasOfflineData ? _checkOfflineLogin : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hasOfflineData
                        ?  const Color.fromRGBO(178, 219, 144, 1)
                        :  const Color(0xFF9FA2B2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Conexión Offline',
                    style: TextStyle(
                      fontSize: 16,
                      color: _hasOfflineData ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿No tienes una cuenta? ',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
