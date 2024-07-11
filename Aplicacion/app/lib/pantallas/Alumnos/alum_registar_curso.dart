import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/custom_navigationbar.dart';
import '../../Controladores/save_preferences.dart';

class Matricula {
  final String idCurso;
  final String idEstudiante;

  Matricula({
    required this.idCurso,
    required this.idEstudiante,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_curso': idCurso,
      'id_usuario': idEstudiante,
    };
  }
}

class EstRegistrarCurso extends StatefulWidget {
  const EstRegistrarCurso({super.key});

  @override
  State<EstRegistrarCurso> createState() => _EstRegistrarCursoState();
}

class _EstRegistrarCursoState extends State<EstRegistrarCurso> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  String _nombreCurso = '';
  String _horaInicio = '';
  String _horaFin = '';
  String _dia = '';
  String _ciclo = '';
  String _idProfesor = '';
  String _seccion = '';
  String _duracion = '';

  Future<void> _getCourseInfo(String idCurso) async {
    try {
      final response = await http.post(
        Uri.parse('https://kunan.onrender.com/curso/getinfo'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_curso': idCurso}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        setState(() {
          _nombreCurso = data['nombre'] ?? '';
          _horaInicio = _formatHour(data['hora_inicio'] ?? '');
          _horaFin = _formatHour(data['hora_fin'] ?? '');
          _dia = data['dia'] ?? '';
          _ciclo = data['ciclo'] ?? '';
          _idProfesor = data['id_profesor'] ?? '';
          _seccion = data['seccion'] ?? '';
          _duracion = data['duracion'].toString() ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al obtener la información del curso')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error al obtener la información del curso')),
      );
    }
  }

  String _formatHour(String hour) {
    if (hour.length == 4) {
      return '${hour.substring(0, 2)}:${hour.substring(2, 4)}';
    }
    return hour;
  }

  Future<void> _registrarCurso() async {
    String? userId = await SharedPrefUtils.getString('userId');
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: No se encontró el ID del usuario')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final matricula = Matricula(
        idCurso: _idController.text,
        idEstudiante: userId, //Cambiar
      );

      try {
        final response = await http.post(
          Uri.parse('https://kunan.onrender.com/curso/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(matricula.toJson()),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Matrícula exitosa')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al matricularse')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ocurrió un error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(
            top: size.height * 0.03, left: size.width * 0.09, right: size.width * 0.09),
        color: const Color(0xFF21283F),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Matrícula de Cursos',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(178, 219, 144, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 80),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_idController, 'Id del Curso', onChanged: (value) {
                      _getCourseInfo(value);
                    }),
                    const SizedBox(height: 20),
                    _buildCourseInfoContainer(),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: _registrarCurso,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(128, 179, 255, 1),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Matricularme',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 2,
        usuario: 'Alumno',
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {ValueChanged<String>? onChanged}) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 50,
          width: size.width * 0.8,
          child: TextFormField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Ingresa $label',
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
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa $label';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCourseInfoContainer() {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(15.0),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: const Color(0xFF2C344B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF178C6B), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoField('Nombre del Curso', _nombreCurso),
          _buildInfoField('Hora de Inicio', _horaInicio),
          _buildInfoField('Hora de Fin', _horaFin),
          _buildInfoField('Día', _dia),
          _buildInfoField('Ciclo', _ciclo),
          _buildInfoField('Sección', _seccion),
          _buildInfoField('Duración', _duracion),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromRGBO(178, 219, 144, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
