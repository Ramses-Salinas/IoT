import 'package:flutter/material.dart';
import 'package:kunan_v01/pantallas/Profesores/prof_pantalla_principal.dart';

import 'Alumnos/alum_pantalla_principal.dart';


class SelectUserScreen extends StatelessWidget {
  const SelectUserScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Transform.scale(
        scale: 1.4,
        child: Container(
          width: double.infinity,
          color: const Color(0xFF21283F),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¿Quién soy?',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EstMainMenuScreen(idUsuario: 'OuVmuk1gaojmulu9AnhQ')),
                  );


                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.white,
                  minimumSize: const Size(150, 150),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(178,219,144,1),
                      radius: 50,
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.asset('assets/imagenes/estudiante_registro.png'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Estudiante',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],

                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfMainMenuScreen(idUsuario: 'OuVmuk1gaojmulu9AnhQ')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(15),
                  backgroundColor: Colors.white,
                  minimumSize: const Size(150, 150),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color.fromRGBO(255,195,116,1),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.asset('assets/imagenes/profesor_registro.png'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Profesor',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

