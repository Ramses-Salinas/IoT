
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/custom_navigationbar.dart';

class Curso {
  String nombre;
  String seccion;
  String ciclo;
  String dia;
  String horaInicio;
  String horaFin;
  final String idProfesor;
  Curso({
    required this.nombre,
    required this.seccion,
    required this.ciclo,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
    required this.idProfesor,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'seccion': seccion,
      'ciclo': ciclo,
      'dia': dia,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'id_profesor': idProfesor,
    };
  }
}



class ProfRegistrarCurso extends StatefulWidget {
  const ProfRegistrarCurso ({super.key});

  @override
  State<ProfRegistrarCurso > createState() => _ProfRegistrarCursoState();
}

class _ProfRegistrarCursoState extends State<ProfRegistrarCurso > {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _seccionController = TextEditingController();
  final _cicloController = TextEditingController();
  final _horaInicioController = TextEditingController();
  final _horaFinController = TextEditingController();
  String _selectedDia = 'Lunes';

  Future<void> _registrarCurso() async {
    if (_formKey.currentState!.validate()) {
      final curso = Curso(
        nombre: _nombreController.text,
        seccion: _seccionController.text,
        ciclo: _cicloController.text,
        dia: _selectedDia,
        horaInicio: _horaInicioController.text,
        horaFin: _horaFinController.text,
        idProfesor: "4CZv6v4huRSV3QUxo2R7", //Cambiar
      );

      try {
        final response = await http.post(
          Uri.parse('https://kunan.onrender.com/curso/create'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(curso.toJson()),
        );

        print(response.body);
        print(response.statusCode);

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Curso registrado exitosamente')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al registrar el curso')),
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
        padding: EdgeInsets.only(top: size.height * 0.03, left: size.width * 0.09, right: size.width * 0.09),
        color: const Color(0xFF21283F),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Registro de Cursos',
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
                    _buildTextField(_nombreController, 'Nombre del Curso'),
                    _buildTextField(_seccionController, 'Sección'),
                    _buildTextField(_cicloController, 'Ciclo'),
                    _buildDiaComboBox(),
                    _buildTextField(_horaInicioController, 'Hora de Inicio'),
                    _buildTextField(_horaFinController, 'Hora de Fin'),
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
                        'Registrar Curso',
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
        usuario: 'Profesor',
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {

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
          width:  size.width * 0.8,
          child: TextFormField(
            controller: controller,
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
              contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
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

  Widget _buildDiaComboBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Día',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 50,
          child: DropdownButtonFormField<String>(
            dropdownColor: Colors.grey[800],
            value: _selectedDia,
            items: <String>['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDia = newValue!;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}



