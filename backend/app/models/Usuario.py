class Usuario():
    def __init__(self, nombres, apellidos, codigo, correo, esProfesor, escuela, facultad, password):
        self.nombres = nombres
        self.apellidos = apellidos
        self.codigo = codigo
        self.correo = correo
        self.esProfesor = esProfesor
        self.escuela = escuela
        self.facultad = facultad
        self.password = password

    def to_dict(self):
        return {
            'nombres': self.nombres,
            'apellidos': self.apellidos,
            'codigo': self.codigo,
            'correo': self.correo,
            'esProfesor': self.esProfesor,
            'escuela': self.escuela,
            'facultad': self.facultad,
            'password': self.password,
        }

    @staticmethod
    def from_dict(source):
        return Usuario(
            nombres=source.get('nombres'),
            apellidos=source.get('apellidos'),
            codigo=source.get('codigo'),
            correo=source.get('correo'),
            esProfesor=source.get('esProfesor'),
            escuela=source.get('escuela'),
            facultad=source.get('facultad'),
            password=source.get('password'),
        )