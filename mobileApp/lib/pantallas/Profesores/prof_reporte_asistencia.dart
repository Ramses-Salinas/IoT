import 'package:flutter/material.dart';
import 'package:kunan_v01/widgets/estudiantes_widget.dart';

import '../../widgets/custom_navigationbar.dart';


class ProfReporteAsistencia extends StatelessWidget {
  const ProfReporteAsistencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: double.infinity,
        color: const Color.fromRGBO(1,6,24,1),

        padding: const EdgeInsets.only(top: 20, left: 35),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),
            const Text(
              'Reporte de asistencias',
              style: TextStyle(
                fontSize: 40,
                color: Color.fromRGBO(178,219,144,1),
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              'Estudiantes inasistentes:',
              style: TextStyle(
                fontSize: 30,
                color: Color.fromRGBO(178,219,144,1),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            const EstudianteWidget(
                imagen: '2',
                nombre: 'Juan Lino Gutierrez',
                estado: 'Ausente'
            ),
            const SizedBox(height: 20),
            const EstudianteWidget(
                imagen: '1',
                nombre: 'Sharom Del Ávila',
                estado: 'Ausente'
            ),

            const SizedBox(height: 60),

            const Text(
              'Estudiantes asistentes:',
              style: TextStyle(
                fontSize: 30,
                color: Color.fromRGBO(178,219,144,1),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            const EstudianteWidget(
                imagen: '2',
                nombre: 'Juan Lino Gutierrez',
                estado: 'Ausente'
            ),
            const SizedBox(height: 20),
            const EstudianteWidget(
                imagen: '1',
                nombre: 'Sharom Del Ávila',
                estado: 'Ausente'
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: 400,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Asistencia subida')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(128,179,255,1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'Subir',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(128,179,255,1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),

                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.logout, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Salir',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 0,
        usuario: 'Profesor',
      ),
    );
  }
}
