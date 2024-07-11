import 'package:flutter/material.dart';
import 'package:kunan_v01/pantallas/Alumnos/alum_calendario_semanal.dart';
import 'package:kunan_v01/pantallas/Alumnos/alum_registar_curso.dart';
import 'package:kunan_v01/pantallas/Profesores/prof_calendario_semanal.dart';
import 'package:kunan_v01/pantallas/Alumnos/alum_logout.dart';
import 'package:kunan_v01/pantallas/Profesores/prof_logout.dart';
import 'package:kunan_v01/pantallas/Profesores/prof_registar_curso.dart';

import '../pantallas/Alumnos/alum_pantalla_principal.dart';
import '../pantallas/Profesores/prof_pantalla_principal.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int initialIndex;
  final String usuario;

  const CustomBottomNavigationBar({
    super.key,
    required this.initialIndex,
    required this.usuario,
  });

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();

  Map<String, Widget> getRoutes() {
    switch (usuario) {
      case 'Profesor':
        return {
          '/home_profesor': const ProfMainMenuScreen(idUsuario: 'OuVmuk1gaojmulu9AnhQ'),
          '/calendar_profesor': const ProfCalendarioSemanal(),
          '/curse_profesor': const ProfRegistrarCurso(),
          '/settings_profesor': const ProflogoutScreen(),
        };
      case 'Alumno':
        return {
          '/home_alumno': const EstMainMenuScreen(idUsuario: 'OuVmuk1gaojmulu9AnhQ'),
          '/calendar_alumno': const EstCalendarioSemanal(),
          '/curse_alumno': const EstRegistrarCurso(),
          '/settings_alumno': const EstlogoutScreen(),
        };
      default:
        return {};
    }
  }

}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    final routes = widget.getRoutes();
    final routeKeys = routes.keys.toList();
    Navigator.push(context, MaterialPageRoute(builder: (context) => routes[routeKeys[index]]!));
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items;
    switch (widget.usuario) {
      case 'Profesor':
        items = const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ];
        break;
      case 'Alumno':
        items = const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ];
        break;
      default:
        items = [];
    }
    return SizedBox(
      height: 70,
      child: BottomNavigationBar(
        items: items,
        currentIndex: _currentIndex,
        backgroundColor: const Color.fromRGBO(33,40,63,1),
        unselectedItemColor: const Color.fromRGBO(235,235,245,1),
        selectedItemColor: const Color.fromRGBO(178,219,144,1),
        iconSize: 35,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
      ),
    );
  }
}
