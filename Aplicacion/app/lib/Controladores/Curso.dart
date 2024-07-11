class Curso {
  final String nombre;
  final String horaInicio;
  final String horaFin;

  Curso({
    required this.nombre,
    required this.horaInicio,
    required this.horaFin,
  });

  // Convertir un Curso a un Map
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'horaFin': horaFin,
      'horaInicio': horaInicio,
    };
  }

  // Crear un Curso desde un Map
  factory Curso.fromJson(Map<String, dynamic> json) {
    return Curso(
      nombre: json['nombre'],
      horaInicio: json['horaInicio'],
      horaFin: json['horaFin'],
    );
  }
}
