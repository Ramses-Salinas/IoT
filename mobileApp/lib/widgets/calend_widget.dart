
import 'package:flutter/material.dart';

Widget calendHorasWidget(String numberText, String timeText) {
  return Container(
    width: 30,
    height: 100,
    decoration: const BoxDecoration(
      border: Border(
        //top: BorderSide(width: 1.0, color: Colors.grey),
        bottom: BorderSide(width: 2.0, color: Colors.grey),
      ),
    ),
    child: Column(
      children: [
        Text(
          numberText,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          timeText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}



Widget calendDiasWidget(String numberText, String dayText, String estado) {

  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: estado == "Seleccionado" ? const Color.fromRGBO(33, 40, 63, 1) : Colors.transparent,
      border: const Border(
        //top: BorderSide(width: 1.0, color: Colors.grey),
        bottom: BorderSide(width: 2.0, color: Colors.grey),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          numberText,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          dayText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}


Widget calendCursosWidget(String curso, String aula, int duracion, String estado, Color color) {
  return Column(
    children: List.generate(duracion, (index) => _buildCurso(curso, aula, estado, index, duracion, color)),
  );
}

Widget _buildCurso(String curso, String aula,String estado, int index, int duracion, Color color) {
  bool isFirst = index == 0;
  bool isLast = index == duracion - 1;
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: estado == "Seleccionado" ? const Color.fromRGBO(33, 40, 63, 1) : Colors.transparent,
      border: const Border(
        //top: BorderSide(width: 1.0, color: Colors.grey),
        bottom: BorderSide(width: 2.0, color: Colors.grey),
      ),
    ),
    child: Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.only(left:5, right: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: isFirst ? const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10))
            : isLast ? const BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
            : const BorderRadius.all(Radius.circular(0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: isFirst,
            child: Column(
              children: [
                Text(
                  curso,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  aula,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}



Widget calendLibreWidget(int duracion, String estado) {
  return Column(
    children: List.generate(duracion, (index) => _buildLibre(estado)),
  );
}

Widget _buildLibre(String estado) {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: estado == "Seleccionado" ? const Color.fromRGBO(33, 40, 63, 1) : Colors.transparent,
      border: const Border(
        //top: BorderSide(width: 1.0, color: Colors.grey),
        bottom: BorderSide(width: 2.0, color: Colors.grey),
      ),
    ),
  );
}