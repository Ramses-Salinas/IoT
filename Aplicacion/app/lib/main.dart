import 'package:flutter/material.dart';
import 'package:kunan_v01/pantallas/inicio.dart';

import 'Controladores/save_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: InicioScreen(),
      home: AnimatedSplashScreen(),
    );

  }
}



class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
    _controller.forward();

    _clearSharedPreferences();
  }

  void _clearSharedPreferences() async {
    await SharedPrefUtils.clearData();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: const InicioScreen(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}