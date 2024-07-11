import 'package:flutter/material.dart';
import 'package:kunan_v01/pantallas/inicio.dart';
import '../../widgets/custom_navigationbar.dart';
import '../../Controladores/save_preferences.dart';
class ProflogoutScreen extends StatefulWidget {
  const ProflogoutScreen({super.key});

  @override
  State<ProflogoutScreen> createState() => _ProflogoutScreenState();
}

class _ProflogoutScreenState extends State<ProflogoutScreen> {

  String _nombre = "";
  String _apellido = "";
  String _correo = "";
  String _escuela = "";
  String _facultad = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final nombre = await SharedPrefUtils.getString('nombres') ?? '';
      final apellido = await SharedPrefUtils.getString('apellidos') ?? '';
      final correo = await SharedPrefUtils.getString('correo') ?? '';
      final escuela = await SharedPrefUtils.getString('escuela') ?? '';
      final facultad = await SharedPrefUtils.getString('facultad') ?? '';

      setState(() {
        _nombre = nombre;
        _apellido = apellido;
        _correo = correo;
        _escuela = escuela;
        _facultad = facultad;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al obtener datos guardados')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color.fromRGBO(1,6,24,1),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 115,
                          height: 115,
                          child: Image.asset('assets/imagenes/fotoperfil2.png'),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _nombre,
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nombre completo',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '$_nombre $_apellido',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Correo Electrónico',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _correo, // Mostrar correo electrónico
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Escuela',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _escuela, // Mostrar escuela
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Facultad',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _facultad,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () async {
                    await SharedPrefUtils.clearData();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => InicioScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(178,219,144,1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 3,
        usuario: 'Profesor',
      ),
    );

  }
}