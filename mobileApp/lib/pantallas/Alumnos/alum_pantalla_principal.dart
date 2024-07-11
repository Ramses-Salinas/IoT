import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kunan_v01/widgets/curso_widget.dart';
import 'package:http/http.dart' as http;
import '../../widgets/custom_navigationbar.dart';
import '../../widgets/random_lightcolor.dart';
import '../../Controladores/save_preferences.dart';

class EstMainMenuScreen extends StatefulWidget {
  final String idUsuario;

  const EstMainMenuScreen({super.key, required this.idUsuario});

  @override
  State<EstMainMenuScreen> createState() => _EstMainMenuScreenState();
}

class _EstMainMenuScreenState extends State<EstMainMenuScreen> {
  String _nombre = "";
  List<dynamic> _cursos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _printPreferences();
    _loadData();
  }

  void _printPreferences() async {
    await SharedPrefUtils.printAllValues();
  }
  Future<void> _loadData() async {
    final cursos = await SharedPrefUtils.getStringList('user_courses');
    if (cursos != null && cursos.isNotEmpty) {
      setState(() {
        _cursos = cursos;
        _isLoading = false;
      });
    } else {
      await _fetchCoursedta();
    }

    final nombre = await SharedPrefUtils.getString('nombres');
    if (nombre != null) {
      setState(() {
        _nombre = nombre;
      });
    } else {
      await _fetchUserData();
    }
  }
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      await SharedPrefUtils.saveString('id', userData['id'] ?? '');
      await SharedPrefUtils.saveString(
          'apellidos', userData['apellidos'] ?? '');
      await SharedPrefUtils.saveString('codigo', userData['codigo'] ?? '');
      await SharedPrefUtils.saveString('correo', userData['correo'] ?? '');
      await SharedPrefUtils.saveBool(
          'esProfesor', userData['esProfesor'] ?? false);
      await SharedPrefUtils.saveString('escuela', userData['escuela'] ?? '');
      await SharedPrefUtils.saveString('facultad', userData['facultad'] ?? '');
      await SharedPrefUtils.saveString('nombres', userData['nombres'] ?? '');
      await SharedPrefUtils.saveBool("isLoggedIn", true);
      print('Datos de usuario guardados exitosamente');
    } catch (e) {
      print('Error al guardar datos de usuario: $e');
    }
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://kunan.onrender.com/usuario_info/info/${widget.idUsuario}'),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _nombre = data['nombres'];
          _isLoading = false;
        });

        if (data['codigo'] != null) {
          _saveUserData(data);
        }
      } else {
        throw Exception('Error al obtener datos del usuario');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener datos del servidor')),
      );
    }
  }

  Future<void> _fetchCoursedta() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://kunan.onrender.com/usuario_info/user/${widget.idUsuario}'),
        headers: {'Content-Type': 'application/json'},
      );
      print(
          "----------------------------------------------------------------------------------");
      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final courses = data['cursos'] as List<dynamic>;
        final courseNames =
            courses.map((course) => course['nombre'].toString()).toList();
        setState(() {
          _cursos = courseNames;
          _isLoading = false;
          print(_cursos);
        });
        // Guardar cursos en SharedPreferences
        await SharedPrefUtils.saveStringList('user_courses', courseNames);
      } else {
        throw Exception('Error al obtener datos del usuario');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener datos del servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromRGBO(1, 6, 24, 1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // LOGO
              Container(
                margin: EdgeInsets.only(
                    top: size.height * 0.02, left: size.width * 0.1),
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.12,
                      height: size.height * 0.12,
                      child: Image.asset(
                          'assets/imagenes/sombrero-de-graduacion.png'),
                    ),
                    Text(
                      'Kunan',
                      style: TextStyle(
                        fontSize: size.width * 0.11,
                        color: const Color.fromRGBO(178, 219, 144, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.01),

              Column(
                children: [
                  // BIENVENIDA
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: size.width * 0.1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '¡Hola!',
                              style: TextStyle(
                                fontSize: size.width * 0.11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _nombre,
                              style: TextStyle(
                                fontSize: size.width * 0.09,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: size.width * 0.1),
                        width: size.width * 0.3,
                        height: size.width * 0.3,
                        child: Image.asset('assets/imagenes/fotoperfil2.png'),
                      ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.02),

                  // EN CURSO
                  Container(
                    margin: EdgeInsets.only(
                        left: size.width * 0.06, right: size.width * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'En Curso',
                          style: TextStyle(
                            fontSize: size.width * 0.09,
                            color: const Color.fromRGBO(178, 219, 144, 1),
                          ),
                        ),
                        const CursoWidget(
                          curso: 'Taller de Software Movil',
                          siglas: 'TM',
                          color: Color.fromRGBO(255, 194, 120, 1),
                          estado: 'Asistencia',
                          usuario: 'Alumno',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // MIS CURSOS
                  Container(
                    margin: EdgeInsets.only(
                        left: size.width * 0.06, right: size.width * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' Mis Cursos',
                          style: TextStyle(
                            fontSize: size.width * 0.09,
                            color: const Color.fromRGBO(178, 219, 144, 1),
                          ),
                        ),
                        if (_isLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _cursos.length,
                            itemBuilder: (context, index) {
                              final cursoNombre = _cursos[index];
                              final siglas =
                                  cursoNombre.substring(0, 2).toUpperCase();
                              final Color color = getRandomLightColor();
                              const estado = 'Sin estado';
                              const usuario = 'Alumno';

                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CursoWidget(
                                  curso: cursoNombre,
                                  siglas: siglas,
                                  color: color,
                                  estado: estado,
                                  usuario: usuario,
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 0,
        usuario: 'Alumno',
      ),
    );
  }
}
