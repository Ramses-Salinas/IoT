import 'package:flutter/material.dart';
import 'package:kunan_v01/pantallas/login.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color(0xFF21283F),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width * 0.3,
              child: Image.asset(
                'assets/imagenes/sombrero-de-graduacion.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              'KUNAN',
              style: TextStyle(
                fontSize: size.width * 0.1,
                color: const Color.fromRGBO(178, 219, 144, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.2),
            SizedBox(
              width: size.width * 0.3,
              height: size.width * 0.1,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(178, 219, 144, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  'Inicio ►',
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.2),
            SizedBox(
              width: size.width * 0.6,
              child: Image.asset(
                'assets/imagenes/Logo FISI.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
