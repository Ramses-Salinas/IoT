import 'package:flutter/material.dart';
import 'package:kunan_v01/widgets/calend_widget.dart';

import '../../widgets/custom_navigationbar.dart';


class EstCalendarioDiario extends StatelessWidget {
  const EstCalendarioDiario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: const Color.fromRGBO(1,6,24,1),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              '22 de abril del 2024',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 30),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    height: 800,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        calendHorasWidget('', ''),
                        calendHorasWidget('08', 'AM'),
                        calendHorasWidget('09', 'AM'),
                        calendHorasWidget('10', 'AM'),
                        calendHorasWidget('11', 'AM'),
                        calendHorasWidget('12', 'PM'),
                        calendHorasWidget('13', 'PM'),
                        calendHorasWidget('14', 'PM'),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      calendDiasWidget('22', 'Lun','Seleccionado'),
                      calendCursosWidget(
                        'Taller de Software Móvil',
                        'Lab 01',
                        4,
                        "Seleccionado",
                        const Color.fromRGBO(255, 195, 116, 1),
                      ),
                      calendLibreWidget(2, 'Seleccionado'),
                      calendCursosWidget(
                        'Minería de Datos',
                        'Saón 103',
                        1,
                        "Seleccionado",
                        const Color.fromRGBO(74, 210, 201, 1),
                      ),
                      //calendHorasWidget('14', 'PM'),
                    ],
                  ),

                  Column(
                    children: [
                      calendDiasWidget('24', 'Mar',''),
                      calendCursosWidget(
                        'Gestión de riesgos',
                        'Salón 109',
                        4,
                        "",
                        const Color.fromRGBO(143, 152, 255, 1),
                      ),
                      calendLibreWidget(3, '')
                    ],
                  ),

                  Column(
                    children: [
                      calendDiasWidget('25', 'Mie',''),
                      calendLibreWidget(7, '')
                    ],
                  ),

                  Column(
                    children: [
                      calendDiasWidget('26', 'Jue',''),
                      calendLibreWidget(5, ''),
                      calendCursosWidget(
                        'Desarrollo de Tesis 1',
                        'Salón 104',
                        2,
                        "Seleccionado",
                        const Color.fromRGBO(128, 179, 255, 1),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      calendDiasWidget('27', 'Vie',''),
                      calendCursosWidget(
                        'Gestión de Mantenimiento',
                        'Salón 201',
                        4,
                        "Seleccionado",
                        const Color.fromRGBO(254, 153, 70, 1),
                      ),
                      calendLibreWidget(3, ''),
                    ],
                  ),
                  Column(
                    children: [
                      calendDiasWidget('28', 'Sab',''),
                      calendLibreWidget(7, '')
                    ],

                  ),

                ],
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        initialIndex: 1,
        usuario: 'Alumno',
      ),
    );
  }
}
