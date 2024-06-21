
import 'package:flutter/material.dart';
import 'package:kunan_v01/pantallas/Profesores/prof_asistencia.dart';

import '../Controladores/save_preferences.dart';
import '../pantallas/Alumnos/alum_asistencia.dart';


class CursoWidget extends StatefulWidget {

  final String curso;
  final String siglas;
  final String estado;
  final String usuario;
  final Color color;

  const CursoWidget({super.key, required this.curso,
    required this.siglas, required this.estado,
    required this.usuario, required this.color});

  @override
  State<CursoWidget> createState() => _CursoWidgetState();
}

class _CursoWidgetState extends State<CursoWidget> {

  bool asistenciaMarcada = false;

  @override
  void initState() {
    super.initState();
    _loadAsistenciaMarcada();
  }

  Future<void> _loadAsistenciaMarcada() async {
    bool? marcada = await SharedPrefUtils.getBool("asistenciaMarcada");
    if (marcada != null && marcada) {
      setState(() {
        asistenciaMarcada = marcada;
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return Container(
        //width: double.infinity,
      width: 400,
      height: widget.estado == "En Curso" || widget.estado == "Asistencia"? 125.0 : 75.0,
      decoration: BoxDecoration(
        color: widget.estado == "En Curso" || widget.estado == "Asistencia" ? Colors.white :const Color.fromRGBO(33,40,63,1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: widget.estado == "En Curso" || widget.estado == "Asistencia" ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(left: 50, right: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
                child: Center(
                  child: Text(
                    widget.siglas,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.curso,
                    style: TextStyle(
                      color: widget.estado == "En Curso" ? Colors.black : widget.color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.estado == "Asistencia" && !asistenciaMarcada)
                    const Text(
                      "Asistencia en proceso",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),
          if(widget.estado == "En Curso" || widget.estado == "Asistencia")
            TomarAsistenciaWidget(context:context, usuario: widget.usuario),



        ],
      ),

    );

  }
}

class TomarAsistenciaWidget extends StatelessWidget {
  final BuildContext context;
  final String usuario;

  const TomarAsistenciaWidget({super.key, required this.context, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (usuario == "Alumno") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AlumTomarAsistencia()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfTomarAsistencia()),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(128, 179, 255, 1),
        minimumSize: const Size(400, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        usuario == "Alumno" ? "Marcar Asistencia" : "Iniciar Asistencia",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}