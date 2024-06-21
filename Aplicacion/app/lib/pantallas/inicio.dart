import 'package:flutter/material.dart';
import 'package:kunan_v01/pantallas/login.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});


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
              Image.asset('assets/imagenes/sombrero-de-graduacion.png'),
              const SizedBox(height: 20),
              const Text(
                'KUNAN',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(178,219,144,1),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(178,219,144,1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Inicio  ►',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              Image.asset('assets/imagenes/Logo FISI.png'),
            ],
          ),
        ),
      ),
    );
  }
}