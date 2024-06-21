
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class EstudianteWidget extends StatelessWidget {

  final String imagen;
  final String nombre;
  final String estado;

  const EstudianteWidget({super.key, required this.imagen, required this.nombre, required this.estado, });


  @override
  Widget build(BuildContext context) {

    return Container(
      width: 400,
      height: 75.0,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(33,40,63,1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                margin: const EdgeInsets.only(left: 30, right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: imagen == "1"?
                      const AssetImage('assets/imagenes/fotoperfil1.png'):
                      const AssetImage('assets/imagenes/fotoperfil2.png'),
                    fit: BoxFit.cover,
                  ),
                ),

              ),
              Text(
                nombre,
                style: const TextStyle(
                  color: Color.fromRGBO(128, 179, 255, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 50,
                    height: 20,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: estado == "Ausente"? const Color.fromRGBO(179,38,30,1) : const Color.fromRGBO(178,219,144,1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              )
            ],
          ),


        ],
      ),

    );

  }
}

