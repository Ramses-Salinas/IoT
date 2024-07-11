import 'dart:math';
import 'dart:ui';

Color getRandomLightColor() {
  final Random random = Random();
  final int red = 128 + random.nextInt(128);
  final int green = 128 + random.nextInt(128);
  final int blue = 128 + random.nextInt(128);

  return Color.fromARGB(255, red, green, blue);
}