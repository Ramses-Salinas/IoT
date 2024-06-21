import 'package:flutter/material.dart';
import 'package:kunan_v01/widgets/calend_widget.dart';

import '../../widgets/custom_navigationbar.dart';


class ProfCalendarioSemanal extends StatelessWidget {
  const ProfCalendarioSemanal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        color: const Color.fromRGBO(1,6,24,1),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(right: 60),
              child: const Text(
                'Horario',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
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
                        calendLibreWidget(3, 'Seleccionado')

                        //calendHorasWidget('14', 'PM'),
                      ],
                    ),

                    Column(
                      children: [
                        calendDiasWidget('24', 'Mar',''),
                        calendLibreWidget(7, '')
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
                        calendLibreWidget(7, '')
                      ],
                    ),
                    Column(
                      children: [
                        calendDiasWidget('27', 'Vie',''),
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
        usuario: 'Profesor',
      ),
    );
  }
}
